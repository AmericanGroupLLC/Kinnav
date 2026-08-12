# Deploying kinnav.com

The site is a **Vite + React SPA**. `website/` is source and cannot be uploaded
as-is: its `index.html` loads `/src/main.jsx`, which only a dev server resolves.
Only the compiled output in `dist/` can be served.

You build it locally and publish it to the `deploy` branch, which cPanel checks
out. HostGator never runs Node:

```
master (source)
  └─ website/
        │  cd website && pnpm deploy
        │  lint → test → build → write .cpanel.yml
        ▼
  deploy branch  ← built site only, plus .cpanel.yml
        │  cPanel: Update from Remote → Deploy HEAD Commit
        ▼
  /home2/safecode/kinnav.com/  →  https://kinnav.com
```

`dist/` is **not** committed to `master`. The `deploy` branch is an orphan branch
rewritten wholesale on every publish — never commit to it by hand.

GitHub Actions runs the tests on every push but does **not** publish. There is a
manual fallback workflow (Actions → *Build and publish website (manual
fallback)* → Run workflow) for when you cannot build locally; it is manual so
that two publishers can never force-push the same branch.

## Publishing

```bash
cd website
pnpm deploy              # lint, test, build, push to the deploy branch
pnpm deploy --no-test    # skip the suite (not recommended)
```

The script refuses to run with uncommitted changes in `website/`, so the deploy
commit always names a source commit that exists. It also checks the build before
pushing: `index.html`, `.htaccess`, `.cpanel.yml`, `api/contact.php` and
`api/.htaccess` must be present, and it aborts if any source map or `.env` file
would be published.

## One-time cPanel setup

**Git Version Control → Create**

| Field | Value |
|---|---|
| Clone a Repository | on |
| Clone URL | `https://github.com/AmericanGroupLLC/Kinnav.git` (public) or `git@github.com:AmericanGroupLLC/Kinnav.git` (private) |
| Repository Path | `repositories/KinnavDeploy` |
| Repository Name | `Kinnav Website` |

A private repository cannot use the HTTPS URL — cPanel has no way to supply a
password. Use SSH and add the key cPanel shows you (or `~/.ssh/id_*.pub`) to
GitHub → repo → Settings → **Deploy keys**. Read-only access is enough.

The checkout deliberately lives outside the document root so `.git` is never
web-reachable.

Then switch it to the built branch, in cPanel → Terminal:

```bash
cd ~/repositories/KinnavDeploy
git fetch origin
git checkout deploy
git branch --set-upstream-to=origin/deploy deploy
git status        # expect: up to date with 'origin/deploy', working tree clean
```

`git checkout deploy` only works once `pnpm deploy` has run at least once and the
branch exists on GitHub.

## Every deploy after that

```bash
cd website && pnpm deploy
```

Then cPanel → Git Version Control → **Kinnav Website** → Manage →
**Update from Remote**, then **Deploy HEAD Commit**.

The manifest the script writes into `deploy`:

```yaml
deployment:
  tasks:
    - export DEPLOYPATH=/home2/safecode/kinnav.com/
    - if [ "$(pwd -P)" = "$(cd $DEPLOYPATH 2>/dev/null && pwd -P)" ]; then echo 'already live'; exit 0; fi
    - /bin/rm -rf $DEPLOYPATH/assets
    - rsync -a --exclude '.git/' --exclude '.cpanel.yml' ./ $DEPLOYPATH
```

`rsync` is unqualified because it lives in `/bin/rsync` on this server, not
`/usr/bin/rsync`. The first task makes the manifest safe when the repository is
checked out directly in the document root: the checkout is already the site, so
copying it onto itself — and deleting `assets/` first — would destroy it.

`rsync` rather than `cp -a .` because the deployment task runs from the
repository root: a plain copy would publish `.git`, exposing the full history at
`https://kinnav.com/.git/`. The `.htaccess` also refuses to serve `.git` and
`.cpanel.yml` as a second line of defence. Clearing `assets` first stops old
content-hashed bundles accumulating forever.

## What gets published

```
/home2/safecode/kinnav.com/
├── .htaccess          # SPA routing, HTTPS, caching, security headers
├── index.html
├── api/
│   ├── .htaccess
│   └── contact.php    # emails support@kinnav.com
├── assets/            # content-hashed js + css
├── images/
└── favicon.svg  icons.svg  robots.txt  sitemap.xml  404.html
```

Permissions: files `644`, folders `755`.

## Verify after a deploy

```bash
curl -I http://kinnav.com          # 301 -> https
curl -I https://kinnav.com         # 200, text/html
curl -I https://kinnav.com/about   # 200 (SPA fallback, not 404)
curl -I https://www.kinnav.com     # 301 -> https://kinnav.com
curl -I https://kinnav.com/.git/config   # 403 or 404, never 200

curl -s -X POST https://kinnav.com/api/contact.php \
  -H 'Content-Type: application/json' \
  -d '{"form":"contact","name":"Test","email":"you@example.com","subject":"Test — Kinnav","body":"Hello"}'
# expect {"ok":true}, then check the support@kinnav.com inbox for "[Contact] Test — Kinnav"

curl -s -X POST https://kinnav.com/api/contact.php \
  -H 'Content-Type: application/json' \
  -d '{"form":"waitlist","name":"Test","email":"you@example.com","subject":"Signup","body":"Hello"}'
# expect {"ok":true}, then "[Waitlist] Signup" — a different subject tag proves
# the two forms are distinguishable in the shared inbox
```

