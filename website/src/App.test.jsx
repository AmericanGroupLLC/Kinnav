// Functional tests — routing and chrome. These cover the behaviour that the
// Apache .htaccess rewrite exists to support: every route must render a real
// page rather than the 404 component.
import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import { MemoryRouter, Routes, Route } from 'react-router-dom'
import Home from './pages/Home'
import HowItWorks from './pages/HowItWorks'
import Waitlist from './pages/Waitlist'
import About from './pages/About'
import PrivacyPolicy from './pages/PrivacyPolicy'
import Terms from './pages/Terms'
import Contact from './pages/Contact'
import NotFound from './pages/NotFound'
import Navbar from './components/Navbar'
import Footer from './components/Footer'

const ROUTES = [
  ['/', Home, /Kinnav|safety/i],
  ['/how-it-works', HowItWorks, /how it works|safe call/i],
  ['/waitlist', Waitlist, /waitlist/i],
  ['/about', About, /about|mission/i],
  ['/privacy', PrivacyPolicy, /privacy/i],
  ['/terms', Terms, /terms/i],
  ['/contact', Contact, /get in touch|contact/i],
]

function renderAt(path, Page) {
  return render(
    <MemoryRouter initialEntries={[path]}>
      <Routes>
        <Route path={path} element={<Page />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </MemoryRouter>
  )
}

describe('routing', () => {
  it.each(ROUTES)('renders %s without falling through to 404', (path, Page, pattern) => {
    const { container } = renderAt(path, Page)
    expect(container.textContent).toMatch(pattern)
    expect(container.textContent).not.toMatch(/404/)
  })

  it.each([['/privacy', PrivacyPolicy], ['/terms', Terms]])(
    '%s names the support address, which both app stores require in the policy itself',
    (path, Page) => {
      // A store listing points its privacy-policy URL here. A reviewer who
      // cannot find a contact method in the policy rejects the submission, and
      // a link to a form does not count.
      const { container } = renderAt(path, Page)
      expect(container.textContent).toContain('support@kinnav.com')
      const mailto = Array.from(container.querySelectorAll('a'))
        .map(a => a.getAttribute('href'))
        .filter(h => h?.startsWith('mailto:'))
      expect(mailto).toContain('mailto:support@kinnav.com')
    })

  it('shows the 404 page for an unknown route', () => {
    render(
      <MemoryRouter initialEntries={['/no-such-page']}>
        <Routes><Route path="*" element={<NotFound />} /></Routes>
      </MemoryRouter>
    )
    expect(screen.getByText(/404/)).toBeInTheDocument()
  })
})

describe('chrome', () => {
  it('navbar links to the primary pages and the waitlist CTA', () => {
    render(<MemoryRouter><Navbar /></MemoryRouter>)
    const hrefs = Array.from(document.querySelectorAll('a')).map(a => a.getAttribute('href'))
    for (const path of ['/', '/how-it-works', '/about', '/waitlist']) {
      expect(hrefs).toContain(path)
    }
  })

  it('footer reaches contact and the legal pages', () => {
    const { container } = render(<MemoryRouter><Footer /></MemoryRouter>)
    const hrefs = Array.from(container.querySelectorAll('a')).map(a => a.getAttribute('href'))
    for (const path of ['/contact', '/privacy', '/terms', '/waitlist']) {
      expect(hrefs).toContain(path)
    }
    expect(container.textContent).toMatch(/©\s*\d{4}\s*Kinnav/)
    expect(container.textContent).not.toMatch(/gmail/i)
  })

  it('opens external social links safely', () => {
    const { container } = render(<MemoryRouter><Footer /></MemoryRouter>)
    for (const a of container.querySelectorAll('a[target="_blank"]')) {
      expect(a.getAttribute('rel')).toMatch(/noopener/)
    }
  })
})
