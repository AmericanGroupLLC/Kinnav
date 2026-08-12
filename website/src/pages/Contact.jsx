import { useState } from 'react'
import { motion } from 'framer-motion'
import { Send, RefreshCw, MessageSquare, Shield, Users, Briefcase, Newspaper } from 'lucide-react'
import { SITE_EMAIL } from '../config'
import { submitForm, mailtoLink } from '../lib/submitForm'
import Honeypot from '../components/Honeypot'

const fadeUp = { hidden: { opacity: 0, y: 40 }, visible: { opacity: 1, y: 0, transition: { duration: 0.6 } } }
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

// Every topic lands in the same inbox (SITE_EMAIL); the subject line is what
// tells them apart, so it can be filtered in webmail. submitForm() prefixes
// all of them with [Contact], which separates them from waitlist signups.
const contactTypes = [
  { value: 'general', label: '💬 General Inquiry', subject: 'General Inquiry — Kinnav' },
  { value: 'support', label: '🛠️ App Support', subject: 'App Support — Kinnav' },
  { value: 'guardian', label: '🛡️ Become a Guardian', subject: 'Guardian Application — Kinnav' },
  { value: 'partner', label: '🤝 Partnership / NGO', subject: 'Partnership Inquiry — Kinnav' },
  { value: 'investor', label: '💼 Investor Relations', subject: 'Investor Inquiry — Kinnav' },
  { value: 'press', label: '📰 Press / Media', subject: 'Press Inquiry — Kinnav' },
]

