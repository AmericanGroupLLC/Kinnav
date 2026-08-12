// Integration tests — the contact form as a visitor uses it: fill in, submit,
// see the confirmation. The network boundary (fetch) is the only thing mocked.
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { MemoryRouter } from 'react-router-dom'
import Contact from './Contact'

function renderPage() {
  return render(<MemoryRouter><Contact /></MemoryRouter>)
}

function okFetch() {
  const mock = vi.fn().mockResolvedValue({ ok: true, json: async () => ({ ok: true }) })
  vi.stubGlobal('fetch', mock)
  return mock
}

async function fillIn(user, { name = 'Ada Lovelace', email = 'ada@example.com', message = 'I need help with the app.' } = {}) {
  await user.type(screen.getByPlaceholderText('Your name'), name)
  await user.type(screen.getByPlaceholderText('you@example.com'), email)
  await user.type(screen.getByPlaceholderText('Tell us how we can help...'), message)
}

describe('Contact page', () => {
  beforeEach(() => {
    delete window.location
    window.location = { href: '' }
  })

  it('renders every enquiry topic', () => {
    renderPage()
    for (const label of ['General Inquiry', 'App Support', 'Become a Guardian', 'Partnership / NGO', 'Investor Relations', 'Press / Media']) {
      expect(screen.getByRole('button', { name: new RegExp(label) })).toBeInTheDocument()
    }
  })

  it('sends the enquiry to the server and confirms it was received', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Send Message/i }))

    await waitFor(() => expect(screen.getByText(/Message sent!/i)).toBeInTheDocument())
    expect(screen.getByText(/ada@example.com/)).toBeInTheDocument()

    const payload = JSON.parse(fetchMock.mock.calls[0][1].body)
    expect(payload.subject).toBe('[Contact] General Inquiry — Kinnav — from Ada Lovelace')
    expect(payload.body).toContain('I need help with the app.')
    // No mail client was opened — the server accepted it.
    expect(window.location.href).toBe('')
  })

  it('tags the subject with the selected topic', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await user.click(screen.getByRole('button', { name: /Become a Guardian/ }))
    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Send Message/i }))

    await waitFor(() => expect(fetchMock).toHaveBeenCalled())
    const payload = JSON.parse(fetchMock.mock.calls[0][1].body)
    expect(payload.subject).toContain('Guardian Application — Kinnav')
    expect(payload.type).toContain('Become a Guardian')
  })

  it('tags the enquiry as a contact one so it files apart from waitlist signups', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Send Message/i }))

    await waitFor(() => expect(fetchMock).toHaveBeenCalled())
    const payload = JSON.parse(fetchMock.mock.calls[0][1].body)
    expect(payload.form).toBe('contact')
    expect(payload.subject).toMatch(/^\[Contact\] /)
    expect(payload.subject).not.toContain('[Waitlist]')
  })

  it('tells the visitor to press send when the server is unreachable', async () => {
    const user = userEvent.setup()
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(new TypeError('Failed to fetch')))
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Send Message/i }))

    await waitFor(() => expect(screen.getByText(/Almost there — press send/i)).toBeInTheDocument())
    // The page always offers the plain address; the fallback adds one with the
    // topic already in the subject, so both are on screen at this point.
    const mailtos = screen.getAllByRole('link', { name: 'support@kinnav.com' })
    expect(mailtos.some(a => a.getAttribute('href').includes('subject='))).toBe(true)
    expect(window.location.href).toContain('mailto:support@kinnav.com')
    // It must not claim delivery it cannot vouch for.
    expect(screen.queryByText(/Message sent!/i)).not.toBeInTheDocument()
  })

  it('does not submit when required fields are empty', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await user.click(screen.getByRole('button', { name: /Send Message/i }))

    expect(fetchMock).not.toHaveBeenCalled()
    expect(screen.queryByText(/Message sent!/i)).not.toBeInTheDocument()
  })

  it('carries a honeypot field that is hidden from real visitors', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    const { container } = renderPage()

    const honeypot = container.querySelector('input[name="website"]')
    expect(honeypot).toBeTruthy()
    expect(honeypot.closest('[aria-hidden="true"]')).toBeTruthy()
    expect(honeypot.tabIndex).toBe(-1)

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Send Message/i }))
    await waitFor(() => expect(fetchMock).toHaveBeenCalled())
    expect(JSON.parse(fetchMock.mock.calls[0][1].body).website).toBe('')
  })

  it('lets the visitor send another message afterwards', async () => {
    const user = userEvent.setup()
    okFetch()
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Send Message/i }))
    await waitFor(() => expect(screen.getByText(/Message sent!/i)).toBeInTheDocument())

    await user.click(screen.getByRole('button', { name: /Send another/i }))
    expect(screen.getByPlaceholderText('Your name')).toBeInTheDocument()
  })

  it('publishes no personal gmail address anywhere on the page', () => {
    const { container } = renderPage()
    expect(container.textContent).not.toMatch(/gmail/i)
  })

  it('shows the support address without needing the form to fail first', () => {
    // Someone who would rather use their own mail client should not have to
    // submit a form, or hit a server error, to discover where to write.
    renderPage()
    const link = screen.getByRole('link', { name: 'support@kinnav.com' })
    expect(link).toHaveAttribute('href', 'mailto:support@kinnav.com')
  })
})