Then click through `/how-it-works`, `/waitlist`, `/about`, `/privacy`, `/terms`,
`/contact` in a browser, hard-refreshing each — that is the case the SPA rewrite
exists for.

## Forms → support@kinnav.com

Both forms POST to `/api/contact.php`, which emails **support@kinnav.com** using
the server's local mail transport. No SMTP password is stored anywhere; the
IMAP/SMTP settings cPanel shows (993/995/465) are for mail clients, not for the
site — they are recorded under [Mailbox: support@kinnav.com](#mailbox-supportkinnavcom).
The address is set in `src/config.js` (`SITE_EMAIL`) and in the handler
(`INBOX`/`FROM`) — both must agree.

Requirements and behaviour:

- PHP must be enabled for the domain: cPanel → **MultiPHP Manager** → PHP 8.x.
- The SPA rewrite skips real files, so `/api/contact.php` executes.
- Protections: honeypot, CR/LF stripping so submitted values cannot inject mail
  headers, 5 submissions per IP per hour, 5000-character cap.
- `Reply-To` is the visitor, so replying from webmail reaches them.
- If PHP is missing or the mail server refuses, the form opens the visitor's mail
  client pre-filled and says so rather than claiming delivery.

HTML instead of JSON from the `curl` test above means PHP is not running for the
domain. Mail accepted but not arriving: check cPanel → **Track Delivery** and the
mailbox quota.

### Telling the two forms apart

Contact enquiries and waitlist signups share the one mailbox, so every message
is tagged twice — once where any mail client can see it, once in a header:

| Form | Subject | Header |
|---|---|---|
| Contact → *Send us a message* | `[Contact] General Inquiry — Kinnav — from …` | `X-Kinnav-Form: contact` |
| Waitlist → *Join the Waitlist* | `[Waitlist] Kinnav waitlist — … (Guardian)` | `X-Kinnav-Form: waitlist` |

The subject prefix exists because the mailto: fallback cannot set headers — a
signup that arrives from the visitor's own mail client is still tagged.

The list of forms is in **two places that must agree**: `FORM_PREFIXES` in
`src/config.js` and the const of the same name in `public/api/contact.php`. The
handler treats anything not on that whitelist as `contact` rather than
rejecting it, so an unrecognised tag mis-files a message but never loses one.

To sort them into folders — cPanel → **Email Filters** → *support@kinnav.com* →
Create a New Filter:

| Field | Value |
|---|---|
| Rules | `Subject` · `begins with` · `[Waitlist]` |
| Actions | `Deliver to folder` · `INBOX.Waitlist` |

Filtering on the header instead (`X-Kinnav-Form` · `is` · `waitlist`) is the
stricter option: a visitor can type `[Waitlist]` into a contact message, but
they cannot set a header. Create the folder first in Webmail → Roundcube →
Settings → Folders, or the filter has nowhere to deliver.

## Mailbox: support@kinnav.com

The mailbox the forms deliver to, as cPanel → **Email Accounts** → *Connect
Devices* reports it. None of this is used by the website — `contact.php` hands
mail to the local MTA and stores no credentials — it is here so the account can
be re-added to a mail client without digging through cPanel.

| | Setting |
|---|---|
| Username | `support@kinnav.com` |
| Password | the mailbox password (not stored in this repo) |
| Incoming | `kinnav.com` — IMAP `993`, POP3 `995` (SSL/TLS) |
| Outgoing | `kinnav.com` — SMTP `465` (SSL/TLS) |
| Auth | required for IMAP, POP3 and SMTP |

Use **IMAP**, not POP3: the same inbox is read from more than one device, and
POP3 pulls mail off the server.

Calendar and contacts on the same account, over SSL/TLS at `https://kinnav.com:2080`:

| | URL |
|---|---|
| CalDAV | `https://kinnav.com:2080/calendars/support@kinnav.com/calendar` |
| CardDAV | `https://kinnav.com:2080/addressbooks/support@kinnav.com/addressbook` |

cPanel also publishes non-SSL equivalents on `mail.kinnav.com:2079`. Do not use
them — they send the mailbox password in the clear.

cPanel can generate `.mobileconfig` profiles (Email Accounts → Connect Devices →
Apple device) that configure mail, calendar and contacts in one tap on
iOS/macOS. They are not committed here: a profile embeds the account details and
prompts for the password, so it belongs in a password manager, not in a public
repository.

## SSL and DNS

If HTTP works but HTTPS does not: cPanel → **SSL/TLS Status** → select
`kinnav.com` and `www.kinnav.com` → **Run AutoSSL**. It needs the A record
resolving to the HostGator IP first, and the `.htaccess` deliberately exempts
`/.well-known/` so validation is never rewritten.

- HostGator's TTL is 4 hours; propagation can take 24–48 hours.
- **Do not delete the MX, SPF, DKIM or DMARC records** — those are email, not the
  website, and removing them silently breaks mail.
- Only the `A` record for `kinnav.com` and the `www` record matter for the site.

## Other local commands

```bash
cd website
pnpm install
pnpm dev            # dev server
pnpm build          # -> dist/
pnpm preview        # serve dist/
pnpm test           # the suite pnpm deploy runs before publishing
pnpm package        # zip dist/ for a manual File Manager upload, if ever needed
```
