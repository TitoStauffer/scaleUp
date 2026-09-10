import { ResumoGeralCard } from '../components/ResumoGeralCard';
import { AtalhosAcaoCard } from '../components/AtalhosAcaoCard';
import { DominiosEmAndamentoList } from '../components/DominiosEmAndamentoList';

/**
 * Tela inicial (`/`) — substitui a antiga `DomainListPage` como rota raiz (ticket UI/UX,
 * seção 6). Cada bloco busca seus próprios dados e trata seu próprio estado de
 * carregamento/erro (seção 6.6 / AC-14), então um bloco lento ou com erro nunca trava os
 * outros.
 *
 * O bloco "Revisões pendentes" (seção 6.5, Open Question A) foi omitido nesta v1, por
 * recomendação explícita do ticket — não há hoje um dado real de "revisão pendente" no
 * backend, e inventar uma métrica criaria uma expectativa errada no usuário.
 */
export function DashboardPage() {
  return (
    <section aria-labelledby="dashboard-title">
      <h1 id="dashboard-title">Olá! Aqui está seu progresso.</h1>
      <ResumoGeralCard />
      <AtalhosAcaoCard />
      <DominiosEmAndamentoList />
    </section>
  );
}
