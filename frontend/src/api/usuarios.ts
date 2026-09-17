import { apiDelete, apiGet, apiGetBlobUrl, apiPut, apiUpload } from './client';
import type { AtualizarPerfilRequest, EstatisticasPerfil, MensagemResponse, UsuarioAtual } from './types';

export function fetchUsuarioAtual(): Promise<UsuarioAtual> {
  return apiGet<UsuarioAtual>('/api/usuarios/atual');
}

export function atualizarPerfil(request: AtualizarPerfilRequest): Promise<UsuarioAtual> {
  return apiPut<UsuarioAtual>('/api/usuarios/atual/perfil', request);
}

export function fetchEstatisticasPerfil(): Promise<EstatisticasPerfil> {
  return apiGet<EstatisticasPerfil>('/api/usuarios/atual/perfil/estatisticas');
}

export function uploadFotoPerfil(arquivo: File): Promise<MensagemResponse> {
  const formData = new FormData();
  formData.append('arquivo', arquivo);
  return apiUpload<MensagemResponse>('/api/usuarios/atual/foto', formData);
}

export function removerFotoPerfil(): Promise<MensagemResponse> {
  return apiDelete<MensagemResponse>('/api/usuarios/atual/foto');
}

/** `null` quando a conta não tem foto (404) — ver `apiGetBlobUrl`. */
export function fetchFotoPerfilUrl(): Promise<string | null> {
  return apiGetBlobUrl('/api/usuarios/atual/foto');
}
