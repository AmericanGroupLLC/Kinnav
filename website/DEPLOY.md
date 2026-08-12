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

`kinnav-site.zip` contains (23 files):

```
index.html
.htaccess              <- required: SPA routing, HTTPS, caching
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

## 5. If HTTPS fails but HTTP works

cPanel → **SSL/TLS Status** → select `kinnav.com` and `www.kinnav.com` → **Run AutoSSL**.
AutoSSL needs the A record already resolving to the HostGator IP, so run it after DNS
has propagated. If it fails, the usual cause is the `www` record still pointing
elsewhere.

## 6. DNS notes

- HostGator's TTL is 4 hours; full propagation can take 24–48 hours.
- **Do not delete the MX, SPF, DKIM, or DMARC records** while changing DNS — those are
  email, not the website. Removing them silently breaks mail delivery.
- Only the `A` record for `kinnav.com` and the `www` record need to point at the
  HostGator server for this site.

## 7. Redeploying

Repeat steps 1–2. Because bundles are content-hashed and `index.html` is sent
`no-cache`, visitors get the new build on their next load — no cache purge needed.
Delete the old `assets/` folder before extracting so stale bundles don't pile up.
