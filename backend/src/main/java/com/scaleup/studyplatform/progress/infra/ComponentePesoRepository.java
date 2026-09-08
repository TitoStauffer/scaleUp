package com.scaleup.studyplatform.progress.infra;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.progress.domain.ComponentePeso;

public interface ComponentePesoRepository extends JpaRepository<ComponentePeso, UUID> {

    List<ComponentePeso> findAllByOrderByOrdemAsc();
}
