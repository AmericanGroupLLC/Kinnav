import { useState, useEffect, useRef } from 'react'
import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Heart, Shield, Code, Globe, CheckCircle, ArrowRight, ExternalLink, Users, Zap, Lock, Mail, Send, RefreshCw } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

// Zeffy donation form URL for EmbeddedOS Foundation (Safer Women project)
const ZEFFY_URL = 'https://www.zeffy.com/en-US/embed/donation-form/donate-to-change-lives-17596'

const fundingGoals = [
  { icon: <Code size={22} />, title: 'Real-Time Backend Infrastructure', amount: '$45,000', pct: 30, desc: 'Firebase/Supabase backend, authentication, guardian geo-queries, and database architecture.', color: '#9B59D0' },
  { icon: <Zap size={22} />, title: 'Safe Call — Voice & Video', amount: '$35,000', pct: 23, desc: 'Agora RTC or Twilio integration for real multi-party voice and video calls.', color: '#7B3FBE' },
  { icon: <Globe size={22} />, title: 'Guardian Network Launch', amount: '$25,000', pct: 17, desc: 'Guardian vetting workflow, 40-hour course platform, payment infrastructure, NGO partnerships.', color: '#B57BE0' },
  { icon: <Lock size={22} />, title: 'Security, Compliance & Legal', amount: '$20,000', pct: 13, desc: 'GDPR/CCPA compliance, encryption, independent safety/legal review, app store submissions.', color: '#6A1B9A' },
  { icon: <Users size={22} />, title: 'Push Notifications & Emergency', amount: '$15,000', pct: 10, desc: 'FCM/APNs push notifications, emergency dial integration, safety contact alerts.', color: '#E53935' },
  { icon: <Shield size={22} />, title: 'QA, Testing & App Store Launch', amount: '$10,000', pct: 7, desc: 'Full test suite, CI/CD pipeline, crash reporting, analytics, and iOS/Android store listings.', color: '#43A047' },
]

const grantOpportunities = [
  { name: 'Violence Against Women Act (VAWA) Grants', org: 'U.S. Department of Justice', focus: 'Technology solutions for women\'s safety and violence prevention', fit: 'High' },
  { name: 'Safety and Justice Challenge', org: 'MacArthur Foundation', focus: 'Innovative community safety solutions', fit: 'High' },
  { name: "Women's Safety & Empowerment Fund", org: 'Various Foundations', focus: 'Apps and platforms empowering women in vulnerable situations', fit: 'High' },
  { name: 'Tech for Social Good Grants', org: 'Google.org / Microsoft Philanthropies', focus: 'Nonprofit technology solving social challenges', fit: 'Medium-High' },
  { name: 'Campus Safety Innovation Grants', org: 'U.S. Department of Education', focus: 'University and campus safety technology', fit: 'Medium-High' },
  { name: 'Open Source Foundation Grants', org: 'Mozilla Foundation / Linux Foundation', focus: 'Open-source safety and privacy tools', fit: 'Medium' },
]

const donationTiers = [
  { amount: '$25', title: 'Supporter', perks: ['Donor wall recognition', 'Safer newsletter updates', 'Early access waitlist priority'], color: '#B57BE0' },
  { amount: '$100', title: 'Guardian Sponsor', perks: ['All Supporter perks', 'Sponsor one guardian\'s training materials', 'Quarterly impact report', 'Safer sticker pack'], color: '#9B59D0', featured: true },
  { amount: '$500', title: 'Safety Champion', perks: ['All Guardian Sponsor perks', 'Sponsor a campus ambassador', 'Logo on website (organizations)', 'Direct team call'], color: '#6A1B9A' },
  { amount: 'Custom', title: 'Grant Partner', perks: ['Custom grant partnership', 'Co-branded impact reporting', 'Advisory board consideration', 'Full recognition package'], color: '#1a0533' },
]

