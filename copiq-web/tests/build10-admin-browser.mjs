import assert from 'node:assert/strict'
import { createRequire } from 'node:module'
import { mkdir } from 'node:fs/promises'
const require = createRequire(import.meta.url)
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright')
const baseURL = process.env.TEST_BASE_URL || 'http://localhost:3107'
const output = process.env.TEST_SCREENSHOTS || '.test-results/build10'
await mkdir(output, { recursive: true })
const browser = await chromium.launch({ channel: 'msedge', headless: true })
const user = { id: '00000000-0000-4000-8000-000000000010', email: 'review@example.invalid', factors: [{ id: 'test-factor', factor_type: 'totp', status: 'verified' }] }
const accessToken = ['eyJhbGciOiJIUzI1NiJ9', Buffer.from(JSON.stringify({ sub: user.id, exp: Math.floor(Date.now()/1000)+3600, role: 'authenticated', aal: 'aal2' })).toString('base64url'), 'mock-signature'].join('.')
const session = { access_token: accessToken, refresh_token: 'mock-refresh-token', expires_at: Math.floor(Date.now()/1000)+3600, expires_in: 3600, token_type: 'bearer', user }
const rows = [{ user_id: user.id, email: user.email, first_name: 'Compte', last_name: 'Vérification', username: null, is_premium: true, manual_active: true,
  sources: [
    { source: 'APP_STORE', environment: 'SANDBOX', plan: 'month', product_id: 'fr.copiq.premium.monthly', status: 'active', expires_at: '2026-11-18T12:00:00Z', verified_at: '2026-10-18T10:00:00Z', grants_access: false, cancel_at_period_end: false },
    { source: 'PLAY_STORE', environment: 'PRODUCTION', plan: 'year', product_id: 'premium_annual', status: 'active', expires_at: '2027-10-18T12:00:00Z', verified_at: '2026-10-18T10:00:00Z', grants_access: true, cancel_at_period_end: true },
    { source: 'MANUAL', environment: 'PRODUCTION', plan: 'premium', status: 'active', expires_at: '2026-11-18T12:00:00Z', verified_at: '2026-10-18T10:00:00Z', grants_access: true, cancel_at_period_end: false },
  ] }]
try {
  for (const role of ['owner','admin','moderator']) {
    const context = await browser.newContext({ viewport: { width: 1440, height: 1000 } })
    await context.addCookies([{ name: 'sb-test-auth-token', value: 'base64-'+Buffer.from(JSON.stringify(session)).toString('base64url'), url: baseURL }])
    await context.route('**/copiq-config.js', route => route.fulfill({ contentType: 'application/javascript', body: 'window.COPIQ_CONFIG={SUPABASE_URL:"https://test.supabase.co",SUPABASE_ANON_KEY:"test-anon-key"};' }))
    const calls = []
    await context.route('**/*.supabase.co/**', async route => {
      const url = new URL(route.request().url())
      calls.push(url.pathname)
      let data = []
      if (url.pathname.endsWith('/admin_mfa_status')) data = { ok: true, role, permissions: { subscriptions: true, dashboard: true, users: true }, aal: 'aal2', code_required: false }
      else if (url.pathname.endsWith('/user')) data = user
      else if (url.pathname.endsWith('/admin_subscription_sources')) data = rows
      await route.fulfill({ contentType: 'application/json', body: JSON.stringify(data) })
    })
    const page = await context.newPage()
    const errors = []
    page.on('pageerror', error => errors.push(error.message))
    await page.goto(baseURL+'/admin/abonnements/')
    if (role === 'owner') {
      await page.getByText('Apple App Store', { exact: true }).waitFor({ timeout: 60000 })
      await page.getByText('Google Play', { exact: true }).waitFor()
      await page.getByText('Test Sandbox', { exact: true }).waitFor()
      const rejectCookies = page.getByRole('button', { name: 'Tout refuser', exact: true })
      if (await rejectCookies.isVisible()) await rejectCookies.click()
      await page.waitForTimeout(800)
      assert.equal(await page.getByRole('button', { name: 'Retirer le cadeau', exact: true }).isEnabled(), true)
      await page.screenshot({ path: output+'/subscriptions-desktop.png', fullPage: true })
      await page.setViewportSize({ width: 390, height: 844 })
      await page.waitForTimeout(800)
      await page.screenshot({ path: output+'/subscriptions-mobile.png', fullPage: true })
      assert.equal(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), true)
    } else {
      await page.getByText(role === 'admin' ? 'Cette page est réservée au fondateur.' : 'Accéder à la modération du forum', { exact: true }).waitFor({ timeout: 60000 })
      assert.equal(calls.some(call => call.endsWith('/admin_subscription_sources')), false)
      assert.equal(await page.getByRole('link', { name: 'Abonnements', exact: true }).count(), 0)
    }
    assert.deepEqual(errors, [])
    console.log(`PASS: ${role} panel access`)
    await context.close()
  }
} finally { await browser.close() }
