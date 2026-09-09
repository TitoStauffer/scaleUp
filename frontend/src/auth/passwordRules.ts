// Espelha a regra de senha do backend (PasswordValidator.java, TICKET-autenticacao.md,
// seção 4): mínimo 8 caracteres, 1 maiúscula, 1 minúscula, 1 número, 1 símbolo. Usado só
// para o feedback em tempo real da tela de cadastro — o backend é a fonte de verdade e
// revalida tudo de novo (ver restrição do ticket: client-side é UX, não segurança).

export interface PasswordRule {
  id: string;
  label: string;
  atendido: (senha: string) => boolean;
}

export const PASSWORD_RULES: PasswordRule[] = [
  { id: 'tamanho', label: 'Mínimo de 8 caracteres', atendido: (senha) => senha.length >= 8 },
  { id: 'maiuscula', label: 'Pelo menos 1 letra maiúscula', atendido: (senha) => /[A-Z]/.test(senha) },
  { id: 'minuscula', label: 'Pelo menos 1 letra minúscula', atendido: (senha) => /[a-z]/.test(senha) },
  { id: 'numero', label: 'Pelo menos 1 número', atendido: (senha) => /[0-9]/.test(senha) },
  { id: 'simbolo', label: 'Pelo menos 1 símbolo', atendido: (senha) => /[^A-Za-z0-9]/.test(senha) },
];

export function atendeTodosOsRequisitos(senha: string): boolean {
  return PASSWORD_RULES.every((regra) => regra.atendido(senha));
}
