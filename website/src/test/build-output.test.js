// Smoke + performance-budget + deployment-config tests against the real build
// output, served the way cPanel will serve it.
//
// These need `pnpm build` to have run; the suite builds if dist is missing.
import { describe, it, expect, beforeAll, afterAll } from 'vitest'
import { spawn } from 'node:child_process'
import { existsSync, readFileSync, readdirSync, statSync } from 'node:fs'
import { gzipSync } from 'node:zlib'
import { join } from 'node:path'

const PORT = 4183
const BASE = `http://localhost:${PORT}`
const ROUTES = ['/', '/how-it-works', '/waitlist', '/about', '/privacy', '/terms', '/contact']

let server

beforeAll(async () => {
  // dist/ is guaranteed by the global setup.
  server = spawn('npx', ['vite', 'preview', '--port', String(PORT), '--strictPort'], { stdio: 'ignore' })

  const deadline = Date.now() + 60_000
  while (Date.now() < deadline) {
    try {
      await fetch(BASE + '/')
      return
    } catch {
      await new Promise(r => setTimeout(r, 300))
    }
  }
  throw new Error('preview server did not start')
}, 120_000)

afterAll(() => server?.kill('SIGKILL'))

describe('smoke — served build', () => {
  it.each(ROUTES)('%s returns 200 HTML with the app shell', async (route) => {
    const res = await fetch(BASE + route)
    expect(res.status).toBe(200)
    expect(res.headers.get('content-type')).toContain('text/html')

    const html = await res.text()
    expect(html).toContain('<div id="root">')
    expect(html).toMatch(/<script[^>]+src="\/assets\/index-[^"]+\.js"/)
  })

  it.each([
    '/images/kinnav_logo.png',
    '/images/kinnav_icon.png',
    '/images/hero-bg.jpg',
    '/favicon.svg',
    '/robots.txt',
    '/sitemap.xml',
    '/api/contact.php',
  ])('%s is present in the deployed output', async (asset) => {
    expect((await fetch(BASE + asset)).status).toBe(200)
  })

  it('serves the SPA shell for an unknown path, not a hard 404', async () => {
    const res = await fetch(BASE + '/no-such-route')
    expect(res.status).toBe(200)
    expect(await res.text()).toContain('<div id="root">')
  })
})

