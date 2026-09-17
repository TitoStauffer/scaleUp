package com.scaleup.studyplatform.identity.application;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.assessment.infra.QuizAttemptRepository;
import com.scaleup.studyplatform.content.application.ContentVisibilidadeConfig;
import com.scaleup.studyplatform.content.domain.Domain;
import com.scaleup.studyplatform.content.infra.DomainRepository;
import com.scaleup.studyplatform.identity.application.dto.EstatisticasDominioDto;
import com.scaleup.studyplatform.identity.application.dto.EstatisticasGeraisDto;
import com.scaleup.studyplatform.identity.application.dto.EstatisticasPerfilDto;
import com.scaleup.studyplatform.progress.application.ConsultarResultadoGeralService;
import com.scaleup.studyplatform.progress.application.dto.ResultadoGeralDto;
import com.scaleup.studyplatform.progress.domain.DomainProgress;
import com.scaleup.studyplatform.progress.infra.DomainProgressRepository;
import com.scaleup.studyplatform.study.infra.StudySessionRepository;

/**
 * GET /api/usuarios/atual/perfil/estatisticas (TICKET-perfil-usuario.md, seção 7). Consolida
 * dados já calculados por Study/Progress — não recalcula pontuação nem duplica a lógica de
 * "tentativa concluída" (seção 5.4 do ticket).
 */
@Service
public class ConsultarEstatisticasPerfilService {

    private final CurrentUserProvider currentUserProvider;
    private final DomainRepository domainRepository;
    private final ContentVisibilidadeConfig visibilidadeConfig;
    private final StudySessionRepository studySessionRepository;
    private final QuizAttemptRepository quizAttemptRepository;
    private final DomainProgressRepository domainProgressRepository;
    private final ConsultarResultadoGeralService consultarResultadoGeralService;

    public ConsultarEstatisticasPerfilService(CurrentUserProvider currentUserProvider, DomainRepository domainRepository,
            ContentVisibilidadeConfig visibilidadeConfig, StudySessionRepository studySessionRepository,
            QuizAttemptRepository quizAttemptRepository, DomainProgressRepository domainProgressRepository,
            ConsultarResultadoGeralService consultarResultadoGeralService) {
        this.currentUserProvider = currentUserProvider;
        this.domainRepository = domainRepository;
        this.visibilidadeConfig = visibilidadeConfig;
        this.studySessionRepository = studySessionRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.domainProgressRepository = domainProgressRepository;
        this.consultarResultadoGeralService = consultarResultadoGeralService;
    }

    @Transactional(readOnly = true)
    public EstatisticasPerfilDto consultar() {
        UUID userId = currentUserProvider.getCurrentUserId();

        List<Domain> dominios = domainRepository.findByStatusRevisaoInOrderByNomeAsc(visibilidadeConfig.statusPermitidos());
        Map<UUID, DomainProgress> progressoPorDominio = domainProgressRepository.findByUserId(userId).stream()
                .collect(Collectors.toMap(DomainProgress::getDomainRef, Function.identity()));

        List<EstatisticasDominioDto> porDominio = dominios.stream()
                .map(dominio -> mapearDominio(userId, dominio, progressoPorDominio.get(dominio.getId())))
                .toList();

        int totalSessoesEstudo = porDominio.stream().mapToInt(EstatisticasDominioDto::totalSessoesEstudo).sum();
        int totalTentativasQuiz = porDominio.stream().mapToInt(EstatisticasDominioDto::totalTentativasQuiz).sum();

        ResultadoGeralDto resultadoGeral = consultarResultadoGeralService.consultar(userId);
        EstatisticasGeraisDto geral = new EstatisticasGeraisDto(totalSessoesEstudo, totalTentativasQuiz,
                resultadoGeral.avaliado(), resultadoGeral.resultadoGeral());

        return new EstatisticasPerfilDto(geral, porDominio);
    }

    private EstatisticasDominioDto mapearDominio(UUID userId, Domain dominio, DomainProgress progresso) {
        long sessoes = studySessionRepository.countByUserIdAndDomainRef(userId, dominio.getId());
        long tentativas = quizAttemptRepository.countConcludedByUserAndDomain(userId, dominio.getId());
        boolean volumeMinimoAtingido = progresso != null && progresso.isVolumeMinimoAtingido();
        var pontuacaoQuizMedia = progresso != null ? progresso.getPontuacaoQuiz() : null;

        return new EstatisticasDominioDto(dominio.getId(), dominio.getNome(), (int) sessoes, (int) tentativas,
                volumeMinimoAtingido, pontuacaoQuizMedia);
    }
}
