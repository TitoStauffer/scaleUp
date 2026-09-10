import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchDominios } from '../api/dominios';
import { dominioTemConteudo, type Modo } from '../lib/escopo';
import { FilaSequencialProvider } from '../fila/FilaSequencialContext';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import { DomainSlidesPage } from './DomainSlidesPage';
import { FlashcardsPage } from './FlashcardsPage';
import { QuizPage } from './QuizPage';
import type { DomainSummary } from '../api/types';

const CONFIG: Record<Modo, { titulo: string; substantivo: string; concluirLabel: string }> = {
  estudar: { titulo: 'Estudar tudo', substantivo: 'estudo', concluirLabel: 'Concluir este domínio' },
  revisar: { titulo: 'Revisar tudo', substantivo: 'revisão', concluirLabel: 'Concluir revisão deste domínio' },
  quiz: { titulo: 'Quiz geral', substantivo: 'quiz', concluirLabel: 'Concluir quiz deste domínio' },
};

type Etapa = 'verificando' | 'ativo' | 'concluido' | 'fim';

/**
 * Orquestra o fluxo cross-domínio "Estudar tudo" / "Revisar tudo" / "Quiz geral" (ticket UI/UX,
 * seção 5.3). Não existe sessão/tentativa verdadeiramente cross-domínio no backend hoje — por
 * isso isto é uma fila sequencial de domínios montada e avançada inteiramente no frontend,
 * reaproveitando as páginas de conteúdo já existentes (uma sessão por domínio, como já
 * acontecia antes deste ticket).
 */
export function FilaSequencialPage({ modo }: { modo: Modo }) {
  const dominiosResult = useAsync(fetchDominios, []);
  const dominios: DomainSummary[] | null =
    dominiosResult.status === 'success' ? dominiosResult.data : null;

  const [indice, setIndice] = useState(0);
  const [etapa, setEtapa] = useState<Etapa>('verificando');
  const [concluidos, setConcluidos] = useState(0);
  const [erroVerificacao, setErroVerificacao] = useState<string | null>(null);
  const navigate = useNavigate();
  const tentativaVerificacao = useRef(0);

  useEffect(() => {
    if (!dominios) return;

    if (indice >= dominios.length) {
      setEtapa('fim');
      return;
    }

    let cancelado = false;
    setEtapa('verificando');
    setErroVerificacao(null);

    dominioTemConteudo(modo, dominios[indice].slug)
      .then((temConteudo) => {
        if (cancelado) return;
        if (temConteudo) {
          setEtapa('ativo');
        } else {
          // AC-06: domínio sem conteúdo para o modo escolhido é pulado automaticamente, sem
          // interromper o usuário.
          setIndice((i) => i + 1);
        }
      })
      .catch(() => {
        if (cancelado) return;
        setErroVerificacao('Não foi possível verificar o conteúdo deste domínio.');
      });

    return () => {
      cancelado = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [dominios, indice, modo, tentativaVerificacao.current]);

  function avancar() {
    setConcluidos((c) => c + 1);
    setIndice((i) => i + 1);
  }

  function mostrarConcluido() {
    setEtapa('concluido');
  }

  function encerrar() {
    navigate('/');
  }

  function tentarNovamente() {
    tentativaVerificacao.current += 1;
    setErroVerificacao(null);
    setIndice((i) => i);
  }

  const config = CONFIG[modo];

  return (
    <section aria-labelledby="fila-title">
      <h1 id="fila-title">{config.titulo}</h1>
      <RequestState result={dominiosResult} loadingLabel="Carregando domínios...">
        {(lista) => {
          if (lista.length === 0) {
            return <p className="empty-state">Nenhum domínio disponível no momento.</p>;
          }

          if (erroVerificacao) {
            return (
              <div role="alert" className="status-message status-message--error">
                <p>{erroVerificacao}</p>
                <button type="button" onClick={tentarNovamente}>
                  Tentar novamente
                </button>
              </div>
            );
          }

          if (etapa === 'verificando') {
            return (
              <p role="status" className="status-message">
                Preparando o próximo domínio da fila...
              </p>
            );
          }

          if (etapa === 'fim') {
            return (
              <div className="fila-conclusao" role="status">
                <h2>Fila concluída</h2>
                <p>
                  Você concluiu {config.substantivo} em {concluidos}{' '}
                  {concluidos === 1 ? 'domínio' : 'domínios'}.
                </p>
                <button type="button" onClick={() => navigate('/')}>
                  Voltar para o início
                </button>
              </div>
            );
          }

          const dominioAtual = lista[indice];

          if (etapa === 'concluido') {
            return (
              <div className="fila-conclusao" role="status">
                <h2>
                  {dominioAtual.nome} concluído ({indice + 1} de {lista.length})
                </h2>
                <div className="fila-conclusao-actions">
                  <button type="button" onClick={avancar}>
                    Próximo domínio
                  </button>
                  <button type="button" onClick={encerrar} className="logout-button">
                    Encerrar sessão de tudo
                  </button>
                </div>
              </div>
            );
          }

          return (
            <FilaSequencialProvider
              value={{
                modo,
                indiceAtual: indice,
                totalDominios: lista.length,
                mostrarConcluido,
                avancar,
                encerrar,
              }}
            >
              {modo === 'estudar' && <DomainSlidesPage slugProp={dominioAtual.slug} />}
              {modo === 'revisar' && <FlashcardsPage slugProp={dominioAtual.slug} />}
              {modo === 'quiz' && <QuizPage slugProp={dominioAtual.slug} />}
            </FilaSequencialProvider>
          );
        }}
      </RequestState>
    </section>
  );
}
