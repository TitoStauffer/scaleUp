import { useParams } from 'react-router-dom';
import { fetchDominioDetalhe } from '../api/dominios';
import { fetchProgresso } from '../api/progresso';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { DomainProgress } from '../api/types';

async function carregarProgresso(slug: string): Promise<DomainProgress> {
  const dominio = await fetchDominioDetalhe(slug);
  return fetchProgresso(dominio.id);
}

interface ComponenteInfo {
  label: string;
  valor: number | null;
}

function formatarPontuacao(valor: number | null): string {
  return valor === null ? 'Ainda sem dados suficientes' : valor.toFixed(2);
}

export function ProgressoPage() {
  const { slug } = useParams<{ slug: string }>();
  const result = useAsync(() => carregarProgresso(slug ?? ''), [slug]);

  return (
    <RequestState result={result} loadingLabel="Carregando progresso do domínio...">
      {(progresso) => {
        const componentes: ComponenteInfo[] = [
          { label: 'Quiz (peso 40%)', valor: progresso.pontuacaoQuiz },
          { label: 'Flashcards (peso 25%)', valor: progresso.pontuacaoFlashcards },
          { label: 'Questões novas (peso 20%)', valor: progresso.pontuacaoQuestoesNovas },
          { label: 'Consistência (peso 10%)', valor: progresso.pontuacaoConsistencia },
          { label: 'Calibração de autoconfiança (peso 5%)', valor: progresso.pontuacaoCalibracao },
        ];

        return (
          <div className="progresso-viewer">
            {progresso.emAvaliacao ? (
              <div className="status-message progresso-em-avaliacao">
                <p>
                  Nível em avaliação — ainda faltam evidências suficientes neste domínio: {' '}
                  {progresso.faltamSessoesQuiz} tentativa(s) de quiz e {progresso.faltamRevisoesFlashcard}{' '}
                  revisão(ões) de flashcard.
                </p>
              </div>
            ) : (
              <div className="progresso-resumo">
                <p className="progresso-nivel">Nível atual: {progresso.nivelAtual}</p>
                <p className="progresso-geral">
                  Pontuação geral: {formatarPontuacao(progresso.pontuacaoGeral)}
                </p>
              </div>
            )}

            <ul className="progresso-componentes">
              {componentes.map((componente) => (
                <li key={componente.label} className="progresso-componente">
                  <span className="progresso-componente-label">{componente.label}</span>
                  <span className="progresso-componente-valor">{formatarPontuacao(componente.valor)}</span>
                </li>
              ))}
            </ul>
          </div>
        );
      }}
    </RequestState>
  );
}
