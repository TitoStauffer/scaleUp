import { createContext, useContext } from 'react';
import type { Modo } from '../lib/escopo';

/**
 * Informação que a fila sequencial (ticket UI/UX, seção 5.3) expõe às páginas de conteúdo já
 * existentes (`DomainSlidesPage`, `FlashcardsPage`, `QuizPage`) quando elas estão sendo
 * renderizadas dentro do fluxo "tudo" — permite que essas páginas, sem duplicar lógica,
 * mostrem a posição na fila e ofereçam "concluir este domínio"/"encerrar sessão de tudo".
 *
 * Quando a página é acessada fora da fila (rota normal `/dominios/:slug/...`), o hook
 * `useFilaSequencial()` retorna `null` e nenhum comportamento extra é exibido — é assim que a
 * mesma página serve às duas portas de entrada (ticket, seção 4, trade-off assumido).
 */
export interface FilaSequencialInfo {
  modo: Modo;
  /** Índice (0-based) do domínio atual dentro da fila. */
  indiceAtual: number;
  /** Quantidade total de domínios na fila (antes de descartar os pulados). */
  totalDominios: number;
  /**
   * Usado por Estudar/Revisar (que não têm uma tela de resultado natural): sinaliza que o
   * usuário terminou o domínio atual e quer ver a tela intermediária "Domínio concluído".
   */
  mostrarConcluido: () => void;
  /**
   * Avança diretamente para o próximo domínio da fila (sem passar pela tela intermediária) —
   * usado pelo Quiz, cuja própria tela de resultado já serve como ponto de parada natural, e
   * pelos botões "Próximo domínio" da tela intermediária.
   */
  avancar: () => void;
  /** Encerra a sessão de "tudo" e volta para o início. */
  encerrar: () => void;
}

const FilaSequencialContext = createContext<FilaSequencialInfo | null>(null);

export const FilaSequencialProvider = FilaSequencialContext.Provider;

export function useFilaSequencial(): FilaSequencialInfo | null {
  return useContext(FilaSequencialContext);
}
