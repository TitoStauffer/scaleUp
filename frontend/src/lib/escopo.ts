import { fetchDominioDetalhe, fetchFlashcards, fetchQuestoes } from '../api/dominios';

/**
 * Modo de tarefa promovido a navegação global (ticket UI/UX, seção 4): Estudar (slides),
 * Revisar (flashcards) ou Quiz (questões).
 */
export type Modo = 'estudar' | 'revisar' | 'quiz';

/**
 * Verifica se um domínio tem conteúdo para o modo escolhido (e, no caso de Revisar, para a
 * dificuldade escolhida) — usado tanto pela tela de seleção de escopo (evitar navegar para uma
 * tela vazia, seção 7.3) quanto pela fila sequencial "tudo" (pular domínio sem conteúdo,
 * seção 5.3 / AC-06).
 */
export async function dominioTemConteudo(
  modo: Modo,
  slug: string,
  opts?: { dificuldade?: string },
): Promise<boolean> {
  if (modo === 'estudar') {
    const detalhe = await fetchDominioDetalhe(slug);
    return detalhe.conceitos.length > 0;
  }
  if (modo === 'revisar') {
    const cards = await fetchFlashcards(slug, opts?.dificuldade);
    return cards.length > 0;
  }
  const questoes = await fetchQuestoes(slug);
  return questoes.length > 0;
}
