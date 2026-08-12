// Unit tests — submitForm() decides whether a submission reached the server or
// has to fall back to the visitor's mail client. Getting that wrong means
// telling someone "message sent" when nothing was sent, so it is tested hard.
import { describe, it, expect, beforeEach, vi, afterEach } from 'vitest'
import { submitForm, mailtoLink } from './submitForm'
import { SITE_EMAIL, FORM_ENDPOINT } from '../config'

const originalLocation = window.location

function mockLocation() {
  delete window.location
  window.location = { href: '' }
  return window.location
}

describe('submitForm', () => {
  let location

  beforeEach(() => {
    location = mockLocation()
  })

  afterEach(() => {
    window.location = originalLocation
  })

  it('posts JSON to the form endpoint and reports "sent" on {ok:true}', async () => {
    const fetchMock = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ ok: true }),
    })
    vi.stubGlobal('fetch', fetchMock)

    const result = await submitForm({
      subject: 'Test — Kinnav',
      fields: { name: 'Ada', email: 'ada@example.com', type: 'General' },
      message: 'Hello there',
    })

    expect(result).toBe('sent')
    expect(fetchMock).toHaveBeenCalledTimes(1)

    const [url, init] = fetchMock.mock.calls[0]
    expect(url).toBe(FORM_ENDPOINT)
    expect(init.method).toBe('POST')
    expect(init.headers['Content-Type']).toBe('application/json')

    const payload = JSON.parse(init.body)
    expect(payload.subject).toBe('Test — Kinnav')
    expect(payload.name).toBe('Ada')
    expect(payload.email).toBe('ada@example.com')
    expect(payload.body).toContain('Name: Ada')
    expect(payload.body).toContain('Email: ada@example.com')
    expect(payload.body).toContain('Hello there')
    expect(payload.website).toBe('')

    // No mail client involved when the server took it.
    expect(location.href).toBe('')
  })

  it('falls back to mailto when the endpoint returns HTML (no PHP)', async () => {
    // A static host serves index.html for /api/contact.php, status 200.
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: async () => { throw new SyntaxError('Unexpected token <') },
    }))

    const result = await submitForm({
      subject: 'Kinnav waitlist',
      fields: { name: 'Ada', email: 'ada@example.com' },
      message: 'hi',
    })

    expect(result).toBe('mailto')
    expect(location.href).toContain(`mailto:${SITE_EMAIL}`)
  })

  it('falls back to mailto when the server rejects the message', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      json: async () => ({ ok: false, error: 'The mail server rejected the message.' }),
    }))

    const result = await submitForm({
      subject: 'Kinnav waitlist',
      fields: { name: 'Ada', email: 'ada@example.com' },
      message: 'hi',
    })

    expect(result).toBe('mailto')
  })

  it('falls back to mailto when the network is unreachable', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new TypeError('Failed to fetch')))

    const result = await submitForm({
      subject: 'Kinnav waitlist',
      fields: { name: 'Ada', email: 'ada@example.com' },
      message: 'hi',
    })

    expect(result).toBe('mailto')
    expect(location.href).toContain('mailto:')
  })

  it('does not treat {ok:false} with a 200 status as sent', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ ok: false, error: 'Too many messages' }),
    }))

    expect(await submitForm({ subject: 's', fields: { name: 'a', email: 'b@c.d' }, message: 'm' }))
      .toBe('mailto')
  })

  it('forwards the honeypot value so the server can drop bot submissions', async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, json: async () => ({ ok: true }) })
    vi.stubGlobal('fetch', fetchMock)

    await submitForm({
      subject: 's',
      fields: { name: 'a', email: 'b@c.d' },
      message: 'm',
      honeypot: 'http://spam.example',
    })

    expect(JSON.parse(fetchMock.mock.calls[0][1].body).website).toBe('http://spam.example')
  })

  it('labels an empty message rather than sending a blank body', async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, json: async () => ({ ok: true }) })
    vi.stubGlobal('fetch', fetchMock)

    await submitForm({ subject: 's', fields: { name: 'a', email: 'b@c.d' }, message: '' })

    expect(JSON.parse(fetchMock.mock.calls[0][1].body).body).toContain('(none)')
  })

  it('URL-encodes the mailto fallback so subjects survive intact', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new Error('offline')))

    await submitForm({
      subject: 'Guardian Application — Kinnav',
      fields: { name: 'Ada Lovelace', email: 'ada@example.com' },
      message: 'a & b',
    })

    expect(location.href).toContain('subject=Guardian%20Application%20%E2%80%94%20Kinnav')
    expect(location.href).toContain('%26') // the ampersand is encoded, not a new param
  })
})

describe('mailtoLink', () => {
  it('always points at the configured inbox', () => {
    expect(mailtoLink('Hello')).toBe(`mailto:${SITE_EMAIL}?subject=Hello`)
  })

  it('uses the kinnav.com support address, not a personal one', () => {
    expect(SITE_EMAIL).toBe('support@kinnav.com')
    expect(SITE_EMAIL).not.toMatch(/gmail/i)
  })
})
