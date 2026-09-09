import { useState, type FormEvent } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { cadastrar } from '../api/auth';
import { ApiError } from '../api/client';
import { PasswordChecklist } from '../components/PasswordChecklist';

type Estado = { status: 'idle' } | { status: 'enviando' } | { status: 'erro'; mensagem: string };

/**
 * Cadastro (ticket, seção 4 e 10). A checklist de senha (componente `PasswordChecklist`) é
 * só feedback em tempo real — não impede o envio (restrição explícita do Tito): quem
 * submete com requisito pendente recebe o erro real do backend (AC-02), fonte de verdade da
 * regra. A única checagem que bloqueia o envio aqui é senha != confirmação, que é UX pura
 * de digitação (ticket, seção 4), não segurança.
 */
export function CadastroPage() {
  const navigate = useNavigate();

  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const [confirmacaoSenha, setConfirmacaoSenha] = useState('');
  const [estado, setEstado] = useState<Estado>({ status: 'idle' });

  const enviando = estado.status === 'enviando';
  const senhasDivergem = confirmacaoSenha.length > 0 && senha !== confirmacaoSenha;

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();

    if (senha !== confirmacaoSenha) {
      setEstado({ status: 'erro', mensagem: 'A senha e a confirmação de senha não coincidem.' });
      return;
    }

    setEstado({ status: 'enviando' });
    try {
      const resposta = await cadastrar({ email: email.trim(), senha, confirmacaoSenha });
      // Mensagem sempre genérica (anti-enumeração, ticket seção 4) — nunca revela se o
      // e-mail já existia.
      navigate('/confirmar', { state: { email: email.trim(), mensagem: resposta.mensagem } });
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  return (
    <section aria-labelledby="cadastro-title" className="auth-page">
      <h1 id="cadastro-title">Criar conta</h1>

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
            autoComplete="new-password"
            required
            value={senha}
            disabled={enviando}
            onChange={(e) => setSenha(e.target.value)}
          />
        </label>

        <PasswordChecklist senha={senha} />

        <label className="auth-field">
          <span>Confirmar senha</span>
          <input
            type="password"
            name="confirmacaoSenha"
            autoComplete="new-password"
            required
            value={confirmacaoSenha}
            disabled={enviando}
            onChange={(e) => setConfirmacaoSenha(e.target.value)}
            aria-invalid={senhasDivergem}
            aria-describedby={senhasDivergem ? 'confirmacao-senha-erro' : undefined}
          />
        </label>
        {senhasDivergem && (
          <p id="confirmacao-senha-erro" className="auth-field-error">
            A senha e a confirmação de senha não coincidem.
          </p>
        )}

        {estado.status === 'erro' && (
          <div role="alert" className="status-message status-message--error">
            <p>{estado.mensagem}</p>
          </div>
        )}

        <button type="submit" disabled={enviando}>
          {enviando ? 'Cadastrando...' : 'Cadastrar'}
        </button>
      </form>

      <p className="auth-links">
        Já tem conta? <Link to="/login">Entrar</Link>
      </p>
    </section>
  );
}
