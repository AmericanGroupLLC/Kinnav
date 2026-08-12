import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

// Unit + integration tests run in jsdom. The Playwright end-to-end suite lives
// in e2e/ and is excluded here so `pnpm test` stays fast.
export default defineConfig({
  plugins: [react()],
  esbuild: { jsx: 'automatic' },
  test: {
    environment: 'jsdom',
    globals: true,
    globalSetup: ['./src/test/global-setup.js'],
    setupFiles: ['./src/test/setup.js'],
    include: ['src/**/*.test.{js,jsx}'],
    exclude: ['e2e/**', 'node_modules/**', 'dist/**'],
    coverage: {
      provider: 'v8',
      include: ['src/**/*.{js,jsx}'],
      exclude: ['src/**/*.test.{js,jsx}', 'src/test/**', 'src/main.jsx'],
      reporter: ['text-summary'],
    },
  },
})
