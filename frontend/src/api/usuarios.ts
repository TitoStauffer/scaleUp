import { apiGet } from './client';
import type { UsuarioAtual } from './types';

export function fetchUsuarioAtual(): Promise<UsuarioAtual> {
  return apiGet<UsuarioAtual>('/api/usuarios/atual');
}
