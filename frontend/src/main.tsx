import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import './styles.css'
import { App } from './App'
import { DomainListPage } from './pages/DomainListPage'
import { DomainLayout } from './pages/DomainLayout'
import { DomainSlidesPage } from './pages/DomainSlidesPage'
import { FlashcardsPage } from './pages/FlashcardsPage'
import { QuizPage } from './pages/QuizPage'
import { NotFoundPage } from './pages/NotFoundPage'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route element={<App />}>
          <Route index element={<DomainListPage />} />
          <Route path="dominios/:slug" element={<DomainLayout />}>
            <Route index element={<DomainSlidesPage />} />
            <Route path="flashcards" element={<FlashcardsPage />} />
            <Route path="quiz" element={<QuizPage />} />
          </Route>
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </StrictMode>,
)
