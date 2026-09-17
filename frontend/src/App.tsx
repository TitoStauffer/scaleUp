import { Link, NavLink, Outlet } from 'react-router-dom';
import { useAuth } from './auth/AuthContext';

export function App() {
  const { isAuthenticated, logout } = useAuth();

  return (
    <div className="app-shell">
      <header className="app-header">
        <div className="app-header-start">
          <Link to="/" className="brand">
            ScaleUp
          </Link>
          {isAuthenticated && (
            <nav className="app-nav" aria-label="Navegação principal">
              <NavLink to="/" end>
                Início
              </NavLink>
              <NavLink to="/estudar">Estudar</NavLink>
              <NavLink to="/revisar">Revisar</NavLink>
              <NavLink to="/quiz">Quiz</NavLink>
              <NavLink to="/dominios">Domínios</NavLink>
            </nav>
          )}
        </div>
        {isAuthenticated && (
          <div className="app-header-end">
            {/* TICKET-alterar-senha.md, OPEN QUESTION-005: link direto no header, mesmo nível
                visual do "Sair" — mais simples que um dropdown para o único item existente. */}
            <NavLink to="/conta">Minha conta</NavLink>
            <button type="button" className="logout-button" onClick={logout}>
              Sair
            </button>
          </div>
        )}
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
}
