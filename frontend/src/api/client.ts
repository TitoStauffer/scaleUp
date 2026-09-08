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
const rawBaseUrl = import.meta.env.VITE_API_BASE_URL ?? '';
export const API_BASE_URL = rawBaseUrl.replace(/\/$/, '');

export class ApiError extends Error {
  readonly status: number;

  constructor(message: string, status: number) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
  }
}

interface ApiErrorBody {
  mensagem?: string;
  erro?: string;
}

export async function apiGet<T>(path: string): Promise<T> {
  let response: Response;
  try {
    response = await fetch(`${API_BASE_URL}${path}`, {
      headers: { Accept: 'application/json' },
    });
  } catch {
    throw new ApiError(
      'Não foi possível conectar à API. Verifique se o servidor está disponível e tente novamente.',
      0,
    );
  }

  if (!response.ok) {
    let mensagem = `Erro ao consultar a API (status ${response.status}).`;
    try {
      const body = (await response.json()) as ApiErrorBody;
      if (body.mensagem) {
        mensagem = body.mensagem;
      }
    } catch {
      // corpo de erro ausente ou não é JSON: mantém a mensagem padrão acima.
    }
    throw new ApiError(mensagem, response.status);
  }

  return (await response.json()) as T;
}
