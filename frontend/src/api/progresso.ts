import { apiGet } from './client';
import type { DomainProgress, HistoricoItem, ResultadoGeral } from './types';

export function fetchProgresso(dominioId: string): Promise<DomainProgress> {
  return apiGet<DomainProgress>(`/api/dominios/${encodeURIComponent(dominioId)}/progresso`);
}

export function fetchResultadoGeral(userId: string): Promise<ResultadoGeral> {
  return apiGet<ResultadoGeral>(`/api/usuarios/${encodeURIComponent(userId)}/resultado-geral`);
}

/**
 * `dominioId` é opcional no backend (histórico geral vs. por domínio), mas as telas atuais
 * só usam a variante por domínio (aba "Histórico" dentro de um domínio).
 */
export function fetchHistorico(userId: string, dominioId: string): Promise<HistoricoItem[]> {
  const query = new URLSearchParams({ dominioId });
  return apiGet<HistoricoItem[]>(`/api/usuarios/${encodeURIComponent(userId)}/historico?${query.toString()}`);
}