// Waitlist form component
function WaitlistForm() {
  const [form, setForm] = useState({ name: '', email: '', role: 'user', message: '' })
  const [status, setStatus] = useState('idle') // idle | submitting | success | error

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!form.email || !form.name) return
    setStatus('submitting')
    // Use mailto as the submission mechanism (no backend needed for static site)
    const subject = encodeURIComponent(`Safer App Early Access — ${form.role === 'guardian' ? 'Guardian' : 'User'} Waitlist`)
    const body = encodeURIComponent(
      `Name: ${form.name}\nEmail: ${form.email}\nRole: ${form.role}\nMessage: ${form.message || 'N/A'}\n\n[Submitted from mysaferapp.com waitlist form]`
    )
    window.location.href = `mailto:saferapp3@gmail.com?subject=${subject}&body=${body}`
    setTimeout(() => setStatus('success'), 500)
  }

  if (status === 'success') {
    return (
      <div style={{ textAlign: 'center', padding: '3rem 2rem' }}>
        <div style={{ fontSize: 48, marginBottom: 16 }}>💜</div>
        <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>You're on the list!</h3>
        <p style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7 }}>
          We'll email you at <strong>{form.email}</strong> when Safer launches. Thank you for your support.
        </p>
        <button
          onClick={() => setStatus('idle')}
          style={{ marginTop: 20, color: '#9B59D0', background: 'none', border: 'none', cursor: 'pointer', fontWeight: 600, fontSize: 15 }}
        >
          Submit another →
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
            { value: 'investor', label: '💼 Investor / Donor' },
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

// Zeffy donation embed component
function ZeffyDonateEmbed() {
  const [loaded, setLoaded] = useState(false)
  const iframeRef = useRef(null)

  return (
    <div>
      <div style={{ marginBottom: 16 }}>
        <h2 style={{ fontSize: 24, fontWeight: 900, color: '#fff', marginBottom: 8 }}>Make a Donation</h2>
        <p style={{ color: 'rgba(255,255,255,0.6)', fontSize: 14, lineHeight: 1.6 }}>
          Powered by <strong style={{ color: '#B57BE0' }}>Zeffy</strong> — 0% platform fees. All funds go directly to EmbeddedOS Foundation to build Safer.
        </p>
      </div>

      {/* Zeffy tip notice */}
      <div style={{
        marginBottom: 16, padding: '10px 14px', borderRadius: 10,
        background: 'rgba(245,158,11,0.1)', border: '1px solid rgba(245,158,11,0.25)',
        fontSize: 13, color: 'rgba(245,158,11,0.9)', display: 'flex', gap: 8, alignItems: 'flex-start',
      }}>
        <span style={{ flexShrink: 0, marginTop: 1 }}>ℹ</span>
        <span>Zeffy may show an optional tip (default 17%). You can set it to 0% — it is completely optional and does not affect your donation amount.</span>
      </div>

      {/* Iframe container */}
      <div style={{
        position: 'relative', borderRadius: 20, overflow: 'hidden',
        border: '1px solid rgba(181,123,224,0.3)',
        background: 'rgba(255,255,255,0.05)',
        minHeight: 820,
      }}>
        {!loaded && (
          <div style={{
            position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column',
            alignItems: 'center', justifyContent: 'center', gap: 12, zIndex: 10,
          }}>
            <RefreshCw size={32} style={{ color: '#B57BE0', animation: 'spin 1s linear infinite' }} />
            <p style={{ color: 'rgba(255,255,255,0.5)', fontSize: 14 }}>Loading donation form…</p>
          </div>
        )}
        <iframe
          ref={iframeRef}
          title="Donation form — EmbeddedOS Foundation for Safer Women"
          src={ZEFFY_URL}
          allow="payment"
          onLoad={() => setLoaded(true)}
          style={{
            overflow: 'hidden', width: '100%', border: 'none', display: 'block',
            opacity: loaded ? 1 : 0, transition: 'opacity 0.4s ease',
          }}
          height={820}
        />
      </div>

      {/* Other ways to give */}
      <div style={{ marginTop: 20, padding: '16px 20px', borderRadius: 14, background: 'rgba(255,255,255,0.05)', border: '1px solid rgba(181,123,224,0.15)' }}>
        <div style={{ fontSize: 13, fontWeight: 700, color: 'rgba(255,255,255,0.6)', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 1 }}>Other Ways to Give</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
          <a href="mailto:foundation@embeddedos.org?subject=Donation%20to%20Safer%20Women%20Project" style={{ color: '#B57BE0', fontSize: 14, textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 8 }}>
            <Mail size={14} /> Wire / Check: foundation@embeddedos.org
          </a>
          <a href="mailto:saferapp3@gmail.com?subject=Grant%20Partnership%20Inquiry" style={{ color: '#B57BE0', fontSize: 14, textDecoration: 'none', display: 'flex', alignItems: 'center', gap: 8 }}>
            <Mail size={14} /> Grant Partnerships: saferapp3@gmail.com
          </a>
        </div>
      </div>

      {/* Tax info */}
      <div style={{ marginTop: 16, padding: '12px 16px', borderRadius: 12, background: 'rgba(67,160,71,0.1)', border: '1px solid rgba(67,160,71,0.25)' }}>
        <div style={{ color: '#81C784', fontSize: 13, display: 'flex', alignItems: 'center', gap: 8 }}>
          <Shield size={14} />
          <span><strong>Tax-deductible donation</strong> · EmbeddedOS Foundation · EIN: 41-4821627 · 501(c)(3) Public Charity · Tax receipt by email</span>
        </div>
      </div>
      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  )
}

