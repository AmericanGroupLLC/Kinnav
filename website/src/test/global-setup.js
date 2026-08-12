import { execSync } from 'node:child_process'
import { existsSync } from 'node:fs'

// The security and build-output suites assert on what actually ships, so they
// need dist/ to exist. `pnpm test` runs before `pnpm build` in CI, and a
// developer may never have built at all, so produce it once here rather than
// letting individual test files race each other building it.
export default function setup() {
  if (!existsSync('dist/index.html')) {
    // NODE_ENV must be forced: Vitest sets it to "test", and Vite passes it
    // through to the bundle, which would ship React's development build —
    // 680 KB instead of 440 KB, and slower at runtime.
    execSync('npx vite build', {
      stdio: 'inherit',
      env: { ...process.env, NODE_ENV: 'production' },
    })
  }
}
