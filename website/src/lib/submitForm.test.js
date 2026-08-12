// Unit tests — submitForm() decides whether a submission reached the server or
// has to fall back to the visitor's mail client. Getting that wrong means
// telling someone "message sent" when nothing was sent, so it is tested hard.
import { describe, it, expect, beforeEach, vi, afterEach } from 'vitest'
import { submitForm, mailtoLink, tagSubject } from './submitForm'
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
      form: 'contact',
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
    expect(payload.subject).toBe('[Contact] Test — Kinnav')
    expect(payload.form).toBe('contact')
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
      form: 'contact',
      subject: 'Guardian Application — Kinnav',
      fields: { name: 'Ada Lovelace', email: 'ada@example.com' },
      message: 'a & b',
    })

    expect(location.href).toContain('subject=%5BContact%5D%20Guardian%20Application%20%E2%80%94%20Kinnav')
    expect(location.href).toContain('%26') // the ampersand is encoded, not a new param
  })
})

// One inbox serves both forms, so the tag is the only thing that lets webmail
// file a waitlist signup apart from a support request. If it goes missing the
// two streams silently merge again.
describe('form tagging', () => {
  let location

  beforeEach(() => {
    location = mockLocation()
  })

  afterEach(() => {
    window.location = originalLocation
  })

  async function subjectSentFor(form) {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, json: async () => ({ ok: true }) })
    vi.stubGlobal('fetch', fetchMock)
    await submitForm({ form, subject: 'Hello', fields: { name: 'a', email: 'b@c.d' }, message: 'm' })
    return JSON.parse(fetchMock.mock.calls[0][1].body)
  }

  it('prefixes contact enquiries with [Contact]', async () => {
    expect((await subjectSentFor('contact')).subject).toBe('[Contact] Hello')
  })

  it('prefixes waitlist signups with [Waitlist]', async () => {
    const payload = await subjectSentFor('waitlist')
    expect(payload.subject).toBe('[Waitlist] Hello')
    expect(payload.form).toBe('waitlist')
  })

  it('gives the two forms different prefixes', async () => {
    expect((await subjectSentFor('contact')).subject)
      .not.toBe((await subjectSentFor('waitlist')).subject)
  })

  it('falls back to the contact tag for an unknown or missing form', async () => {
    expect((await subjectSentFor('nonsense')).form).toBe('contact')
    expect((await subjectSentFor(undefined)).subject).toBe('[Contact] Hello')
  })

  it('carries the tag through the mailto fallback, which cannot set headers', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new Error('offline')))

    await submitForm({
      form: 'waitlist',
      subject: 'Kinnav waitlist — Grace',
      fields: { name: 'Grace', email: 'grace@example.com' },
      message: '',
    })

    expect(decodeURIComponent(location.href)).toContain('subject=[Waitlist] Kinnav waitlist — Grace')
  })

  it('does not tag a subject twice', () => {
    expect(tagSubject('[Waitlist] Hello', 'waitlist')).toBe('[Waitlist] Hello')
  })

  it('does not let a form field overwrite the subject or the tag', async () => {
    const fetchMock = vi.fn().mockResolvedValue({ ok: true, json: async () => ({ ok: true }) })
    vi.stubGlobal('fetch', fetchMock)

    await submitForm({
      form: 'waitlist',
      subject: 'Real subject',
      fields: { name: 'a', email: 'b@c.d', form: 'contact', subject: 'Injected' },
      message: 'm',
    })

    const payload = JSON.parse(fetchMock.mock.calls[0][1].body)
    expect(payload.subject).toBe('[Waitlist] Real subject')
    expect(payload.form).toBe('waitlist')
  })
})

describe('mailtoLink', () => {
  it('always points at the configured inbox', () => {
    expect(mailtoLink('Hello')).toBe(`mailto:${SITE_EMAIL}?subject=%5BContact%5D%20Hello`)
  })

  it('tags the direct-email link with the form it is shown on', () => {
    expect(mailtoLink('Kinnav waitlist', 'waitlist'))
      .toBe(`mailto:${SITE_EMAIL}?subject=%5BWaitlist%5D%20Kinnav%20waitlist`)
  })

  it('uses the kinnav.com support address, not a personal one', () => {
    expect(SITE_EMAIL).toBe('support@kinnav.com')
    expect(SITE_EMAIL).not.toMatch(/gmail/i)
  })
})