export default function GrantFunding() {
  // Scroll to donate section if URL has #donate hash
  useEffect(() => {
    if (window.location.hash === '#donate') {
      setTimeout(() => {
        const el = document.getElementById('donate')
        if (el) el.scrollIntoView({ behavior: 'smooth' })
      }, 300)
    }
  }, [])

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
        <div style={{ position: 'absolute', inset: 0, backgroundImage: 'url(/images/grant-fundraising.jpg)', backgroundSize: 'cover', backgroundPosition: 'center', opacity: 0.12 }} />
        <div style={{ position: 'relative', zIndex: 1, maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(181,123,224,0.2)', color: '#D8C4F0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>
              Grant & Funding
            </motion.div>
            <motion.h1 variants={fadeUp} style={{ fontSize: 'clamp(2rem, 4vw, 3.5rem)', fontWeight: 900, color: '#fff', lineHeight: 1.15, marginBottom: 20 }}>
              Help Build the Future of<br />Women's Safety Technology
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7, marginBottom: 40 }}>
              The Safer prototype is complete. We need grant funding and community donations to build the full production app — real guardian calls, real-time infrastructure, and global reach.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
              <a href="#donate" onClick={e => { e.preventDefault(); document.getElementById('donate')?.scrollIntoView({ behavior: 'smooth' }) }}
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none', boxShadow: '0 8px 30px rgba(155,89,208,0.5)' }}>
                Donate Now 💜
              </a>
              <a href="#waitlist" onClick={e => { e.preventDefault(); document.getElementById('waitlist')?.scrollIntoView({ behavior: 'smooth' }) }}
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.3)', color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none' }}>
                Join Waitlist
              </a>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Stats bar */}
      <section style={{ background: 'linear-gradient(135deg, #6A1B9A, #9B59D0)', padding: '3rem 1.5rem' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '2rem' }}>
            {[
              { value: '1 in 3', label: 'Women experience violence globally' },
              { value: '$150K', label: 'Total funding goal for production app' },
              { value: '501(c)(3)', label: 'EmbeddedOS Foundation — tax-deductible' },
              { value: '0%', label: 'Platform fees via Zeffy — all funds go to mission' },
            ].map((m, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.1 }} style={{ textAlign: 'center' }}>
                <div style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#fff', lineHeight: 1 }}>{m.value}</div>
                <div style={{ color: 'rgba(255,255,255,0.75)', fontSize: 14, marginTop: 8, lineHeight: 1.4 }}>{m.label}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* EmbeddedOS Partnership */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1000, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}
            style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '5rem', alignItems: 'center' }} className="two-col">
            <motion.div variants={fadeUp}>
              <div style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>
                Development Partner
              </div>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Built by EmbeddedOS Foundation
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 20 }}>
                The Safer app is developed by <strong style={{ color: '#9B59D0' }}>EmbeddedOS (EoS) Research Foundation</strong> — a 501(c)(3) nonprofit. Your donations and grants go directly to EmbeddedOS Foundation to fund the engineering work required to bring Safer from a working prototype to a full production application.
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 32 }}>
                {[
                  '501(c)(3) tax-exempt — donations are fully tax-deductible',
                  'Open-source development — transparent, auditable code',
                  'EIN: 41-4821627 · Embedded Operating Systems Research Foundation',
                  'Deployed across 52+ hardware platforms globally',
                ].map((item, i) => (
                  <div key={i} style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                    <CheckCircle size={18} style={{ color: '#9B59D0', flexShrink: 0, marginTop: 2 }} />
                    <span style={{ color: '#374151', fontSize: 15 }}>{item}</span>
                  </div>
                ))}
              </div>
              <a href="https://www.embeddedos.org/" target="_blank" rel="noopener noreferrer"
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '12px 28px', borderRadius: 50, border: '2px solid #9B59D0', color: '#9B59D0', fontWeight: 700, fontSize: 15, textDecoration: 'none' }}>
                Visit EmbeddedOS.org <ExternalLink size={16} />
              </a>
            </motion.div>
            <motion.div variants={fadeUp}>
              <div style={{ background: 'linear-gradient(135deg, #F4ECFA, #EDE3F6)', borderRadius: 24, padding: '3rem 2.5rem', border: '1px solid rgba(155,89,208,0.15)', textAlign: 'center' }}>
                <div style={{ width: 80, height: 80, borderRadius: 20, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 24px', fontSize: 36 }}>🛡️</div>
                <h3 style={{ fontWeight: 900, fontSize: 24, color: '#1a1a2e', marginBottom: 12 }}>EmbeddedOS Foundation</h3>
                <div style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '4px 14px', fontSize: 13, fontWeight: 700, marginBottom: 20 }}>501(c)(3) Nonprofit</div>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7, marginBottom: 24 }}>
                  "The Operating System for Every Device" — built by embedded engineers, for any embedded hardware. Community-driven, open-source, and 501(c)(3) forever.
                </p>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', textAlign: 'left' }}>
                  {[{ label: 'EIN', value: '41-4821627' }, { label: 'Status', value: '501(c)(3)' }, { label: 'Platforms', value: '52+' }, { label: 'License', value: 'MIT Open' }].map((stat, i) => (
                    <div key={i} style={{ background: '#fff', borderRadius: 12, padding: '12px 16px', border: '1px solid rgba(155,89,208,0.1)' }}>
                      <div style={{ fontSize: 12, color: '#9B7AB0', fontWeight: 600, textTransform: 'uppercase', letterSpacing: 1 }}>{stat.label}</div>
                      <div style={{ fontSize: 16, fontWeight: 800, color: '#9B59D0', marginTop: 4 }}>{stat.value}</div>
                    </div>
                  ))}
                </div>
              </div>
            </motion.div>
          </motion.div>
        </div>
        <style>{`.two-col { } @media (max-width: 768px) { .two-col { grid-template-columns: 1fr !important; gap: 2rem !important; } .form-grid { grid-template-columns: 1fr !important; } }`}</style>
      </section>

      {/* Funding Goals */}
      <section style={{ padding: '6rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '4rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>Funding Roadmap</motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>Where your funding goes</motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', maxWidth: 600, margin: '0 auto' }}>
              Total target: <strong style={{ color: '#9B59D0' }}>$150,000</strong> to bring Safer from prototype to production. Every dollar is tracked and reported.
            </motion.p>
          </motion.div>

          {/* Progress bar */}
          <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
            style={{ background: '#fff', borderRadius: 20, padding: '2rem', boxShadow: '0 4px 20px rgba(155,89,208,0.1)', border: '1px solid rgba(155,89,208,0.1)', marginBottom: '3rem' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 12 }}>
              <span style={{ fontWeight: 700, fontSize: 16, color: '#1a1a2e' }}>Fundraising Goal: $150,000</span>
              <span style={{ fontWeight: 700, fontSize: 16, color: '#9B59D0' }}>Help us reach it!</span>
            </div>
            <div style={{ background: '#EDE3F6', borderRadius: 50, height: 12, overflow: 'hidden' }}>
              <motion.div initial={{ width: 0 }} whileInView={{ width: '8%' }} viewport={{ once: true }} transition={{ duration: 1.5, ease: 'easeOut' }}
                style={{ height: '100%', background: 'linear-gradient(90deg, #B57BE0, #9B59D0)', borderRadius: 50 }} />
            </div>
            <div style={{ fontSize: 13, color: '#9B7AB0', marginTop: 8 }}>Early stage — every donation counts toward our goal</div>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem' }}>
            {fundingGoals.map((goal, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.1 }}
                style={{ background: '#fff', borderRadius: 20, padding: '2rem', boxShadow: '0 4px 20px rgba(155,89,208,0.08)', border: '1px solid rgba(155,89,208,0.1)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 16 }}>
                  <div style={{ width: 48, height: 48, borderRadius: 12, background: `${goal.color}15`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: goal.color }}>{goal.icon}</div>
                  <div style={{ fontWeight: 900, fontSize: 20, color: goal.color }}>{goal.amount}</div>
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 8 }}>{goal.title}</h3>
                <div style={{ background: '#EDE3F6', borderRadius: 50, height: 6, overflow: 'hidden', marginBottom: 10 }}>
                  <div style={{ height: '100%', background: goal.color, borderRadius: 50, width: `${goal.pct}%` }} />
                </div>
                <p style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.7 }}>{goal.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* MAIN DONATION SECTION — Zeffy embed */}
      <section id="donate" style={{ padding: '6rem 1.5rem', background: 'linear-gradient(135deg, #1a0533, #3d1278)' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(181,123,224,0.2)', color: '#D8C4F0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>Donate</motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>Support the Safer Mission</motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.7)', fontSize: 17, maxWidth: 600, margin: '0 auto' }}>
              All donations go to EmbeddedOS Foundation (501c3 · EIN 41-4821627) to fund Safer development. Tax-deductible. 0% platform fees.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: '3fr 2fr', gap: '3rem', alignItems: 'start' }} className="donate-grid">
            {/* Left: Zeffy embed */}
            <ZeffyDonateEmbed />

            {/* Right: Donation tiers + trust */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
              <div style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(181,123,224,0.2)', borderRadius: 20, padding: '1.5rem' }}>
                <h3 style={{ fontWeight: 800, fontSize: 16, color: '#fff', marginBottom: 16 }}>Donation Impact Tiers</h3>
                {donationTiers.map((tier, i) => (
                  <div key={i} style={{
                    padding: '14px 16px', borderRadius: 12, marginBottom: 10,
                    background: tier.featured ? 'rgba(181,123,224,0.15)' : 'rgba(255,255,255,0.04)',
                    border: tier.featured ? '1px solid rgba(181,123,224,0.4)' : '1px solid rgba(255,255,255,0.06)',
                  }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
                      <span style={{ fontWeight: 800, fontSize: 18, color: '#fff' }}>{tier.amount}</span>
                      <span style={{ fontSize: 13, fontWeight: 700, color: '#B57BE0' }}>{tier.title}</span>
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
                      {tier.perks.slice(0, 2).map((p, j) => (
                        <div key={j} style={{ display: 'flex', alignItems: 'center', gap: 8, fontSize: 12, color: 'rgba(255,255,255,0.6)' }}>
                          <Heart size={10} style={{ color: '#B57BE0', fill: '#B57BE0', flexShrink: 0 }} />
                          {p}
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>

              {/* Trust signals */}
              <div style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(181,123,224,0.2)', borderRadius: 20, padding: '1.5rem' }}>
                <h3 style={{ fontWeight: 800, fontSize: 14, color: 'rgba(255,255,255,0.6)', textTransform: 'uppercase', letterSpacing: 1, marginBottom: 14 }}>Why Donate Here?</h3>
                {[
                  { icon: <Shield size={16} />, text: '501(c)(3) — fully tax-deductible' },
                  { icon: <CheckCircle size={16} />, text: '0% platform fees via Zeffy' },
                  { icon: <Mail size={16} />, text: 'Tax receipt sent by email' },
                  { icon: <Globe size={16} />, text: 'Open-source — transparent code' },
                  { icon: <Heart size={16} />, text: 'Directly funds Safer development' },
                ].map((t, i) => (
                  <div key={i} style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 10, color: 'rgba(255,255,255,0.7)', fontSize: 14 }}>
                    <span style={{ color: '#B57BE0' }}>{t.icon}</span>
                    {t.text}
                  </div>
                ))}
              </div>

              {/* Grant partnership CTA */}
              <div style={{ background: 'rgba(155,89,208,0.15)', border: '1px solid rgba(181,123,224,0.3)', borderRadius: 20, padding: '1.5rem', textAlign: 'center' }}>
                <h3 style={{ fontWeight: 800, fontSize: 16, color: '#fff', marginBottom: 8 }}>Grant Partnership?</h3>
                <p style={{ color: 'rgba(255,255,255,0.6)', fontSize: 14, marginBottom: 16, lineHeight: 1.6 }}>For foundations, government agencies, or corporate CSR programs.</p>
                <a href="mailto:saferapp3@gmail.com?subject=Grant%20Partnership%20Inquiry%20—%20Safer%20Women"
                  style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '10px 20px', borderRadius: 50, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', color: '#fff', fontWeight: 700, fontSize: 14, textDecoration: 'none' }}>
                  Contact Us <ArrowRight size={14} />
                </a>
              </div>
            </div>
          </div>
        </div>
        <style>{`@media (max-width: 900px) { .donate-grid { grid-template-columns: 1fr !important; } }`}</style>
      </section>

      {/* Grant Opportunities */}
      <section id="grant-opportunities" style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1000, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '4rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>Grant Opportunities</motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>Aligned grant programs</motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', maxWidth: 600, margin: '0 auto' }}>
              Safer aligns with multiple federal, foundation, and corporate grant programs focused on women's safety and nonprofit technology.
            </motion.p>
          </motion.div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {grantOpportunities.map((grant, i) => (
              <motion.div key={i} initial={{ opacity: 0, x: -20 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.08 }}
                style={{ background: '#F9F5FF', borderRadius: 16, padding: '1.5rem 2rem', border: '1px solid rgba(155,89,208,0.1)', display: 'flex', alignItems: 'center', gap: '2rem', flexWrap: 'wrap' }}>
                <div style={{ flex: 1, minWidth: 200 }}>
                  <div style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 4 }}>{grant.name}</div>
                  <div style={{ fontSize: 13, color: '#9B59D0', fontWeight: 600 }}>{grant.org}</div>
                </div>
                <div style={{ flex: 2, minWidth: 200 }}><div style={{ fontSize: 14, color: '#6B7280' }}>{grant.focus}</div></div>
                <div style={{ background: grant.fit === 'High' ? 'rgba(67,160,71,0.1)' : 'rgba(255,152,0,0.1)', color: grant.fit === 'High' ? '#2E7D32' : '#E65100', borderRadius: 50, padding: '4px 14px', fontSize: 13, fontWeight: 700, whiteSpace: 'nowrap' }}>
                  {grant.fit} Fit
                </div>
              </motion.div>
            ))}
          </div>
          <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }}
            style={{ marginTop: '3rem', background: 'linear-gradient(135deg, #F4ECFA, #EDE3F6)', borderRadius: 20, padding: '2.5rem', border: '1px solid rgba(155,89,208,0.2)', textAlign: 'center' }}>
            <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>Are you a grant officer or foundation?</h3>
            <p style={{ color: '#6B7280', fontSize: 16, marginBottom: 24 }}>We welcome partnership inquiries from foundations, government agencies, and corporate social responsibility programs.</p>
            <a href="mailto:saferapp3@gmail.com?subject=Grant%20Partnership%20Inquiry%20—%20Safer%20Women"
              style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '12px 28px', borderRadius: 50, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', color: '#fff', fontWeight: 700, fontSize: 15, textDecoration: 'none' }}>
              Contact for Grant Partnership <ArrowRight size={16} />
            </a>
          </motion.div>
        </div>
      </section>

      {/* Waitlist / Early Access */}
      <section id="waitlist" style={{ padding: '6rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.div variants={fadeUp} style={{ textAlign: 'center', marginBottom: '3rem' }}>
              <div style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '6px 16px', fontSize: 13, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 20 }}>Early Access</div>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>Join the Waitlist</h2>
              <p style={{ fontSize: 17, color: '#6B7280', lineHeight: 1.7 }}>
                Be first to access Safer when it launches. Whether you're a future user, guardian, partner, or investor — we want to hear from you.
              </p>
            </motion.div>
            <motion.div variants={fadeUp} style={{ background: '#fff', borderRadius: 24, padding: '2.5rem', boxShadow: '0 8px 40px rgba(155,89,208,0.12)', border: '1px solid rgba(155,89,208,0.1)' }}>
              <WaitlistForm />
            </motion.div>
          </motion.div>
        </div>
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
              <a href="mailto:saferapp3@gmail.com?subject=Pitch%20Deck%20Request%20—%20Safer%20Women"
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none', boxShadow: '0 8px 30px rgba(155,89,208,0.4)' }}>
                Request Pitch Deck <ArrowRight size={18} />
              </a>
              <a href="mailto:saferapp3@gmail.com?subject=Partner%20With%20Safer"
                style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '14px 32px', borderRadius: 50, border: '2px solid #9B59D0', color: '#9B59D0', fontWeight: 700, fontSize: 16, textDecoration: 'none' }}>
                Partner With Us
              </a>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
