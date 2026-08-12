// Single source of truth for where site enquiries go.
//
// Every form (contact + waitlist) and every published address points here, so
// changing the inbox is a one-line edit. The mailbox lives on the cPanel
// account that also hosts kinnav.com, which is why /api/contact.php can send
// to it locally without SMTP credentials.
export const SITE_EMAIL = 'support@kinnav.com'

// Server-side handler that emails SITE_EMAIL. Relative so it works on any
// host. If it is missing (e.g. a static preview with no PHP) the forms fall
// back to a mailto: link.
export const FORM_ENDPOINT = '/api/contact.php'

// One inbox, two forms — so every message says which form it came from:
//
//   subject prefix   `[Contact] …` / `[Waitlist] …`  — visible in any client,
//                    and it survives the mailto: fallback, which cannot set
//                    headers.
//   X-Kinnav-Form    added by /api/contact.php from this same key.
//
// A cPanel → Email Filter can sort on either one, e.g.
//   "Subject" "begins with" "[Waitlist]"  → Deliver to folder  Waitlist
//
// The keys are the wire values; the handler has the same whitelist and falls
// back to `contact` for anything it does not recognise.
export const FORM_PREFIXES = {
  contact: '[Contact]',
  waitlist: '[Waitlist]',
}

export const DEFAULT_FORM = 'contact'
