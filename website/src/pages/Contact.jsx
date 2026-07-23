import { useState } from 'react'
import { motion } from 'framer-motion'
import { Mail, Send, RefreshCw, MessageSquare, Users, Shield, BookOpen, ExternalLink } from 'lucide-react'

const fadeUp = { hidden: { opacity: 0, y: 40 }, visible: { opacity: 1, y: 0, transition: { duration: 0.6 } } }
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const contactTypes = [
  { value: 'general', label: '💬 General Inquiry', email: 'saferapp3@gmail.com', subject: 'General Inquiry — Safer' },
  { value: 'support', label: '🛠️ App Support', email: 'support@safecodeg.com', subject: 'App Support — Safer' },
  { value: 'guardian', label: '🛡️ Become a Guardian', email: 'saferapp3@gmail.com', subject: 'Guardian Application — Safer' },
  { value: 'partner', label: '🤝 Partnership / NGO', email: 'support@safecodeg.com', subject: 'Partnership Inquiry — Safer' },
  { value: 'grant', label: '💼 Grant / Funding', email: 'support@safecodeg.com', subject: 'Grant Inquiry — Safer' },
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

      <div style={{ background: '#F9F5FF', borderRadius: 12, padding: '12px 16px', border: '1px solid rgba(155,89,208,0.15)', fontSize: 13, color: '#6B7280' }}>
        Your message will be sent to: <strong style={{ color: '#9B59D0' }}>{selectedType.email}</strong>
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

      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '4rem', alignItems: 'start' }} className="contact-grid">
            {/* Form */}
            <motion.div initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
              style={{ background: '#fff', borderRadius: 24, padding: '2.5rem', boxShadow: '0 8px 40px rgba(155,89,208,0.1)', border: '1px solid rgba(155,89,208,0.1)' }}>
              <h2 style={{ fontWeight: 900, fontSize: 24, color: '#1a1a2e', marginBottom: 8 }}>Send us a message</h2>
              <p style={{ color: '#6B7280', fontSize: 15, marginBottom: 28 }}>We typically respond within 1–2 business days.</p>
              <ContactForm />
            </motion.div>

            {/* Contact info sidebar */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
              {[
                { icon: <Mail size={20} />, title: 'App Support', email: 'support@safecodeg.com', desc: 'Technical issues, account help, feedback' },
                { icon: <MessageSquare size={20} />, title: 'General / Team', email: 'saferapp3@gmail.com', desc: 'Partnerships, press, general questions' },
                { icon: <Shield size={20} />, title: 'EmbeddedOS Foundation', email: 'foundation@embeddedos.org', desc: 'Grant inquiries, development partnership' },
              ].map((c, i) => (
                <motion.div key={i} initial={{ opacity: 0, x: 20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.1 }}
                  style={{ background: '#F9F5FF', borderRadius: 16, padding: '1.5rem', border: '1px solid rgba(155,89,208,0.1)' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 8 }}>
                    <div style={{ color: '#9B59D0' }}>{c.icon}</div>
                    <div style={{ fontWeight: 800, fontSize: 15, color: '#1a1a2e' }}>{c.title}</div>
                  </div>
                  <a href={`mailto:${c.email}`} style={{ color: '#9B59D0', fontWeight: 600, fontSize: 14, textDecoration: 'none', display: 'block', marginBottom: 4 }}>{c.email}</a>
                  <div style={{ color: '#9B7AB0', fontSize: 13 }}>{c.desc}</div>
                </motion.div>
              ))}

              <motion.div initial={{ opacity: 0, x: 20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: 0.3 }}
                style={{ background: 'linear-gradient(135deg, #F4ECFA, #EDE3F6)', borderRadius: 16, padding: '1.5rem', border: '1px solid rgba(155,89,208,0.15)' }}>
                <div style={{ fontWeight: 800, fontSize: 15, color: '#1a1a2e', marginBottom: 8 }}>GitHub Repository</div>
                <a href="https://github.com/AmericanGroupLLC/Safer-Women" target="_blank" rel="noopener noreferrer"
                  style={{ color: '#9B59D0', fontWeight: 600, fontSize: 14, textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 6 }}>
                  AmericanGroupLLC/Safer-Women <ExternalLink size={14} />
                </a>
                <div style={{ color: '#9B7AB0', fontSize: 13, marginTop: 4 }}>Open source · MIT License</div>
              </motion.div>
            </div>
          </div>
        </div>
        <style>{`@media (max-width: 900px) { .contact-grid { grid-template-columns: 1fr !important; } }`}</style>
      </section>
    </div>
  )
}
