import { useState } from 'react'
import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, Send, RefreshCw } from 'lucide-react'
import { SITE_EMAIL } from '../config'
import { submitForm, mailtoLink } from '../lib/submitForm'
import Honeypot from '../components/Honeypot'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const ROLE_LABELS = {
  user: 'App User',
  guardian: 'Guardian',
  partner: 'Partner / NGO',
  investor: 'Investor',
}

// Waitlist form component
//
// Signups are emailed to SITE_EMAIL by /api/contact.php — the same inbox the
// contact form uses, which is why they are tagged [Waitlist] and carry an
// X-Kinnav-Form header, so webmail can file them separately.
//
// If that handler is
// unreachable the form falls back to opening the visitor's mail client, in
// which case the signup only reaches us once they actually press send — the
// confirmation copy below states which of the two happened rather than
// claiming a signup we may not have received.
function WaitlistForm() {
  const [form, setForm] = useState({ name: '', email: '', role: 'user', message: '' })
  const [honeypot, setHoneypot] = useState('')
  const [status, setStatus] = useState('idle') // idle | submitting | sent | mailto

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!form.email || !form.name) return
    setStatus('submitting')
    const roleLabel = ROLE_LABELS[form.role] || form.role
    const result = await submitForm({
      form: 'waitlist',
      subject: `Kinnav waitlist — ${form.name} (${roleLabel})`,
      fields: { name: form.name, email: form.email, 'joining as': roleLabel },
      message: form.message,
      honeypot,
    })
    setStatus(result)
  }

  if (status === 'sent' || status === 'mailto') {
    return (
      <div style={{ textAlign: 'center', padding: '3rem 2rem' }}>
        <div style={{ fontSize: 48, marginBottom: 16 }}>💜</div>
        <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>
          {status === 'sent' ? "You're on the list" : 'Almost there — press send'}
        </h3>
        <p style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7 }}>
          {status === 'sent' ? (
            <>Thanks for joining. We'll email <strong>{form.email}</strong> the moment the full app is ready.</>
          ) : (
            <>Your email app should have opened with your details already filled in.
              <strong> Send that email and you're on the list.</strong></>
          )}
        </p>
        {status === 'mailto' && (
          <p style={{ color: '#A98BC4', fontSize: 14, lineHeight: 1.7, marginTop: 14 }}>
            Nothing opened? Email us directly at{' '}
            <a href={mailtoLink('Kinnav waitlist', 'waitlist')} style={{ color: '#BF6EEE', fontWeight: 600 }}>{SITE_EMAIL}</a>.
          </p>
        )}
        <button
          onClick={() => setStatus('idle')}
          style={{ marginTop: 20, color: '#BF6EEE', background: 'none', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: 15 }}
        >
          ← Back to the form
        </button>
      </div>
    )
  }

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 16, position: 'relative' }}>
      <Honeypot value={honeypot} onChange={setHoneypot} />
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }} className="form-grid">
        <div>
          <label style={{ display: 'block', fontSize: 13, fontWeight: 600, color: '#374151', marginBottom: 6 }}>Full Name *</label>
          <input
            type="text"
            required
            value={form.name}
            onChange={e => setForm({ ...form, name: e.target.value })}
            placeholder="Your name"
            style={{
              width: '100%', padding: '10px 14px', borderRadius: 10,
              border: '1.5px solid #EFE0FB', fontSize: 15, outline: 'none',
              background: '#FAFAFA', color: '#1a1a2e',
              transition: 'border-color 0.2s',
            }}
            onFocus={e => e.target.style.borderColor = '#BF6EEE'}
            onBlur={e => e.target.style.borderColor = '#EFE0FB'}
          />
        </div>
        <div>
          <label style={{ display: 'block', fontSize: 13, fontWeight: 600, color: '#374151', marginBottom: 6 }}>Email Address *</label>
          <input
            type="email"
            required
            value={form.email}
            onChange={e => setForm({ ...form, email: e.target.value })}
            placeholder="you@example.com"
            style={{
              width: '100%', padding: '10px 14px', borderRadius: 10,
              border: '1.5px solid #EFE0FB', fontSize: 15, outline: 'none',
              background: '#FAFAFA', color: '#1a1a2e',
              transition: 'border-color 0.2s',
            }}
            onFocus={e => e.target.style.borderColor = '#BF6EEE'}
            onBlur={e => e.target.style.borderColor = '#EFE0FB'}
          />
        </div>
      </div>
      <div>
        <label style={{ display: 'block', fontSize: 13, fontWeight: 600, color: '#374151', marginBottom: 6 }}>I want to join as</label>
        <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
          {[
            { value: 'user', label: '👩 App User' },
            { value: 'guardian', label: '🛡️ Guardian' },
            { value: 'partner', label: '🤝 Partner / NGO' },
            { value: 'investor', label: '💼 Investor' },
          ].map(opt => (
            <button
              key={opt.value}
              type="button"
              onClick={() => setForm({ ...form, role: opt.value })}
              style={{
                padding: '8px 16px', borderRadius: 50, fontSize: 14, fontWeight: 600,
                cursor: 'pointer', transition: 'all 0.2s',
                background: form.role === opt.value ? 'linear-gradient(135deg, #D4A5F5, #BF6EEE)' : '#FAF5FF',
                color: form.role === opt.value ? '#fff' : '#6B7280',
                border: form.role === opt.value ? 'none' : '1.5px solid #EFE0FB',
              }}
            >
              {opt.label}
            </button>
          ))}
        </div>
      </div>
      <div>
        <label style={{ display: 'block', fontSize: 13, fontWeight: 600, color: '#374151', marginBottom: 6 }}>Message (optional)</label>
        <textarea
          value={form.message}
          onChange={e => setForm({ ...form, message: e.target.value })}
          placeholder="Tell us about yourself or how you'd like to get involved..."
          rows={3}
          style={{
            width: '100%', padding: '10px 14px', borderRadius: 10,
            border: '1.5px solid #EFE0FB', fontSize: 15, outline: 'none',
            background: '#FAFAFA', color: '#1a1a2e', resize: 'vertical',
            fontFamily: 'inherit', transition: 'border-color 0.2s',
          }}
          onFocus={e => e.target.style.borderColor = '#BF6EEE'}
          onBlur={e => e.target.style.borderColor = '#EFE0FB'}
        />
      </div>
      <button
        type="submit"
        disabled={status === 'submitting'}
        style={{
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          padding: '14px 32px', borderRadius: 50,
          background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)',
          color: '#fff', fontWeight: 700, fontSize: 16,
          border: 'none', cursor: status === 'submitting' ? 'not-allowed' : 'pointer',
          boxShadow: '0 8px 30px rgba(191,110,238,0.4)',
          opacity: status === 'submitting' ? 0.7 : 1,
          transition: 'all 0.2s',
        }}
      >
        {status === 'submitting' ? (
          <><RefreshCw size={18} style={{ animation: 'spin 1s linear infinite' }} /> Joining...</>
        ) : (
          <><Send size={18} /> Join the Waitlist</>
        )}
      </button>
      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </form>
  )
}

