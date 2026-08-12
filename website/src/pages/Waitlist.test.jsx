// Integration tests — waitlist signup. The confirmation wording is part of the
// contract here: "You're on the list" may only appear when the server actually
// took the signup.
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { MemoryRouter } from 'react-router-dom'
import Waitlist from './Waitlist'

function renderPage() {
  return render(<MemoryRouter><Waitlist /></MemoryRouter>)
}

function okFetch() {
  const mock = vi.fn().mockResolvedValue({ ok: true, json: async () => ({ ok: true }) })
  vi.stubGlobal('fetch', mock)
  return mock
}

async function fillIn(user, { name = 'Grace', email = 'grace@example.com' } = {}) {
  await user.type(screen.getByPlaceholderText('Your name'), name)
  await user.type(screen.getByPlaceholderText('you@example.com'), email)
}

describe('Waitlist page', () => {
  beforeEach(() => {
    delete window.location
    window.location = { href: '' }
  })

  it('offers all four signup roles', () => {
    renderPage()
    for (const role of ['App User', 'Guardian', 'Partner / NGO', 'Investor']) {
      expect(screen.getByRole('button', { name: new RegExp(role) })).toBeInTheDocument()
    }
  })

  it('registers the signup and confirms it', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Join the Waitlist/i }))

    await waitFor(() => expect(screen.getByText(/You're on the list/i)).toBeInTheDocument())
    expect(screen.getByText(/grace@example.com/)).toBeInTheDocument()

    const payload = JSON.parse(fetchMock.mock.calls[0][1].body)
    expect(payload.subject).toBe('[Waitlist] Kinnav waitlist — Grace (App User)')
    expect(payload.body).toContain('Grace')
    expect(payload.body).toContain('grace@example.com')
  })

  it('tags the signup as a waitlist one so it files apart from support mail', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Join the Waitlist/i }))

    await waitFor(() => expect(fetchMock).toHaveBeenCalled())
    const payload = JSON.parse(fetchMock.mock.calls[0][1].body)
    expect(payload.form).toBe('waitlist')
    expect(payload.subject).toMatch(/^\[Waitlist\] /)
    expect(payload.subject).not.toContain('[Contact]')
  })

  it('records the chosen role in the subject', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await user.click(screen.getByRole('button', { name: /Investor/ }))
    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Join the Waitlist/i }))

    await waitFor(() => expect(fetchMock).toHaveBeenCalled())
    expect(JSON.parse(fetchMock.mock.calls[0][1].body).subject).toContain('(Investor)')
  })

  it('sends an optional message when one is written', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await fillIn(user)
    await user.type(screen.getByPlaceholderText(/Tell us about yourself/i), 'I run a shelter.')
    await user.click(screen.getByRole('button', { name: /Join the Waitlist/i }))

    await waitFor(() => expect(fetchMock).toHaveBeenCalled())
    expect(JSON.parse(fetchMock.mock.calls[0][1].body).body).toContain('I run a shelter.')
  })

  it('does not claim the signup is recorded when it fell back to mailto', async () => {
    const user = userEvent.setup()
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({ ok: false, json: async () => ({ ok: false, error: 'nope' }) }))
    renderPage()

    await fillIn(user)
    await user.click(screen.getByRole('button', { name: /Join the Waitlist/i }))

    await waitFor(() => expect(screen.getByText(/Almost there — press send/i)).toBeInTheDocument())
    // The success heading must not appear — only the "press send" prompt does.
    expect(screen.queryByRole('heading', { name: /You're on the list/i })).not.toBeInTheDocument()
    expect(window.location.href).toContain('mailto:support@kinnav.com')
  })

  it('requires both name and email before submitting', async () => {
    const user = userEvent.setup()
    const fetchMock = okFetch()
    renderPage()

    await user.type(screen.getByPlaceholderText('Your name'), 'Grace')
    await user.click(screen.getByRole('button', { name: /Join the Waitlist/i }))

    expect(fetchMock).not.toHaveBeenCalled()
  })
})
