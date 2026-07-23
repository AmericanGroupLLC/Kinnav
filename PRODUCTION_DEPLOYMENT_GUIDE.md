# mysaferapp.com — Production Deployment Guide

**Domain:** mysaferapp.com  
**App:** Safer — Women's Safety, Empowerment & Rewards  
**Developer:** EmbeddedOS Foundation (501c3 · EIN 41-4821627)  
**Owner:** American Group LLC  
**GitHub:** https://github.com/Safer-Women (GitHub)  

---

## Website Overview

| Page | Route | Purpose |
|---|---|---|
| Home | `/` | Hero, features, how-it-works, competitive table, app screenshots, donate CTA |
| How It Works | `/how-it-works` | Full app walkthrough, guardian program, empowerment, rewards |
| Grant & Funding | `/grant-funding` | **Zeffy donation embed**, funding roadmap, grant table, waitlist form |
| About | `/about` | Mission, team, values, community roles |
| Contact | `/contact` | Categorized contact form (6 inquiry types) |
| Privacy Policy | `/privacy` | Full GDPR/CCPA privacy policy |
| Terms of Service | `/terms` | Full legal terms |
| 404 | `*` | Custom not-found page |

---

## Donation System

### How Donations Work

The donation system uses **Zeffy** — a 0% platform fee nonprofit payment processor.

| Item | Value |
|---|---|
| Zeffy Form URL | `https://www.zeffy.com/en-US/embed/donation-form/donate-to-change-lives-17596` |
| Recipient | EmbeddedOS (EoS) Research Foundation |
| EIN | 41-4821627 |
| Tax Status | 501(c)(3) — fully tax-deductible |
| Platform Fees | 0% (Zeffy charges nothing) |
| Tax Receipt | Automatically emailed by Zeffy |

### Donation Flow

1. User clicks **"Donate Now 💜"** in Navbar or any CTA button
2. Page scrolls to `#donate` section on `/grant-funding`
3. Zeffy iframe loads the donation form (one-time, monthly, quarterly, yearly)
4. User completes payment on Zeffy (credit card, Apple Pay, Google Pay)
5. Tax receipt emailed automatically
6. Funds deposited to EmbeddedOS Foundation bank account

### Other Donation Channels

- **Wire/Check:** foundation@embeddedos.org
- **GitHub Sponsors:** https://github.com/sponsors/embeddedos-org
- **Grant Partnerships:** saferapp3@gmail.com

---

## Deploying to mysaferapp.com

### Option 1: Netlify (Recommended — Free)

1. Go to [netlify.com](https://netlify.com) → New site from Git
2. Connect to `Safer-Women (GitHub)` repository
3. Set **Base directory:** `website`
4. Set **Build command:** `pnpm build`
5. Set **Publish directory:** `website/dist`
6. Deploy — Netlify automatically uses `website/public/_redirects` for SPA routing
7. In Netlify → Domain Settings → Add custom domain: `mysaferapp.com`
8. Enable HTTPS (auto via Let's Encrypt)

### Option 2: Vercel (Recommended — Free)

1. Go to [vercel.com](https://vercel.com) → New Project
2. Import `Safer-Women (GitHub)`
3. Set **Root Directory:** `website`
4. Build command: `pnpm build` · Output directory: `dist`
5. Deploy — Vercel uses `website/vercel.json` for SPA routing
6. Settings → Domains → Add `mysaferapp.com`

### Option 3: cPanel / Traditional Web Hosting

1. Run `pnpm build` in `website/` directory
2. Upload contents of `website/dist/` to your `public_html/` folder
3. The `.htaccess` file is already in `dist/` (from `public/`) — it handles SPA routing
4. Point `mysaferapp.com` DNS to your hosting IP

### DNS Configuration (for any host)

```
Type    Name    Value
A       @       [your host IP]
A       www     [your host IP]
CNAME   www     mysaferapp.com
```

---

## Required Information Checklist

Before going live, confirm the following:

### Zeffy Donation Form
- [ ] Log into Zeffy account and verify the form `donate-to-change-lives-17596` is active
- [ ] Confirm bank account is connected to receive funds
- [ ] Test a $1 donation end-to-end
- [ ] Verify tax receipt email is working

### Domain & SSL
- [ ] Domain `mysaferapp.com` is registered and DNS is configured
- [ ] SSL certificate is active (HTTPS)
- [ ] `www.mysaferapp.com` redirects to `mysaferapp.com`

### Email Addresses (Verify these work)
- [ ] `saferapp3@gmail.com` — app support inbox
- [ ] `saferapp3@gmail.com` — team inbox
- [ ] `foundation@embeddedos.org` — EmbeddedOS Foundation grants

### SEO & Analytics
- [ ] Submit `https://mysaferapp.com/sitemap.xml` to Google Search Console
- [ ] Add Google Analytics or Plausible tracking code to `index.html`
- [ ] Verify `robots.txt` is accessible at `https://mysaferapp.com/robots.txt`

### Social Media (Optional but recommended)
- [ ] Create Instagram: `@mysaferapp`
- [ ] Create Twitter/X: `@mysaferapp`
- [ ] Update Footer social links in `src/components/Footer.jsx`

---

## Contact Information

| Role | Email |
|---|---|
| App Support | saferapp3@gmail.com |
| Team / General | saferapp3@gmail.com |
| EmbeddedOS Foundation | foundation@embeddedos.org |
| Grant Partnerships | saferapp3@gmail.com |

---

## Grant Opportunities

The following grant programs are aligned with Safer's mission:

| Grant Program | Organization | Fit |
|---|---|---|
| Violence Against Women Act (VAWA) Grants | U.S. Department of Justice | High |
| Safety and Justice Challenge | MacArthur Foundation | High |
| Women's Safety & Empowerment Fund | Various Foundations | High |
| Tech for Social Good | Google.org / Microsoft Philanthropies | Medium-High |
| Campus Safety Innovation Grants | U.S. Department of Education | Medium-High |
| Open Source Foundation Grants | Mozilla / Linux Foundation | Medium |

**To apply for grants:** Contact saferapp3@gmail.com with subject "Grant Partnership Inquiry — Safer Women"

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
| Payments | Zeffy (iframe embed) |
| Deployment | Netlify / Vercel / cPanel |

---

## EmbeddedOS Foundation

The Safer app is developed by **EmbeddedOS (EoS) Research Foundation** — a 501(c)(3) nonprofit.

- Website: https://www.embeddedos.org/
- EIN: 41-4821627
- GitHub: https://github.com/embeddedos-org
- Safer is listed on: https://www.embeddedos.org/eapps

All donations to Safer go through EmbeddedOS Foundation and are fully tax-deductible.

---

*Last updated: July 2025 · mysaferapp.com Production Guide*
