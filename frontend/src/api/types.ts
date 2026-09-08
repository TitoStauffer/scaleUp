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
