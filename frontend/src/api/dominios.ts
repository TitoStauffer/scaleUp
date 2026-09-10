import { apiGet } from './client';
import type { DomainDetail, DomainSummary, Flashcard, Question } from './types';

export function fetchDominios(): Promise<DomainSummary[]> {
  return apiGet<DomainSummary[]>('/api/dominios');
}

export function fetchDominioDetalhe(slug: string): Promise<DomainDetail> {
  return apiGet<DomainDetail>(`/api/dominios/${encodeURIComponent(slug)}`);
}

/**
 * `dificuldade` é opcional (filtro já suportado pelo backend, ticket UI/UX seção 5.4) —
 * sem o parâmetro, o comportamento é idêntico ao de antes (todos os flashcards do domínio).
 */
export function fetchFlashcards(slug: string, dificuldade?: string): Promise<Flashcard[]> {
  const query = dificuldade ? `?${new URLSearchParams({ dificuldade }).toString()}` : '';
  return apiGet<Flashcard[]>(`/api/dominios/${encodeURIComponent(slug)}/flashcards${query}`);
}

export function fetchQuestoes(slug: string): Promise<Question[]> {
  return apiGet<Question[]>(`/api/dominios/${encodeURIComponent(slug)}/questoes`);
}
