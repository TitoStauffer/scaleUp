// Cliente HTTP centralizado para a API de leitura de conteúdo (módulo Content).
//
// Decisão de URL base: por padrão a base é vazia, ou seja, as chamadas usam caminhos
// relativos (`/api/...`), resolvidos contra a própria origem do frontend. Isso funciona
// tanto em `npm run dev` (proxy configurado em vite.config.ts, redirecionando /api para o
// backend local) quanto no Docker Compose (proxy reverso configurado no nginx do container
// do frontend, redirecionando /api para o serviço `backend`). A vantagem de usar caminhos
// relativos + proxy em vez de apontar direto para `http://localhost:8080` a partir do
// browser é evitar CORS: o backend hoje não tem nenhuma configuração de CORS (ver
// backend/src/main/java/com/scaleup/studyplatform), e alterar isso está fora do escopo
// desta tarefa (só frontend). Ainda assim, `VITE_API_BASE_URL` continua configurável — se
// definida (ex.: apontando direto para um backend com CORS habilitado), as chamadas passam
// a usar essa URL absoluta em vez do proxy.
import { getToken, notifyUnauthorized } from '../auth/authToken';

const rawBaseUrl = import.meta.env.VITE_API_BASE_URL ?? '';
export const API_BASE_URL = rawBaseUrl.replace(/\/$/, '');

export class ApiError extends Error {
  readonly status: number;
  /** Código de erro do backend (`ApiErrorResponse.erro`, ex.: `TOKEN_EXPIRADO`), quando houver. */
  readonly code?: string;

  constructor(message: string, status: number, code?: string) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
  }
}

interface ApiErrorBody {
  mensagem?: string;
  erro?: string;
}

/**
 * Header `Authorization` a partir do JWT salvo (TICKET-autenticacao.md, seção 8). Todas as
 * chamadas passam por aqui — nenhuma precisa anexar o token individualmente.
 */
function authHeaders(): Record<string, string> {
  const token = getToken();
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function apiGet<T>(path: string): Promise<T> {
  const token = getToken();
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      headers: { Accept: 'application/json', ...authHeaders() },
    });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  return handleResponse<T>(response, Boolean(token));
}

/**
 * POST com corpo JSON opcional. Usado pelos endpoints de escrita de sessão/quiz/flashcard
 * (módulos Study/Assessment) e pelos endpoints de autenticação (módulo Identity).
 */
export async function apiPost<T>(path: string, body?: unknown): Promise<T> {
  const token = getToken();
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      method: 'POST',
      headers: { Accept: 'application/json', 'Content-Type': 'application/json', ...authHeaders() },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  return handleResponse<T>(response, Boolean(token));
}

/** PUT com corpo JSON. Usado por `PUT /api/usuarios/atual/perfil` (TICKET-perfil-usuario.md). */
export async function apiPut<T>(path: string, body?: unknown): Promise<T> {
  const token = getToken();
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      method: 'PUT',
      headers: { Accept: 'application/json', 'Content-Type': 'application/json', ...authHeaders() },
      body: body === undefined ? undefined : JSON.stringify(body),
    });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  return handleResponse<T>(response, Boolean(token));
}

/** DELETE sem corpo. Usado por `DELETE /api/usuarios/atual/foto` (TICKET-perfil-usuario.md). */
export async function apiDelete<T>(path: string): Promise<T> {
  const token = getToken();
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      method: 'DELETE',
      headers: { Accept: 'application/json', ...authHeaders() },
    });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  return handleResponse<T>(response, Boolean(token));
}

/**
 * Upload multipart/form-data. Usado por `POST /api/usuarios/atual/foto`
 * (TICKET-perfil-usuario.md) — não define `Content-Type` manualmente: o browser precisa
 * gerar o boundary do multipart sozinho a partir do `FormData`.
 */
export async function apiUpload<T>(path: string, formData: FormData): Promise<T> {
  const token = getToken();
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      method: 'POST',
      headers: { Accept: 'application/json', ...authHeaders() },
      body: formData,
    });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  return handleResponse<T>(response, Boolean(token));
}

/**
 * Busca um recurso binário (a foto de perfil) autenticado e devolve uma Object URL pronta
 * para usar em `<img src>` — `fetch` comum não anexaria o header Authorization se a imagem
 * fosse carregada direto via `<img src="/api/...">`.
 */
export async function apiGetBlobUrl(path: string): Promise<string | null> {
  const token = getToken();
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, { headers: { ...authHeaders() } });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  if (response.status === 404) {
    return null;
  }
  if (!response.ok) {
    return handleResponse<string>(response, Boolean(token));
  }

  const blob = await response.blob();
  return URL.createObjectURL(blob);
}

/**
 * `requestHadToken` distingue um 401 de sessão expirada (chamada autenticada cujo token não
 * vale mais — deve limpar o token e mandar para /login, ticket seção 8) de um 401 esperado do
 * próprio fluxo de login (`POST /api/auth/login` com credenciais erradas, AC-08), que não tem
 * token nenhum para limpar e deve ser tratado como erro comum pela tela de login.
 */
async function handleResponse<T>(response: Response, requestHadToken: boolean): Promise<T> {
  if (!response.ok) {
    let mensagem = `Erro ao consultar a API (status ${response.status}).`;
    let codigo: string | undefined;
    try {
      const body = (await response.json()) as ApiErrorBody;
      if (body.mensagem) {
        mensagem = body.mensagem;
      }
      codigo = body.erro;
    } catch {
      // corpo de erro ausente ou não é JSON: mantém a mensagem padrão acima.
    }

    if (response.status === 401 && requestHadToken) {
      notifyUnauthorized();
    }

    throw new ApiError(mensagem, response.status, codigo);
  }

  if (response.status === 204) {
    return undefined as T;
  }

  return (await response.json()) as T;
}
