import { useEffect, useState } from 'react';
import { ApiError } from '../api/client';

export type AsyncState<T> =
  | { status: 'loading' }
  | { status: 'error'; message: string; httpStatus: number }
  | { status: 'success'; data: T };

export type AsyncResult<T> = AsyncState<T> & { reload: () => void };

/**
 * Hook genérico para chamadas de API que precisam dos três estados obrigatórios
 * (carregando/erro/sucesso). Reexecuta a busca quando `deps` muda ou quando `reload` é
 * chamado (ex.: botão "tentar novamente").
 */
export function useAsync<T>(fetcher: () => Promise<T>, deps: unknown[]): AsyncResult<T> {
  const [state, setState] = useState<AsyncState<T>>({ status: 'loading' });
  const [reloadKey, setReloadKey] = useState(0);

  useEffect(() => {
    let cancelled = false;
    setState({ status: 'loading' });

    fetcher()
      .then((data) => {
        if (!cancelled) {
          setState({ status: 'success', data });
        }
      })
      .catch((err: unknown) => {
        if (cancelled) return;
        if (err instanceof ApiError) {
          setState({ status: 'error', message: err.message, httpStatus: err.status });
        } else {
          setState({
            status: 'error',
            message: 'Ocorreu um erro inesperado. Tente novamente.',
            httpStatus: 0,
          });
        }
      });

    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [...deps, reloadKey]);

  return { ...state, reload: () => setReloadKey((k) => k + 1) };
}
