import { useState, type FormEvent } from 'react';
import { alterarSenha } from '../api/auth';
import { ApiError } from '../api/client';
import { PasswordChecklist } from '../components/PasswordChecklist';

type Estado =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'sucesso' }
  | { status: 'senha-atual-incorreta' }
  | { status: 'erro'; mensagem: string };

/**
 * Alterar senha (TICKET-alterar-senha.md, seção 7). A sessão atual continua válida após o
 * sucesso (seção 8 do ticket) — não há redirecionamento nem logout automático.
 */
export function ContaPage() {
  const [senhaAtual, setSenhaAtual] = useState('');
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
      await alterarSenha({ senhaAtual, novaSenha, confirmacaoNovaSenha });
      setSenhaAtual('');
      setNovaSenha('');
      setConfirmacaoNovaSenha('');
      setEstado({ status: 'sucesso' });
    } catch (err) {
      if (err instanceof ApiError && err.code === 'SENHA_ATUAL_INCORRETA') {
        setEstado({ status: 'senha-atual-incorreta' });
        return;
      }
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  return (
    <section aria-labelledby="conta-title" className="auth-page">
      <h1 id="conta-title">Minha conta</h1>

      <form className="auth-form" onSubmit={handleSubmit} noValidate>
        <label className="auth-field">
          <span>Senha atual</span>
          <input
            type="password"
            name="senhaAtual"
            autoComplete="current-password"
            required
            value={senhaAtual}
            disabled={enviando}
            onChange={(e) => setSenhaAtual(e.target.value)}
            aria-invalid={estado.status === 'senha-atual-incorreta'}
            aria-describedby={estado.status === 'senha-atual-incorreta' ? 'senha-atual-erro' : undefined}
          />
        </label>
        {estado.status === 'senha-atual-incorreta' && (
          <p id="senha-atual-erro" role="alert" className="auth-field-error">
            Senha atual incorreta.
          </p>
        )}

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

        {estado.status === 'sucesso' && (
          <p role="status" className="status-message">
            Senha alterada com sucesso.
          </p>
        )}

        {estado.status === 'erro' && (
          <div role="alert" className="status-message status-message--error">
            <p>{estado.mensagem}</p>
          </div>
        )}

        <button type="submit" disabled={enviando}>
          {enviando ? 'Salvando...' : 'Alterar senha'}
        </button>
      </form>
    </section>
  );
}
