package com.scaleup.studyplatform.study.infra;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.study.domain.StudySession;

public interface StudySessionRepository extends JpaRepository<StudySession, UUID> {
}
