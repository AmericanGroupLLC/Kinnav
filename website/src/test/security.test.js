// Static security checks over the source and the deployable output.
//
// The runtime side of security lives in php-handler.test.js (injection,
// honeypot, rate limiting) and build-output.test.js (headers, .htaccess).
// This file covers what those cannot see: what the source does, and what ends
// up published.
import { describe, it, expect } from 'vitest'
import { readFileSync, readdirSync, existsSync } from 'node:fs'
import { join } from 'node:path'

function walk(dir, acc = []) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const path = join(dir, entry.name)
    if (entry.isDirectory()) walk(path, acc)
    else acc.push(path)
  }
  return acc
}

const sourceFiles = walk('src').filter(f => /\.(js|jsx)$/.test(f) && !f.includes('.test.'))
const readAll = files => files.map(f => ({ file: f, code: readFileSync(f, 'utf8') }))

describe('front-end source', () => {
  it('never injects unescaped HTML', () => {
    const offenders = readAll(sourceFiles)
      .filter(({ code }) => code.includes('dangerouslySetInnerHTML') || /\.innerHTML\s*=/.test(code))
      .map(({ file }) => file)
    expect(offenders).toEqual([])
  })

  it('never evaluates strings as code', () => {
    const offenders = readAll(sourceFiles)
      .filter(({ code }) => /\beval\(|new Function\(/.test(code))
      .map(({ file }) => file)
    expect(offenders).toEqual([])
  })

  it('contains no credentials, tokens or keys', () => {
    const patterns = [
      /(?:api[_-]?key|secret|passwd|password)\s*[:=]\s*['"][^'"]{6,}/i,
      /AKIA[0-9A-Z]{16}/,            // AWS
      /sk_live_[0-9a-zA-Z]{10,}/,    // Stripe
      /AIza[0-9A-Za-z_-]{35}/,       // Google
      /ghp_[0-9A-Za-z]{30,}/,        // GitHub
    ]
    const offenders = []
    for (const { file, code } of readAll(sourceFiles)) {
      for (const pattern of patterns) {
        if (pattern.test(code)) offenders.push(`${file} matches ${pattern}`)
      }
    }
    expect(offenders).toEqual([])
  })

  it('opens every external link with rel="noopener"', () => {
    const offenders = []
    for (const { file, code } of readAll(sourceFiles)) {
      for (const match of code.matchAll(/target=["']_blank["']/g)) {
        const window_ = code.slice(Math.max(0, match.index - 300), match.index + 300)
        if (!/rel=["'][^"']*noopener/.test(window_)) offenders.push(file)
      }
    }
    expect(offenders).toEqual([])
  })

  it('talks to its own origin only', () => {
    const offenders = []
    for (const { file, code } of readAll(sourceFiles)) {
      for (const match of code.matchAll(/fetch\(\s*['"`]([^'"`]+)/g)) {
        if (/^https?:\/\//.test(match[1])) offenders.push(`${file}: ${match[1]}`)
      }
    }
    expect(offenders).toEqual([])
  })
})

describe('deployable output', () => {
  const distFiles = () => (existsSync('dist') ? walk('dist') : [])

  it('publishes no source maps', () => {
    expect(distFiles().filter(f => f.endsWith('.map'))).toEqual([])
  })

  it('publishes no environment files or lockfiles', () => {
    const leaked = distFiles().filter(f => /\.env|\.pem$|\.key$|pnpm-lock|package\.json$/.test(f))
    expect(leaked).toEqual([])
  })

  it('contains no credential-looking strings in the shipped bundles', () => {
    const bundles = distFiles().filter(f => /\.(js|css|html)$/.test(f))
    const offenders = bundles.filter(f =>
      /AKIA[0-9A-Z]{16}|sk_live_[0-9a-zA-Z]{10,}|ghp_[0-9A-Za-z]{30,}/.test(readFileSync(f, 'utf8')))
    expect(offenders).toEqual([])
  })

  it('exposes the PHP handler and nothing else under /api', () => {
    const apiFiles = distFiles()
      .filter(f => f.startsWith(join('dist', 'api')))
      .map(f => f.replace(join('dist', 'api') + '/', ''))
    expect(apiFiles.sort()).toEqual(['.htaccess', 'contact.php'])
  })
})
