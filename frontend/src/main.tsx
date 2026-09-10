import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import './styles.css'
import { App } from './App'
import { AuthProvider } from './auth/AuthContext'
import { ProtectedRoute } from './auth/ProtectedRoute'
import { LoginPage } from './pages/LoginPage'
import { CadastroPage } from './pages/CadastroPage'
import { ConfirmarPage } from './pages/ConfirmarPage'
import { DashboardPage } from './pages/DashboardPage'
import { DomainListPage } from './pages/DomainListPage'
import { DomainLayout } from './pages/DomainLayout'
import { DomainSlidesPage } from './pages/DomainSlidesPage'
import { FlashcardsPage } from './pages/FlashcardsPage'
import { QuizPage } from './pages/QuizPage'
import { ProgressoPage } from './pages/ProgressoPage'
import { HistoricoPage } from './pages/HistoricoPage'
import { EscolherEscopoPage } from './pages/EscolherEscopoPage'
import { FilaSequencialPage } from './pages/FilaSequencialPage'
import { NotFoundPage } from './pages/NotFoundPage'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      {/* AuthProvider precisa estar dentro do Router: usa useNavigate para o logout e para
          reagir a 401 (ticket, seção 8). */}
      <AuthProvider>
        <Routes>
          <Route element={<App />}>
            <Route path="login" element={<LoginPage />} />
            <Route path="cadastro" element={<CadastroPage />} />
            <Route path="confirmar" element={<ConfirmarPage />} />

            {/* TICKET-autenticacao.md, seção 10: toda rota de conteúdo/estudo/quiz/progresso
                exige JWT válido — sem token, cai em /login. */}
            <Route element={<ProtectedRoute />}>
              {/* TICKET-ui-ux-melhorias-interface.md, seção 4: navegação global orientada a
                  tarefa. "/" passa a ser o dashboard; a antiga lista de domínios (hoje em "/")
                  muda para "/dominios", mantida como porta de entrada alternativa orientada a
                  entidade (AC-11 — nenhuma rota atual foi removida). */}
              <Route index element={<DashboardPage />} />
              {/* AC-12: link antigo para /resultado-geral continua funcionando, redirecionando
                  para o dashboard, onde o mesmo resultado geral está incorporado (seção 6.3). */}
              <Route path="resultado-geral" element={<Navigate to="/" replace />} />

              <Route path="dominios" element={<DomainListPage />} />
              <Route path="dominios/:slug" element={<DomainLayout />}>
                <Route index element={<DomainSlidesPage />} />
                <Route path="flashcards" element={<FlashcardsPage />} />
                <Route path="quiz" element={<QuizPage />} />
                <Route path="progresso" element={<ProgressoPage />} />
                <Route path="historico" element={<HistoricoPage />} />
              </Route>

              {/* Telas de seleção de escopo (seção 7) + fluxo cross-domínio "tudo" (seção 5.3). */}
              <Route path="estudar" element={<EscolherEscopoPage modo="estudar" />} />
              <Route path="estudar/tudo" element={<FilaSequencialPage modo="estudar" />} />
              <Route path="revisar" element={<EscolherEscopoPage modo="revisar" />} />
              <Route path="revisar/tudo" element={<FilaSequencialPage modo="revisar" />} />
              <Route path="quiz" element={<EscolherEscopoPage modo="quiz" />} />
              <Route path="quiz/tudo" element={<FilaSequencialPage modo="quiz" />} />
            </Route>

            <Route path="*" element={<NotFoundPage />} />
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>,
)