function ContactForm() {
  const [form, setForm] = useState({ name: '', email: '', type: 'general', message: '' })
  const [honeypot, setHoneypot] = useState('')
  const [status, setStatus] = useState('idle') // idle | submitting | sent | mailto

  const selectedType = contactTypes.find(t => t.value === form.type) || contactTypes[0]

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!form.name || !form.email || !form.message) return
    setStatus('submitting')
    const result = await submitForm({
      form: 'contact',
      subject: `${selectedType.subject} — from ${form.name}`,
      fields: { name: form.name, email: form.email, type: selectedType.label },
      message: form.message,
      honeypot,
    })
    setStatus(result)
  }

  if (status === 'sent' || status === 'mailto') {
    return (
      <div style={{ textAlign: 'center', padding: '3rem 2rem' }}>
        <div style={{ fontSize: 56, marginBottom: 16 }}>💜</div>
        <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>
          {status === 'sent' ? 'Message sent!' : 'Almost there — press send'}
        </h3>
        <p style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7 }}>
          {status === 'sent' ? (
            <>Thanks — we've got it. We'll reply to <strong>{form.email}</strong> within 1–2 business days.</>
          ) : (
            <>We couldn't reach our mail server, so your email app has opened with the message ready.
              <strong> Send it and we'll pick it up.</strong></>
          )}
        </p>
        {status === 'mailto' && (
          <p style={{ color: '#A98BC4', fontSize: 14, lineHeight: 1.7, marginTop: 14 }}>
            Nothing opened? Email us directly at{' '}
            <a href={mailtoLink(selectedType.subject, 'contact')} style={{ color: '#BF6EEE', fontWeight: 600 }}>{SITE_EMAIL}</a>.
          </p>
        )}
        <button onClick={() => setStatus('idle')} style={{ marginTop: 20, color: '#BF6EEE', background: 'none', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: 15 }}>Send another →</button>
      </div>
    )
  }

  const inputStyle = {
    width: '100%', padding: '12px 16px', borderRadius: 12,
    border: '1.5px solid #EFE0FB', fontSize: 15, outline: 'none',
    background: '#FAFAFA', color: '#1a1a2e', fontFamily: 'inherit',
    transition: 'border-color 0.2s',
  }

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 20, position: 'relative' }}>
      <Honeypot value={honeypot} onChange={setHoneypot} />
      <div>
        <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 8 }}>What can we help you with?</label>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: 8 }}>
          {contactTypes.map(ct => (
            <button key={ct.value} type="button" onClick={() => setForm({ ...form, type: ct.value })}
              style={{
                padding: '10px 14px', borderRadius: 10, fontSize: 13, fontWeight: 600,
                cursor: 'pointer', textAlign: 'left', transition: 'all 0.2s',
                background: form.type === ct.value ? 'linear-gradient(135deg, #D4A5F5, #BF6EEE)' : '#FAF5FF',
                color: form.type === ct.value ? '#fff' : '#6B7280',
                border: form.type === ct.value ? 'none' : '1.5px solid #EFE0FB',
              }}>
              {ct.label}
            </button>
          ))}
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }} className="form-grid">
        <div>
          <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 6 }}>Full Name *</label>
          <input type="text" required value={form.name} onChange={e => setForm({ ...form, name: e.target.value })}
            placeholder="Your name" style={inputStyle}
            onFocus={e => e.target.style.borderColor = '#BF6EEE'} onBlur={e => e.target.style.borderColor = '#EFE0FB'} />
        </div>
        <div>
          <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 6 }}>Email Address *</label>
          <input type="email" required value={form.email} onChange={e => setForm({ ...form, email: e.target.value })}
            placeholder="you@example.com" style={inputStyle}
            onFocus={e => e.target.style.borderColor = '#BF6EEE'} onBlur={e => e.target.style.borderColor = '#EFE0FB'} />
        </div>
      </div>

      <div>
        <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 6 }}>Message *</label>
        <textarea required value={form.message} onChange={e => setForm({ ...form, message: e.target.value })}
          placeholder="Tell us how we can help..."
          rows={5} style={{ ...inputStyle, resize: 'vertical' }}
          onFocus={e => e.target.style.borderColor = '#BF6EEE'} onBlur={e => e.target.style.borderColor = '#EFE0FB'} />
      </div>

      <button type="submit" disabled={status === 'submitting'}
        style={{
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          padding: '14px 32px', borderRadius: 50,
          background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)',
          color: '#fff', fontWeight: 700, fontSize: 16,
          border: 'none', cursor: 'pointer',
          boxShadow: '0 8px 30px rgba(191,110,238,0.4)',
          opacity: status === 'submitting' ? 0.7 : 1,
        }}>
        {status === 'submitting' ? <><RefreshCw size={18} style={{ animation: 'spin 1s linear infinite' }} /> Sending...</> : <><Send size={18} /> Send Message</>}
      </button>
      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } } @media (max-width: 600px) { .form-grid { grid-template-columns: 1fr !important; } }`}</style>
    </form>
  )
}

export default function Contact() {
  const contactCards = [
    { icon: <MessageSquare size={24} />, title: 'General & App Support', desc: 'Technical issues, account help, feedback, and general questions.', color: '#BF6EEE' },
    { icon: <Users size={24} />, title: 'Become a Guardian', desc: 'Join our vetted guardian network and help protect women in your community.', color: '#9A4FD8' },
    { icon: <Briefcase size={24} />, title: 'Partnerships & NGOs', desc: 'Collaborate with Kinnav to expand our reach and impact.', color: '#D4A5F5' },
    { icon: <Shield size={24} />, title: 'Investor Relations', desc: 'Investment enquiries, pitch deck requests, and commercial partnerships.', color: '#7B2FB8' },
    { icon: <Newspaper size={24} />, title: 'Press & Media', desc: 'Media inquiries, press kits, and interview requests.', color: '#FD62D8' },

  ]

  return (
    <div style={{ paddingTop: 72 }}>
      <section style={{ background: 'linear-gradient(135deg, #1E0838 0%, #4A1690 50%, #7B2FB8 100%)', padding: '5rem 1.5rem', textAlign: 'center' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(212,165,245,0.2)', color: '#E3CCFA', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>Contact</motion.div>
            <motion.h1 variants={fadeUp} style={{ fontSize: 'clamp(2rem, 4vw, 3.5rem)', fontWeight: 900, color: '#fff', lineHeight: 1.15, marginBottom: 20 }}>Get in Touch</motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7 }}>
              Whether you're a future user, guardian, partner, investor, or press — we'd love to hear from you.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Contact topic cards */}
      <section style={{ padding: '5rem 1.5rem', background: '#FAF5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <h2 style={{ fontSize: 'clamp(1.6rem, 3vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 12 }}>How can we help?</h2>
            <p style={{ color: '#6B7280', fontSize: 16 }}>Use the form below to reach the right team for your inquiry.</p>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.25rem', marginBottom: '4rem' }}>
            {contactCards.map((card, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.08 }}
                style={{ background: '#fff', borderRadius: 18, padding: '1.75rem', border: '1px solid rgba(191,110,238,0.1)', boxShadow: '0 4px 20px rgba(191,110,238,0.06)' }}>
                <div style={{ width: 48, height: 48, borderRadius: 12, background: `${card.color}15`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: card.color, marginBottom: 14 }}>
                  {card.icon}
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 8 }}>{card.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.7 }}>{card.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Contact form */}
      <section style={{ padding: '0 1.5rem 6rem', background: '#FAF5FF' }}>
        <div style={{ maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
            style={{ background: '#fff', borderRadius: 24, padding: '2.5rem', boxShadow: '0 8px 40px rgba(191,110,238,0.1)', border: '1px solid rgba(191,110,238,0.1)' }}>
            <h2 style={{ fontWeight: 900, fontSize: 24, color: '#1a1a2e', marginBottom: 8 }}>Send us a message</h2>
            <p style={{ color: '#6B7280', fontSize: 15, marginBottom: 28 }}>
              We typically respond within 1–2 business days. Prefer your own mail client?
              Write to{' '}
              <a href={`mailto:${SITE_EMAIL}`} style={{ color: '#BF6EEE', fontWeight: 600 }}>{SITE_EMAIL}</a>.
            </p>
            <ContactForm />
          </motion.div>
        </div>
      </section>
    </div>
  )
}
