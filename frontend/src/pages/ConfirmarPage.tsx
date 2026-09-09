import { useState, type FormEvent } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { confirmarCadastro, reenviarToken } from '../api/auth';
import { ApiError } from '../api/client';

type Estado =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'token-invalido' }
  | { status: 'token-expirado' }
  | { status: 'erro'; mensagem: string };

interface LocationState {
  email?: string;
  mensagem?: string;
}

/**
 * Confirmação de cadastro (ticket, seção 5 e 10). E-mail vem pré-preenchido via
 * `location.state` quando a navegação parte do cadastro ou do "reenviar" da tela de login,
 * mas o campo continua editável — o usuário pode chegar aqui direto (ex.: link salvo) sem
 * esse state.
 */
export function ConfirmarPage() {
  const navigate = useNavigate();
  const location = useLocation();
  const locationState = location.state as LocationState | null;

  const [email, setEmail] = useState(locationState?.email ?? '');
  const [token, setToken] = useState('');
  const [estado, setEstado] = useState<Estado>({ status: 'idle' });
  const [reenviando, setReenviando] = useState(false);
  const [reenvioConfirmado, setReenvioConfirmado] = useState(false);

  const enviando = estado.status === 'enviando';

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setEstado({ status: 'enviando' });
    setReenvioConfirmado(false);
    try {
      await confirmarCadastro({ email: email.trim(), token: token.trim() });
      navigate('/login', { state: { mensagem: 'Conta confirmada com sucesso. Faça login para continuar.' } });
    } catch (err) {
      if (err instanceof ApiError && err.code === 'TOKEN_EXPIRADO') {
        setEstado({ status: 'token-expirado' });
        return;
      }
      if (err instanceof ApiError && err.code === 'TOKEN_INVALIDO') {
        setEstado({ status: 'token-invalido' });
        return;
      }
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  async function handleReenviar() {
    setReenviando(true);
    setReenvioConfirmado(false);
    try {
      await reenviarToken({ email: email.trim() });
      setReenvioConfirmado(true);
      setEstado({ status: 'idle' });
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado ao reenviar o token.';
      setEstado({ status: 'erro', mensagem });
    } finally {
      setReenviando(false);
    }
  }

  return (
    <section aria-labelledby="confirmar-title" className="auth-page">
      <h1 id="confirmar-title">Confirmar cadastro</h1>

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
          <span>Código de 6 dígitos</span>
          <input
            type="text"
            name="token"
            inputMode="numeric"
            pattern="[0-9]{6}"
            maxLength={6}
            autoComplete="one-time-code"
            required
            value={token}
            disabled={enviando}
            onChange={(e) => setToken(e.target.value.replace(/\D/g, '').slice(0, 6))}
          />
        </label>

        {estado.status === 'token-invalido' && (
          <div role="alert" className="status-message status-message--error">
            <p>Token inválido. Confira o código recebido por e-mail e tente novamente.</p>
          </div>
        )}

        {estado.status === 'token-expirado' && (
          <div role="alert" className="status-message status-message--error">
            <p>Este token expirou. Solicite um novo para continuar.</p>
            <button type="button" onClick={handleReenviar} disabled={reenviando}>
              {reenviando ? 'Reenviando...' : 'Reenviar token'}
            </button>
          </div>
        )}

        {estado.status === 'erro' && (
          <div role="alert" className="status-message status-message--error">
            <p>{estado.mensagem}</p>
          </div>
        )}

        {reenvioConfirmado && (
          <p role="status" className="status-message">
            Se o e-mail informado tiver uma conta pendente, um novo token foi enviado.
          </p>
        )}

        <button type="submit" disabled={enviando}>
          {enviando ? 'Confirmando...' : 'Confirmar'}
        </button>
      </form>

      <p className="auth-links">
        Não recebeu o token?{' '}
        <button type="button" className="link-button" onClick={handleReenviar} disabled={reenviando}>
          Reenviar
        </button>
      </p>
      <p className="auth-links">
        <Link to="/login">Voltar para o login</Link>
      </p>
    </section>
  );
}
