import { useState } from 'react';
import { useParams } from 'react-router-dom';
import { fetchQuestoes } from '../api/dominios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';

export function QuizPage() {
  const { slug } = useParams<{ slug: string }>();
  const result = useAsync(() => fetchQuestoes(slug ?? ''), [slug]);
  const [index, setIndex] = useState(0);
  const [respostas, setRespostas] = useState<Record<string, string>>({});
  const [concluido, setConcluido] = useState(false);

  return (
    <RequestState result={result} loadingLabel="Carregando questões...">
      {(questoes) => {
        if (questoes.length === 0) {
          return (
            <p className="empty-state">
              Nenhuma questão disponível para este domínio ainda.
            </p>
          );
        }

        if (concluido) {
          const respondidas = Object.keys(respostas).length;
          return (
            <div className="quiz-summary" role="status">
              <h2>Quiz concluído</h2>
              <p>
                Você respondeu {respondidas} de {questoes.length} questões.
              </p>
              <p className="quiz-disclaimer">
                A correção automática, a explicação de cada questão e a pontuação do domínio
                ainda não estão disponíveis nesta versão — esse recurso está em
                desenvolvimento. Suas respostas não foram enviadas nem avaliadas.
              </p>
              <button
                type="button"
                onClick={() => {
                  setConcluido(false);
                  setIndex(0);
                }}
              >
                Revisar respostas
              </button>
            </div>
          );
        }

        const safeIndex = Math.min(index, questoes.length - 1);
        const questao = questoes[safeIndex];
        const selecionada = respostas[questao.id];
        const isUltima = safeIndex === questoes.length - 1;

        return (
          <div className="quiz-viewer">
            <p className="quiz-counter">
              Questão {safeIndex + 1} de {questoes.length} · dificuldade: {questao.dificuldade}
            </p>
            <fieldset className="quiz-question">
              <legend>{questao.enunciado}</legend>
              {questao.alternativas.map((alternativa) => (
                <label key={alternativa.id} className="quiz-option">
                  <input
                    type="radio"
                    name={`questao-${questao.id}`}
                    value={alternativa.id}
                    checked={selecionada === alternativa.id}
                    onChange={() =>
                      setRespostas((prev) => ({ ...prev, [questao.id]: alternativa.id }))
                    }
                  />
                  {alternativa.texto}
                </label>
              ))}
            </fieldset>
            <div className="pager">
              <button
                type="button"
                onClick={() => setIndex((i) => i - 1)}
                disabled={safeIndex === 0}
              >
                Anterior
              </button>
              {isUltima ? (
                <button type="button" onClick={() => setConcluido(true)}>
                  Concluir quiz
                </button>
              ) : (
                <button type="button" onClick={() => setIndex((i) => i + 1)}>
                  Próxima
                </button>
              )}
            </div>
            <p className="quiz-disclaimer">
              Envio e resultado do quiz em breve — por enquanto você pode navegar pelas
              questões e escolher uma alternativa, mas nenhuma resposta é corrigida ou
              enviada.
            </p>
          </div>
        );
      }}
    </RequestState>
  );
}
