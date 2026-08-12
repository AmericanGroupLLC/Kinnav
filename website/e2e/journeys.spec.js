// End-to-end journeys — a real browser, real navigation, real form submission.
// The form handler is stubbed at the network layer because the preview server
// does not run PHP; the PHP side has its own suite (src/test/php-handler.test.js).
import { test, expect } from '@playwright/test'

async function stubFormEndpoint(page, { ok = true, status = 200 } = {}) {
  const calls = []
  await page.route('**/api/contact.php', async (route) => {
    calls.push(JSON.parse(route.request().postData() || '{}'))
    await route.fulfill({
      status,
      contentType: 'application/json',
      body: JSON.stringify({ ok }),
    })
  })
  return calls
}

test.describe('navigation', () => {
  test('a visitor can reach every page from the home page', async ({ page, isMobile }) => {
    await page.goto('/')

    if (isMobile) {
      // The mobile menu has to be opened first.
      await page.getByRole('button', { name: /menu/i }).click()
    }
    await page.getByRole('link', { name: 'How It Works', exact: true }).first().click()
    await expect(page).toHaveURL(/\/how-it-works$/)

    await page.goto('/')
    await page.getByRole('link', { name: /Join Waitlist|Get Early Access|Waitlist/i }).first().click()
    await expect(page).toHaveURL(/\/waitlist$/)
  })

  test('deep links work on a cold load, not just via client routing', async ({ page }) => {
    // This is what the Apache rewrite in .htaccess exists for.
    await page.goto('/privacy')
    await expect(page.locator('body')).toContainText(/privacy/i)
    await page.reload()
    await expect(page.locator('body')).toContainText(/privacy/i)
  })

  test('an unknown route renders the 404 page rather than a blank screen', async ({ page }) => {
    await page.goto('/definitely-not-a-page')
    await expect(page.locator('body')).toContainText('404')
    await expect(page.locator('#root')).not.toBeEmpty()
  })

  test('the browser back button returns to the previous page', async ({ page }) => {
    await page.goto('/')
    await page.goto('/about')
    await page.goBack()
    await expect(page).toHaveURL(/\/$/)
  })
})

test.describe('contact form', () => {
  test('submits an enquiry and confirms delivery', async ({ page }) => {
    const calls = await stubFormEndpoint(page)
    await page.goto('/contact')

    await page.getByPlaceholder('Your name').fill('Ada Lovelace')
    await page.getByPlaceholder('you@example.com').fill('ada@example.com')
    await page.getByPlaceholder('Tell us how we can help...').fill('How do I become a guardian?')
    await page.getByRole('button', { name: /Send Message/i }).click()

    await expect(page.getByText('Message sent!')).toBeVisible()
    expect(calls).toHaveLength(1)
    expect(calls[0].subject).toContain('General Inquiry — Kinnav')
    expect(calls[0].body).toContain('How do I become a guardian?')
  })

  test('routes a guardian application under its own subject', async ({ page }) => {
    const calls = await stubFormEndpoint(page)
    await page.goto('/contact')

    await page.getByRole('button', { name: /Become a Guardian/ }).click()
    await page.getByPlaceholder('Your name').fill('Grace')
    await page.getByPlaceholder('you@example.com').fill('grace@example.com')
    await page.getByPlaceholder('Tell us how we can help...').fill('I would like to apply.')
    await page.getByRole('button', { name: /Send Message/i }).click()

    await expect(page.getByText('Message sent!')).toBeVisible()
    expect(calls[0].subject).toContain('Guardian Application')
  })

  test('the browser blocks a malformed email address before submission', async ({ page }) => {
    const calls = await stubFormEndpoint(page)
    await page.goto('/contact')

    await page.getByPlaceholder('Your name').fill('Ada')
    await page.getByPlaceholder('you@example.com').fill('not-an-email')
    await page.getByPlaceholder('Tell us how we can help...').fill('Hello')
    await page.getByRole('button', { name: /Send Message/i }).click()

    await expect(page.getByText('Message sent!')).toBeHidden()
    expect(calls).toHaveLength(0)
  })

  test('falls back to the mail client when the handler fails', async ({ page }) => {
    await stubFormEndpoint(page, { ok: false, status: 502 })
    await page.goto('/contact')

    await page.getByPlaceholder('Your name').fill('Ada')
    await page.getByPlaceholder('you@example.com').fill('ada@example.com')
    await page.getByPlaceholder('Tell us how we can help...').fill('Hello')
    await page.getByRole('button', { name: /Send Message/i }).click()

    await expect(page.getByText(/Almost there — press send/i)).toBeVisible()
    await expect(page.getByRole('link', { name: 'support@kinnav.com' })).toBeVisible()
    await expect(page.getByText('Message sent!')).toBeHidden()
  })
})

test.describe('waitlist form', () => {
  test('signs a visitor up and confirms it', async ({ page }) => {
    const calls = await stubFormEndpoint(page)
    await page.goto('/waitlist')

    await page.getByPlaceholder('Your name').fill('Grace Hopper')
    await page.getByPlaceholder('you@example.com').fill('grace@example.com')
    await page.getByRole('button', { name: /Investor/ }).click()
    await page.getByRole('button', { name: /Join the Waitlist/i }).click()

    await expect(page.getByRole('heading', { name: /You're on the list/i })).toBeVisible()
    expect(calls[0].subject).toContain('(Investor)')
  })

  test('sends nothing to the network when required fields are empty', async ({ page }) => {
    const calls = await stubFormEndpoint(page)
    await page.goto('/waitlist')

    await page.getByRole('button', { name: /Join the Waitlist/i }).click()
    await expect(page.getByRole('heading', { name: /You're on the list/i })).toBeHidden()
    expect(calls).toHaveLength(0)
  })
})
