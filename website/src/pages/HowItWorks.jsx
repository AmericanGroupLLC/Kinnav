import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Phone, Video, MessageSquare, AlertTriangle, ArrowRight } from 'lucide-react'

const fadeUp = { hidden: { opacity: 0, y: 30 }, visible: { opacity: 1, y: 0, transition: { duration: 0.55 } } }
const stagger = { visible: { transition: { staggerChildren: 0.1 } } }

const callTypes = [
  { icon: <Phone size={22} />, title: 'Voice Call', desc: 'Audio only — private and discreet.', color: '#BF6EEE' },
  { icon: <Video size={22} />, title: 'Video Call', desc: 'Face-to-face with a guardian.', color: '#9A4FD8' },
  { icon: <MessageSquare size={22} />, title: 'Text Message', desc: 'Chat when you can\'t speak.', color: '#D4A5F5' },
  { icon: <AlertTriangle size={22} />, title: 'Emergency', desc: 'Video + police notification.', color: '#E53935' },
]

const guardianSteps = [
  { num: '01', title: 'Apply', desc: 'Women 18+ apply through the app.' },
  { num: '02', title: 'Train', desc: 'Complete a 40-hour virtual advocacy course.' },
  { num: '03', title: 'Go Online', desc: 'Appear on the guardian map when available.' },
  { num: '04', title: 'Earn', desc: 'Get paid for every call you take.' },
]

const modules = [
  'Safety Planning', 'Self Defense', 'Assertive Communication',
  'Tech Abuse Awareness', 'Self Care & Wellness', 'Workforce & Career',
]

const rewards = [
  'Yoga Classes', 'Meditation', 'Dance Therapy', 'Counseling',
  'Career Coaching', 'ESL Training', 'Financial Training', 'Wellness Deals',
]

