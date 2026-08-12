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
