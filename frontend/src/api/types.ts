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
