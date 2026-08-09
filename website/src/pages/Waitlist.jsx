import { useState } from 'react'
import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { ArrowRight, Send, RefreshCw } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

// Where waitlist signups are sent. Same inbox the contact form uses.
const WAITLIST_EMAIL = 'saferapp3@gmail.com'

const ROLE_LABELS = {
  user: 'App User',
  guardian: 'Guardian',
  partner: 'Partner / NGO',
  investor: 'Investor',
}

// Waitlist form component
//
// Submissions are sent by email: the form composes a mailto: link and hands it
// to the visitor's mail client. There is no server, so nothing is stored on our
// side — the signup only reaches us once the visitor actually presses send in
// their mail app. The confirmation copy below says exactly that rather than
// claiming the signup is already recorded, because we cannot know that it is.
function WaitlistForm() {
  const [form, setForm] = useState({ name: '', email: '', role: 'user', message: '' })
  const [status, setStatus] = useState('idle') // idle | submitting | sent

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!form.email || !form.name) return
    setStatus('submitting')
    const roleLabel = ROLE_LABELS[form.role] || form.role
    const subject = encodeURIComponent(`Kinnav waitlist — ${form.name} (${roleLabel})`)
    const body = encodeURIComponent(
      `Name: ${form.name}\n` +
      `Email: ${form.email}\n` +
      `Joining as: ${roleLabel}\n\n` +
      `Message:\n${form.message || '(none)'}\n\n` +
      `[Sent from the kinnav.com waitlist form]`
    )
    window.location.href = `mailto:${WAITLIST_EMAIL}?subject=${subject}&body=${body}`
    setTimeout(() => setStatus('sent'), 500)
  }

  if (status === 'sent') {
    const mailtoFallback = `mailto:${WAITLIST_EMAIL}?subject=${encodeURIComponent('Kinnav waitlist')}`
    return (
      <div style={{ textAlign: 'center', padding: '3rem 2rem' }}>
        <div style={{ fontSize: 48, marginBottom: 16 }}>💜</div>
        <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>Almost there — press send</h3>
        <p style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7 }}>
          Your email app should have opened with your details already filled in.
          <strong> Send that email and you're on the list.</strong>
        </p>
        <p style={{ color: '#9B7AB0', fontSize: 14, lineHeight: 1.7, marginTop: 14 }}>
          Nothing opened? Email us directly at{' '}
          <a href={mailtoFallback} style={{ color: '#9B59D0', fontWeight: 600 }}>{WAITLIST_EMAIL}</a>.
        </p>
        <button
          onClick={() => setStatus('idle')}
          style={{ marginTop: 20, color: '#9B59D0', background: 'none', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: 15 }}
        >
          ← Back to the form
        </button>
      </div>
    )
  }

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
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
              border: '1.5px solid #EDE3F6', fontSize: 15, outline: 'none',
              background: '#FAFAFA', color: '#1a1a2e',
              transition: 'border-color 0.2s',
            }}
            onFocus={e => e.target.style.borderColor = '#9B59D0'}
            onBlur={e => e.target.style.borderColor = '#EDE3F6'}
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
              border: '1.5px solid #EDE3F6', fontSize: 15, outline: 'none',
              background: '#FAFAFA', color: '#1a1a2e',
              transition: 'border-color 0.2s',
            }}
            onFocus={e => e.target.style.borderColor = '#9B59D0'}
            onBlur={e => e.target.style.borderColor = '#EDE3F6'}
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
                background: form.role === opt.value ? 'linear-gradient(135deg, #B57BE0, #9B59D0)' : '#F9F5FF',
                color: form.role === opt.value ? '#fff' : '#6B7280',
                border: form.role === opt.value ? 'none' : '1.5px solid #EDE3F6',
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
            border: '1.5px solid #EDE3F6', fontSize: 15, outline: 'none',
            background: '#FAFAFA', color: '#1a1a2e', resize: 'vertical',
            fontFamily: 'inherit', transition: 'border-color 0.2s',
          }}
          onFocus={e => e.target.style.borderColor = '#9B59D0'}
          onBlur={e => e.target.style.borderColor = '#EDE3F6'}
        />
      </div>
      <button
        type="submit"
        disabled={status === 'submitting'}
        style={{
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          padding: '14px 32px', borderRadius: 50,
          background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
          color: '#fff', fontWeight: 700, fontSize: 16,
          border: 'none', cursor: status === 'submitting' ? 'not-allowed' : 'pointer',
          boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
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
        background: 'linear-gradient(135deg, #1a0533 0%, #3d1278 50%, #6A1B9A 100%)',
        padding: '5rem 1.5rem',
        textAlign: 'center',
        position: 'relative',
        overflow: 'hidden',
      }}>
        <div style={{ position: 'relative', zIndex: 1, maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(181,123,224,0.2)', color: '#D8C4F0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>
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
      <section id="waitlist" style={{ padding: '6rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.div variants={fadeUp} style={{ textAlign: 'center', marginBottom: '3rem' }}>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>Join the Waitlist</h2>
              <p style={{ fontSize: 17, color: '#6B7280', lineHeight: 1.7 }}>
                Whether you're a future user, guardian, partner, or investor — we want to hear from you.
              </p>
            </motion.div>
            <motion.div variants={fadeUp} style={{ background: '#fff', borderRadius: 24, padding: '2.5rem', boxShadow: '0 8px 40px rgba(155,89,208,0.12)', border: '1px solid rgba(155,89,208,0.1)' }}>
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
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none', boxShadow: '0 8px 30px rgba(155,89,208,0.4)' }}>
                Request Pitch Deck <ArrowRight size={18} />
              </Link>
              <Link to="/contact"
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, border: '2px solid #9B59D0', color: '#9B59D0', fontWeight: 700, fontSize: 16, textDecoration: 'none' }}>
                Partner With Us
              </Link>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
