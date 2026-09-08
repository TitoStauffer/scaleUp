package com.scaleup.studyplatform.progress.application;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.assessment.domain.Answer;
import com.scaleup.studyplatform.assessment.domain.QuizAttempt;
import com.scaleup.studyplatform.assessment.infra.AnswerRepository;
import com.scaleup.studyplatform.assessment.infra.QuizAttemptRepository;
import com.scaleup.studyplatform.progress.domain.ComponentePeso;
import com.scaleup.studyplatform.progress.domain.DomainProgress;
import com.scaleup.studyplatform.progress.domain.NivelReferencia;
import com.scaleup.studyplatform.progress.infra.ComponentePesoRepository;
import com.scaleup.studyplatform.progress.infra.DomainProgressRepository;
import com.scaleup.studyplatform.progress.infra.NivelReferenciaRepository;
import com.scaleup.studyplatform.study.domain.FlashcardReview;
import com.scaleup.studyplatform.study.domain.ResultadoAutoavaliacao;
import com.scaleup.studyplatform.study.infra.FlashcardReviewRepository;

/**
 * Recalcula, de ponta a ponta, o {@code domain_progress} de um (usuário, domínio) a partir
 * das evidências brutas (QuizAttempt, Answer, FlashcardReview) — TICKET-assessment-
 * progress.md, seções 5.1 a 5.4. Chamado de forma síncrona, dentro da mesma transação, ao
 * final de: submissão de quiz (seção 6.1) e registro de flashcard review (mesma lógica —
 * ambos são eventos que produzem evidência nova).
 *
 * Decisão pragmática de acoplamento: em vez de criar portas/interfaces novas entre Progress
 * e Study/Assessment (nenhum consumidor além deste serviço existe hoje, e a arquitetura já
 * documentada em implementation-plan-backend-infra.md não define esse contrato ainda), este
 * serviço injeta diretamente os repositórios dos módulos vizinhos — mesmo padrão já usado
 * para reaproveitar QuestionRepository do módulo Content. Se um segundo consumidor precisar
 * das mesmas consultas, é o sinal para extrair uma porta explícita.
 */
@Service
public class RecalcularDomainProgressService {

    private static final int MIN_VOLUME_QUIZ = 3;
    private static final int MIN_VOLUME_FLASHCARD = 10;
    private static final int JANELA_CONSISTENCIA_DIAS = 30;
    private static final int MIN_DIAS_DISTINTOS_CONSISTENCIA = 2;
    private static final int MIN_EVENTOS_CONSISTENCIA = 3;
    private static final int MIN_DECLARACOES_CALIBRACAO = 5;

    private static final String COMPONENTE_QUIZ = "quiz";
    private static final String COMPONENTE_FLASHCARDS = "flashcards";
    private static final String COMPONENTE_QUESTOES_NOVAS = "questoes_novas";
    private static final String COMPONENTE_CONSISTENCIA = "consistencia";
    private static final String COMPONENTE_CALIBRACAO = "calibracao_confianca";

    private final QuizAttemptRepository quizAttemptRepository;
    private final AnswerRepository answerRepository;
    private final FlashcardReviewRepository flashcardReviewRepository;
    private final DomainProgressRepository domainProgressRepository;
    private final NivelReferenciaRepository nivelReferenciaRepository;
    private final ComponentePesoRepository componentePesoRepository;

    public RecalcularDomainProgressService(QuizAttemptRepository quizAttemptRepository,
            AnswerRepository answerRepository, FlashcardReviewRepository flashcardReviewRepository,
            DomainProgressRepository domainProgressRepository, NivelReferenciaRepository nivelReferenciaRepository,
            ComponentePesoRepository componentePesoRepository) {
        this.quizAttemptRepository = quizAttemptRepository;
        this.answerRepository = answerRepository;
        this.flashcardReviewRepository = flashcardReviewRepository;
        this.domainProgressRepository = domainProgressRepository;
        this.nivelReferenciaRepository = nivelReferenciaRepository;
        this.componentePesoRepository = componentePesoRepository;
    }

