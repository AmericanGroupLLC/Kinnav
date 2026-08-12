import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Shield, Phone, Map, Users, BookOpen, Gift, ArrowRight } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 30 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.55, ease: 'easeOut' } },
}
const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const features = [
  { icon: <Map size={26} />, title: 'Guardian Map', desc: 'See vetted guardians near you on a live map. Real people, always nearby.', color: '#BF6EEE' },
  { icon: <Phone size={26} />, title: 'Safe Call', desc: 'One tap — voice, video, or text with a guardian. No time limit.', color: '#9A4FD8' },
  { icon: <Shield size={26} />, title: 'Emergency', desc: 'Instantly alert emergency services and notify your safety contacts.', color: '#E53935' },
  { icon: <BookOpen size={26} />, title: 'Empowerment', desc: 'Self-defense, safety planning, wellness modules — all in the app.', color: '#7B2FB8' },
  { icon: <Users size={26} />, title: 'Be a Guardian', desc: 'Complete a 40-hour course, get verified, and earn while helping others.', color: '#D4A5F5' },
  { icon: <Gift size={26} />, title: 'Rewards', desc: 'Earn wellness rewards — yoga, counseling, career coaching, and more.', color: '#DDA146' },
]

const steps = [
  { num: '1', title: 'Open the app', desc: 'See guardians near you on the map.' },
  { num: '2', title: 'Tap Call Guardians', desc: 'Choose voice, video, or text.' },
  { num: '3', title: 'Stay connected', desc: 'Guardian stays until you feel safe.' },
  { num: '4', title: 'You\'re safe', desc: 'End the call. That\'s it.' },
]

