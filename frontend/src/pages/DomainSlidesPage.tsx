import { useState } from 'react';
import { useParams } from 'react-router-dom';
import { fetchDominioDetalhe } from '../api/dominios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { Concept } from '../api/types';

export function DomainSlidesPage() {
  const { slug } = useParams<{ slug: string }>();
  const result = useAsync(() => fetchDominioDetalhe(slug ?? ''), [slug]);
  const [conceptIndex, setConceptIndex] = useState(0);
  const [slideIndex, setSlideIndex] = useState(0);

  function selecionarConcept(index: number) {
    setConceptIndex(index);
    setSlideIndex(0);
  }

  return (
    <RequestState result={result} loadingLabel="Carregando conteúdo do domínio...">
      {(dominio) => {
        if (dominio.conceitos.length === 0) {
          return (
            <p className="empty-state">
              Este domínio ainda não tem conceitos ou slides publicados.
            </p>
          );
        }

        const safeConceptIndex = Math.min(conceptIndex, dominio.conceitos.length - 1);
        const concept: Concept = dominio.conceitos[safeConceptIndex];
        const slides = [...concept.slides].sort((a, b) => a.ordem - b.ordem);
        const safeSlideIndex = Math.min(slideIndex, Math.max(slides.length - 1, 0));
        const slide = slides[safeSlideIndex];

        return (
          <div className="slides-layout">
            <nav aria-label="Conceitos do domínio" className="concept-list">
              <ul>
                {dominio.conceitos.map((c, index) => (
                  <li key={c.id}>
                    <button
                      type="button"
                      className="concept-button"
                      aria-current={index === safeConceptIndex ? 'true' : undefined}
                      onClick={() => selecionarConcept(index)}
                    >
                      {c.titulo}
                    </button>
                  </li>
                ))}
              </ul>
            </nav>

            <div className="slide-viewer">
              <p className="concept-summary">{concept.resumo}</p>

              {slides.length === 0 ? (
                <p className="empty-state">Este conceito ainda não tem slides.</p>
              ) : (
                <>
                  <p className="slide-counter">
                    Slide {safeSlideIndex + 1} de {slides.length}
                  </p>
                  <article className="slide-card" aria-live="polite">
                    <h2>{slide.titulo}</h2>
                    <p>{slide.conteudo}</p>
                  </article>
                  <div className="pager">
                    <button
                      type="button"
                      onClick={() => setSlideIndex((i) => i - 1)}
                      disabled={safeSlideIndex === 0}
                    >
                      Anterior
                    </button>
                    <button
                      type="button"
                      onClick={() => setSlideIndex((i) => i + 1)}
                      disabled={safeSlideIndex === slides.length - 1}
                    >
                      Próximo
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        );
      }}
    </RequestState>
  );
}
