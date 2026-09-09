import { useState, type FormEvent } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { login as loginRequest, reenviarToken } from '../api/auth';
import { ApiError } from '../api/client';
import { useAuth } from '../auth/AuthContext';

type Estado =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'credenciais-invalidas' }
  | { status: 'conta-nao-confirmada' }
  | { status: 'erro'; mensagem: string };

interface LocationState {
  from?: { pathname: string };
  mensagem?: string;
}

export function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [estado, setEstado] = useState<Estado>({ status: 'idle' });
  const [reenviando, setReenviando] = useState(false);

  const enviando = estado.status === 'enviando' || reenviando;
  const locationState = location.state as LocationState | null;
  const destino = locationState?.from?.pathname ?? '/';

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setEstado({ status: 'enviando' });
    try {
      const resposta = await loginRequest({ email: email.trim(), senha });
      login(resposta.token);
      navigate(destino, { replace: true });
    } catch (err) {
      if (err instanceof ApiError && err.status === 403) {
        // Ticket, seção 7: conta existe e credenciais corretas, mas ainda pendente de
        // confirmação — erro específico, com ação para reenviar/confirmar.
        setEstado({ status: 'conta-nao-confirmada' });
        return;
      }
      if (err instanceof ApiError && err.status === 401) {
        // AC-08: mesma mensagem genérica para e-mail inexistente ou senha errada.
        setEstado({ status: 'credenciais-invalidas' });
        return;
      }
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  async function handleReenviarEIrParaConfirmacao() {
    setReenviando(true);
    try {
      await reenviarToken({ email: email.trim() });
      navigate('/confirmar', { state: { email: email.trim() } });
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado ao reenviar o token.';
      setEstado({ status: 'erro', mensagem });
    } finally {
      setReenviando(false);
    }
  }

  return (
    <section aria-labelledby="login-title" className="auth-page">
      <h1 id="login-title">Entrar</h1>

      {locationState?.mensagem && (
        <p role="status" className="status-message">
          {locationState.mensagem}
        </p>
      )}

      <form className="auth-form" onSubmit={handleSubmit} noValidate>
        <label className="auth-field">
          <span>E-mail</span>
          <input
            type="email"
            name="email"
            autoComplete="email"
            required
            value={email}
            disabled={enviando}
            onChange={(e) => setEmail(e.target.value)}
          />
        </label>

        <label className="auth-field">
          <span>Senha</span>
          <input
            type="password"
            name="senha"
            autoComplete="current-password"
            required
            value={senha}
            disabled={enviando}
            onChange={(e) => setSenha(e.target.value)}
          />
        </label>

        {estado.status === 'credenciais-invalidas' && (
          <div role="alert" className="status-message status-message--error">
            <p>E-mail ou senha inválidos.</p>
          </div>
        )}

        {estado.status === 'conta-nao-confirmada' && (
          <div role="alert" className="status-message status-message--error">
            <p>Confirme seu cadastro antes de entrar.</p>
            <button type="button" onClick={handleReenviarEIrParaConfirmacao} disabled={enviando}>
              {reenviando ? 'Reenviando...' : 'Reenviar token de confirmação'}
            </button>
          </div>
        )}

        {estado.status === 'erro' && (
          <div role="alert" className="status-message status-message--error">
            <p>{estado.mensagem}</p>
          </div>
        )}

        <button type="submit" disabled={enviando}>
          {estado.status === 'enviando' ? 'Entrando...' : 'Entrar'}
        </button>
      </form>

      <p className="auth-links">
        Ainda não tem conta? <Link to="/cadastro">Cadastre-se</Link>
      </p>
      <p className="auth-links">
        Já tem um token de confirmação? <Link to="/confirmar">Confirmar cadastro</Link>
      </p>
    </section>
  );
}
