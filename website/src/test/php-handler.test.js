// Security + functional tests for public/api/contact.php.
//
// PHP runs for real here (php-wasm, PHP 8.5) behind the built-in web server,
// so these are true HTTP requests against the handler. The one thing wasm has
// no answer for is an MTA: mail() always fails, which surfaces as the 502
// "mail server rejected" branch. That is exactly the branch a request must
// reach to prove it passed every validation and abuse check, so it is used as
// the "accepted" signal below. Actual delivery is verified against the live
// server with the curl command in DEPLOY.md.
import { describe, it, expect, beforeAll, afterAll } from 'vitest'
import { spawn } from 'node:child_process'
import { mkdtempSync, readFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join } from 'node:path'

const PHP = 'node_modules/.bin/php-wasm-cli'
const servers = []

// Distinct source addresses keep rate-limit counters from bleeding between runs.
let port = 20

function runPhp(script, env = {}) {
  return new Promise((resolve, reject) => {
    const proc = spawn(PHP, [script], { env: { ...process.env, ...env } })
    let out = ''
    let err = ''
    proc.stdout.on('data', d => { out += d })
    proc.stderr.on('data', d => { err += d })
    proc.on('close', code => (code === 0 ? resolve(out) : reject(new Error(`${script} exited ${code}: ${err}`))))
  })
}

async function startServer(port) {
  const proc = spawn(PHP, ['-S', `127.0.0.1:${port}`, '-t', 'public'], {
    // A private temp dir per server keeps the rate-limit counters isolated.
    env: { ...process.env, TMPDIR: mkdtempSync(join(tmpdir(), 'kinnav-php-')) },
    stdio: 'ignore',
  })
  servers.push(proc)

  const deadline = Date.now() + 60_000
  while (Date.now() < deadline) {
    try {
      await fetch(`http://127.0.0.1:${port}/robots.txt`)
      return `http://127.0.0.1:${port}`
    } catch {
      await new Promise(r => setTimeout(r, 500))
    }
  }
  throw new Error(`php-wasm server on ${port} did not come up`)
}

function post(base, body, init = {}) {
  return fetch(`${base}/api/contact.php`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: typeof body === 'string' ? body : JSON.stringify(body),
    ...init,
  })
}

const valid = {
  name: 'Ada Lovelace',
  email: 'ada@example.com',
  subject: 'General Inquiry — Kinnav',
  body: 'Name: Ada Lovelace\nEmail: ada@example.com\n\nMessage:\nHello',
}

let base

beforeAll(async () => {
  base = await startServer(8131)
}, 90_000)

afterAll(() => {
  for (const proc of servers) proc.kill('SIGKILL')
})

describe('contact.php — request handling', () => {
  it('rejects GET with 405 and advertises POST', async () => {
    const res = await fetch(`${base}/api/contact.php`)
    expect(res.status).toBe(405)
    expect(res.headers.get('allow')).toBe('POST')
    expect(await res.json()).toEqual({ ok: false, error: 'Method not allowed' })
  })

  it('always answers with JSON, never HTML', async () => {
    const res = await post(base, valid)
    expect(res.headers.get('content-type')).toContain('application/json')
    await expect(res.json()).resolves.toBeTypeOf('object')
  })

  it('tells the browser not to cache the response', async () => {
    const res = await post(base, valid)
    expect(res.headers.get('cache-control')).toContain('no-store')
  })

  it('rejects a body that is not JSON', async () => {
    const res = await post(base, 'name=Ada&email=ada@example.com')
    expect(res.status).toBe(400)
    expect((await res.json()).error).toMatch(/malformed/i)
  })

  it('accepts a complete submission and gets as far as sending', async () => {
    const res = await post(base, valid)
    // 502 == validation passed, abuse checks passed, mail() attempted.
    expect(res.status).toBe(502)
    expect((await res.json()).error).toMatch(/mail server/i)
  })
})

describe('contact.php — validation', () => {
  it.each([
    ['missing name', { ...valid, name: '' }],
    ['missing email', { ...valid, email: '' }],
    ['missing body', { ...valid, body: '   ' }],
  ])('rejects a submission with a %s', async (_label, payload) => {
    const res = await post(base, payload)
    expect(res.status).toBe(422)
    expect((await res.json()).error).toMatch(/fill in/i)
  })

  it.each([
    'not-an-email',
    'ada@',
    '@example.com',
    'ada example.com',
  ])('rejects the malformed address %s', async (email) => {
    const res = await post(base, { ...valid, email })
    expect(res.status).toBe(422)
    expect((await res.json()).error).toMatch(/valid/i)
  })

  it('rejects a message longer than the 5000-character cap', async () => {
    const res = await post(base, { ...valid, body: 'x'.repeat(5001) })
    expect(res.status).toBe(422)
    expect((await res.json()).error).toMatch(/too long/i)
  })

  it('accepts a message right at the cap', async () => {
    const res = await post(base, { ...valid, body: 'x'.repeat(5000) })
    expect(res.status).toBe(502) // reached the send stage, i.e. not rejected
  })
})

