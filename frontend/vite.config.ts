import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// Proxy de /api para o backend local em desenvolvimento (`npm run dev`). Evita CORS: o
// browser só fala com a própria origem do Vite, e o Vite repassa a chamada para o backend
// server-to-server. Mesma estratégia usada em produção via nginx (ver frontend/nginx.conf).
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
})
