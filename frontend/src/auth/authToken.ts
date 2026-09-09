// Armazenamento do JWT e canal de notificação de "sessão expirada", desacoplados de React.
//
// Fica fora de `auth/AuthContext.tsx` de propósito: `api/client.ts` precisa ler o token
// (para anexar `Authorization`) e notificar 401 sem depender de React ou do Context (evita
// import circular entre a camada de API e a camada de UI). O `AuthContext` é quem assina o
// listener e decide o que fazer na prática (limpar estado, navegar para /login).
const STORAGE_KEY = 'scaleup.auth.token';

export function getToken(): string | null {
  return localStorage.getItem(STORAGE_KEY);
}

export function setToken(token: string): void {
  localStorage.setItem(STORAGE_KEY, token);
}

export function clearToken(): void {
  localStorage.removeItem(STORAGE_KEY);
}

type UnauthorizedListener = () => void;

let unauthorizedListener: UnauthorizedListener | null = null;

/** `AuthProvider` registra aqui o que fazer quando uma chamada autenticada volta 401. */
export function setUnauthorizedListener(listener: UnauthorizedListener | null): void {
  unauthorizedListener = listener;
}

export function notifyUnauthorized(): void {
  unauthorizedListener?.();
}
