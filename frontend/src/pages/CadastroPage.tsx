import { useState, type FormEvent } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { cadastrar } from '../api/auth';
import { ApiError } from '../api/client';
import { PasswordChecklist } from '../components/PasswordChecklist';

type Estado =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'email-ja-cadastrado-ativo' }
  | { status: 'email-ja-cadastrado-pendente' }
  | { status: 'erro'; mensagem: string };

/**
 * Cadastro (TICKET-cadastro-email-duplicado-visivel.md, que revoga o anti-enumeração de
 * cadastro de TICKET-autenticacao.md seção 4/10). A checklist de senha (componente
 * `PasswordChecklist`) é só feedback em tempo real — não impede o envio (restrição explícita
 * do Tito): quem submete com requisito pendente recebe o erro real do backend (AC-02), fonte
 * de verdade da regra. A única checagem que bloqueia o envio aqui é senha != confirmação, que
 * é UX pura de digitação (ticket, seção 4), não segurança.
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
      navigate('/confirmar', { state: { email: email.trim(), mensagem: resposta.mensagem } });
    } catch (err) {
      if (err instanceof ApiError && err.code === 'EMAIL_JA_CADASTRADO_ATIVO') {
        setEstado({ status: 'email-ja-cadastrado-ativo' });
        return;
      }
      if (err instanceof ApiError && err.code === 'EMAIL_JA_CADASTRADO_PENDENTE') {
        setEstado({ status: 'email-ja-cadastrado-pendente' });
        return;
      }
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstado({ status: 'erro', mensagem });
    }
  }

  const emailComErro =
    estado.status === 'email-ja-cadastrado-ativo' || estado.status === 'email-ja-cadastrado-pendente';

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
            aria-invalid={emailComErro}
            aria-describedby={emailComErro ? 'email-erro' : undefined}
          />
        </label>
        {estado.status === 'email-ja-cadastrado-ativo' && (
          <p id="email-erro" role="alert" className="auth-field-error">
            Este e-mail já possui uma conta ativa. <Link to="/login">Fazer login</Link>
          </p>
        )}
        {estado.status === 'email-ja-cadastrado-pendente' && (
          <p id="email-erro" role="alert" className="auth-field-error">
            Este e-mail já possui um cadastro pendente de confirmação.{' '}
            <Link to="/confirmar" state={{ email: email.trim() }}>
              Confirmar cadastro
            </Link>
          </p>
        )}

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
