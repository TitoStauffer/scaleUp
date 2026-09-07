import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './styles.css'

function App() {
  return (
    <main className="app-shell">
      <section className="hero" aria-labelledby="page-title">
        <p className="eyebrow">ScaleUp</p>
        <h1 id="page-title">Aprenda. Revise. Teste.</h1>
        <p className="intro">
          Sua plataforma de preparação para entrevistas de System Design.
        </p>
        <button type="button">Começar estudo</button>
      </section>
    </main>
  )
}

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
)
