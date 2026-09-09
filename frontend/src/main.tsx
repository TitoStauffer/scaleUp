import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import './styles.css'
import { App } from './App'
import { AuthProvider } from './auth/AuthContext'
import { ProtectedRoute } from './auth/ProtectedRoute'
import { LoginPage } from './pages/LoginPage'
import { CadastroPage } from './pages/CadastroPage'
import { ConfirmarPage } from './pages/ConfirmarPage'
import { DomainListPage } from './pages/DomainListPage'
import { DomainLayout } from './pages/DomainLayout'
import { DomainSlidesPage } from './pages/DomainSlidesPage'
import { FlashcardsPage } from './pages/FlashcardsPage'
import { QuizPage } from './pages/QuizPage'
import { ProgressoPage } from './pages/ProgressoPage'
import { HistoricoPage } from './pages/HistoricoPage'
import { ResultadoGeralPage } from './pages/ResultadoGeralPage'
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
              <Route index element={<DomainListPage />} />
              <Route path="resultado-geral" element={<ResultadoGeralPage />} />
              <Route path="dominios/:slug" element={<DomainLayout />}>
                <Route index element={<DomainSlidesPage />} />
                <Route path="flashcards" element={<FlashcardsPage />} />
                <Route path="quiz" element={<QuizPage />} />
                <Route path="progresso" element={<ProgressoPage />} />
                <Route path="historico" element={<HistoricoPage />} />
              </Route>
            </Route>

            <Route path="*" element={<NotFoundPage />} />
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>,
)