    @Transactional
    public DomainProgress recalcular(UUID userId, UUID domainRef) {
        DomainProgress progresso = domainProgressRepository.findByUserIdAndDomainRef(userId, domainRef)
                .orElseGet(() -> new DomainProgress(userId, domainRef));

        int volumeQuiz = (int) quizAttemptRepository.countConcludedByUserAndDomain(userId, domainRef);
        int volumeFlashcard = (int) flashcardReviewRepository.countByUserAndDomain(userId, domainRef);
        boolean volumeMinimoAtingido = volumeQuiz >= MIN_VOLUME_QUIZ && volumeFlashcard >= MIN_VOLUME_FLASHCARD;

        BigDecimal pontuacaoQuiz = calcularComponenteQuiz(userId, domainRef, volumeQuiz);
        BigDecimal pontuacaoFlashcards = calcularComponenteFlashcards(userId, domainRef, volumeFlashcard);
        BigDecimal pontuacaoQuestoesNovas = calcularComponenteQuestoesNovas(userId, domainRef);
        BigDecimal pontuacaoConsistencia = calcularComponenteConsistencia(userId, domainRef);
        BigDecimal pontuacaoCalibracao = calcularComponenteCalibracao(userId, domainRef);

        progresso.setVolumeEvidenciaQuiz(volumeQuiz);
        progresso.setVolumeEvidenciaFlashcard(volumeFlashcard);
        progresso.setVolumeMinimoAtingido(volumeMinimoAtingido);
        progresso.setPontuacaoQuiz(pontuacaoQuiz);
        progresso.setPontuacaoFlashcards(pontuacaoFlashcards);
        progresso.setPontuacaoQuestoesNovas(pontuacaoQuestoesNovas);
        progresso.setPontuacaoConsistencia(pontuacaoConsistencia);
        progresso.setPontuacaoCalibracao(pontuacaoCalibracao);

        if (volumeMinimoAtingido) {
            BigDecimal pontuacaoGeral = ProgressFormulas.agregarPontuacaoGeral(List.of(
                    new ComponenteValor(COMPONENTE_QUIZ, pontuacaoQuiz),
                    new ComponenteValor(COMPONENTE_FLASHCARDS, pontuacaoFlashcards),
                    new ComponenteValor(COMPONENTE_QUESTOES_NOVAS, pontuacaoQuestoesNovas),
                    new ComponenteValor(COMPONENTE_CONSISTENCIA, pontuacaoConsistencia),
                    new ComponenteValor(COMPONENTE_CALIBRACAO, pontuacaoCalibracao)),
                    carregarPesos());
            progresso.setPontuacaoGeral(pontuacaoGeral);
            progresso.setNivelAtual(pontuacaoGeral == null ? null : determinarNivel(pontuacaoGeral));
        } else {
            progresso.setPontuacaoGeral(null);
            progresso.setNivelAtual(null);
        }

        progresso.setUltimaAvaliacaoEm(Instant.now());
        progresso.setAtualizadoEm(Instant.now());
        return domainProgressRepository.save(progresso);
    }

    private BigDecimal calcularComponenteQuiz(UUID userId, UUID domainRef, int volumeQuiz) {
        if (volumeQuiz == 0) {
            return null;
        }
        List<BigDecimal> ultimasPontuacoes = quizAttemptRepository
                .findRecentConcludedByUserAndDomain(userId, domainRef, 3).stream()
                .map(QuizAttempt::getPontuacaoObtida)
                .toList();
        return ProgressFormulas.calcularPontuacaoQuiz(ultimasPontuacoes);
    }

    private BigDecimal calcularComponenteFlashcards(UUID userId, UUID domainRef, int volumeFlashcard) {
        if (volumeFlashcard == 0) {
            return null;
        }
        List<Boolean> ultimosLembrei = flashcardReviewRepository.findRecentByUserAndDomain(userId, domainRef, 30)
                .stream()
                .map(fr -> fr.getResultadoAutoavaliacao() == ResultadoAutoavaliacao.LEMBREI)
                .toList();
        return ProgressFormulas.calcularPontuacaoFlashcards(ultimosLembrei);
    }

