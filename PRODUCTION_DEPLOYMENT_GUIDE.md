# kinnav.com — Production Deployment Guide

**Domain:** kinnav.com  
**App:** Kinnav — Women's Safety, Empowerment & Rewards  
**Owner / Developer:** American Group LLC (private company)  
**GitHub:** https://github.com/AmericanGroupLLC/Kinnav  

---

## Website Overview

| Page | Route | Purpose |
|---|---|---|
| Home | `/` | Hero, features, how-it-works, competitive table, app screenshots, early-access CTA |
| How It Works | `/how-it-works` | Full app walkthrough, guardian program, empowerment, rewards |
| Waitlist | `/waitlist` | Early-access waitlist form, pitch deck request |
| About | `/about` | Mission, team, values, community roles |
| Contact | `/contact` | Categorized contact form (6 inquiry types) |
| Privacy Policy | `/privacy` | Full GDPR/CCPA privacy policy |
| Terms of Service | `/terms` | Full legal terms |
| 404 | `*` | Custom not-found page |

---

## No donations or charitable solicitation

Kinnav is a product of **American Group LLC**, a private company. It is **not** a
nonprofit, has no 501(c)(3) status, and must not solicit tax-deductible
donations.

Removed from the site — do not reintroduce without legal review:

- the Zeffy donation embed and all donation tiers
- "Donate Now" / "Support Our Mission" calls to action
- EmbeddedOS (EoS) Research Foundation attribution, EIN, and 501(c)(3) claims
- the `/grant-funding` page and route (replaced by `/waitlist`)

Soliciting donations, or describing them as tax-deductible, while operating as a
private LLC creates real legal exposure — most US states regulate charitable
solicitation, and a tax-deductibility claim without 501(c)(3) status is a
misrepresentation to donors. Commercial funding routes (investment, revenue,
partnerships) are unaffected; route those through `/contact` → *Investor
Relations*.

---

## Deploying to kinnav.com

### Option 0: GitHub Pages — **this is the configured path**

Already wired up: `.github/workflows/deploy-website.yml` builds `website/` and
deploys to GitHub Pages on every push to `master` that touches `website/**`.
Nothing to set up in the repo.

DNS records, the HostGator specifics, and the records you must *not* delete:
**[`docs/DNS_KINNAV_COM.md`](docs/DNS_KINNAV_COM.md)**.

The options below are alternatives. Choosing one means retiring the GitHub Pages
workflow — don't run two deploy targets at the same domain.

### Option 1: Netlify (Free)

1. Go to [netlify.com](https://netlify.com) → New site from Git
2. Connect to `AmericanGroupLLC/Kinnav` repository
3. Set **Base directory:** `website`
4. Set **Build command:** `pnpm build`
5. Set **Publish directory:** `website/dist`
6. Deploy — Netlify automatically uses `website/public/_redirects` for SPA routing
7. In Netlify → Domain Settings → Add custom domain: `kinnav.com`
8. Enable HTTPS (auto via Let's Encrypt)

### Option 2: Vercel (Recommended — Free)

1. Go to [vercel.com](https://vercel.com) → New Project
2. Import `AmericanGroupLLC/Kinnav`
3. Set **Root Directory:** `website`
4. Build command: `pnpm build` · Output directory: `dist`
5. Deploy — Vercel uses `website/vercel.json` for SPA routing
6. Settings → Domains → Add `kinnav.com`

### Option 3: cPanel / Traditional Web Hosting

1. Run `pnpm build` in `website/` directory
2. Upload contents of `website/dist/` to your `public_html/` folder
3. **You must create an `.htaccess` yourself** — there is none in `website/public/`,
   so none is emitted into `dist/`. Without it, every client-side route
   (`/about`, `/contact`, …) returns a 404 from Apache. Minimum:
   ```apache
   <IfModule mod_rewrite.c>
     RewriteEngine On
     RewriteBase /
     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d
     RewriteRule . /index.html [L]
   </IfModule>
   ```
4. Point `kinnav.com` DNS to your hosting IP

### DNS Configuration

For the configured GitHub Pages path, use the exact records in
**[`docs/DNS_KINNAV_COM.md`](docs/DNS_KINNAV_COM.md)** — it lists GitHub's four
apex `A` records, the `www` CNAME target, and the conflicting HostGator records
that must be removed first.

For a self-hosted alternative (Option 3), the generic shape is:

```
Type    Name    Value
A       @       [your host IP]
CNAME   www     kinnav.com
```

---

## Required Information Checklist

Before going live, confirm the following:

### Domain & SSL
- [ ] Domain `kinnav.com` is registered and DNS is configured
- [ ] SSL certificate is active (HTTPS)
- [ ] `www.kinnav.com` redirects to `kinnav.com`

### Email Addresses (Verify these work)
- [ ] `saferapp3@gmail.com` — app support / team / investor inbox

### SEO & Analytics
- [ ] Submit `https://kinnav.com/sitemap.xml` to Google Search Console
- [ ] Add Google Analytics or Plausible tracking code to `index.html`
- [ ] Verify `robots.txt` is accessible at `https://kinnav.com/robots.txt`

### Social Media (Optional but recommended)
- [ ] Create Instagram: `@kinnav`
- [ ] Create Twitter/X: `@kinnav`
- [ ] Update Footer social links in `src/components/Footer.jsx`

---

## Contact Information

| Role | Email |
|---|---|
| App Support | saferapp3@gmail.com |
| Team / General | saferapp3@gmail.com |
| Investor Relations | saferapp3@gmail.com |

---

## Development Commands

```bash
cd website/

pnpm install        # Install dependencies
pnpm dev            # Start dev server (http://localhost:5173)
pnpm build          # Production build → dist/
pnpm preview        # Preview production build locally
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | React 19 + Vite 8 |
| Styling | Tailwind CSS v4 |
| Animations | Framer Motion |
| Routing | React Router DOM v7 |
| Icons | Lucide React |
| Payments | None on the website (app subscriptions ship via App Store / Play billing) |
| Deployment | GitHub Pages (configured) |

---

## Ownership

Kinnav is owned and developed by **American Group LLC**, a private company.

---

*Last updated: 2026-08-08 · kinnav.com Production Guide*
