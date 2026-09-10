import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchDominios, fetchDominioDetalhe } from '../api/dominios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import { dominioTemConteudo, type Modo } from '../lib/escopo';

interface ModoConfig {
  titulo: string;
  tudoLabel: string;
  tudoDescricao: string;
  tudoRota: string;
  escolherLabel: string;
  mensagemVazioGeral: string;
}

const CONFIG: Record<Modo, ModoConfig> = {
  estudar: {
    titulo: 'O que você quer estudar?',
    tudoLabel: 'Estudar tudo',
    tudoDescricao: 'Percorra todos os seus domínios, um de cada vez.',
    tudoRota: '/estudar/tudo',
    escolherLabel: 'Escolher domínio',
    mensagemVazioGeral: 'Este domínio ainda não tem conceitos ou slides publicados.',
  },
  revisar: {
    titulo: 'O que você quer revisar?',
    tudoLabel: 'Revisar tudo',
    tudoDescricao: 'Percorra todos os seus domínios, um de cada vez.',
    tudoRota: '/revisar/tudo',
    escolherLabel: 'Escolher domínio',
    mensagemVazioGeral: 'Nenhum flashcard disponível para este domínio ainda.',
  },
  quiz: {
    titulo: 'O que você quer praticar no quiz?',
    tudoLabel: 'Quiz geral',
    tudoDescricao: 'Percorra todos os seus domínios, um de cada vez.',
    tudoRota: '/quiz/tudo',
    escolherLabel: 'Escolher domínio',
    mensagemVazioGeral: 'Nenhuma questão disponível para este domínio ainda.',
  },
};

type Opcao = 'tudo' | 'dominio' | null;

/**
 * Tela de seleção de escopo, compartilhada por Estudar/Revisar/Quiz (ticket UI/UX, seção 7 e
 * 10 — "componente parametrizável por modo, evitando 3 componentes quase idênticos").
 */
export function EscolherEscopoPage({ modo }: { modo: Modo }) {
  const config = CONFIG[modo];
  const dominiosResult = useAsync(fetchDominios, []);

  const [opcao, setOpcao] = useState<Opcao>(null);
  const [dominioSlug, setDominioSlug] = useState('');
  const [conceitoId, setConceitoId] = useState('todos');
  const [dificuldade, setDificuldade] = useState('todas');
  const [verificando, setVerificando] = useState(false);
  const [erroConteudo, setErroConteudo] = useState<string | null>(null);
  const navigate = useNavigate();

  const detalheResult = useAsync(
    () => (modo === 'estudar' && dominioSlug ? fetchDominioDetalhe(dominioSlug) : Promise.resolve(null)),
    [modo, dominioSlug],
  );

  function selecionarDominio(slug: string) {
    setDominioSlug(slug);
    setConceitoId('todos');
    setDificuldade('todas');
    setErroConteudo(null);
  }

  async function iniciar() {
    if (opcao === 'tudo') {
      navigate(config.tudoRota);
      return;
    }

    if (opcao !== 'dominio' || !dominioSlug) return;

    setErroConteudo(null);
    setVerificando(true);
    try {
      const dificuldadeParam = modo === 'revisar' && dificuldade !== 'todas' ? dificuldade : undefined;
      const temConteudo = await dominioTemConteudo(modo, dominioSlug, { dificuldade: dificuldadeParam });
      if (!temConteudo) {
        setErroConteudo(
          dificuldadeParam
            ? `Nenhum flashcard com dificuldade "${dificuldadeParam}" disponível para este domínio ainda.`
            : config.mensagemVazioGeral,
        );
        return;
      }

      if (modo === 'estudar') {
        const query = conceitoId !== 'todos' ? `?conceito=${encodeURIComponent(conceitoId)}` : '';
        navigate(`/dominios/${dominioSlug}${query}`);
      } else if (modo === 'revisar') {
        const query = dificuldadeParam ? `?dificuldade=${encodeURIComponent(dificuldadeParam)}` : '';
        navigate(`/dominios/${dominioSlug}/flashcards${query}`);
      } else {
        navigate(`/dominios/${dominioSlug}/quiz`);
      }
    } catch {
      setErroConteudo('Não foi possível verificar o conteúdo deste domínio. Tente novamente.');
    } finally {
      setVerificando(false);
    }
  }

  const podeComecar = opcao === 'tudo' || (opcao === 'dominio' && dominioSlug !== '');

  return (
    <section aria-labelledby="escopo-title">
      <h1 id="escopo-title">{config.titulo}</h1>
      <RequestState result={dominiosResult} loadingLabel="Carregando domínios...">
        {(dominios) =>
          dominios.length === 0 ? (
            <p className="empty-state">Nenhum domínio disponível no momento.</p>
          ) : (
            <div className="escopo-page">
              <div role="radiogroup" aria-labelledby="escopo-title" className="escopo-opcoes">
                <label className="escopo-opcao">
                  <input
                    type="radio"
                    name="escopo-opcao"
                    value="tudo"
                    checked={opcao === 'tudo'}
                    onChange={() => setOpcao('tudo')}
                  />
                  <span>
                    <strong>{config.tudoLabel}</strong>
                    <br />
                    {config.tudoDescricao}
                  </span>
                </label>
                <label className="escopo-opcao">
                  <input
                    type="radio"
                    name="escopo-opcao"
                    value="dominio"
                    checked={opcao === 'dominio'}
                    onChange={() => setOpcao('dominio')}
                  />
                  <span>
                    <strong>{config.escolherLabel}</strong>
                  </span>
                </label>
              </div>

              {opcao === 'dominio' && (
                <div className="escopo-detalhe">
                  <label className="escopo-select-label">
                    Domínio
                    <select
                      value={dominioSlug}
                      onChange={(e) => selecionarDominio(e.target.value)}
                    >
                      <option value="">Selecione um domínio</option>
                      {dominios.map((d) => (
                        <option key={d.id} value={d.slug}>
                          {d.nome}
                        </option>
                      ))}
                    </select>
                  </label>

                  {modo === 'estudar' && dominioSlug && (
                    <label className="escopo-select-label">
                      Conceito
                      <select value={conceitoId} onChange={(e) => setConceitoId(e.target.value)}>
                        <option value="todos">Todos os conceitos</option>
                        {detalheResult.status === 'success' &&
                          detalheResult.data?.conceitos.map((c) => (
                            <option key={c.id} value={c.id}>
                              {c.titulo}
                            </option>
                          ))}
                      </select>
                    </label>
                  )}

                  {modo === 'revisar' && dominioSlug && (
                    <label className="escopo-select-label">
                      Dificuldade
                      <select value={dificuldade} onChange={(e) => setDificuldade(e.target.value)}>
                        <option value="todas">Todas as dificuldades</option>
                        <option value="facil">Fácil</option>
                        <option value="medio">Médio</option>
                        <option value="dificil">Difícil</option>
                      </select>
                    </label>
                  )}
                </div>
              )}

              {erroConteudo && (
                <div role="alert" className="status-message status-message--error">
                  <p>{erroConteudo}</p>
                </div>
              )}

              <div className="escopo-actions">
                <button
                  type="button"
                  onClick={iniciar}
                  disabled={!podeComecar || verificando}
                  aria-disabled={!podeComecar || verificando}
                >
                  {verificando ? 'Verificando...' : 'Começar'}
                </button>
                {!podeComecar && (
                  <p className="escopo-ajuda">
                    Escolha "{config.tudoLabel}" ou selecione um domínio para continuar.
                  </p>
                )}
              </div>
            </div>
          )
        }
      </RequestState>
    </section>
  );
}
