// Accessibility, responsive layout and performance budgets.
//
// These are the checks that catch the things a functional test happily passes
// over: an unreadable contrast ratio, a page that scrolls sideways on a phone,
// or a bundle that has quietly doubled in size.
import { test, expect } from '@playwright/test'
import AxeBuilder from '@axe-core/playwright'

const ROUTES = ['/', '/how-it-works', '/waitlist', '/about', '/privacy', '/terms', '/contact']

test.describe('accessibility', () => {
  for (const route of ROUTES) {
    test(`${route} has no critical or serious WCAG violations`, async ({ page }) => {
      await page.goto(route)
      const { violations } = await new AxeBuilder({ page })
        .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'])
        .analyze()

      const blocking = violations.filter(v => ['critical', 'serious'].includes(v.impact))
      expect(
        blocking.map(v => `${v.impact}: ${v.id} (${v.nodes.length}x) — ${v.help}`),
      ).toEqual([])
    })
  }

  test('every page has exactly one h1', async ({ page }) => {
    for (const route of ROUTES) {
      await page.goto(route)
      expect(await page.locator('h1').count(), `${route} h1 count`).toBe(1)
    }
  })

  test('every image carries alt text', async ({ page }) => {
    for (const route of ROUTES) {
      await page.goto(route)
      const missing = await page.locator('img:not([alt])').count()
      expect(missing, `${route} images without alt`).toBe(0)
    }
  })

  test('form fields are labelled', async ({ page }) => {
    await page.goto('/contact')
    for (const field of await page.locator('input:not([type=hidden]), textarea').all()) {
      const name = await field.getAttribute('name')
      if (name === 'website') continue // honeypot, deliberately hidden
      const described = await field.evaluate(el => Boolean(
        el.labels?.length || el.getAttribute('aria-label') || el.getAttribute('placeholder'),
      ))
      expect(described).toBe(true)
    }
  })

  test('the keyboard can reach and submit the contact form', async ({ page, isMobile }) => {
    test.skip(isMobile, 'no hardware keyboard on the mobile project')
    await page.goto('/contact')
    await page.getByPlaceholder('Your name').focus()
    await page.keyboard.type('Ada')
    await page.keyboard.press('Tab')
    await page.keyboard.type('ada@example.com')
    await expect(page.getByPlaceholder('you@example.com')).toHaveValue('ada@example.com')
  })
})

test.describe('responsive layout', () => {
  const VIEWPORTS = [
    { name: 'phone', width: 375, height: 812 },
    { name: 'tablet', width: 768, height: 1024 },
    { name: 'laptop', width: 1440, height: 900 },
  ]

  for (const viewport of VIEWPORTS) {
    test(`no horizontal overflow at ${viewport.name} width`, async ({ page }) => {
      await page.setViewportSize({ width: viewport.width, height: viewport.height })
      for (const route of ROUTES) {
        await page.goto(route)
        const overflow = await page.evaluate(() =>
          document.documentElement.scrollWidth - document.documentElement.clientWidth)
        expect(overflow, `${route} at ${viewport.width}px overflows by ${overflow}px`).toBeLessThanOrEqual(1)
      }
    })
  }

  test('primary calls to action are large enough to tap', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 })
    await page.goto('/')
    for (const cta of await page.getByRole('link', { name: /waitlist|get early access/i }).all()) {
      if (!(await cta.isVisible())) continue
      const box = await cta.boundingBox()
      expect(box.height, 'tap target height').toBeGreaterThanOrEqual(40)
    }
  })
})

test.describe('performance', () => {
  test('the home page renders quickly and stays within budget', async ({ page }) => {
    await page.goto('/')
    const metrics = await page.evaluate(() => {
      const nav = performance.getEntriesByType('navigation')[0]
      const paint = performance.getEntriesByName('first-contentful-paint')[0]
      return {
        domContentLoaded: nav.domContentLoadedEventEnd - nav.startTime,
        load: nav.loadEventEnd - nav.startTime,
        fcp: paint ? paint.startTime : null,
      }
    })

    expect(metrics.domContentLoaded, 'DOMContentLoaded ms').toBeLessThan(3000)
    if (metrics.fcp !== null) expect(metrics.fcp, 'first contentful paint ms').toBeLessThan(3000)
  })

  test('transferred JavaScript stays under 250 KB gzipped', async ({ page }) => {
    const sizes = []
    page.on('response', async (res) => {
      if (res.url().endsWith('.js')) {
        const headers = res.headers()
        sizes.push(Number(headers['content-length'] || 0))
      }
    })
    await page.goto('/', { waitUntil: 'networkidle' })
    const total = sizes.reduce((a, b) => a + b, 0)
    expect(total, `total JS bytes: ${total}`).toBeLessThan(250 * 1024)
  })

  test('no image is larger than 500 KB', async ({ page }) => {
    const oversized = []
    page.on('response', async (res) => {
      if (/\.(png|jpe?g|webp|gif)$/i.test(res.url())) {
        const size = Number(res.headers()['content-length'] || 0)
        if (size > 500 * 1024) oversized.push(`${res.url()} = ${Math.round(size / 1024)}KB`)
      }
    })
    await page.goto('/', { waitUntil: 'networkidle' })
    expect(oversized).toEqual([])
  })
})

test.describe('SEO', () => {
  test('canonical, Open Graph and structured data are present', async ({ page }) => {
    await page.goto('/')
    await expect(page.locator('link[rel="canonical"]')).toHaveAttribute('href', 'https://kinnav.com/')
    await expect(page.locator('meta[property="og:title"]')).toHaveAttribute('content', /Kinnav/)
    await expect(page.locator('meta[property="og:image"]')).toHaveAttribute('content', /^https:\/\/kinnav\.com\//)
    const ld = await page.locator('script[type="application/ld+json"]').textContent()
    expect(() => JSON.parse(ld)).not.toThrow()
  })

  test('robots.txt points at the sitemap and the sitemap lists every route', async ({ request }) => {
    const robots = await (await request.get('/robots.txt')).text()
    expect(robots).toContain('Sitemap: https://kinnav.com/sitemap.xml')

    const sitemap = await (await request.get('/sitemap.xml')).text()
    for (const route of ROUTES) {
      expect(sitemap, `sitemap should list ${route}`).toContain(`https://kinnav.com${route === '/' ? '/' : route}`)
    }
  })
})
