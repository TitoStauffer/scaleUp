import { useState } from 'react';
import { useParams } from 'react-router-dom';
import { fetchDominioDetalhe, fetchFlashcards } from '../api/dominios';
import { iniciarSessao, registrarFlashcardReview } from '../api/sessoes';
import { ApiError } from '../api/client';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { Flashcard } from '../api/types';

interface FluxoFlashcards {
  sessaoId: string;
  cards: Flashcard[];
}

/**
 * Inicia uma StudySession real para o domínio (não há endpoint para retomar uma sessão
 * ativa existente, então cada visita a esta tela começa uma sessão nova — mesma decisão
 * tomada no QuizPage) e carrega os flashcards do domínio.
 */
async function iniciarFluxoFlashcards(slug: string): Promise<FluxoFlashcards> {
  const [dominio, cards] = await Promise.all([fetchDominioDetalhe(slug), fetchFlashcards(slug)]);
  const sessao = await iniciarSessao(dominio.id);
  return { sessaoId: sessao.id, cards };
}

type EstadoEnvio = { status: 'idle' } | { status: 'enviando' } | { status: 'erro'; mensagem: string };

export function FlashcardsPage() {
  const { slug } = useParams<{ slug: string }>();
  const result = useAsync(() => iniciarFluxoFlashcards(slug ?? ''), [slug]);
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
        if (cards.length === 0) {
          return (
            <p className="empty-state">
              Nenhum flashcard disponível para este domínio ainda.
            </p>
          );
        }

        const safeIndex = Math.min(index, cards.length - 1);
        const card = cards[safeIndex];
        const avaliacaoAtual = avaliados[card.id];
        const enviando = envio.status === 'enviando';

        return (
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
        );
      }}
    </RequestState>
  );
}
