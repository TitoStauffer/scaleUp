import { Link, NavLink, Outlet, useParams } from 'react-router-dom';

function formatSlug(slug: string): string {
  return slug
    .split('-')
    .filter(Boolean)
    .map((palavra) => palavra[0].toUpperCase() + palavra.slice(1))
    .join(' ');
}

/**
 * Layout compartilhado pelas três sub-telas de um domínio (slides, flashcards, quiz).
 * Não busca o detalhe do domínio aqui para evitar uma segunda chamada de API só para
 * exibir o nome: o título usa o slug formatado, e o nome completo aparece na tela de
 * slides, que já carrega o `DomainDetail`.
 */
export function DomainLayout() {
  const { slug } = useParams<{ slug: string }>();

  if (!slug) {
    return null;
  }

  const titulo = formatSlug(slug);

  return (
    <section aria-labelledby="domain-title">
      <p className="breadcrumb">
        <Link to="/">Domínios</Link> / {titulo}
      </p>
      <h1 id="domain-title">{titulo}</h1>
      <nav aria-label="Seções do domínio" className="domain-tabs">
        <NavLink to="" end>
          Slides
        </NavLink>
        <NavLink to="flashcards">Flashcards</NavLink>
        <NavLink to="quiz">Quiz</NavLink>
      </nav>
      <Outlet />
    </section>
  );
}
