import { useState, type FormEvent } from 'react';
import { Link, useNavigate, useSearchParams } from 'react-router-dom';
import { redefinirSenha } from '../api/auth';
import { ApiError } from '../api/client';
import { PasswordChecklist } from '../components/PasswordChecklist';

type Estado =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'token-invalido' }
  | { status: 'erro'; mensagem: string };

/**
 * Redefinir senha a partir de um token de recuperação (TICKET-esqueci-minha-senha.md, seção
 * 4 e 7). O token chega como query param de um link clicável enviado por e-mail, mas o campo
 * continua editável (mesmo padrão de `ConfirmarPage`, para quem digitar/colar manualmente).
 */
export function RedefinirSenhaPage() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();

  const [token, setToken] = useState(searchParams.get('token') ?? '');
  const [novaSenha, setNovaSenha] = useState('');
  const [confirmacaoNovaSenha, setConfirmacaoNovaSenha] = useState('');
  const [estado, setEstado] = useState<Estado>({ status: 'idle' });

  const enviando = estado.status === 'enviando';
  const senhasDivergem = confirmacaoNovaSenha.length > 0 && novaSenha !== confirmacaoNovaSenha;

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();

    if (novaSenha !== confirmacaoNovaSenha) {
      setEstado({ status: 'erro', mensagem: 'A nova senha e a confirmação não coincidem.' });
      return;
    }

    setEstado({ status: 'enviando' });
    try {
      await redefinirSenha({ token: token.trim(), novaSenha, confirmacaoNovaSenha });
      navigate('/login', { state: { mensagem: 'Senha redefinida com sucesso. Faça login para continuar.' } });
    } catch (err) {
      if (err instanceof ApiError && err.code === 'TOKEN_RECUPERACAO_INVALIDO') {
        setEstado({ status: 'token-invalido' });
        return;
      }
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  return (
    <section aria-labelledby="redefinir-senha-title" className="auth-page">
      <h1 id="redefinir-senha-title">Redefinir senha</h1>

      <form className="auth-form" onSubmit={handleSubmit} noValidate>
        <label className="auth-field">
          <span>Token de recuperação</span>
          <input
            type="text"
            name="token"
            required
            value={token}
            disabled={enviando}
            onChange={(e) => setToken(e.target.value)}
          />
        </label>

        <label className="auth-field">
          <span>Nova senha</span>
          <input
            type="password"
            name="novaSenha"
            autoComplete="new-password"
            required
            value={novaSenha}
            disabled={enviando}
            onChange={(e) => setNovaSenha(e.target.value)}
          />
        </label>

        <PasswordChecklist senha={novaSenha} />

        <label className="auth-field">
          <span>Confirmar nova senha</span>
          <input
            type="password"
            name="confirmacaoNovaSenha"
            autoComplete="new-password"
            required
            value={confirmacaoNovaSenha}
            disabled={enviando}
            onChange={(e) => setConfirmacaoNovaSenha(e.target.value)}
            aria-invalid={senhasDivergem}
            aria-describedby={senhasDivergem ? 'confirmacao-nova-senha-erro' : undefined}
          />
        </label>
        {senhasDivergem && (
          <p id="confirmacao-nova-senha-erro" className="auth-field-error">
            A nova senha e a confirmação não coincidem.
          </p>
        )}

        {estado.status === 'token-invalido' && (
          <div role="alert" className="status-message status-message--error">
            <p>Token inválido, expirado ou já utilizado. Solicite uma nova recuperação de senha.</p>
            <Link to="/esqueci-senha">Solicitar novamente</Link>
          </div>
        )}

        {estado.status === 'erro' && (
          <div role="alert" className="status-message status-message--error">
            <p>{estado.mensagem}</p>
          </div>
        )}

        <button type="submit" disabled={enviando}>
          {enviando ? 'Redefinindo...' : 'Redefinir senha'}
        </button>
      </form>

      <p className="auth-links">
        <Link to="/login">Voltar para o login</Link>
      </p>
    </section>
  );
}
