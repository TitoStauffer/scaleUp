import { apiPost } from './client';
import type {
  AlterarSenhaRequest,
  CadastroRequest,
  ConfirmarRequest,
  EsqueciSenhaRequest,
  LoginRequest,
  LoginResponse,
  MensagemResponse,
  RedefinirSenhaRequest,
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

export function alterarSenha(request: AlterarSenhaRequest): Promise<MensagemResponse> {
  return apiPost<MensagemResponse>('/api/usuarios/atual/senha', request);
}

export function esqueciSenha(request: EsqueciSenhaRequest): Promise<MensagemResponse> {
  return apiPost<MensagemResponse>('/api/auth/esqueci-senha', request);
}

export function redefinirSenha(request: RedefinirSenhaRequest): Promise<MensagemResponse> {
  return apiPost<MensagemResponse>('/api/auth/redefinir-senha', request);
}
