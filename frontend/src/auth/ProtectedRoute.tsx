import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuth } from './AuthContext';

/**
 * Guarda de rota (ticket, seção 10, "redirecionamento global"): sem JWT salvo, qualquer rota
 * de conteúdo/estudo/quiz/progresso cai em /login. Preserva a rota de origem em `state` para
 * a tela de login poder voltar para onde o usuário tentou ir (pequena melhoria de UX, não
 * exigida pelo ticket, mas de custo zero).
 */
export function ProtectedRoute() {
  const { isAuthenticated } = useAuth();
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  return <Outlet />;
}
