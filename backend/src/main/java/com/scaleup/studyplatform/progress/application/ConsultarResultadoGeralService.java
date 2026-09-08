package com.scaleup.studyplatform.progress.application;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.progress.application.dto.ResultadoGeralDto;
import com.scaleup.studyplatform.progress.domain.DomainProgress;
import com.scaleup.studyplatform.progress.infra.DomainProgressRepository;

/**
 * GET /usuarios/{userId}/resultado-geral (ticket, seções 5.5 e 7): média aritmética simples
 * de `pontuacao_geral` entre os domínios com `volume_minimo_atingido = true`. Domínios ainda
 * não avaliados não entram na média (nem como zero) — se nenhum domínio foi avaliado, o
 * resultado é o estado explícito "ainda não avaliado" (AC-09), nunca `0`.
 */
@Service
public class ConsultarResultadoGeralService {

    private final DomainProgressRepository domainProgressRepository;

    public ConsultarResultadoGeralService(DomainProgressRepository domainProgressRepository) {
        this.domainProgressRepository = domainProgressRepository;
    }

    @Transactional(readOnly = true)
    public ResultadoGeralDto consultar(UUID userId) {
        List<DomainProgress> avaliados = domainProgressRepository.findByUserIdAndVolumeMinimoAtingidoTrue(userId);
        if (avaliados.isEmpty()) {
            return new ResultadoGeralDto(false, null, 0);
        }

        BigDecimal soma = avaliados.stream()
                .map(DomainProgress::getPontuacaoGeral)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal media = soma.divide(BigDecimal.valueOf(avaliados.size()), 2, RoundingMode.HALF_UP);
        return new ResultadoGeralDto(true, media, avaliados.size());
    }
}
