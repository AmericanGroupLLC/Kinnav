import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  // base: '/' is correct for custom domain (kinnav.com)
  // GitHub Pages serves from root when a custom domain CNAME is set
  base: '/',
  plugins: [
    react(),
    tailwindcss(),
  ],
  build: {
    outDir: 'dist',
    emptyOutDir: true,
  },
  preview: {
    allowedHosts: 'all',
  },
  server: {
    allowedHosts: 'all',
  },
})