    /**
     * "Nova" = primeira resposta já registrada para (usuário, question_id), considerando todo
     * o histórico do domínio (seção 5.3). Calculado em memória: percorre as respostas em
     * ordem cronológica e mantém só a primeira ocorrência de cada questão, preservando a
     * ordem — depois pega as últimas até 20.
     */
    private BigDecimal calcularComponenteQuestoesNovas(UUID userId, UUID domainRef) {
        List<Answer> historico = answerRepository.findAllByUserAndDomainOrderByRespondidoEmAsc(userId, domainRef);
        Map<UUID, Answer> primeiraRespostaPorQuestao = new LinkedHashMap<>();
        for (Answer answer : historico) {
            primeiraRespostaPorQuestao.putIfAbsent(answer.getQuestionId(), answer);
        }
        List<Answer> respostasNovas = new ArrayList<>(primeiraRespostaPorQuestao.values());
        List<Boolean> ultimasAte20 = respostasNovas.stream()
                .skip(Math.max(0, respostasNovas.size() - 20))
                .map(Answer::isCorreta)
                .toList();
        return ProgressFormulas.calcularPontuacaoQuestoesNovas(ultimasAte20);
    }

    private BigDecimal calcularComponenteConsistencia(UUID userId, UUID domainRef) {
        Instant desde = Instant.now().minus(JANELA_CONSISTENCIA_DIAS, ChronoUnit.DAYS);
        List<Instant> datasQuiz = quizAttemptRepository.findDatasConclusaoDesde(userId, domainRef, desde);
        List<Instant> datasFlashcard = flashcardReviewRepository.findDatasRevisaoDesde(userId, domainRef, desde);

        int totalEventos = datasQuiz.size() + datasFlashcard.size();
        long diasDistintos = java.util.stream.Stream.concat(datasQuiz.stream(), datasFlashcard.stream())
                .map(instant -> instant.atZone(java.time.ZoneOffset.UTC).toLocalDate())
                .distinct()
                .count();

        if (diasDistintos < MIN_DIAS_DISTINTOS_CONSISTENCIA || totalEventos < MIN_EVENTOS_CONSISTENCIA) {
            return null;
        }

        List<BigDecimal> ultimasPontuacoesQuiz = quizAttemptRepository
                .findRecentConcludedByUserAndDomain(userId, domainRef, 5).stream()
                .map(QuizAttempt::getPontuacaoObtida)
                .toList();
        return ProgressFormulas.calcularPontuacaoConsistencia((int) diasDistintos, ultimasPontuacoesQuiz);
    }

    private BigDecimal calcularComponenteCalibracao(UUID userId, UUID domainRef) {
        record DeclaracaoComData(Instant quando, ConfiancaResultado par) {
        }

        List<DeclaracaoComData> deAnswers = answerRepository
                .findRecentComConfiancaByUserAndDomain(userId, domainRef, 30).stream()
                .map(a -> new DeclaracaoComData(a.getRespondidoEm(), new ConfiancaResultado(
                        ProgressFormulas.mapConfiancaParaProbabilidade(a.getConfiancaDeclarada()), a.isCorreta())))
                .toList();
        List<DeclaracaoComData> deFlashcards = flashcardReviewRepository
                .findRecentComConfiancaByUserAndDomain(userId, domainRef, 30).stream()
                .map(fr -> new DeclaracaoComData(fr.getRevisadoEm(), new ConfiancaResultado(
                        ProgressFormulas.mapConfiancaParaProbabilidade(fr.getConfiancaDeclarada()),
                        fr.getResultadoAutoavaliacao() == ResultadoAutoavaliacao.LEMBREI)))
                .toList();

        // As duas fontes (Answer e FlashcardReview) precisam ser intercaladas por data real
        // antes de cortar em 30 — cada lista já vem limitada a 30 da própria origem, mas a
        // combinação das mais recentes de fato exige ordenar pelo timestamp, não concatenar.
        List<ConfiancaResultado> combinadas = java.util.stream.Stream.concat(deAnswers.stream(), deFlashcards.stream())
                .sorted((a, b) -> b.quando().compareTo(a.quando()))
                .limit(30)
                .map(DeclaracaoComData::par)
                .toList();

        if (combinadas.size() < MIN_DECLARACOES_CALIBRACAO) {
            return null;
        }
        return ProgressFormulas.calcularPontuacaoCalibracao(combinadas);
    }

    private Map<String, BigDecimal> carregarPesos() {
        return componentePesoRepository.findAll().stream()
                .collect(Collectors.toMap(ComponentePeso::getComponente, ComponentePeso::getPeso));
    }

    private NivelReferencia determinarNivel(BigDecimal pontuacaoGeral) {
        return ProgressFormulas.determinarNivel(pontuacaoGeral, nivelReferenciaRepository.findAllByOrderByOrdemAsc());
    }
}
