import { PASSWORD_RULES } from '../auth/passwordRules';

interface Props {
  senha: string;
}

/**
 * Checklist de requisitos de senha, atualizada a cada tecla digitada (ticket, seção 10 —
 * pedido explícito do Tito). Puramente client-side, para feedback imediato: não bloqueia o
 * envio do formulário, só orienta — a regra de verdade é revalidada pelo backend (AC-02).
 */
export function PasswordChecklist({ senha }: Props) {
  return (
    <ul className="password-checklist" aria-label="Requisitos da senha">
      {PASSWORD_RULES.map((regra) => {
        const atendido = regra.atendido(senha);
        return (
          <li
            key={regra.id}
            className={`password-checklist-item ${atendido ? 'password-checklist-item--ok' : ''}`}
          >
            <span aria-hidden="true">{atendido ? '✓' : '○'}</span>
            <span>
              {regra.label}
              <span className="visually-hidden">{atendido ? ' (atendido)' : ' (pendente)'}</span>
            </span>
          </li>
        );
      })}
    </ul>
  );
}
