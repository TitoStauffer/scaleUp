import { Link, Outlet } from 'react-router-dom';
import { useAuth } from './auth/AuthContext';

export function App() {
  const { isAuthenticated, logout } = useAuth();

  return (
    <div className="app-shell">
      <header className="app-header">
        <Link to="/" className="brand">
          ScaleUp
        </Link>
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
