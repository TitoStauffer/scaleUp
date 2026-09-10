import { useEffect, useRef, useState } from 'react';
import { useParams, useSearchParams } from 'react-router-dom';
import { fetchDominioDetalhe } from '../api/dominios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import { useFilaSequencial } from '../fila/FilaSequencialContext';
import type { Concept } from '../api/types';

interface Props {
  /**
   * Slug vindo da fila sequencial (`FilaSequencialPage`), quando esta página é renderizada
   * dentro do fluxo "Estudar tudo" em vez da rota `/dominios/:slug`. Sem essa prop, o slug é
   * lido normalmente da URL — comportamento idêntico ao existente antes deste ticket (AC-08,
   * AC-11).
   */
  slugProp?: string;
}

export function DomainSlidesPage({ slugProp }: Props = {}) {
  const { slug: slugParam } = useParams<{ slug: string }>();
  const slug = slugProp ?? slugParam ?? '';
  const [searchParams] = useSearchParams();
  // AC-10: deep-link para um conceito específico, vindo da tela de seleção de escopo
  // (`/dominios/:slug?conceito=<id>`). Ausente na fila "tudo", que sempre usa o domínio inteiro.
  const conceitoQueryId = searchParams.get('conceito');
  const fila = useFilaSequencial();

  const result = useAsync(() => fetchDominioDetalhe(slug), [slug]);
  const [conceptIndex, setConceptIndex] = useState(0);
  const [slideIndex, setSlideIndex] = useState(0);
  const conceitoInicialAplicado = useRef(false);

  useEffect(() => {
    if (result.status !== 'success' || conceitoInicialAplicado.current) return;
    conceitoInicialAplicado.current = true;
    if (!conceitoQueryId) return;
    const index = result.data.conceitos.findIndex((c) => c.id === conceitoQueryId);
    if (index >= 0) {
      setConceptIndex(index);
      setSlideIndex(0);
    }
  }, [result, conceitoQueryId]);

  function selecionarConcept(index: number) {
    setConceptIndex(index);
    setSlideIndex(0);
  }

  return (
    <RequestState result={result} loadingLabel="Carregando conteúdo do domínio...">
      {(dominio) => {
        if (dominio.conceitos.length === 0) {
          return (
            <>
              <p className="empty-state">
                Este domínio ainda não tem conceitos ou slides publicados.
              </p>
              {fila && (
                <div className="fila-progresso">
                  <button type="button" onClick={fila.avancar}>
                    Próximo domínio
                  </button>
                  <button type="button" className="logout-button" onClick={fila.encerrar}>
                    Encerrar sessão de tudo
                  </button>
                </div>
              )}
            </>
          );
        }

        const safeConceptIndex = Math.min(conceptIndex, dominio.conceitos.length - 1);
        const concept: Concept = dominio.conceitos[safeConceptIndex];
        const slides = [...concept.slides].sort((a, b) => a.ordem - b.ordem);
        const safeSlideIndex = Math.min(slideIndex, Math.max(slides.length - 1, 0));
        const slide = slides[safeSlideIndex];

        return (
          <>
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

            {fila && (
              <div className="fila-progresso">
                <p className="fila-counter">
                  Domínio {fila.indiceAtual + 1} de {fila.totalDominios}
                </p>
                <div className="fila-progresso-actions">
                  <button type="button" onClick={fila.mostrarConcluido}>
                    Concluir este domínio
                  </button>
                  <button type="button" className="logout-button" onClick={fila.encerrar}>
                    Encerrar sessão de tudo
                  </button>
                </div>
              </div>
            )}
          </>
        );
      }}
    </RequestState>
  );
}
