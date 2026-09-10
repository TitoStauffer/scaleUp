import { Link } from 'react-router-dom';

/**
 * Bloco "Atalhos de ação" do dashboard (ticket UI/UX, seção 6.2) — leva diretamente às telas
 * de seleção de escopo orientadas a tarefa (seção 4), sem exigir escolher um domínio antes.
 */
export function AtalhosAcaoCard() {
  return (
    <div className="dashboard-block" aria-labelledby="atalhos-title">
      <h2 id="atalhos-title">O que você quer fazer?</h2>
      <div className="dashboard-shortcuts">
        <Link to="/estudar" className="shortcut-link">
          Estudar
        </Link>
        <Link to="/revisar" className="shortcut-link">
          Revisar
        </Link>
        <Link to="/quiz" className="shortcut-link">
          Fazer quiz
        </Link>
      </div>
    </div>
  );
}
