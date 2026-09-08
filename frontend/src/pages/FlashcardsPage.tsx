import { useState } from 'react';
import { useParams } from 'react-router-dom';
import { fetchFlashcards } from '../api/dominios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';

export function FlashcardsPage() {
  const { slug } = useParams<{ slug: string }>();
  const result = useAsync(() => fetchFlashcards(slug ?? ''), [slug]);
  const [index, setIndex] = useState(0);
  const [revelado, setRevelado] = useState(false);

  function irPara(novoIndex: number) {
    setIndex(novoIndex);
    setRevelado(false);
  }

  return (
    <RequestState result={result} loadingLabel="Carregando flashcards...">
      {(cards) => {
        if (cards.length === 0) {
          return (
            <p className="empty-state">
              Nenhum flashcard disponível para este domínio ainda.
            </p>
          );
        }

        const safeIndex = Math.min(index, cards.length - 1);
        const card = cards[safeIndex];

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
