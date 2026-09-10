import { useEffect, useRef, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { fetchDominioDetalhe } from '../api/dominios';
import { iniciarSessao } from '../api/sessoes';
import { iniciarQuizAttempt, submeterQuizAttempt } from '../api/quizAttempts';
import { ApiError } from '../api/client';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import { useFilaSequencial } from '../fila/FilaSequencialContext';
import type { QuizAttempt, RespostaSubmissao, SubmissaoResultado } from '../api/types';

interface FluxoQuiz {
  dominioId: string;
  attempt: QuizAttempt;
}

/**
 * Inicia, em sequência, uma StudySession e um QuizAttempt reais para o domínio (ticket,
 * seção 7). Cada visita a esta tela começa uma tentativa nova — não há endpoint para
 * descobrir/retomar uma sessão ativa existente, então essa é a menor solução adequada.
 */
async function iniciarFluxoQuiz(slug: string): Promise<FluxoQuiz> {
  const dominio = await fetchDominioDetalhe(slug);
  const sessao = await iniciarSessao(dominio.id);
  const attempt = await iniciarQuizAttempt(sessao.id);
  return { dominioId: dominio.id, attempt };
}

type EstadoSubmissao =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'erro'; mensagem: string }
  | { status: 'concluido'; resultado: SubmissaoResultado };

function nivelLabel(progresso: SubmissaoResultado['progresso']): string {
  if (progresso.emAvaliacao) {
    return `Nível em avaliação — faltam ${progresso.faltamSessoesQuiz} tentativa(s) de quiz e ${progresso.faltamRevisoesFlashcard} revisão(ões) de flashcard para o domínio ter evidência suficiente.`;
  }
  return `Nível atual do domínio: ${progresso.nivelAtual} (pontuação geral ${progresso.pontuacaoGeral?.toFixed(2)}).`;
}

// Ticket UI/UX — seletor de confiança escondido da UI por decisão de produto (não é bug,
// não remover a lógica). Religar: trocar para `true`.
const EXIBIR_SELETOR_CONFIANCA = false;

interface Props {
  /** Slug vindo da fila sequencial (`FilaSequencialPage`) — ver `DomainSlidesPage` para o mesmo padrão. */
  slugProp?: string;
}

