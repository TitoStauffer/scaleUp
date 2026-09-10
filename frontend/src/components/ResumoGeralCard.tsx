import { Link } from 'react-router-dom';
import { fetchUsuarioAtual } from '../api/usuarios';
import { fetchResultadoGeral } from '../api/progresso';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { ResultadoGeral } from '../api/types';

async function carregarResultadoGeral(): Promise<ResultadoGeral> {
  const usuario = await fetchUsuarioAtual();
  return fetchResultadoGeral(usuario.id);
}

/**
 * Bloco "Resumo geral" do dashboard (ticket UI/UX, seção 6.3) — fusão da antiga
 * `ResultadoGeralPage`, mesmo endpoint (`GET /usuarios/{userId}/resultado-geral`). Trata seu
 * próprio erro/loading independentemente dos outros blocos do dashboard (AC-14).
 */
export function ResumoGeralCard() {
  const result = useAsync(carregarResultadoGeral, []);

  return (
    <div className="dashboard-block" aria-labelledby="resumo-geral-title">
      <h2 id="resumo-geral-title">Resumo geral</h2>
      <RequestState result={result} loadingLabel="Carregando resultado geral...">
        {(resultado) =>
          resultado.avaliado ? (
            <div className="resultado-geral-resumo">
              <p className="resultado-geral-valor">{resultado.resultadoGeral!.toFixed(2)}</p>
              <p className="resultado-geral-detalhe">
                Média entre {resultado.dominiosAvaliados}{' '}
                {resultado.dominiosAvaliados === 1 ? 'domínio avaliado' : 'domínios avaliados'}.
              </p>
            </div>
          ) : (
            <div className="empty-state">
              <p>
                Ainda não avaliado — conclua evidências suficientes (quiz e flashcards) em pelo
                menos um domínio para ver seu resultado geral.
              </p>
              <Link to="/estudar">Começar a estudar</Link>
            </div>
          )
        }
      </RequestState>
    </div>
  );
}
