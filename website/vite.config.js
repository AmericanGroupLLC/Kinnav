import { rmSync } from 'node:fs'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// api/contact.php keeps its per-IP rate-limit counters in api/.state when it
// cannot write to a temp dir — which is what happens when the test suite runs
// the handler locally. That directory lives inside publicDir, so Vite copies it
// straight into dist/ and it would be published: hashed visitor IPs shipped to
// the live server. It is a runtime artefact on the server, never build output.
const stripRateLimitState = () => ({
  name: 'kinnav-strip-rate-limit-state',
  closeBundle() {
    rmSync('dist/api/.state', { recursive: true, force: true })
  },
})

export default defineConfig({
  // base: '/' is correct for custom domain (kinnav.com)
  // GitHub Pages serves from root when a custom domain CNAME is set
  base: '/',
  plugins: [
    react(),
    tailwindcss(),
    stripRateLimitState(),
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
