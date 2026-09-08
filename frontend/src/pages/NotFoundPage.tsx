import { Link } from 'react-router-dom';

export function NotFoundPage() {
  return (
    <section aria-labelledby="not-found-title">
      <h1 id="not-found-title">Página não encontrada</h1>
      <p>
        <Link to="/">Voltar para a lista de domínios</Link>
      </p>
    </section>
  );
}
