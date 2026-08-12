# Deploying kinnav.com to cPanel (HostGator)

The site is a **Vite + React SPA**. The `website/` folder is *source*, not something
you can upload as-is — cPanel serves static files, so you must build first and upload
the contents of `dist/`.

## 1. Build the upload bundle

```bash
cd website
pnpm install
pnpm package      # runs vite build, then zips dist/ -> website/kinnav-site.zip
```

`kinnav-site.zip` contains (25 entries):

```
index.html
.htaccess              <- required: SPA routing, HTTPS, caching
api/contact.php        <- required: emails the contact + waitlist forms
assets/index-*.js      <- content-hashed bundle
assets/index-*.css
images/*.jpg|.png
favicon.svg  icons.svg  robots.txt  sitemap.xml  404.html
CNAME  _redirects      <- leftovers from GitHub Pages / Netlify; harmless on Apache
```

## 2. Upload to the document root

The document root for the addon domain is **`/home2/safecode/kinnav.com/`** —
*not* `public_html/`, which serves a different domain.

1. cPanel → **File Manager** → Home → `kinnav.com`
2. Delete any placeholder (`default.html`, cPanel's stock `index.html`) already there.
3. **Upload** `kinnav-site.zip` into `/home2/safecode/kinnav.com/`
4. Right-click the zip → **Extract** → target `/home2/safecode/kinnav.com`
5. Delete `kinnav-site.zip` afterwards.
6. File Manager → **Settings** → tick **Show Hidden Files (dotfiles)** and confirm
   `.htaccess` landed next to `index.html`. Without it, `/about`, `/waitlist`, etc.
   return Apache 404s — only the home page would work.

Result:

```
/home2/safecode/kinnav.com/
├── .htaccess
├── index.html
├── api/contact.php
├── assets/
├── images/
├── favicon.svg
├── robots.txt
└── sitemap.xml
```

Permissions: files `644`, folders `755` (File Manager's default for uploads).

## 3. What `.htaccess` handles

| Rule | Why |
|---|---|
| Rewrite non-file paths → `index.html` | React Router uses `BrowserRouter`; deep links would 404 otherwise |
| `RewriteRule ^\.well-known/ - [L]` | Keeps AutoSSL / Let's Encrypt validation working |
| Force HTTPS | `http://kinnav.com` → `https://kinnav.com` |
| `www.kinnav.com` → `kinnav.com` | One canonical host for SEO |
| `Cache-Control` split | Hashed `assets/*` cached a year; `index.html` never cached, so redeploys are picked up immediately |
| gzip, `nosniff`, `SAMEORIGIN`, `Referrer-Policy` | Compression + basic hardening |

## 4. Verify

```bash
curl -I http://kinnav.com          # expect 301 -> https
curl -I https://kinnav.com         # expect 200, text/html
curl -I https://kinnav.com/about   # expect 200 (SPA fallback, not 404)
curl -I https://www.kinnav.com     # expect 301 -> https://kinnav.com
```

Then load `https://kinnav.com` in a browser and click through
`/how-it-works`, `/waitlist`, `/about`, `/privacy`, `/terms`, `/contact`,
including a hard refresh on each (that is the case `.htaccess` fixes).

## 5. Forms → support@kinnav.com

Both forms (contact and waitlist) POST JSON to `/api/contact.php`, which emails
**support@kinnav.com**. The address is set in two places, and both must agree:

| File | Constant |
|---|---|
| `src/config.js` | `SITE_EMAIL` — what the site displays and the mailto fallback uses |
| `public/api/contact.php` | `INBOX` / `FROM` |

The handler uses PHP's `mail()`, which hands the message to the server's own
mail transport. That means **no SMTP password is stored on the server**, and the
message is DKIM-signed and SPF-valid because it originates from the host in your
SPF record. The IMAP/SMTP settings cPanel showed you (ports 993/465, server
`kinnav.com`) are for *mail clients* — Outlook, Apple Mail, your phone — and are
not needed by the website.

Requirements and behaviour:

- PHP must be enabled for the domain — cPanel → **MultiPHP Manager**, set
  `kinnav.com` to PHP 8.x. It is on by default on HostGator shared hosting.
- The `.htaccess` SPA rewrite skips real files, so `/api/contact.php` is executed
  rather than swallowed by the rewrite to `index.html`.
- Protections: hidden honeypot field, CR/LF stripping so submitted values cannot
  inject mail headers, 5 submissions per IP per hour, 5000-character cap.
- `Reply-To` is set to the visitor, so replying from webmail reaches them.
- If PHP is missing or the mail server rejects the message, the form opens the
  visitor's mail client pre-filled and tells them to press send — it never claims
  a message was delivered when it was not.

Test after uploading:

```bash
curl -s -X POST https://kinnav.com/api/contact.php \
  -H 'Content-Type: application/json' \
  -d '{"name":"Test","email":"you@example.com","subject":"Test — Kinnav","body":"Hello"}'
# expect: {"ok":true}   then check the support@kinnav.com inbox
```

`{"ok":false,...}` tells you what was rejected. A response that is HTML instead of
JSON means PHP is not running for the domain.

If mail is accepted but never arrives, check cPanel → **Track Delivery**, and make
sure the mailbox is not over quota.

## 6. If HTTPS fails but HTTP works

cPanel → **SSL/TLS Status** → select `kinnav.com` and `www.kinnav.com` → **Run AutoSSL**.
AutoSSL needs the A record already resolving to the HostGator IP, so run it after DNS
has propagated. If it fails, the usual cause is the `www` record still pointing
elsewhere.

## 7. DNS notes

- HostGator's TTL is 4 hours; full propagation can take 24–48 hours.
- **Do not delete the MX, SPF, DKIM, or DMARC records** while changing DNS — those are
  email, not the website. Removing them silently breaks mail delivery.
- Only the `A` record for `kinnav.com` and the `www` record need to point at the
  HostGator server for this site.

## 8. Redeploying

Repeat steps 1–2. Because bundles are content-hashed and `index.html` is sent
`no-cache`, visitors get the new build on their next load — no cache purge needed.
Delete the old `assets/` folder before extracting so stale bundles don't pile up.
