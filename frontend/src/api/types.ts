// Tipos espelhando os DTOs reais do backend (content/application/dto/*.java).
// Mantidos em sincronia manual com o contrato documentado em
// docs/architecture/implementation-plan-backend-infra.md (seção 3).

export interface DomainSummary {
  id: string;
  slug: string;
  nome: string;
  descricao: string;
}

export interface Slide {
  id: string;
  titulo: string;
  conteudo: string;
  ordem: number;
}

export interface Concept {
  id: string;
  titulo: string;
  resumo: string;
  slides: Slide[];
}

export interface DomainDetail {
  id: string;
  slug: string;
  nome: string;
  descricao: string;
  conceitos: Concept[];
}

export interface Flashcard {
  id: string;
  frente: string;
  verso: string;
  dificuldade: string;
}

export interface Alternativa {
  id: string;
  texto: string;
}

export interface Question {
  id: string;
  enunciado: string;
  dificuldade: string;
  alternativas: Alternativa[];
}

// Tipos espelhando os DTOs reais dos módulos Study/Assessment/Progress
// (study/application/dto, assessment/application/dto, progress/application/dto).

export interface StudySession {
  id: string;
  dominioId: string;
  status: string;
  iniciadaEm: string;
}

export interface QuizAttempt {
  id: string;
  domainRef: string;
  status: string;
  totalQuestoes: number;
  iniciadoEm: string;
  questoes: Question[];
}

/**
 * Uma entrada por questão da tentativa, mesmo as não respondidas (alternativaSelecionadaId
 * null) — é assim que o backend identifica qual questão ficou pendente (AC-02). Espelha
 * `RespostaSubmissaoRequest`.
 */
export interface RespostaSubmissao {
  questionId: string;
  alternativaSelecionadaId: string | null;
  confiancaDeclarada?: number;
}

export interface SubmissaoQuizRequest {
  respostas: RespostaSubmissao[];
}

/** Só existe depois da submissão — nunca antes (AC-01, AC-13). Espelha `RespostaResultadoDto`. */
export interface RespostaResultado {
  questionId: string;
  correta: boolean;
  alternativaCorretaId: string;
  explicacao: string;
}

export interface SubmissaoResultado {
  quizAttemptId: string;
  acertos: number;
  totalQuestoes: number;
  pontuacaoObtida: number;
  concluidoEm: string;
  respostas: RespostaResultado[];
  progresso: DomainProgress;
}

export interface RegistrarFlashcardReviewRequest {
  flashcardId: string;
  resultadoAutoavaliacao: 'lembrei' | 'nao_lembrei';
  confiancaDeclarada?: number;
}

export interface FlashcardReview {
  id: string;
  sessaoId: string;
  flashcardId: string;
  resultadoAutoavaliacao: string;
  revisadoEm: string;
}

/**
 * `emAvaliacao=true` significa que o domínio ainda não atingiu o volume mínimo de evidência
 * — `pontuacaoGeral` e `nivelAtual` permanecem `null` nesse caso. Espelha `DomainProgressDto`.
 */
export interface DomainProgress {
  domainRef: string;
  volumeMinimoAtingido: boolean;
  emAvaliacao: boolean;
  faltamSessoesQuiz: number;
  faltamRevisoesFlashcard: number;
  pontuacaoQuiz: number | null;
  pontuacaoFlashcards: number | null;
  pontuacaoQuestoesNovas: number | null;
  pontuacaoConsistencia: number | null;
  pontuacaoCalibracao: number | null;
  pontuacaoGeral: number | null;
  nivelAtual: string | null;
}

/**
 * Resposta de `GET /api/usuarios/atual`. Permite descobrir o `userId` do único usuário
 * local do MVP (sem autenticação real) para consumir os endpoints `/usuarios/{userId}/...`.
 * Espelha `UsuarioAtualDto`.
 */
export interface UsuarioAtual {
  id: string;
  nome: string;
  email: string;
}

/**
 * `avaliado=false` (com `resultadoGeral=null`) representa o estado explícito "ainda não
 * avaliado" — nunca um resultado numérico `0`. Espelha `ResultadoGeralDto`.
 */
export interface ResultadoGeral {
  avaliado: boolean;
  resultadoGeral: number | null;
  dominiosAvaliados: number;
}

/** Uma tentativa de quiz concluída. Espelha `HistoricoItemDto`. */
export interface HistoricoItem {
  quizAttemptId: string;
  domainRef: string;
  pontuacaoObtida: number;
  iniciadoEm: string;
  concluidoEm: string;
}

// Tipos espelhando os DTOs reais do módulo Identity/auth
// (identity/application/dto/*.java, TICKET-autenticacao.md).

/** POST /api/auth/cadastro. Espelha `CadastroRequest`. */
export interface CadastroRequest {
  email: string;
  senha: string;
  confirmacaoSenha: string;
}

/** POST /api/auth/confirmar. Espelha `ConfirmarRequest`. */
export interface ConfirmarRequest {
  email: string;
  token: string;
}

/** POST /api/auth/reenviar-token. Espelha `ReenviarRequest`. */
export interface ReenviarRequest {
  email: string;
}

/** POST /api/auth/login. Espelha `LoginRequest`. */
export interface LoginRequest {
  email: string;
  senha: string;
}

/** Resposta de sucesso de cadastro/confirmar/reenviar-token — sempre mensagem genérica. Espelha `MensagemDto`. */
export interface MensagemResponse {
  mensagem: string;
}

/** POST /api/usuarios/atual/senha. Espelha `AlterarSenhaRequest`. */
export interface AlterarSenhaRequest {
  senhaAtual: string;
  novaSenha: string;
  confirmacaoNovaSenha: string;
}

/** POST /api/auth/esqueci-senha. Espelha `EsqueciSenhaRequest`. */
export interface EsqueciSenhaRequest {
  email: string;
}

/** POST /api/auth/redefinir-senha. Espelha `RedefinirSenhaRequest`. */
export interface RedefinirSenhaRequest {
  token: string;
  novaSenha: string;
  confirmacaoNovaSenha: string;
}

/** AC-09: JWT emitido no login. `tipo` segue a convenção do header `Authorization: Bearer <token>`. Espelha `LoginResponseDto`. */
export interface LoginResponse {
  token: string;
  tipo: string;
  expiraEm: string;
}
