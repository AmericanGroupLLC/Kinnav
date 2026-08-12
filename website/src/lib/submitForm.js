import { DEFAULT_FORM, FORM_ENDPOINT, FORM_PREFIXES, SITE_EMAIL } from '../config'

// Posts a form to the PHP handler, which emails SITE_EMAIL.
//
// `form` is which form this is ('contact' | 'waitlist'); both share one inbox,
// so it becomes a subject prefix here and an X-Kinnav-Form header server-side.
//
// Returns 'sent'   — the server accepted it and the mail is on its way.
//         'mailto' — no working endpoint (no PHP, offline, 404); the visitor's
//                    mail client was opened with the message pre-filled and
//                    they still have to press send.
//
// The distinction matters because the confirmation copy must not claim we
// received something we did not.
export async function submitForm({ form = DEFAULT_FORM, subject, fields, message, honeypot = '' }) {
  const kind = formKind(form)
  const tagged = tagSubject(subject, kind)
  const body = formatBody(fields, message)

  try {
    const res = await fetch(FORM_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      // The named keys go last so a field can never overwrite one of them.
      body: JSON.stringify({ ...fields, subject: tagged, body, form: kind, website: honeypot }),
    })
    // A missing handler returns the SPA's index.html with a 200, so check the
    // payload rather than trusting the status code.
    const data = await res.json()
    if (res.ok && data?.ok) return 'sent'
  } catch {
    // network error, no PHP, HTML response — fall through to mailto
  }

  openMailto(tagged, body)
  return 'mailto'
}

export function mailtoLink(subject, form = DEFAULT_FORM) {
  return `mailto:${SITE_EMAIL}?subject=${encodeURIComponent(tagSubject(subject, form))}`
}

// Prefixes a subject with the form's tag, unless it already carries it — so
// tagging twice (client then server) cannot produce "[Contact] [Contact] …".
export function tagSubject(subject, form = DEFAULT_FORM) {
  const prefix = FORM_PREFIXES[formKind(form)]
  const text = String(subject ?? '').trim()
  return text.startsWith(prefix) ? text : `${prefix} ${text}`.trim()
}

function formKind(form) {
  return Object.hasOwn(FORM_PREFIXES, form) ? form : DEFAULT_FORM
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