describe('acceptance — published metadata', () => {
  it('the document head carries title, description and social cards', async () => {
    const html = await (await fetch(BASE + '/')).text()
    expect(html).toMatch(/<title>[^<]*Kinnav[^<]*<\/title>/)
    expect(html).toMatch(/<meta name="description" content="[^"]{50,}"/)
    expect(html).toContain('<link rel="canonical" href="https://kinnav.com/"')
    expect(html).toMatch(/og:image" content="https:\/\/kinnav\.com\//)
    expect(html).toMatch(/twitter:card" content="summary_large_image"/)
  })

  it('structured data is valid JSON describing the app', async () => {
    const html = await (await fetch(BASE + '/')).text()
    const ld = html.match(/<script type="application\/ld\+json">([\s\S]*?)<\/script>/)[1]
    const data = JSON.parse(ld)
    expect(data['@type']).toBe('MobileApplication')
    expect(data.url).toBe('https://kinnav.com')
  })

  it('robots.txt allows crawling and points at the sitemap', async () => {
    const robots = await (await fetch(BASE + '/robots.txt')).text()
    expect(robots).toMatch(/User-agent:\s*\*/)
    expect(robots).toContain('Sitemap: https://kinnav.com/sitemap.xml')
    expect(robots).not.toMatch(/^Disallow:\s*\/$/m)
  })

  it('the sitemap lists every public route', async () => {
    const sitemap = await (await fetch(BASE + '/sitemap.xml')).text()
    for (const route of ROUTES) {
      expect(sitemap, `sitemap missing ${route}`).toContain(`https://kinnav.com${route}`)
    }
  })
})

describe('performance budgets', () => {
  const distFiles = (dir = 'dist', acc = []) => {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const path = join(dir, entry.name)
      entry.isDirectory() ? distFiles(path, acc) : acc.push(path)
    }
    return acc
  }

  it('JavaScript stays under 150 KB gzipped', () => {
    const js = distFiles().filter(f => f.endsWith('.js'))
    const gzipped = js.reduce((total, f) => total + gzipSync(readFileSync(f)).length, 0)
    expect(gzipped, `${Math.round(gzipped / 1024)}KB gzipped`).toBeLessThan(150 * 1024)
  })

  it('CSS stays under 20 KB gzipped', () => {
    const css = distFiles().filter(f => f.endsWith('.css'))
    const gzipped = css.reduce((total, f) => total + gzipSync(readFileSync(f)).length, 0)
    expect(gzipped, `${Math.round(gzipped / 1024)}KB gzipped`).toBeLessThan(20 * 1024)
  })

  it('no single image exceeds 400 KB', () => {
    const oversized = distFiles()
      .filter(f => /\.(png|jpe?g|webp|gif)$/i.test(f))
      .map(f => ({ f, kb: Math.round(statSync(f).size / 1024) }))
      .filter(({ kb }) => kb > 400)
    expect(oversized.map(o => `${o.f} ${o.kb}KB`)).toEqual([])
  })

  it('the whole deployable site stays under 5 MB', () => {
    const total = distFiles().reduce((sum, f) => sum + statSync(f).size, 0)
    expect(total, `${Math.round(total / 1024 / 1024)}MB`).toBeLessThan(5 * 1024 * 1024)
  })

  it('assets are content-hashed so they can be cached for a year', () => {
    const assets = readdirSync('dist/assets')
    for (const asset of assets) {
      expect(asset, `${asset} is not content-hashed`).toMatch(/-[A-Za-z0-9_-]{8,}\.(js|css)$/)
    }
  })
})

describe('deployment configuration', () => {
  const htaccess = () => readFileSync('dist/.htaccess', 'utf8')

  it('ships an .htaccess next to index.html', () => {
    expect(existsSync('dist/.htaccess')).toBe(true)
    expect(existsSync('dist/index.html')).toBe(true)
  })

  it('rewrites unknown paths to index.html only when no real file matches', () => {
    const rules = htaccess()
    expect(rules).toMatch(/RewriteCond %\{REQUEST_FILENAME\} !-f/)
    expect(rules).toMatch(/RewriteCond %\{REQUEST_FILENAME\} !-d/)
    expect(rules).toMatch(/RewriteRule \^ index\.html \[L\]/)
  })

  it('leaves AutoSSL validation traffic alone', () => {
    const rules = htaccess()
    const wellKnown = rules.indexOf('.well-known')
    const forceHttps = rules.indexOf('RewriteCond %{HTTPS} !=on')
    expect(wellKnown).toBeGreaterThan(-1)
    expect(wellKnown, '.well-known rule must come before the HTTPS redirect').toBeLessThan(forceHttps)
  })

  it('forces HTTPS and a single canonical host', () => {
    const rules = htaccess()
    expect(rules).toMatch(/RewriteRule \^\(\.\*\)\$ https:\/\/%\{HTTP_HOST\}\/\$1 \[R=301,L\]/)
    expect(rules).toMatch(/HTTP_HOST\} \^www\\\./)
  })

  it('never caches index.html but caches hashed assets hard', () => {
    const rules = htaccess()
    expect(rules).toMatch(/ExpiresByType text\/html\s+"access plus 0 seconds"/)
    expect(rules).toMatch(/max-age=31536000, immutable/)
  })

  it('sets the baseline security headers', () => {
    const rules = htaccess()
    expect(rules).toMatch(/X-Content-Type-Options "nosniff"/)
    expect(rules).toMatch(/X-Frame-Options "SAMEORIGIN"/)
    expect(rules).toMatch(/Referrer-Policy "strict-origin-when-cross-origin"/)
  })

  it('blocks directory listing and the rate-limit state directory', () => {
    expect(htaccess()).toMatch(/Options -Indexes/)
    const apiRules = readFileSync('dist/api/.htaccess', 'utf8')
    expect(apiRules).toMatch(/\.state/)
  })

  it('publishes no source, lockfiles or configuration', () => {
    const leaked = distFiles()
      .map(f => f.replace(/^dist\//, ''))
      .filter(f => /^(src|node_modules)\/|package\.json$|pnpm-lock\.yaml$|vite\.config|eslint/.test(f))
    expect(leaked).toEqual([])
  })

  function distFiles(dir = 'dist', acc = []) {
    for (const entry of readdirSync(dir, { withFileTypes: true })) {
      const path = join(dir, entry.name)
      entry.isDirectory() ? distFiles(path, acc) : acc.push(path)
    }
    return acc
  }
})
