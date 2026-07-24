import { useState } from 'react'
import { motion } from 'framer-motion'
import { Mail, Send, RefreshCw, MessageSquare, Shield, Users, Briefcase, Newspaper } from 'lucide-react'

const fadeUp = { hidden: { opacity: 0, y: 40 }, visible: { opacity: 1, y: 0, transition: { duration: 0.6 } } }
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const contactTypes = [
  { value: 'general', label: '💬 General Inquiry', email: 'saferapp3@gmail.com', subject: 'General Inquiry — Safer' },
  { value: 'support', label: '🛠️ App Support', email: 'saferapp3@gmail.com', subject: 'App Support — Safer' },
  { value: 'guardian', label: '🛡️ Become a Guardian', email: 'saferapp3@gmail.com', subject: 'Guardian Application — Safer' },
  { value: 'partner', label: '🤝 Partnership / NGO', email: 'saferapp3@gmail.com', subject: 'Partnership Inquiry — Safer' },
  { value: 'grant', label: '💼 Grant / Funding', email: 'foundation@embeddedos.org', subject: 'Grant Inquiry — Safer' },
  { value: 'press', label: '📰 Press / Media', email: 'saferapp3@gmail.com', subject: 'Press Inquiry — Safer' },
]

function ContactForm() {
  const [form, setForm] = useState({ name: '', email: '', type: 'general', message: '' })
  const [status, setStatus] = useState('idle')

  const selectedType = contactTypes.find(t => t.value === form.type) || contactTypes[0]

  const handleSubmit = (e) => {
    e.preventDefault()
    if (!form.name || !form.email || !form.message) return
    setStatus('submitting')
    const subject = encodeURIComponent(`${selectedType.subject} — from ${form.name}`)
    const body = encodeURIComponent(`Name: ${form.name}\nEmail: ${form.email}\nType: ${selectedType.label}\n\nMessage:\n${form.message}\n\n[Sent from mysaferapp.com contact form]`)
    window.location.href = `mailto:${selectedType.email}?subject=${subject}&body=${body}`
    setTimeout(() => setStatus('success'), 500)
  }

  if (status === 'success') {
    return (
      <div style={{ textAlign: 'center', padding: '3rem 2rem' }}>
        <div style={{ fontSize: 56, marginBottom: 16 }}>💜</div>
        <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>Message sent!</h3>
        <p style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7 }}>Your email client should have opened. We'll get back to you at <strong>{form.email}</strong> as soon as possible.</p>
        <button onClick={() => setStatus('idle')} style={{ marginTop: 20, color: '#9B59D0', background: 'none', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: 15 }}>Send another →</button>
      </div>
    )
  }

  const inputStyle = {
    width: '100%', padding: '12px 16px', borderRadius: 12,
    border: '1.5px solid #EDE3F6', fontSize: 15, outline: 'none',
    background: '#FAFAFA', color: '#1a1a2e', fontFamily: 'inherit',
    transition: 'border-color 0.2s',
  }

  return (
    <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: 20 }}>
      <div>
        <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 8 }}>What can we help you with?</label>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: 8 }}>
          {contactTypes.map(ct => (
            <button key={ct.value} type="button" onClick={() => setForm({ ...form, type: ct.value })}
              style={{
                padding: '10px 14px', borderRadius: 10, fontSize: 13, fontWeight: 600,
                cursor: 'pointer', textAlign: 'left', transition: 'all 0.2s',
                background: form.type === ct.value ? 'linear-gradient(135deg, #B57BE0, #9B59D0)' : '#F9F5FF',
                color: form.type === ct.value ? '#fff' : '#6B7280',
                border: form.type === ct.value ? 'none' : '1.5px solid #EDE3F6',
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
            onFocus={e => e.target.style.borderColor = '#9B59D0'} onBlur={e => e.target.style.borderColor = '#EDE3F6'} />
        </div>
        <div>
          <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 6 }}>Email Address *</label>
          <input type="email" required value={form.email} onChange={e => setForm({ ...form, email: e.target.value })}
            placeholder="you@example.com" style={inputStyle}
            onFocus={e => e.target.style.borderColor = '#9B59D0'} onBlur={e => e.target.style.borderColor = '#EDE3F6'} />
        </div>
      </div>

      <div>
        <label style={{ display: 'block', fontSize: 13, fontWeight: 700, color: '#374151', marginBottom: 6 }}>Message *</label>
        <textarea required value={form.message} onChange={e => setForm({ ...form, message: e.target.value })}
          placeholder="Tell us how we can help..."
          rows={5} style={{ ...inputStyle, resize: 'vertical' }}
          onFocus={e => e.target.style.borderColor = '#9B59D0'} onBlur={e => e.target.style.borderColor = '#EDE3F6'} />
      </div>

      <button type="submit" disabled={status === 'submitting'}
        style={{
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          padding: '14px 32px', borderRadius: 50,
          background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
          color: '#fff', fontWeight: 700, fontSize: 16,
          border: 'none', cursor: 'pointer',
          boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
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
    { icon: <MessageSquare size={24} />, title: 'General & App Support', desc: 'Technical issues, account help, feedback, and general questions.', color: '#9B59D0' },
    { icon: <Users size={24} />, title: 'Become a Guardian', desc: 'Join our vetted guardian network and help protect women in your community.', color: '#7B3FBE' },
    { icon: <Briefcase size={24} />, title: 'Partnerships & NGOs', desc: 'Collaborate with Safer to expand our reach and impact.', color: '#B57BE0' },
    { icon: <Shield size={24} />, title: 'Grant & Funding', desc: 'Foundation, government, and corporate grant partnership inquiries.', color: '#6A1B9A' },
    { icon: <Newspaper size={24} />, title: 'Press & Media', desc: 'Media inquiries, press kits, and interview requests.', color: '#E91E8C' },

  ]

  return (
    <div style={{ paddingTop: 72 }}>
      <section style={{ background: 'linear-gradient(135deg, #1a0533 0%, #3d1278 50%, #6A1B9A 100%)', padding: '5rem 1.5rem', textAlign: 'center' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(181,123,224,0.2)', color: '#D8C4F0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>Contact</motion.div>
            <motion.h1 variants={fadeUp} style={{ fontSize: 'clamp(2rem, 4vw, 3.5rem)', fontWeight: 900, color: '#fff', lineHeight: 1.15, marginBottom: 20 }}>Get in Touch</motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7 }}>
              Whether you're a future user, guardian, partner, investor, or press — we'd love to hear from you.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Contact topic cards */}
      <section style={{ padding: '5rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <h2 style={{ fontSize: 'clamp(1.6rem, 3vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 12 }}>How can we help?</h2>
            <p style={{ color: '#6B7280', fontSize: 16 }}>Use the form below to reach the right team for your inquiry.</p>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.25rem', marginBottom: '4rem' }}>
            {contactCards.map((card, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.08 }}
                style={{ background: '#fff', borderRadius: 18, padding: '1.75rem', border: '1px solid rgba(155,89,208,0.1)', boxShadow: '0 4px 20px rgba(155,89,208,0.06)' }}>
                <div style={{ width: 48, height: 48, borderRadius: 12, background: `${card.color}15`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: card.color, marginBottom: 14 }}>
                  {card.icon}
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 8 }}>{card.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.7, marginBottom: card.link ? 12 : 0 }}>{card.desc}</p>
                {card.link && (
                  <a href={card.link} target="_blank" rel="noopener noreferrer"
                    style={{ color: card.color, fontWeight: 600, fontSize: 13, textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 4 }}>
                    Visit Website <ExternalLink size={12} />
                  </a>
                )}
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Contact form */}
      <section style={{ padding: '0 1.5rem 6rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
            style={{ background: '#fff', borderRadius: 24, padding: '2.5rem', boxShadow: '0 8px 40px rgba(155,89,208,0.1)', border: '1px solid rgba(155,89,208,0.1)' }}>
            <h2 style={{ fontWeight: 900, fontSize: 24, color: '#1a1a2e', marginBottom: 8 }}>Send us a message</h2>
            <p style={{ color: '#6B7280', fontSize: 15, marginBottom: 28 }}>We typically respond within 1–2 business days.</p>
            <ContactForm />
          </motion.div>
        </div>
      </section>
    </div>
  )
}
