import { renderToStaticMarkup } from 'react-dom/server'
import { MemoryRouter } from 'react-router-dom'

import { Layout } from './App'

/**
 * Renders one route to static HTML for the prerender step.
 *
 * MemoryRouter rather than StaticRouter: React Router 7 dropped StaticRouter
 * from library mode, and MemoryRouter needs no `window`, so it renders happily
 * under Node.
 *
 * `renderToStaticMarkup` (not renderToString) on purpose — the client does a
 * full render on mount rather than hydrating, so React's hydration markers
 * would be dead weight. The prerendered HTML exists to be read by crawlers and
 * store reviewers; the interactive app replaces it the moment JS runs.
 */
export function render(path) {
  return renderToStaticMarkup(
    <MemoryRouter initialEntries={[path]}>
      <Layout />
    </MemoryRouter>,
  )
}