describe('contact.php — abuse resistance', () => {
  it('silently swallows a submission with the honeypot filled', async () => {
    const res = await post(base, { ...valid, website: 'http://spam.example' })
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({ ok: true })
  })

  it('does not leak that the honeypot was the reason', async () => {
    const res = await post(base, { ...valid, website: 'spam' })
    expect(JSON.stringify(await res.json())).not.toMatch(/honeypot|bot|spam/i)
  })

  it('survives header-injection attempts in the name and subject', async () => {
    const res = await post(base, {
      ...valid,
      name: 'Ada\r\nBcc: attacker@evil.example',
      subject: 'Hi\r\nBcc: attacker@evil.example',
    })
    // Still processed as a single ordinary message rather than erroring out.
    expect(res.status).toBe(502)
  })

  it('strips CR/LF from every value that reaches a mail header', () => {
    // The header values are built from clean()ed variables only.
    const source = readFileSync('public/api/contact.php', 'utf8')
    expect(source).toMatch(/function clean\([^)]*\)[\s\S]*?str_replace\(\["\\r", "\\n", "\\0"\]/)
    for (const field of ['name', 'email', 'subject']) {
      expect(source).toMatch(new RegExp(`\\$${field}\\s*=\\s*clean\\(`))
    }
  })

  it('does not reflect submitted content back into the response', async () => {
    const res = await post(base, { ...valid, name: '<script>alert(1)</script>', email: 'bad' })
    expect(await res.text()).not.toContain('<script>')
  })

  it('rate-limits once an address passes the hourly cap', async () => {
    // Driven in-process; see the comment in php-rate-limit.php for why this
    // cannot go over HTTP under php-wasm.
    // A fresh source address every run: counters can outlive the process when
    // the system temp dir is writable, and a reused address would start the
    // test already rate-limited.
    const ip = `198.51.${Math.floor(Date.now() / 1000) % 250}.${port++}`
    const output = await runPhp('src/test/php-rate-limit.php', { TEST_IP: ip })
    expect(output).toMatch(/^cap=5 ok,ok,ok,ok,ok,blocked,blocked$/m)
  }, 120_000)
})

describe('contact.php — form tagging', () => {
  // Both forms share one mailbox, so the tag is what a cPanel filter sorts on.
  // mail() cannot succeed under php-wasm, so the assertions are on the source
  // and on the fact that a tagged submission still reaches the send stage.
  const source = readFileSync('public/api/contact.php', 'utf8')

  it('knows the same two forms the front end sends', () => {
    expect(source).toMatch(/'contact'\s*=>\s*'\[Contact\]'/)
    expect(source).toMatch(/'waitlist'\s*=>\s*'\[Waitlist\]'/)
  })

  it('stamps the form onto a header for filtering', () => {
    expect(source).toMatch(/'X-Kinnav-Form: '\s*\.\s*\$form/)
  })

  it('builds that header from the whitelist, not from submitted text', () => {
    // $form only ever comes out of form_kind(), which returns a whitelisted key.
    expect(source).toMatch(/\$form\s*=\s*form_kind\(/)
    expect(source).toMatch(/array_key_exists\(\$form, FORM_PREFIXES\)\s*\?\s*\$form\s*:\s*DEFAULT_FORM/)
  })

  it('tags each form distinctly and refuses anything off the whitelist', async () => {
    // Driven in-process; see the comment in php-form-tag.php for why the tag
    // cannot be observed over HTTP under php-wasm.
    const output = await runPhp('src/test/php-form-tag.php')

    expect(output).toContain('contact kind=contact subject=[Contact] General Inquiry — Kinnav')
    expect(output).toContain('waitlist kind=waitlist subject=[Waitlist] Kinnav waitlist — Ada (Guardian)')
    // Unrecognised, missing, or header-injecting values fall back to the
    // default instead of reaching the header.
    expect(output).toContain('unknown kind=contact')
    expect(output).toContain('missing kind=contact')
    expect(output).toContain('injected kind=contact')
    expect(output).not.toMatch(/kind=.*Bcc/)
    // Case-insensitive, and it never tags a subject twice.
    expect(output).toContain('uppercase kind=waitlist')
    expect(output).toContain('pretagged kind=waitlist subject=[Waitlist] Kinnav waitlist — Ada')
    expect(output).not.toContain('[Waitlist] [Waitlist]')
  }, 120_000)

  it.each([
    ['waitlist', 'Kinnav waitlist — Ada'],
    ['contact', 'General Inquiry — Kinnav'],
    ['nonsense', 'General Inquiry — Kinnav'],
    ['', 'General Inquiry — Kinnav'],
  ])('accepts a %s submission and gets as far as sending', async (form, subject) => {
    const res = await post(base, { ...valid, form, subject })
    expect(res.status).toBe(502)
  })

  it('does not reject a submission that arrives already tagged', async () => {
    const res = await post(base, { ...valid, form: 'waitlist', subject: '[Waitlist] Kinnav waitlist' })
    expect(res.status).toBe(502)
  })

  it('refuses to be talked into an injected header via the form name', async () => {
    const res = await post(base, { ...valid, form: "contact\r\nBcc: attacker@evil.example" })
    expect(res.status).toBe(502)
  })
})

describe('contact.php — configuration', () => {
  it('sends to the support mailbox, never a personal address', () => {
    const source = readFileSync('public/api/contact.php', 'utf8')
    expect(source).toMatch(/const INBOX\s*=\s*'support@kinnav\.com'/)
    expect(source).not.toMatch(/gmail/i)
  })

  it('stores no credentials', () => {
    // Comments are stripped first: the file explains *why* no password is
    // needed, and that prose should not trip the check.
    const code = readFileSync('public/api/contact.php', 'utf8')
      .replace(/\/\*[\s\S]*?\*\//g, '')
      .replace(/(^|\s)\/\/.*$/gm, '')
      .replace(/(^|\s)#.*$/gm, '')
    expect(code).not.toMatch(/password|passwd|smtp_pass|secret|api[_-]?key/i)
  })
})
