import { useState } from 'react';
import { useParams, useSearchParams } from 'react-router-dom';
import { fetchDominioDetalhe, fetchFlashcards } from '../api/dominios';
import { iniciarSessao, registrarFlashcardReview } from '../api/sessoes';
import { ApiError } from '../api/client';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import { useFilaSequencial } from '../fila/FilaSequencialContext';
import type { Flashcard } from '../api/types';

interface FluxoFlashcards {
  sessaoId: string;
  cards: Flashcard[];
}

/**
 * Inicia uma StudySession real para o domínio (não há endpoint para retomar uma sessão
 * ativa existente, então cada visita a esta tela começa uma sessão nova — mesma decisão
 * tomada no QuizPage) e carrega os flashcards do domínio, opcionalmente filtrados por
 * dificuldade (ticket UI/UX, seção 5.4 / AC-09).
 */
async function iniciarFluxoFlashcards(slug: string, dificuldade?: string): Promise<FluxoFlashcards> {
  const [dominio, cards] = await Promise.all([
    fetchDominioDetalhe(slug),
    fetchFlashcards(slug, dificuldade),
  ]);
  const sessao = await iniciarSessao(dominio.id);
  return { sessaoId: sessao.id, cards };
}

type EstadoEnvio = { status: 'idle' } | { status: 'enviando' } | { status: 'erro'; mensagem: string };

interface Props {
  /** Slug vindo da fila sequencial (`FilaSequencialPage`) — ver `DomainSlidesPage` para o mesmo padrão. */
  slugProp?: string;
}

export function FlashcardsPage({ slugProp }: Props = {}) {
  const { slug: slugParam } = useParams<{ slug: string }>();
  const slug = slugProp ?? slugParam ?? '';
  const [searchParams] = useSearchParams();
  // AC-09: filtro de dificuldade vindo da tela de seleção de escopo
  // (`/dominios/:slug/flashcards?dificuldade=facil`). Ausente na fila "tudo".
  const dificuldade = searchParams.get('dificuldade') ?? undefined;
  const fila = useFilaSequencial();

  const result = useAsync(() => iniciarFluxoFlashcards(slug, dificuldade), [slug, dificuldade]);
  const [index, setIndex] = useState(0);
  const [revelado, setRevelado] = useState(false);
  const [avaliados, setAvaliados] = useState<Record<string, 'lembrei' | 'nao_lembrei'>>({});
  const [envio, setEnvio] = useState<EstadoEnvio>({ status: 'idle' });

  function irPara(novoIndex: number) {
    setIndex(novoIndex);
    setRevelado(false);
    setEnvio({ status: 'idle' });
  }

  async function avaliar(sessaoId: string, card: Flashcard, resultado: 'lembrei' | 'nao_lembrei') {
    setEnvio({ status: 'enviando' });
    try {
      await registrarFlashcardReview(sessaoId, {
        flashcardId: card.id,
        resultadoAutoavaliacao: resultado,
      });
      setAvaliados((prev) => ({ ...prev, [card.id]: resultado }));
      setEnvio({ status: 'idle' });
    } catch (err) {
      const mensagem =
        err instanceof ApiError
          ? err.message
          : 'Ocorreu um erro inesperado ao registrar sua autoavaliação. Tente novamente.';
      setEnvio({ status: 'erro', mensagem });
    }
  }

  return (
    <RequestState result={result} loadingLabel="Carregando flashcards...">
      {({ sessaoId, cards }) => {
        const filaBloco = fila && (
          <div className="fila-progresso">
            <p className="fila-counter">
              Domínio {fila.indiceAtual + 1} de {fila.totalDominios}
            </p>
            <div className="fila-progresso-actions">
              <button type="button" onClick={fila.mostrarConcluido}>
                Concluir revisão deste domínio
              </button>
              <button type="button" className="logout-button" onClick={fila.encerrar}>
                Encerrar sessão de tudo
              </button>
            </div>
          </div>
        );

        if (cards.length === 0) {
          return (
            <>
              <p className="empty-state">
                {dificuldade
                  ? `Nenhum flashcard com dificuldade "${dificuldade}" disponível para este domínio ainda.`
                  : 'Nenhum flashcard disponível para este domínio ainda.'}
              </p>
              {filaBloco}
            </>
          );
        }

        const safeIndex = Math.min(index, cards.length - 1);
        const card = cards[safeIndex];
        const avaliacaoAtual = avaliados[card.id];
        const enviando = envio.status === 'enviando';

        return (
          <>
            <div className="flashcard-viewer">
              <p className="flashcard-counter">
                Card {safeIndex + 1} de {cards.length} · dificuldade: {card.dificuldade}
              </p>
              <button
                type="button"
                className="flashcard"
                aria-pressed={revelado}
                onClick={() => setRevelado((r) => !r)}
              >
                <span className="flashcard-face-label">{revelado ? 'Verso' : 'Frente'}</span>
                <span className="flashcard-text">{revelado ? card.verso : card.frente}</span>
                <span className="flashcard-hint">Clique ou pressione Enter para virar</span>
              </button>

              {revelado && (
                <div className="flashcard-autoavaliacao" role="group" aria-label="Autoavaliação">
                  <p>Você lembrou da resposta?</p>
                  <div className="flashcard-autoavaliacao-actions">
                    <button
                      type="button"
                      onClick={() => avaliar(sessaoId, card, 'lembrei')}
                      disabled={enviando}
                      aria-pressed={avaliacaoAtual === 'lembrei'}
                    >
                      Lembrei
                    </button>
                    <button
                      type="button"
                      onClick={() => avaliar(sessaoId, card, 'nao_lembrei')}
                      disabled={enviando}
                      aria-pressed={avaliacaoAtual === 'nao_lembrei'}
                    >
                      Não lembrei
                    </button>
                  </div>
                  {avaliacaoAtual && (
                    <p role="status" className="flashcard-autoavaliacao-confirmacao">
                      Autoavaliação registrada: {avaliacaoAtual === 'lembrei' ? 'lembrei' : 'não lembrei'}.
                    </p>
                  )}
                  {envio.status === 'erro' && (
                    <div role="alert" className="status-message status-message--error">
                      <p>{envio.mensagem}</p>
                    </div>
                  )}
                </div>
              )}

              <div className="pager">
                <button
                  type="button"
                  onClick={() => irPara(safeIndex - 1)}
                  disabled={safeIndex === 0}
                >
                  Anterior
                </button>
                <button
                  type="button"
                  onClick={() => irPara(safeIndex + 1)}
                  disabled={safeIndex === cards.length - 1}
                >
                  Próximo
                </button>
              </div>
            </div>

            {filaBloco}
          </>
        );
      }}
    </RequestState>
  );
}