export default function Waitlist() {
  return (
    <div style={{ paddingTop: 72 }}>
      {/* Hero */}
      <section style={{
        background: 'linear-gradient(135deg, #1E0838 0%, #4A1690 50%, #7B2FB8 100%)',
        padding: '5rem 1.5rem',
        textAlign: 'center',
        position: 'relative',
        overflow: 'hidden',
      }}>
        <div style={{ position: 'relative', zIndex: 1, maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(212,165,245,0.2)', color: '#E3CCFA', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>
              Early Access
            </motion.div>
            <motion.h1 variants={fadeUp} style={{ fontSize: 'clamp(2rem, 4vw, 3.5rem)', fontWeight: 900, color: '#fff', lineHeight: 1.15, marginBottom: 20 }}>
              Be first to use Kinnav
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7 }}>
              The Kinnav prototype is complete. Join the waitlist and we'll let you know the moment the full app is ready.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Waitlist / Early Access */}
      <section id="waitlist" style={{ padding: '6rem 1.5rem', background: '#FAF5FF' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.div variants={fadeUp} style={{ textAlign: 'center', marginBottom: '3rem' }}>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>Join the Waitlist</h2>
              <p style={{ fontSize: 17, color: '#6B7280', lineHeight: 1.7 }}>
                Whether you're a future user, guardian, partner, or investor — we want to hear from you.
              </p>
            </motion.div>
            <motion.div variants={fadeUp} style={{ background: '#fff', borderRadius: 24, padding: '2.5rem', boxShadow: '0 8px 40px rgba(191,110,238,0.12)', border: '1px solid rgba(191,110,238,0.1)' }}>
              <WaitlistForm />
            </motion.div>
          </motion.div>
        </div>
        <style>{`@media (max-width: 768px) { .form-grid { grid-template-columns: 1fr !important; } }`}</style>
      </section>

      {/* Pitch Deck CTA */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 800, margin: '0 auto', textAlign: 'center' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>Want the full pitch deck?</motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 40 }}>
              We have a comprehensive pitch deck covering the market opportunity, competitive landscape, business model, team, and funding ask. Contact us to request it.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
              <Link to="/contact"
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)', color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none', boxShadow: '0 8px 30px rgba(191,110,238,0.4)' }}>
                Request Pitch Deck <ArrowRight size={18} />
              </Link>
              <Link to="/contact"
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, border: '2px solid #BF6EEE', color: '#BF6EEE', fontWeight: 700, fontSize: 16, textDecoration: 'none' }}>
                Partner With Us
              </Link>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
