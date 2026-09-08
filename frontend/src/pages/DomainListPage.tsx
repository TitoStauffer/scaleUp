import { Link } from 'react-router-dom';
import { fetchDominios } from '../api/dominios';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';

export function DomainListPage() {
  const result = useAsync(fetchDominios, []);

  return (
    <section aria-labelledby="domains-title">
      <h1 id="domains-title">Domínios de estudo</h1>
      <p className="page-intro">
        Escolha um domínio para estudar os slides, revisar flashcards e treinar com
        questões de múltipla escolha.
      </p>
      <RequestState result={result} loadingLabel="Carregando domínios...">
        {(dominios) =>
          dominios.length === 0 ? (
            <p className="empty-state">Nenhum domínio disponível no momento.</p>
          ) : (
            <ul className="domain-grid">
              {dominios.map((dominio) => (
                <li key={dominio.id}>
                  <Link to={`/dominios/${dominio.slug}`} className="domain-card">
                    <h2>{dominio.nome}</h2>
                    <p>{dominio.descricao}</p>
                  </Link>
                </li>
              ))}
            </ul>
          )
        }
      </RequestState>
    </section>
  );
}
