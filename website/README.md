# Kinnav — Marketing Website

**Domain:** [kinnav.com](https://kinnav.com)

This is the official marketing website for the **Kinnav** women's safety, empowerment, and rewards app.

## Tech Stack

- **React 19** + **Vite 8**
- **Tailwind CSS v4** (via `@tailwindcss/vite`)
- **Framer Motion** — animations
- **React Router DOM** — client-side routing
- **Lucide React** — icons

## Pages

| Route | Description |
|---|---|
| `/` | Home — hero, features, how it works, competitive advantage, app screenshots, early-access CTA |
| `/how-it-works` | Full app walkthrough — safe call flow, guardian program, empowerment modules, rewards |
| `/waitlist` | Early access — waitlist signup, pitch deck request |
| `/about` | About — mission, team, values, community roles, contact |
| `/privacy` | Privacy Policy |
| `/terms` | Terms of Service |
| `/contact` | Contact — general, guardian, partnership, investor, press |

## Development

```bash
pnpm install
pnpm dev        # Start dev server
pnpm build      # Production build
pnpm preview    # Preview production build
pnpm package    # Build + zip dist/ into kinnav-site.zip for cPanel upload
```

## Deployment

Hosted on HostGator cPanel. Upload the **contents of `dist/`** (including the hidden
`.htaccess`) to `/home2/safecode/kinnav.com/` — see [`DEPLOY.md`](DEPLOY.md) for the
full procedure, SSL, and DNS notes.

## About

Kinnav is developed by **American Group LLC**, a private company. Kinnav is not a
nonprofit and does not solicit charitable donations.

Contact: [saferapp3@gmail.com](mailto:saferapp3@gmail.com)
