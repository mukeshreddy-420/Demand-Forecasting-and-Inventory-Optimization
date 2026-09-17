import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  css: {
    postcss: {
      plugins: [],
    },
  },
  server: {
    port: 5173,
    host: true,
    proxy: {
      '/products': 'http://localhost:8000',
      '/stores': 'http://localhost:8000',
      '/inventory': 'http://localhost:8000',
      '/forecast': 'http://localhost:8000',
      '/risk': 'http://localhost:8000',
      '/reorder': 'http://localhost:8000',
      '/store-region': 'http://localhost:8000',
      '/inventory-optimization': 'http://localhost:8000',
      '/alerts': 'http://localhost:8000',
      '/chat': 'http://localhost:8000',
      '/agent': 'http://localhost:8000',
      '/health': 'http://localhost:8000',
    },
  },
})