export default function Home() {
  return (
    <div>
      {/* ── HERO ── */}
      <section style={{
        position: 'relative', minHeight: '100vh',
        display: 'flex', alignItems: 'center', overflow: 'hidden',
      }}>
        <div style={{
          position: 'absolute', inset: 0,
          backgroundImage: 'url(/images/hero-bg.jpg)',
          backgroundSize: 'cover', backgroundPosition: 'center top',
        }} />
        <div style={{
          position: 'absolute', inset: 0,
          background: 'linear-gradient(135deg, rgba(26,5,51,0.93) 0%, rgba(61,18,120,0.87) 45%, rgba(123,47,184,0.75) 70%, rgba(191,110,238,0.55) 100%)',
        }} />

        <div style={{ position: 'relative', zIndex: 1, maxWidth: 1200, margin: '0 auto', padding: '8rem 1.5rem 5rem', width: '100%' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: '3rem', alignItems: 'center' }} className="hero-grid">
            <motion.div initial="hidden" animate="visible" variants={stagger}>
              <motion.div variants={fadeUp} style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                background: 'rgba(212,165,245,0.2)', border: '1px solid rgba(212,165,245,0.4)',
                borderRadius: 50, padding: '7px 16px', marginBottom: 24,
                color: '#E3CCFA', fontSize: 13, fontWeight: 600,
              }}>
                <Shield size={15} style={{ color: '#DDA146' }} />
                Safety · Empowerment · Rewards
              </motion.div>

              <motion.h1 variants={fadeUp} style={{
                fontSize: 'clamp(2.4rem, 5vw, 3.8rem)', fontWeight: 900,
                color: '#fff', lineHeight: 1.1, marginBottom: 20, letterSpacing: -1,
              }}>
                It's easier to look forward
                <br />
                <span style={{
                  background: 'linear-gradient(135deg, #E3CCFA, #D4A5F5)',
                  WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', backgroundClip: 'text',
                }}>
                  when you don't have to
                </span>
                <br />
                watch your back.
              </motion.h1>

              <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7, marginBottom: 36, maxWidth: 520 }}>
                Kinnav connects you to vetted guardians nearby — via voice or video — the moment you need them. No time limit. No judgment.
              </motion.p>

              <motion.div variants={fadeUp} style={{ display: 'flex', flexWrap: 'wrap', gap: 14 }}>
                <Link to="/how-it-works" style={{
                  display: 'inline-flex', alignItems: 'center', gap: 8,
                  padding: '13px 30px', borderRadius: 50,
                  background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)',
                  color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none',
                  boxShadow: '0 8px 30px rgba(191,110,238,0.5)',
                }}>
                  See How It Works <ArrowRight size={17} />
                </Link>
                <Link to="/waitlist" style={{
                  display: 'inline-flex', alignItems: 'center', gap: 8,
                  padding: '13px 30px', borderRadius: 50,
                  background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.3)',
                  color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none',
                  backdropFilter: 'blur(8px)',
                }}>
                  Join the Waitlist 💜
                </Link>
              </motion.div>

              <motion.div variants={fadeUp} style={{ marginTop: 28, display: 'flex', gap: 10 }}>
                {['📱 iOS — Coming Soon', '🤖 Android — Coming Soon'].map(t => (
                  <div key={t} style={{
                    background: 'rgba(255,255,255,0.1)', border: '1px solid rgba(255,255,255,0.2)',
                    borderRadius: 10, padding: '9px 18px', color: 'rgba(255,255,255,0.7)', fontSize: 13, fontWeight: 600,
                  }}>{t}</div>
                ))}
              </motion.div>
            </motion.div>

            {/* Phone mockups — real screenshots */}
            <motion.div
              initial={{ opacity: 0, x: 60 }} animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8, delay: 0.3 }}
              style={{ display: 'flex', gap: 14, alignItems: 'center' }}
              className="hero-phones"
            >
              {[
                { src: '/images/screen-map-guardians.jpg', alt: 'Guardian map', offset: 20 },
                { src: '/images/screen-reach-guardian.jpg', alt: 'Reach a guardian', offset: -20 },
              ].map(({ src, alt, offset }) => (
                <div key={src} style={{
                  background: '#0d0020', borderRadius: 32, padding: 6,
                  boxShadow: '0 30px 80px rgba(0,0,0,0.6), 0 0 0 1px rgba(212,165,245,0.3)',
                  transform: `translateY(${offset}px)`,
                }}>
                  <img src={src} alt={alt} style={{ width: 190, borderRadius: 26, display: 'block' }} />
                </div>
              ))}
            </motion.div>
          </div>
        </div>
        <style>{`
          @media (max-width: 900px) { .hero-phones { display: none !important; } }
          @media (max-width: 640px) { .hero-grid { grid-template-columns: 1fr !important; } }
        `}</style>
      </section>

      {/* ── STATS BAR ── */}
      <section style={{ background: 'linear-gradient(135deg, #7B2FB8, #BF6EEE)', padding: '2.5rem 1.5rem' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto', display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '1.5rem', textAlign: 'center' }}>
          {[
            { v: '1 in 3', l: 'Women experience violence' },
            { v: '81%', l: 'Face harassment' },
            { v: '24/7', l: 'Guardian support' },
            { v: '$3.99', l: 'Per month' },
          ].map((s, i) => (
            <motion.div key={i} initial={{ opacity: 0, y: 15 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.08 }}>
              <div style={{ fontSize: 'clamp(1.8rem, 3.5vw, 2.6rem)', fontWeight: 900, color: '#fff' }}>{s.v}</div>
              <div style={{ color: 'rgba(255,255,255,0.75)', fontSize: 13, marginTop: 6 }}>{s.l}</div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* ── HOW IT WORKS ── */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3.5rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(191,110,238,0.1)', color: '#BF6EEE', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              How It Works
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.7rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 12 }}>
              Safety in 4 simple steps
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, maxWidth: 480, margin: '0 auto' }}>
              From opening the app to feeling safe — it takes seconds.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '1.5rem' }}>
            {steps.map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.1 }}
                style={{ background: '#FAF5FF', borderRadius: 20, padding: '2rem 1.5rem', textAlign: 'center' }}>
                <div style={{ width: 48, height: 48, borderRadius: '50%', background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)', color: '#fff', fontWeight: 900, fontSize: 20, display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 16px' }}>{s.num}</div>
                <div style={{ fontWeight: 800, fontSize: 17, color: '#1a1a2e', marginBottom: 8 }}>{s.title}</div>
                <div style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.6 }}>{s.desc}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* ── APP SCREENS SHOWCASE ── */}
      <section style={{ padding: '5rem 1.5rem', background: '#FAF5FF', overflow: 'hidden' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.7rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 12 }}>
              See the app in action
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16 }}>Real screens from the Kinnav app</motion.p>
          </motion.div>

          <div style={{ display: 'flex', gap: '1.5rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            {[
              { src: '/images/screen-login.jpg', label: 'Join Kinnav' },
              { src: '/images/screen-map-guardians.jpg', label: 'Guardian Map' },
              { src: '/images/screen-reach-guardian.jpg', label: 'Reach a Guardian' },
              { src: '/images/screen-rewards.jpg', label: 'Rewards' },
              { src: '/images/screen-membership.jpg', label: 'Membership' },
            ].map(({ src, label }, i) => (
              <motion.div key={src}
                initial={{ opacity: 0, y: 30 }} whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }} transition={{ delay: i * 0.08 }}
                style={{ textAlign: 'center' }}>
                <div style={{
                  background: '#1E0838', borderRadius: 28, padding: 6,
                  boxShadow: '0 20px 50px rgba(191,110,238,0.25)',
                  display: 'inline-block',
                }}>
                  <img src={src} alt={label} style={{ width: 150, borderRadius: 22, display: 'block' }} />
                </div>
                <div style={{ marginTop: 12, fontSize: 13, fontWeight: 600, color: '#6B7280' }}>{label}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* ── FEATURES ── */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(191,110,238,0.1)', color: '#BF6EEE', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              Features
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.7rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e' }}>
              Everything in one app
            </motion.h2>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.25rem' }}>
            {features.map((f, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.07 }}
                style={{ background: '#FAF5FF', borderRadius: 18, padding: '1.5rem', display: 'flex', gap: 16, alignItems: 'flex-start' }}>
                <div style={{ width: 48, height: 48, borderRadius: 14, background: `${f.color}18`, color: f.color, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                  {f.icon}
                </div>
                <div>
                  <div style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 6 }}>{f.title}</div>
                  <div style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.6 }}>{f.desc}</div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* ── WHY KINNAV ── */}
      <section style={{ padding: '5rem 1.5rem', background: 'linear-gradient(135deg, #1E0838, #4A1690)' }}>
        <div style={{ maxWidth: 900, margin: '0 auto', textAlign: 'center' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.6rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
              The only app that does all three
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.65)', fontSize: 16, marginBottom: '2.5rem' }}>
              Other apps do one thing. Kinnav does everything.
            </motion.p>

            <motion.div variants={fadeUp} style={{ overflowX: 'auto' }}>
              <table style={{ width: '100%', borderCollapse: 'collapse', color: '#fff', fontSize: 15 }}>
                <thead>
                  <tr>
                    {['App', 'Safety', 'Empowerment', 'Rewards'].map(h => (
                      <th key={h} style={{ padding: '12px 16px', textAlign: h === 'App' ? 'left' : 'center', color: 'rgba(255,255,255,0.5)', fontWeight: 600, fontSize: 13, borderBottom: '1px solid rgba(255,255,255,0.1)' }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {[
                    { name: 'bSafe / Noonlight', s: true, e: false, r: false },
                    { name: 'InnerHour', s: false, e: true, r: false },
                    { name: 'Unidays / Drop', s: false, e: false, r: true },
                    { name: 'Kinnav 💜', s: true, e: true, r: true, highlight: true },
                  ].map(row => (
                    <tr key={row.name} style={{ background: row.highlight ? 'rgba(191,110,238,0.2)' : 'transparent', borderRadius: 12 }}>
                      <td style={{ padding: '14px 16px', fontWeight: row.highlight ? 800 : 500, color: row.highlight ? '#E3CCFA' : 'rgba(255,255,255,0.7)', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>{row.name}</td>
                      {[row.s, row.e, row.r].map((v, i) => (
                        <td key={i} style={{ padding: '14px 16px', textAlign: 'center', borderBottom: '1px solid rgba(255,255,255,0.06)' }}>
                          {v ? <span style={{ color: '#D4A5F5', fontSize: 20 }}>✓</span> : <span style={{ color: 'rgba(255,255,255,0.2)', fontSize: 18 }}>—</span>}
                        </td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* ── EARLY ACCESS CTA ── */}
      <section style={{ padding: '5rem 1.5rem', background: '#FAF5FF', textAlign: 'center' }}>
        <div style={{ maxWidth: 640, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.div variants={fadeUp} style={{ fontSize: 48, marginBottom: 16 }}>💜</motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.7rem, 3vw, 2.4rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 14 }}>
              Be first to use Kinnav
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7, marginBottom: 32 }}>
              The prototype is ready. Join the waitlist and we'll let you know the moment the full app launches.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 14, justifyContent: 'center', flexWrap: 'wrap' }}>
              <Link to="/waitlist" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 36px', borderRadius: 50,
                background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)',
                color: '#fff', fontWeight: 700, fontSize: 16, textDecoration: 'none',
                boxShadow: '0 8px 30px rgba(191,110,238,0.35)',
              }}>
                Join the Waitlist 💜
              </Link>
              <Link to="/contact" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 36px', borderRadius: 50,
                border: '2px solid #BF6EEE', color: '#BF6EEE', fontWeight: 700, fontSize: 16, textDecoration: 'none',
              }}>
                Contact Us
              </Link>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
