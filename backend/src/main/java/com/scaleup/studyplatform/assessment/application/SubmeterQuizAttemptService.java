package com.scaleup.studyplatform.assessment.application;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.assessment.application.dto.RespostaResultadoDto;
import com.scaleup.studyplatform.assessment.application.dto.RespostaSubmissaoRequest;
import com.scaleup.studyplatform.assessment.application.dto.SubmissaoQuizRequest;
import com.scaleup.studyplatform.assessment.application.dto.SubmissaoResultadoDto;
import com.scaleup.studyplatform.assessment.domain.Answer;
import com.scaleup.studyplatform.assessment.domain.QuizAttempt;
import com.scaleup.studyplatform.assessment.domain.StatusTentativa;
import com.scaleup.studyplatform.assessment.infra.AnswerRepository;
import com.scaleup.studyplatform.assessment.infra.QuizAttemptQuestionRepository;
import com.scaleup.studyplatform.assessment.infra.QuizAttemptRepository;
import com.scaleup.studyplatform.content.domain.Question;
import com.scaleup.studyplatform.content.domain.QuestionAlternative;
import com.scaleup.studyplatform.content.infra.QuestionRepository;
import com.scaleup.studyplatform.progress.application.ConsultarProgressoService;
import com.scaleup.studyplatform.progress.application.RecalcularDomainProgressService;
import com.scaleup.studyplatform.progress.domain.DomainProgress;
import com.scaleup.studyplatform.shared.EstadoInvalidoException;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;
import com.scaleup.studyplatform.study.domain.StudySession;
import com.scaleup.studyplatform.study.infra.StudySessionRepository;

/**
 * POST /quiz-attempts/{attemptId}/submissao (ticket, seções 6.1 e 7 — AC-01, AC-02, AC-03,
 * AC-13). Tudo-ou-nada: só aceita quando todas as `totalQuestoes` questões têm uma entrada no
 * payload com alternativa selecionada; qualquer rejeição acontece antes de persistir
 * qualquer Answer e antes de revelar `correta`/`explicacao`.
 */
@Service
public class SubmeterQuizAttemptService {

    private final QuizAttemptRepository quizAttemptRepository;
    private final QuizAttemptQuestionRepository quizAttemptQuestionRepository;
    private final AnswerRepository answerRepository;
    private final QuestionRepository questionRepository;
    private final StudySessionRepository studySessionRepository;
    private final RecalcularDomainProgressService recalcularDomainProgressService;

    public SubmeterQuizAttemptService(QuizAttemptRepository quizAttemptRepository,
            QuizAttemptQuestionRepository quizAttemptQuestionRepository, AnswerRepository answerRepository,
            QuestionRepository questionRepository, StudySessionRepository studySessionRepository,
            RecalcularDomainProgressService recalcularDomainProgressService) {
        this.quizAttemptRepository = quizAttemptRepository;
        this.quizAttemptQuestionRepository = quizAttemptQuestionRepository;
        this.answerRepository = answerRepository;
        this.questionRepository = questionRepository;
        this.studySessionRepository = studySessionRepository;
        this.recalcularDomainProgressService = recalcularDomainProgressService;
    }