export default function HowItWorks() {
  return (
    <div style={{ paddingTop: 72 }}>
      {/* Hero */}
      <section style={{ background: 'linear-gradient(135deg, #1E0838 0%, #4A1690 50%, #7B2FB8 100%)', padding: '4.5rem 1.5rem', textAlign: 'center' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(212,165,245,0.2)', color: '#E3CCFA', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              App Walkthrough
            </motion.div>
            <motion.h1 variants={fadeUp} style={{ fontSize: 'clamp(2rem, 4vw, 3rem)', fontWeight: 900, color: '#fff', lineHeight: 1.15, marginBottom: 16 }}>
              How Kinnav Works
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: 'rgba(255,255,255,0.7)', lineHeight: 1.7 }}>
              From opening the app to feeling safe — here's exactly what happens.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Safe Call Flow */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '4rem', alignItems: 'center' }} className="two-col">
            <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
              <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(191,110,238,0.1)', color: '#BF6EEE', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
                Safe Call
              </motion.div>
              <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                One tap to reach a guardian
              </motion.h2>
              <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7, marginBottom: 28 }}>
                Tap <strong style={{ color: '#BF6EEE' }}>CALL GUARDIANS</strong> on the home screen. Choose how you want to connect. A guardian joins within seconds and stays until you feel safe — no time limit.
              </motion.p>
              <motion.div variants={stagger} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
                {callTypes.map((c, i) => (
                  <motion.div key={i} variants={fadeUp} style={{ background: '#FAF5FF', borderRadius: 14, padding: '1rem', display: 'flex', gap: 10, alignItems: 'flex-start' }}>
                    <div style={{ color: c.color, marginTop: 2 }}>{c.icon}</div>
                    <div>
                      <div style={{ fontWeight: 700, fontSize: 14, color: '#1a1a2e' }}>{c.title}</div>
                      <div style={{ fontSize: 12, color: '#A98BC4', marginTop: 2 }}>{c.desc}</div>
                    </div>
                  </motion.div>
                ))}
              </motion.div>
            </motion.div>

            <motion.div initial={{ opacity: 0, x: 40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.6 }}
              style={{ display: 'flex', gap: 16, justifyContent: 'center' }}>
              {[
                { src: '/images/screen-map-guardians.jpg', alt: 'Guardian map', offset: 20 },
                { src: '/images/screen-reach-guardian.jpg', alt: 'Reach guardian', offset: -20 },
              ].map(({ src, alt, offset }) => (
                <div key={src} style={{ background: '#0d0020', borderRadius: 28, padding: 6, boxShadow: '0 20px 60px rgba(191,110,238,0.3)', transform: `translateY(${offset}px)` }}>
                  <img src={src} alt={alt} style={{ width: 160, borderRadius: 22, display: 'block' }} />
                </div>
              ))}
            </motion.div>
          </div>
        </div>
        <style>{`@media (max-width: 768px) { .two-col { grid-template-columns: 1fr !important; gap: 2rem !important; } }`}</style>
      </section>

      {/* Guardian Program */}
      <section style={{ padding: '5rem 1.5rem', background: '#FAF5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(191,110,238,0.1)', color: '#BF6EEE', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              Guardian Program
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 12 }}>
              Become a Guardian — get paid to help
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, maxWidth: 500, margin: '0 auto' }}>
              Women 18+ can apply, train, and earn by supporting other women in their community.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', gap: '1.25rem' }}>
            {guardianSteps.map((s, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.08 }}
                style={{ background: '#fff', borderRadius: 18, padding: '1.75rem 1.5rem', textAlign: 'center', boxShadow: '0 4px 20px rgba(191,110,238,0.08)' }}>
                <div style={{ fontSize: 13, fontWeight: 700, color: '#D4A5F5', letterSpacing: 2, marginBottom: 12 }}>{s.num}</div>
                <div style={{ fontWeight: 800, fontSize: 17, color: '#1a1a2e', marginBottom: 8 }}>{s.title}</div>
                <div style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.6 }}>{s.desc}</div>
              </motion.div>
            ))}
          </div>

          <motion.div initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: 0.3 }}
            style={{ marginTop: '2.5rem', background: 'linear-gradient(135deg, #BF6EEE, #7B2FB8)', borderRadius: 20, padding: '2rem', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 16 }}>
            <div>
              <div style={{ fontWeight: 800, fontSize: 20, color: '#fff', marginBottom: 6 }}>Ready to become a Guardian?</div>
              <div style={{ color: 'rgba(255,255,255,0.7)', fontSize: 15 }}>Available when the app launches. Join the waitlist now.</div>
            </div>
            <Link to="/waitlist" style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '12px 28px', borderRadius: 50, background: '#fff', color: '#BF6EEE', fontWeight: 700, fontSize: 15, textDecoration: 'none' }}>
              Join Waitlist <ArrowRight size={16} />
            </Link>
          </motion.div>
        </div>
      </section>

      {/* Empowerment Modules */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '4rem', alignItems: 'center' }} className="two-col">
            <motion.div initial={{ opacity: 0, x: -30 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.6 }}>
              <img src="/images/empowerment-modules.jpg" alt="Empowerment" style={{ width: '100%', borderRadius: 24, boxShadow: '0 20px 60px rgba(191,110,238,0.2)' }} />
            </motion.div>
            <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
              <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(191,110,238,0.1)', color: '#BF6EEE', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
                Empowerment
              </motion.div>
              <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Grow beyond safety
              </motion.h2>
              <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.7, marginBottom: 24 }}>
                Self-care modules to build confidence, skills, and independence.
              </motion.p>
              <motion.div variants={stagger} style={{ display: 'flex', flexWrap: 'wrap', gap: 10 }}>
                {modules.map((m, i) => (
                  <motion.div key={i} variants={fadeUp} style={{ background: '#FAF5FF', border: '1px solid #EFE0FB', borderRadius: 50, padding: '7px 16px', fontSize: 13, fontWeight: 600, color: '#7B2FB8' }}>{m}</motion.div>
                ))}
              </motion.div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Rewards */}
      <section style={{ padding: '5rem 1.5rem', background: '#FAF5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto', textAlign: 'center' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(191,110,238,0.1)', color: '#BF6EEE', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              Rewards
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 12 }}>
              Get safe. Get rewarded.
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, marginBottom: '2.5rem' }}>
              Earn wellness rewards just by staying safe and empowered.
            </motion.p>
            <motion.div variants={stagger} style={{ display: 'flex', flexWrap: 'wrap', gap: 12, justifyContent: 'center' }}>
              {rewards.map((r, i) => (
                <motion.div key={i} variants={fadeUp} style={{ background: '#fff', border: '1px solid #EFE0FB', borderRadius: 50, padding: '10px 20px', fontSize: 14, fontWeight: 600, color: '#7B2FB8', boxShadow: '0 2px 10px rgba(191,110,238,0.08)' }}>{r}</motion.div>
              ))}
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Pricing */}
      <section style={{ padding: '5rem 1.5rem', background: 'linear-gradient(135deg, #1E0838, #4A1690)', textAlign: 'center' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#fff', marginBottom: 12 }}>
              Simple pricing
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.65)', fontSize: 16, marginBottom: '2.5rem' }}>
              Full access to all features — safety, empowerment, and rewards.
            </motion.p>
            <motion.div variants={stagger} style={{ display: 'flex', gap: '1.5rem', justifyContent: 'center', flexWrap: 'wrap' }}>
              {[
                { label: 'Monthly', price: '$3.99', sub: 'per month' },
                { label: 'Annual', price: '$39.99', sub: 'per year — save 17%', highlight: true },
              ].map((p, i) => (
                <motion.div key={i} variants={fadeUp} style={{
                  background: p.highlight ? 'rgba(212,165,245,0.2)' : 'rgba(255,255,255,0.06)',
                  border: `1px solid ${p.highlight ? 'rgba(212,165,245,0.5)' : 'rgba(255,255,255,0.1)'}`,
                  borderRadius: 20, padding: '2rem 2.5rem', minWidth: 200,
                }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: p.highlight ? '#D4A5F5' : 'rgba(255,255,255,0.5)', letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 12 }}>{p.label}</div>
                  <div style={{ fontSize: 40, fontWeight: 900, color: '#fff', lineHeight: 1 }}>{p.price}</div>
                  <div style={{ fontSize: 13, color: 'rgba(255,255,255,0.5)', marginTop: 8 }}>{p.sub}</div>
                </motion.div>
              ))}
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
