// Accessibility tests — axe-core against every page rendered in jsdom.
//
// jsdom has no layout engine, so colour-contrast and target-size rules cannot
// be evaluated here; those run in the Playwright suite (e2e/quality.spec.js)
// on a real browser. Everything structural — landmarks, labels, roles, heading
// order, link text, ARIA validity — is checked below.
import { describe, it, expect } from 'vitest'
import { render } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import axe from 'axe-core'
import Home from '../pages/Home'
import HowItWorks from '../pages/HowItWorks'
import Waitlist from '../pages/Waitlist'
import About from '../pages/About'
import PrivacyPolicy from '../pages/PrivacyPolicy'
import Terms from '../pages/Terms'
import Contact from '../pages/Contact'
import NotFound from '../pages/NotFound'
import Navbar from '../components/Navbar'
import Footer from '../components/Footer'

const PAGES = [
  ['Home', Home],
  ['HowItWorks', HowItWorks],
  ['Waitlist', Waitlist],
  ['About', About],
  ['PrivacyPolicy', PrivacyPolicy],
  ['Terms', Terms],
  ['Contact', Contact],
  ['NotFound', NotFound],
]

// Rules that need real layout; they are covered by the browser suite instead.
const LAYOUT_DEPENDENT = ['color-contrast', 'target-size', 'scrollable-region-focusable']

async function analyse(container) {
  const { violations } = await axe.run(container, {
    runOnly: { type: 'tag', values: ['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'] },
    rules: Object.fromEntries(LAYOUT_DEPENDENT.map(id => [id, { enabled: false }])),
  })
  return violations
    .filter(v => ['critical', 'serious'].includes(v.impact))
    .map(v => `${v.impact}: ${v.id} (${v.nodes.length}x) — ${v.help}`)
}

describe('accessibility', () => {
  for (const [name, Page] of PAGES) {
    it(`${name} has no critical or serious violations`, async () => {
      const { container } = render(
        <MemoryRouter><main>{<Page />}</main></MemoryRouter>
      )
      expect(await analyse(container)).toEqual([])
    }, 30_000)
  }

  it('the navbar is accessible', async () => {
    const { container } = render(<MemoryRouter><Navbar /></MemoryRouter>)
    expect(await analyse(container)).toEqual([])
  }, 30_000)

  it('the footer is accessible', async () => {
    const { container } = render(<MemoryRouter><Footer /></MemoryRouter>)
    expect(await analyse(container)).toEqual([])
  }, 30_000)

  it('every page has exactly one h1', () => {
    for (const [name, Page] of PAGES) {
      const { container, unmount } = render(<MemoryRouter><Page /></MemoryRouter>)
      expect(container.querySelectorAll('h1').length, `${name} h1 count`).toBe(1)
      unmount()
    }
  })

  it('no image is missing alt text', () => {
    for (const [name, Page] of PAGES) {
      const { container, unmount } = render(<MemoryRouter><Page /></MemoryRouter>)
      expect(container.querySelectorAll('img:not([alt])').length, `${name}`).toBe(0)
      unmount()
    }
  })

  it('interactive controls have an accessible name', () => {
    for (const [name, Page] of PAGES) {
      const { container, unmount } = render(<MemoryRouter><Page /></MemoryRouter>)
      for (const el of container.querySelectorAll('button, a')) {
        const named = Boolean(
          el.textContent.trim() || el.getAttribute('aria-label') || el.getAttribute('title'),
        )
        expect(named, `${name}: unnamed <${el.tagName.toLowerCase()}>`).toBe(true)
      }
      unmount()
    }
  })
})
