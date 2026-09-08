package com.scaleup.studyplatform.assessment.application;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.assessment.application.dto.QuizAttemptDto;
import com.scaleup.studyplatform.assessment.domain.QuizAttempt;
import com.scaleup.studyplatform.assessment.domain.QuizAttemptQuestion;
import com.scaleup.studyplatform.assessment.infra.AnswerRepository;
import com.scaleup.studyplatform.assessment.infra.QuizAttemptQuestionRepository;
import com.scaleup.studyplatform.assessment.infra.QuizAttemptRepository;
import com.scaleup.studyplatform.content.application.ContentVisibilidadeConfig;
import com.scaleup.studyplatform.content.application.dto.AlternativaDto;
import com.scaleup.studyplatform.content.application.dto.QuestionDto;
import com.scaleup.studyplatform.content.domain.Question;
import com.scaleup.studyplatform.content.infra.QuestionRepository;
import com.scaleup.studyplatform.shared.EstadoInvalidoException;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;
import com.scaleup.studyplatform.study.domain.StatusSessao;
import com.scaleup.studyplatform.study.domain.StudySession;
import com.scaleup.studyplatform.study.infra.StudySessionRepository;

/**
 * POST /sessoes/{sessaoId}/quiz-attempts (ticket, seções 6.2 e 7): sorteia 10 questões,
 * priorizando as que o usuário nunca respondeu no domínio; completa com questões já
 * respondidas se não houver 10 novas disponíveis.
 */
@Service
public class IniciarQuizAttemptService {

    private static final int TOTAL_QUESTOES = 10;

    private final StudySessionRepository studySessionRepository;
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    private final QuizAttemptRepository quizAttemptRepository;
    private final QuizAttemptQuestionRepository quizAttemptQuestionRepository;
    private final ContentVisibilidadeConfig visibilidadeConfig;

    public IniciarQuizAttemptService(StudySessionRepository studySessionRepository,
            QuestionRepository questionRepository, AnswerRepository answerRepository,
            QuizAttemptRepository quizAttemptRepository, QuizAttemptQuestionRepository quizAttemptQuestionRepository,
            ContentVisibilidadeConfig visibilidadeConfig) {
        this.studySessionRepository = studySessionRepository;
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.quizAttemptQuestionRepository = quizAttemptQuestionRepository;
        this.visibilidadeConfig = visibilidadeConfig;
    }

    @Transactional
    public QuizAttemptDto iniciar(UUID sessaoId) {
        StudySession sessao = studySessionRepository.findById(sessaoId)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Sessão não encontrada: " + sessaoId));

        if (sessao.getStatus() != StatusSessao.EM_ANDAMENTO) {
            throw new EstadoInvalidoException("Sessão " + sessaoId + " não está em andamento (status atual: "
                    + sessao.getStatus().getValor() + ")");
        }

        List<Question> pool = questionRepository.findByDomain_IdAndStatusRevisaoInOrderByCriadoEmAsc(
                sessao.getDomainRef(), visibilidadeConfig.statusPermitidos());
        if (pool.isEmpty()) {
            throw new EstadoInvalidoException("Domínio " + sessao.getDomainRef() + " não tem questões disponíveis");
        }

        Set<UUID> jaRespondidas = new HashSet<>(
                answerRepository.findQuestionIdsJaRespondidas(sessao.getUserId(), sessao.getDomainRef()));

        List<Question> questoesSelecionadas = selecionarQuestoes(pool, jaRespondidas);

        QuizAttempt tentativa = quizAttemptRepository
                .save(new QuizAttempt(sessao.getId(), sessao.getDomainRef(), questoesSelecionadas.size()));

        registrarQuestoesSorteadas(tentativa, questoesSelecionadas);

        List<QuestionDto> questoesDto = questoesSelecionadas.stream().map(this::toQuestionDto).toList();
        return new QuizAttemptDto(tentativa.getId(), tentativa.getDomainRef(), tentativa.getStatus().getValor(),
                tentativa.getTotalQuestoes(), tentativa.getIniciadoEm(), questoesDto);
    }

    private List<Question> selecionarQuestoes(List<Question> pool, Set<UUID> jaRespondidas) {
        List<Question> novas = new ArrayList<>();
        List<Question> repetidas = new ArrayList<>();
        for (Question questao : pool) {
            if (jaRespondidas.contains(questao.getId())) {
                repetidas.add(questao);
            } else {
                novas.add(questao);
            }
        }
        Collections.shuffle(novas);
        Collections.shuffle(repetidas);

        List<Question> selecionadas = new ArrayList<>(novas.subList(0, Math.min(TOTAL_QUESTOES, novas.size())));
        int faltam = TOTAL_QUESTOES - selecionadas.size();
        if (faltam > 0) {
            selecionadas.addAll(repetidas.subList(0, Math.min(faltam, repetidas.size())));
        }
        return selecionadas;
    }

    /**
     * Persiste, na mesma transação do INSERT em quiz_attempt, uma linha por questão sorteada
     * (V25) — fecha a lacuna que permitia à submissão trocar uma questão sorteada por qualquer
     * outra do mesmo domínio (achado do QA). `ordem` é a posição 1..N na lista já embaralhada
     * por {@link #selecionarQuestoes}.
     */
    private void registrarQuestoesSorteadas(QuizAttempt tentativa, List<Question> questoesSelecionadas) {
        List<QuizAttemptQuestion> registros = new ArrayList<>();
        for (int i = 0; i < questoesSelecionadas.size(); i++) {
            registros.add(new QuizAttemptQuestion(tentativa.getId(), questoesSelecionadas.get(i).getId(),
                    tentativa.getDomainRef(), (short) (i + 1)));
        }
        quizAttemptQuestionRepository.saveAll(registros);
    }

    private QuestionDto toQuestionDto(Question question) {
        List<AlternativaDto> alternativas = question.getAlternativas().stream()
                .map(a -> new AlternativaDto(a.getId(), a.getTexto()))
                .toList();
        return new QuestionDto(question.getId(), question.getEnunciado(), question.getDificuldade().getValor(),
                alternativas);
    }
}
