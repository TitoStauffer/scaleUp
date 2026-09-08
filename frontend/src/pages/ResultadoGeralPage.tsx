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

export function ResultadoGeralPage() {
  const result = useAsync(carregarResultadoGeral, []);

  return (
    <section aria-labelledby="resultado-geral-title">
      <p className="breadcrumb">
        <Link to="/">Domínios</Link> / Resultado geral
      </p>
      <h1 id="resultado-geral-title">Resultado geral</h1>
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
            <p className="empty-state">
              Ainda não avaliado — conclua evidências suficientes (quiz e flashcards) em pelo
              menos um domínio para ver seu resultado geral.
            </p>
          )
        }
      </RequestState>
    </section>
  );
}
