// Smoke tests — the handful of checks that answer "is the deployed site alive
// and not obviously broken?". Fast, no interaction beyond navigation.
import { test, expect } from '@playwright/test'

const ROUTES = ['/', '/how-it-works', '/waitlist', '/about', '/privacy', '/terms', '/contact']

test.describe('smoke', () => {
  for (const route of ROUTES) {
    test(`${route} loads, renders and has no console errors`, async ({ page }) => {
      const errors = []
      page.on('console', msg => msg.type() === 'error' && errors.push(msg.text()))
      page.on('pageerror', err => errors.push(String(err)))

      const response = await page.goto(route)
      expect(response.status()).toBe(200)

      // Header, some body content and the footer all present.
      await expect(page.locator('#root')).not.toBeEmpty()
      await expect(page.getByRole('contentinfo').or(page.locator('footer')).first()).toBeVisible()
      expect(await page.locator('body').innerText()).not.toMatch(/^\s*$/)
      expect(errors).toEqual([])
    })
  }

  test('static assets are served', async ({ request }) => {
    for (const asset of ['/images/kinnav_logo.png', '/images/hero-bg.jpg', '/favicon.svg', '/robots.txt', '/sitemap.xml']) {
      const res = await request.get(asset)
      expect(res.status(), `${asset} should be served`).toBe(200)
    }
  })

  test('the page title and meta description are set', async ({ page }) => {
    await page.goto('/')
    await expect(page).toHaveTitle(/Kinnav/)
    const description = await page.locator('meta[name="description"]').getAttribute('content')
    expect(description).toBeTruthy()
    expect(description.length).toBeGreaterThan(50)
  })

  test('no placeholder or personal contact details are published', async ({ page }) => {
    for (const route of ROUTES) {
      await page.goto(route)
      const text = await page.locator('body').innerText()
      expect(text, `${route} should not leak a gmail address`).not.toMatch(/gmail/i)
      expect(text, `${route} should not contain lorem ipsum`).not.toMatch(/lorem ipsum/i)
    }
  })
})
