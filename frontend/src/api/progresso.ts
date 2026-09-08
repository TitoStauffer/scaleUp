import { apiGet } from './client';
import type { DomainProgress } from './types';

export function fetchProgresso(dominioId: string): Promise<DomainProgress> {
  return apiGet<DomainProgress>(`/api/dominios/${encodeURIComponent(dominioId)}/progresso`);
}
