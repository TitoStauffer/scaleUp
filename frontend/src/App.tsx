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
          <button type="button" className="logout-button" onClick={logout}>
            Sair
          </button>
        )}
      </header>
      <main className="app-main">
        <Outlet />
      </main>
    </div>
  );
}
