import { FORM_ENDPOINT, SITE_EMAIL } from '../config'

// Posts a form to the PHP handler, which emails SITE_EMAIL.
//
// Returns 'sent'   — the server accepted it and the mail is on its way.
//         'mailto' — no working endpoint (no PHP, offline, 404); the visitor's
//                    mail client was opened with the message pre-filled and
//                    they still have to press send.
//
// The distinction matters because the confirmation copy must not claim we
// received something we did not.
export async function submitForm({ subject, fields, message, honeypot = '' }) {
  const body = formatBody(fields, message)

  try {
    const res = await fetch(FORM_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ subject, body, ...fields, website: honeypot }),
    })
    // A missing handler returns the SPA's index.html with a 200, so check the
    // payload rather than trusting the status code.
    const data = await res.json()
    if (res.ok && data?.ok) return 'sent'
  } catch {
    // network error, no PHP, HTML response — fall through to mailto
  }

  openMailto(subject, body)
  return 'mailto'
}

export function mailtoLink(subject) {
  return `mailto:${SITE_EMAIL}?subject=${encodeURIComponent(subject)}`
}

function openMailto(subject, body) {
  window.location.href =
    `mailto:${SITE_EMAIL}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`
}

function formatBody(fields, message) {
  const lines = Object.entries(fields)
    .filter(([key]) => key !== 'message')
    .map(([key, value]) => `${labelFor(key)}: ${value}`)
  return `${lines.join('\n')}\n\nMessage:\n${message || '(none)'}\n\n[Sent from kinnav.com]`
}

function labelFor(key) {
  return key.charAt(0).toUpperCase() + key.slice(1)
}
