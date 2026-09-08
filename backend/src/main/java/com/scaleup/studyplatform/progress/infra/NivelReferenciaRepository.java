package com.scaleup.studyplatform.progress.infra;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.progress.domain.NivelReferencia;

public interface NivelReferenciaRepository extends JpaRepository<NivelReferencia, UUID> {

    List<NivelReferencia> findAllByOrderByOrdemAsc();
}
