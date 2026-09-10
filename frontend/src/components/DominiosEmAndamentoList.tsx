import { Link } from 'react-router-dom';
import { fetchDominios } from '../api/dominios';
import { fetchProgresso } from '../api/progresso';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { DomainSummary } from '../api/types';

/**
 * Um item da lista busca o próprio progresso (`GET /dominios/{id}/progresso`) de forma
 * independente dos demais — se a chamada de um domínio falhar, só aquele item mostra erro com
 * "Tentar novamente"; o restante do dashboard (e os outros itens) continua funcional (AC-14).
 */
function DominioEmAndamentoItem({ dominio }: { dominio: DomainSummary }) {
  const result = useAsync(() => fetchProgresso(dominio.id), [dominio.id]);

  return (
    <li className="dominio-andamento-item">
      <RequestState result={result} loadingLabel="Carregando...">
        {(progresso) => (
          <Link to={`/dominios/${dominio.slug}/progresso`} className="dominio-andamento-link">
            <span className="dominio-andamento-nome">{dominio.nome}</span>
            {progresso.emAvaliacao ? (
              <span className="dominio-andamento-badge">Em avaliação</span>
            ) : (
              <span className="dominio-andamento-badge dominio-andamento-badge--nivel">
                {progresso.nivelAtual}
              </span>
            )}
          </Link>
        )}
      </RequestState>
    </li>
  );
}

/**
 * Bloco "Domínios em andamento" do dashboard (ticket UI/UX, seção 6.4) — nível atual por
 * domínio, uma chamada por domínio (aceitável no volume atual; endpoint agregador é uma
 * necessidade sinalizada ao Backend, não deste ticket).
 */
export function DominiosEmAndamentoList() {
  const result = useAsync(fetchDominios, []);

  return (
    <div className="dashboard-block" aria-labelledby="dominios-andamento-title">
      <h2 id="dominios-andamento-title">Domínios em andamento</h2>
      <RequestState result={result} loadingLabel="Carregando domínios...">
        {(dominios) =>
          dominios.length === 0 ? (
            <p className="empty-state">Nenhum domínio disponível no momento.</p>
          ) : (
            <ul className="dominio-andamento-list">
              {dominios.map((dominio) => (
                <DominioEmAndamentoItem key={dominio.id} dominio={dominio} />
              ))}
            </ul>
          )
        }
      </RequestState>
    </div>
  );
}
