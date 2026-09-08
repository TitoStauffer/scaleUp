import { apiPost } from './client';
import type { QuizAttempt, SubmissaoQuizRequest, SubmissaoResultado } from './types';

export function iniciarQuizAttempt(sessaoId: string): Promise<QuizAttempt> {
  return apiPost<QuizAttempt>(`/api/sessoes/${encodeURIComponent(sessaoId)}/quiz-attempts`);
}

export function submeterQuizAttempt(
  attemptId: string,
  request: SubmissaoQuizRequest,
): Promise<SubmissaoResultado> {
  return apiPost<SubmissaoResultado>(`/api/quiz-attempts/${encodeURIComponent(attemptId)}/submissao`, request);
}
