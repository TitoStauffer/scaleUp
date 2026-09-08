import type { ReactNode } from 'react';
import { Link } from 'react-router-dom';
import type { AsyncResult } from '../hooks/useAsync';

interface Props<T> {
  result: AsyncResult<T>;
  loadingLabel: string;
  children: (data: T) => ReactNode;
}

/**
 * Renderiza os três estados obrigatórios de uma chamada de API (carregando/erro/sucesso).
 * O estado de "vazio" (ex.: domínio sem conteúdo) é responsabilidade de cada página, pois o
 * significado de "vazio" muda por tela.
 */
export function RequestState<T>({ result, loadingLabel, children }: Props<T>) {
  if (result.status === 'loading') {
    return (
      <p role="status" className="status-message">
        {loadingLabel}
      </p>
    );
  }

  if (result.status === 'error') {
    const isNotFound = result.httpStatus === 404;
    return (
      <div role="alert" className="status-message status-message--error">
        <p>{result.message}</p>
        {isNotFound ? (
          <Link to="/">Voltar para a lista de domínios</Link>
        ) : (
          <button type="button" onClick={result.reload}>
            Tentar novamente
          </button>
        )}
      </div>
    );
  }

  return <>{children(result.data)}</>;
}