    @Transactional
    public SubmissaoResultadoDto submeter(UUID attemptId, SubmissaoQuizRequest request) {
        QuizAttempt tentativa = quizAttemptRepository.findById(attemptId)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Tentativa não encontrada: " + attemptId));

        if (tentativa.getStatus() != StatusTentativa.EM_ANDAMENTO) {
            throw new EstadoInvalidoException("Tentativa " + attemptId + " não está em andamento (status atual: "
                    + tentativa.getStatus().getValor() + ")");
        }

        validarCompletude(tentativa, request);
        validarQuestoesPertencemATentativa(tentativa, request);

        List<Answer> respostasParaSalvar = new ArrayList<>();
        List<RespostaResultadoDto> resultadoPorQuestao = new ArrayList<>();
        int acertos = 0;

        for (RespostaSubmissaoRequest resposta : request.respostas()) {
            Question questao = questionRepository.findById(resposta.questionId())
                    .orElseThrow(() -> new IllegalArgumentException("Questão não encontrada: " + resposta.questionId()));

            // AC-03: rejeita antes de persistir qualquer coisa se a questão for de um domínio
            // diferente do domínio da própria tentativa. Desde V25/validarQuestoesPertencemATentativa
            // acima, o controle primário contra troca de questão é o vínculo em
            // quiz_attempt_question (identidade da questão sorteada); esta checagem de domínio
            // permanece como defesa em profundidade (não deveria mais disparar em condições
            // normais, já que toda questão aqui já passou pela validação de pertencimento).
            if (!questao.getDomain().getId().equals(tentativa.getDomainRef())) {
                throw new IllegalArgumentException("Questão " + questao.getId()
                        + " pertence a um domínio diferente do domínio da tentativa (" + tentativa.getDomainRef() + ")");
            }

            QuestionAlternative alternativaSelecionada = questao.getAlternativas().stream()
                    .filter(a -> a.getId().equals(resposta.alternativaSelecionadaId()))
                    .findFirst()
                    .orElseThrow(() -> new IllegalArgumentException(
                            "Alternativa " + resposta.alternativaSelecionadaId() + " não pertence à questão " + questao.getId()));

            QuestionAlternative alternativaCorreta = questao.getAlternativas().stream()
                    .filter(QuestionAlternative::isCorreta)
                    .findFirst()
                    .orElseThrow(() -> new IllegalStateException("Questão " + questao.getId() + " sem alternativa correta"));

            boolean correta = alternativaSelecionada.isCorreta();
            if (correta) {
                acertos++;
            }

            // domain_ref da Answer vem do domain_ref da tentativa, NUNCA do domain_ref da
            // Question — é assim que a FK composta fk_answer_quiz_attempt_domain (V22) passa
            // (mesmo domínio já sempre bate aqui, pois validado acima, mas a fonte do valor
            // gravado é deliberadamente a tentativa, conforme o handoff do DBA).
            respostasParaSalvar.add(new Answer(tentativa.getId(), questao.getId(), questao.getContentVersion(),
                    alternativaSelecionada.getId(), correta, resposta.confiancaDeclarada(), tentativa.getDomainRef()));

            resultadoPorQuestao.add(new RespostaResultadoDto(questao.getId(), correta, alternativaCorreta.getId(),
                    questao.getExplicacao()));
        }

        answerRepository.saveAll(respostasParaSalvar);

        BigDecimal pontuacaoObtida = BigDecimal.valueOf(acertos * 100.0 / tentativa.getTotalQuestoes())
                .setScale(2, RoundingMode.HALF_UP);
        tentativa.concluir(pontuacaoObtida);
        quizAttemptRepository.save(tentativa);

        StudySession sessao = studySessionRepository.findById(tentativa.getStudySessionId())
                .orElseThrow(() -> new IllegalStateException("Sessão " + tentativa.getStudySessionId() + " não encontrada"));
        DomainProgress progresso = recalcularDomainProgressService.recalcular(sessao.getUserId(), tentativa.getDomainRef());

        return new SubmissaoResultadoDto(tentativa.getId(), acertos, tentativa.getTotalQuestoes(), pontuacaoObtida,
                tentativa.getConcluidoEm(), resultadoPorQuestao, ConsultarProgressoService.toDto(progresso));
    }

    /**
     * AC-02: rejeita com erro claro se faltar qualquer resposta, sem revelar nada. Exige que o
     * payload tenha uma entrada por questão da tentativa (mesmo as sem alternativa
     * selecionada) — só assim dá para apontar exatamente qual questão ficou pendente.
     */
    private void validarCompletude(QuizAttempt tentativa, SubmissaoQuizRequest request) {
        if (request.respostas().size() != tentativa.getTotalQuestoes()) {
            throw new IllegalArgumentException("Submissão incompleta: esperado " + tentativa.getTotalQuestoes()
                    + " questões, recebido " + request.respostas().size());
        }

        Set<UUID> questionIds = new HashSet<>();
        List<UUID> pendentes = new ArrayList<>();
        for (RespostaSubmissaoRequest resposta : request.respostas()) {
            if (!questionIds.add(resposta.questionId())) {
                throw new IllegalArgumentException("Questão " + resposta.questionId() + " enviada mais de uma vez na submissão");
            }
            if (resposta.alternativaSelecionadaId() == null) {
                pendentes.add(resposta.questionId());
            }
        }

        if (!pendentes.isEmpty()) {
            throw new IllegalArgumentException("Submissão incompleta: questão(ões) sem resposta selecionada: " + pendentes);
        }
    }

    /**
     * Controle primário de integridade (V25/achado do QA): rejeita, antes de persistir
     * qualquer Answer, qualquer question_id do payload que não conste em
     * quiz_attempt_question para esta tentativa específica — isto é, que não foi de fato
     * sorteada para ela (mesmo que pertença ao domínio correto, ou tenha sido sorteada para
     * OUTRA tentativa do usuário no mesmo domínio).
     */
    private void validarQuestoesPertencemATentativa(QuizAttempt tentativa, SubmissaoQuizRequest request) {
        Set<UUID> questoesSorteadas = new HashSet<>(
                quizAttemptQuestionRepository.findQuestionIdsByQuizAttemptId(tentativa.getId()));

        for (RespostaSubmissaoRequest resposta : request.respostas()) {
            if (!questoesSorteadas.contains(resposta.questionId())) {
                throw new IllegalArgumentException("Questão " + resposta.questionId()
                        + " não pertence à tentativa " + tentativa.getId());
            }
        }
    }
}
