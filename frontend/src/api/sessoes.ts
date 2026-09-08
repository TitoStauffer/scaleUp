import { apiPost } from './client';
import type { FlashcardReview, RegistrarFlashcardReviewRequest, StudySession } from './types';

export function iniciarSessao(dominioId: string): Promise<StudySession> {
  return apiPost<StudySession>(`/api/dominios/${encodeURIComponent(dominioId)}/sessoes`);
}

export function registrarFlashcardReview(
  sessaoId: string,
  request: RegistrarFlashcardReviewRequest,
): Promise<FlashcardReview> {
  return apiPost<FlashcardReview>(`/api/sessoes/${encodeURIComponent(sessaoId)}/flashcard-reviews`, request);
}
