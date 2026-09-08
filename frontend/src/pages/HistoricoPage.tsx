import { useParams } from 'react-router-dom';
import { fetchDominioDetalhe } from '../api/dominios';
import { fetchHistorico } from '../api/progresso';
import { fetchUsuarioAtual } from '../api/usuarios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { HistoricoItem } from '../api/types';

async function carregarHistorico(slug: string): Promise<HistoricoItem[]> {
  const [dominio, usuario] = await Promise.all([fetchDominioDetalhe(slug), fetchUsuarioAtual()]);
  return fetchHistorico(usuario.id, dominio.id);
}

function formatarData(iso: string): string {
  return new Date(iso).toLocaleString('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
}

export function HistoricoPage() {
  const { slug } = useParams<{ slug: string }>();
  const result = useAsync(() => carregarHistorico(slug ?? ''), [slug]);

  return (
    <RequestState result={result} loadingLabel="Carregando histórico...">
      {(itens) =>
        itens.length === 0 ? (
          <p className="empty-state">
            Nenhuma tentativa de quiz concluída neste domínio ainda. Faça um quiz para começar a
            acompanhar sua evolução.
          </p>
        ) : (
          <ul className="historico-list">
            {itens.map((item) => (
              <li key={item.quizAttemptId} className="historico-item">
                <span className="historico-pontuacao">{item.pontuacaoObtida.toFixed(2)}</span>
                <span className="historico-data">{formatarData(item.concluidoEm)}</span>
              </li>
            ))}
          </ul>
        )
      }
    </RequestState>
  );
}
