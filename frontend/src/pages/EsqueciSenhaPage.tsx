import { useState, type FormEvent } from 'react';
import { Link } from 'react-router-dom';
import { esqueciSenha } from '../api/auth';
import { ApiError } from '../api/client';

type Estado = { status: 'idle' } | { status: 'enviando' } | { status: 'enviado' } | { status: 'erro'; mensagem: string };

/**
 * Solicitar recuperação de senha (TICKET-esqueci-minha-senha.md, seção 4). Resposta sempre
 * genérica (anti-enumeração mantida, seção 5) — a tela nunca revela se o e-mail existe.
 */
export function EsqueciSenhaPage() {
  const [email, setEmail] = useState('');
  const [estado, setEstado] = useState<Estado>({ status: 'idle' });

  const enviando = estado.status === 'enviando';

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setEstado({ status: 'enviando' });
    try {
      await esqueciSenha({ email: email.trim() });
      setEstado({ status: 'enviado' });
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  return (
    <section aria-labelledby="esqueci-senha-title" className="auth-page">
      <h1 id="esqueci-senha-title">Esqueci minha senha</h1>

      {estado.status === 'enviado' ? (
        <p role="status" className="status-message">
          Se este e-mail estiver cadastrado e a conta ativa, você receberá instruções de recuperação em instantes.
        </p>
      ) : (
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

          {estado.status === 'erro' && (
            <div role="alert" className="status-message status-message--error">
              <p>{estado.mensagem}</p>
            </div>
          )}

          <button type="submit" disabled={enviando}>
            {enviando ? 'Enviando...' : 'Enviar instruções'}
          </button>
        </form>
      )}

      <p className="auth-links">
        <Link to="/login">Voltar para o login</Link>
      </p>
    </section>
  );
}
