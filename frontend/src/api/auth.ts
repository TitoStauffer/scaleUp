import { apiPost } from './client';
import type {
  CadastroRequest,
  ConfirmarRequest,
  LoginRequest,
  LoginResponse,
  MensagemResponse,
  ReenviarRequest,
} from './types';

export function cadastrar(request: CadastroRequest): Promise<MensagemResponse> {
  return apiPost<MensagemResponse>('/api/auth/cadastro', request);
}

export function confirmarCadastro(request: ConfirmarRequest): Promise<MensagemResponse> {
  return apiPost<MensagemResponse>('/api/auth/confirmar', request);
}

export function reenviarToken(request: ReenviarRequest): Promise<MensagemResponse> {
  return apiPost<MensagemResponse>('/api/auth/reenviar-token', request);
}

export function login(request: LoginRequest): Promise<LoginResponse> {
  return apiPost<LoginResponse>('/api/auth/login', request);
}
