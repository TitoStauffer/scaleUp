import { apiGet } from './client';
import type { DomainDetail, DomainSummary, Flashcard, Question } from './types';

export function fetchDominios(): Promise<DomainSummary[]> {
  return apiGet<DomainSummary[]>('/api/dominios');
}

export function fetchDominioDetalhe(slug: string): Promise<DomainDetail> {
  return apiGet<DomainDetail>(`/api/dominios/${encodeURIComponent(slug)}`);
}

export function fetchFlashcards(slug: string): Promise<Flashcard[]> {
  return apiGet<Flashcard[]>(`/api/dominios/${encodeURIComponent(slug)}/flashcards`);
}

export function fetchQuestoes(slug: string): Promise<Question[]> {
  return apiGet<Question[]>(`/api/dominios/${encodeURIComponent(slug)}/questoes`);
}
