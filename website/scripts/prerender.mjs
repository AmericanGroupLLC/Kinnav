#!/usr/bin/env node
/**
 * Prerender the static routes into real HTML files.
 *
 * Why this exists
 * ---------------
 * The site is a client-rendered SPA: every URL returned the same 3.8 KB shell
 * with an empty <body>. A human in a browser saw the page fine, but anything
 * fetching the URL server-side saw nothing at all — `curl https://kinnav.com/privacy`
 * contained the word "privacy" zero times.
 *
 * That is a store-submission problem, not a cosmetic one. Google Play fetches
 * the privacy-policy URL and checks it for an actual policy, and a listing whose
 * policy URL looks empty gets rejected. Apple reviewers follow the link too.
 *
 * What it does
 * ------------
 * Builds an SSR bundle, renders each route below, and writes
 * `dist/<route>/index.html` with the markup baked into the existing shell.
 * `.htaccess` only rewrites to index.html when the request matches no real file
 * or directory (`!-f`, `!-d`), so a real `dist/privacy/` directory is served
 * directly and the SPA fallback stays intact for everything else.
 *
 * The client still boots and takes over, so behaviour in a browser is unchanged.
 */
import { execFileSync } from 'node:child_process'
import { mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const dist = join(root, 'dist')
const ssrOut = join(root, '.ssr-build')

// Every real route, not just the legal ones.
//
// The SPA fallback serves dist/index.html, which is now the prerendered *home*
// page. Any route missing from this list therefore ships homepage markup and
// paints it for a moment before React renders the real page — a visible flash
// on /contact, and homepage content indexed under the wrong URL. Prerendering
// each route gives it its own correct HTML; only genuinely unknown URLs fall
// back to home.
const ROUTES = [
  '/',
  '/how-it-works',
  '/waitlist',
  '/about',
  '/privacy',
  '/terms',
  '/contact',
]

// Every route must already be a <Route> in src/App.jsx, or it would silently
// prerender the 404 page and publish it as if it were real content.
const KEYWORDS = {
  '/privacy': 'privacy',
  '/terms': 'terms',
}

function build() {
  execFileSync(
    'pnpm',
    ['exec', 'vite', 'build', '--ssr', 'src/entry-server.jsx', '--outDir', '.ssr-build', '--logLevel', 'warn'],
    { cwd: root, stdio: 'inherit', env: { ...process.env, NODE_ENV: 'production' } },
  )
}

async function main() {
  const shell = readFileSync(join(dist, 'index.html'), 'utf8')
  if (!shell.includes('<div id="root"></div>')) {
    throw new Error('dist/index.html has no empty #root div to inject into — run vite build first')
  }

  build()
  const { render } = await import(join(ssrOut, 'entry-server.js'))

  for (const route of ROUTES) {
    let html = render(route)

    // framer-motion renders its `initial` state, which is opacity:0 for most
    // of these pages. That is correct for the animation but means the
    // prerendered copy is invisible without JS — the exact audience this is
    // for. Reveal it; the client re-renders and animates normally.
    html = html.replace(/opacity:\s*0(?=[;"])/g, 'opacity:1')

    const page = shell.replace('<div id="root"></div>', `<div id="root">${html}</div>`)

    const outDir = route === '/' ? dist : join(dist, route)
    mkdirSync(outDir, { recursive: true })
    writeFileSync(join(outDir, 'index.html'), page)

    const keyword = KEYWORDS[route]
    if (keyword && !page.toLowerCase().includes(keyword)) {
      throw new Error(`prerendered ${route} does not contain "${keyword}" — did the route render a 404?`)
    }
    console.log(`  prerendered ${route.padEnd(14)} ${(page.length / 1024).toFixed(1)} KB`)
  }

  rmSync(ssrOut, { recursive: true, force: true })
}

main().catch((err) => {
  console.error(err.message)
  process.exit(1)
})
