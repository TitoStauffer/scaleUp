import { createContext, useContext, useEffect, useMemo, useState, type ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';
import { clearToken, getToken, setToken as persistToken, setUnauthorizedListener } from './authToken';

interface AuthContextValue {
  isAuthenticated: boolean;
  /** Chamado após login/cadastro+confirmação bem-sucedidos: salva o JWT e libera as rotas protegidas. */
  login: (token: string) => void;
  /** Limpa o JWT e manda para /login — usado tanto pelo botão de logout quanto por um 401 de sessão expirada. */
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue | null>(null);

/**
 * Fonte da verdade de "está autenticado" para o app inteiro (proteção de rotas, header,
 * reação a 401). Estado local + localStorage é suficiente aqui — não há mais nada
 * compartilhado sobre a sessão além do próprio token (ver skill state-management: isto não é
 * server state, é estado de sessão do cliente).
 */
export function AuthProvider({ children }: { children: ReactNode }) {
  const [token, setTokenState] = useState<string | null>(() => getToken());
  const navigate = useNavigate();

  function login(newToken: string) {
    persistToken(newToken);
    setTokenState(newToken);
  }

  function logout() {
    clearToken();
    setTokenState(null);
    navigate('/login', { replace: true });
  }

  // Registra a reação global a 401 (ticket, seção 8): qualquer chamada autenticada que volte
  // 401 durante o uso normal limpa o token e redireciona, sem cada tela precisar tratar isso.
  useEffect(() => {
    setUnauthorizedListener(logout);
    return () => setUnauthorizedListener(null);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const value = useMemo<AuthContextValue>(
    () => ({ isAuthenticated: token !== null, login, logout }),
    [token],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth deve ser usado dentro de <AuthProvider>');
  }
  return context;
}