export function QuizPage({ slugProp }: Props = {}) {
  const { slug: slugParam } = useParams<{ slug: string }>();
  const slug = slugProp ?? slugParam ?? '';
  const fila = useFilaSequencial();
  const result = useAsync(() => iniciarFluxoQuiz(slug), [slug]);

  const [index, setIndex] = useState(0);
  const [respostas, setRespostas] = useState<Record<string, string>>({});
  const [confiancas, setConfiancas] = useState<Record<string, number>>({});
  const [submissao, setSubmissao] = useState<EstadoSubmissao>({ status: 'idle' });
  const attemptIdVisto = useRef<string | null>(null);

  const attempt = result.status === 'success' ? result.data.attempt : null;

  // Reseta o estado local sempre que uma nova tentativa é iniciada (primeira carga ou
  // "Fazer nova tentativa" após o resultado).
  useEffect(() => {
    if (attempt && attemptIdVisto.current !== attempt.id) {
      attemptIdVisto.current = attempt.id;
      setIndex(0);
      setRespostas({});
      setConfiancas({});
      setSubmissao({ status: 'idle' });
    }
  }, [attempt]);

  async function enviarQuiz() {
    if (!attempt) return;
    setSubmissao({ status: 'enviando' });
    const payload: RespostaSubmissao[] = attempt.questoes.map((questao) => ({
      questionId: questao.id,
      alternativaSelecionadaId: respostas[questao.id] ?? null,
      confiancaDeclarada: confiancas[questao.id],
    }));
    try {
      const resultado = await submeterQuizAttempt(attempt.id, { respostas: payload });
      setSubmissao({ status: 'concluido', resultado });
    } catch (err) {
      const mensagem =
        err instanceof ApiError
          ? err.message
          : 'Ocorreu um erro inesperado ao enviar o quiz. Tente novamente.';
      setSubmissao({ status: 'erro', mensagem });
    }
  }

  return (
    <RequestState result={result} loadingLabel="Preparando sua tentativa de quiz...">
      {({ attempt: tentativa }) => {
        if (tentativa.questoes.length === 0) {
          return (
            <>
              <p className="empty-state">
                Nenhuma questão disponível para este domínio ainda.
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

        if (submissao.status === 'concluido') {
          const { resultado } = submissao;
          return (
            <div className="quiz-summary" role="status">
              <h2>Quiz concluído</h2>
              <p>
                Você acertou {resultado.acertos} de {resultado.totalQuestoes} questões —
                pontuação da tentativa: {resultado.pontuacaoObtida.toFixed(2)}.
              </p>
              <p className="quiz-progress-note">{nivelLabel(resultado.progresso)}</p>

              <ol className="quiz-review-list">
                {resultado.respostas.map((resposta) => {
                  const questao = tentativa.questoes.find((q) => q.id === resposta.questionId);
                  const alternativaCorreta = questao?.alternativas.find(
                    (a) => a.id === resposta.alternativaCorretaId,
                  );
                  return (
                    <li
                      key={resposta.questionId}
                      className={`quiz-review-item ${resposta.correta ? 'quiz-review-item--correta' : 'quiz-review-item--errada'}`}
                    >
                      <p className="quiz-review-enunciado">{questao?.enunciado}</p>
                      <p>{resposta.correta ? 'Você acertou.' : 'Você errou.'}</p>
                      <p>Alternativa correta: {alternativaCorreta?.texto ?? resposta.alternativaCorretaId}</p>
                      <p className="quiz-review-explicacao">{resposta.explicacao}</p>
                    </li>
                  );
                })}
              </ol>

              {fila && (
                <p className="fila-counter">
                  Domínio {fila.indiceAtual + 1} de {fila.totalDominios} concluído.
                </p>
              )}

              <div className="quiz-summary-actions">
                <Link to={`/dominios/${slug}/progresso`}>Ver progresso do domínio</Link>
                <button type="button" onClick={result.reload}>
                  Fazer nova tentativa
                </button>
                {fila && (
                  <>
                    <button type="button" onClick={fila.avancar}>
                      Próximo domínio
                    </button>
                    <button type="button" className="logout-button" onClick={fila.encerrar}>
                      Encerrar sessão de tudo
                    </button>
                  </>
                )}
              </div>
            </div>
          );
        }

        const safeIndex = Math.min(index, tentativa.questoes.length - 1);
        const questao = tentativa.questoes[safeIndex];
        const selecionada = respostas[questao.id];
        const isUltima = safeIndex === tentativa.questoes.length - 1;
        const respondidas = tentativa.questoes.filter((q) => respostas[q.id]).length;
        const enviando = submissao.status === 'enviando';

        return (
          <div className="quiz-viewer">
            <p className="quiz-counter">
              Questão {safeIndex + 1} de {tentativa.questoes.length} · dificuldade: {questao.dificuldade} ·
              {' '}
              {respondidas} de {tentativa.questoes.length} respondidas
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
                    disabled={enviando}
                    onChange={() =>
                      setRespostas((prev) => ({ ...prev, [questao.id]: alternativa.id }))
                    }
                  />
                  {alternativa.texto}
                </label>
              ))}
            </fieldset>

            {EXIBIR_SELETOR_CONFIANCA && (
              <fieldset className="quiz-confianca" disabled={enviando}>
                <legend>Quão confiante você está nesta resposta? (opcional)</legend>
                <div className="quiz-confianca-options">
                  {[1, 2, 3, 4, 5].map((nivel) => (
                    <label key={nivel} className="quiz-confianca-option">
                      <input
                        type="radio"
                        name={`confianca-${questao.id}`}
                        value={nivel}
                        checked={confiancas[questao.id] === nivel}
                        onChange={() => setConfiancas((prev) => ({ ...prev, [questao.id]: nivel }))}
                      />
                      {nivel}
                    </label>
                  ))}
                </div>
              </fieldset>
            )}

            <div className="pager">
              <button
                type="button"
                onClick={() => setIndex((i) => i - 1)}
                disabled={safeIndex === 0 || enviando}
              >
                Anterior
              </button>
              {isUltima ? (
                <button type="button" onClick={enviarQuiz} disabled={enviando}>
                  {enviando ? 'Enviando...' : 'Enviar quiz'}
                </button>
              ) : (
                <button type="button" onClick={() => setIndex((i) => i + 1)} disabled={enviando}>
                  Próxima
                </button>
              )}
            </div>

            {submissao.status === 'erro' && (
              <div role="alert" className="status-message status-message--error quiz-submit-error">
                <p>{submissao.mensagem}</p>
              </div>
            )}

            <p className="quiz-disclaimer">
              As respostas corretas e as explicações só aparecem depois de enviar o quiz.
            </p>
          </div>
        );
      }}
    </RequestState>
  );
}
