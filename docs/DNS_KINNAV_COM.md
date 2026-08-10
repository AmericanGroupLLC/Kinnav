# DNS Setup — kinnav.com → GitHub Pages

How to point **kinnav.com** (registered at HostGator) at the Kinnav website,
which is built and deployed to **GitHub Pages** by
`.github/workflows/deploy-website.yml`.

Source for the GitHub IP addresses below: GitHub Pages documentation,
["Managing a custom domain for your GitHub Pages site"](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site),
fetched 2026-08-08. Re-check before relying on them — GitHub has changed these
before.

---

## Current state (verified 2026-08-10)

| Thing | State |
|---|---|
| Registry status | `client transfer prohibited` only — the earlier `client hold` is lifted |
| Nameservers | `HGNS1/HGNS2.HOSTGATOR.COM` — correct, delegated |
| Apex `A` | `208.91.197.15` (HostGator parking) — **wrong, delete** |
| `www` | `A` → `208.91.197.15` — **wrong, delete and replace with CNAME** |
| GitHub `A` records | **absent** — must be re-added |
| Site status | serves HostGator's "Page cannot be displayed" error |

The Kinnav build is deployed and verified on GitHub's servers; only these DNS
records stand between it and a working `https://kinnav.com`.

---

## Step 0 — Nameservers: already correct, no action needed

The domain's nameservers are already HostGator's defaults:

| | Value |
|---|---|
| Nameserver 1 | `HGNS1.HOSTGATOR.COM` |
| Nameserver 2 | `HGNS2.HOSTGATOR.COM` |

**Do not change these.** Because they point at HostGator, **HostGator holds the
authoritative DNS zone** for kinnav.com. Every record below is therefore added
in HostGator — under the **DNS** tab next to Nameservers (or cPanel → *Zone
Editor*), not at GitHub and not at any other registrar.

---

## Step 1 — Records to add in HostGator's DNS tab

### Apex domain (`kinnav.com`) — four A records

Host/Name `@` (some HostGator screens want the bare domain `kinnav.com`), type
**A**, TTL default:

```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

All four. They are GitHub's redundant edge servers, not alternatives to choose
between.

### `www.kinnav.com` — one CNAME record

| Field | Value |
|---|---|
| Type | `CNAME` |
| Host / Name | `www` |
| Points to | `americangroupllc.github.io` |

The target is the **organization** Pages host (`AmericanGroupLLC` owns the
repo) — note the trailing `.github.io`, and no repository name. With apex and
`www` both configured, GitHub creates redirects between them automatically.

### Optional — IPv6 (four AAAA records on `@`)

```
2606:50c0:8000::153
2606:50c0:8001::153
2606:50c0:8002::153
2606:50c0:8003::153
```

Not required; add them if you want IPv6 visitors served directly.

---

## Step 2 — Two records you must delete or the site will not load

Verified present in the zone on 2026-08-10, both pointing at HostGator's
parking/error page. These are the cause of a "HostGator page instead of my
site" report:

1. **`A` on `@` → `208.91.197.15`.** If you add GitHub's four and leave this
   one, DNS round-robins across all five and roughly one visitor in five lands
   on HostGator's page. Delete it.
2. **`A` on `www` → `208.91.197.15`.** Delete it, then add the `www` CNAME
   from Step 1 in its place — a host cannot have both an `A` and a `CNAME`.

### Nothing else needs protecting right now

Checked 2026-08-10: the zone has **no `MX`, `TXT`, `AAAA` or `CAA` records**,
so there is no mail routing or domain verification to preserve. If you later
set up email on this domain (HostGator Email & Office, Google Workspace), its
`MX` and SPF/DKIM/DMARC `TXT` records are independent of the website — do not
remove them when touching the records above.

### If the records disappear again

The four GitHub `A` records and the `www` CNAME were entered once and were
later gone from the zone, replaced by the parking records above. The likely
cause is HostGator re-provisioning the zone with hosting defaults when the
domain went active. If it happens a second time, ask HostGator support
whether a hosting or parking product is attached to kinnav.com and resetting
its DNS — re-entering the records will not stick until that is disabled.

---

## Step 3 — GitHub side

1. Repo → **Settings** → **Pages**.
2. **Custom domain** → enter `kinnav.com` → **Save**. GitHub runs a DNS check;
   it will fail until Step 1 propagates, which is expected.
3. Once the check passes, tick **Enforce HTTPS**. GitHub provisions a
   Let's Encrypt certificate automatically — this can take up to ~24 hours and
   the checkbox stays greyed out until the certificate is issued.

The repo already contains `website/public/CNAME` holding `kinnav.com`. Vite
copies everything in `public/` to the build root, so the deployed site ships
`dist/CNAME` and GitHub keeps the custom domain across deploys. **Do not delete
that file** — without it, each deployment resets the custom-domain setting.

---

## Step 4 — Verify

DNS propagation is typically minutes to a few hours; allow up to 48 hours
before treating it as broken.

```bash
# Should return exactly the four GitHub IPs and nothing else
dig +short kinnav.com A

# Should chain to americangroupllc.github.io
dig +short www.kinnav.com CNAME

# Should be 200 and served by GitHub
curl -sSI https://kinnav.com | head -20
```

Confirm the certificate covers the domain, then load `https://kinnav.com` and
click through to `/how-it-works`, `/about`, `/contact`, `/privacy`, `/terms`
and `/grant-funding` — deep links exercise the SPA fallback in
`website/public/404.html`, which is the part most likely to break on a host
change.

---

## Note on the alternative — hosting on HostGator instead

Not the configured path, recorded only so the choice is not re-litigated.
Serving from HostGator shared hosting would mean: build locally or in CI, upload
`website/dist/` to `public_html` over FTP/SFTP, and add an `.htaccess` SPA
rewrite so client-side routes resolve to `index.html`. That trades GitHub's
automatic HTTPS and push-to-deploy for a manual upload step. If you switch,
`.github/workflows/deploy-website.yml` and `website/public/CNAME` both need
revisiting.
