import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Shield, Phone, Map, Star, Users, BookOpen, Gift, ArrowRight, CheckCircle, ChevronRight } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}

const stagger = {
  visible: { transition: { staggerChildren: 0.15 } },
}

const stats = [
  { value: '1 in 3', label: 'Women experience violence in their lifetime' },
  { value: '81%', label: 'Of women have experienced harassment' },
  { value: '24/7', label: 'Guardian support, no time limit, no judgment' },
  { value: '10mi', label: 'Guardian radius — always someone nearby' },
]

const features = [
  {
    icon: <Map size={28} />,
    title: 'Live Guardian Map',
    desc: 'See vetted guardians nearby on a live map. Real-time presence, real people, real support — available the moment you need them.',
    color: '#9B59D0',
  },
  {
    icon: <Phone size={28} />,
    title: 'Safe Call System',
    desc: 'One tap connects you to multiple guardians via voice or video. Add police if needed. Guardians stay until you feel safe — no time limit.',
    color: '#7B3FBE',
  },
  {
    icon: <Shield size={28} />,
    title: 'Emergency Escalation',
    desc: 'Instantly escalate to emergency services with a single tap. Your safety contacts are automatically notified with your live location.',
    color: '#E53935',
  },
  {
    icon: <BookOpen size={28} />,
    title: 'Empowerment Modules',
    desc: 'Self-defense techniques, assertive communication, safety planning, sleep strategies, and more — all in one app.',
    color: '#6A1B9A',
  },
  {
    icon: <Users size={28} />,
    title: 'Guardian Community',
    desc: 'Become a vetted guardian. Complete a 40-hour advocacy course, get paid for helping, and be part of a movement that protects women.',
    color: '#B57BE0',
  },
  {
    icon: <Gift size={28} />,
    title: 'Wellness Rewards',
    desc: 'Earn rewards for staying safe and empowered. Yoga, counseling, dance therapy, career coaching, ESL training, and more.',
    color: '#9B59D0',
  },
]

const howSteps = [
  { num: '01', title: 'Press a Button', desc: 'Open Safer and tap CALL GUARDIANS. That\'s all it takes to start.' },
  { num: '02', title: 'Guardians Connect', desc: 'Vetted guardians nearby join your call within seconds — via voice or video.' },
  { num: '03', title: 'Stay With You', desc: 'Guardians stay on the call until you feel completely safe. No time limit, no judgment.' },
  { num: '04', title: 'Back to Safety', desc: 'Thank your guardians and end the call. You\'re safe. That\'s the Safer promise.' },
]

const competitors = [
  { name: 'bSafe / Noonlight', safety: true, empowerment: false, rewards: false },
  { name: 'Unidays / Drop', safety: false, empowerment: false, rewards: true },
  { name: 'InnerHour', safety: false, empowerment: true, rewards: false },
  { name: 'Safer 💜', safety: true, empowerment: true, rewards: true, highlight: true },
]

export default function Home() {
  return (
    <div>
      {/* Hero Section */}
      <section style={{
        position: 'relative',
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        overflow: 'hidden',
      }}>
        {/* Background */}
        <div style={{
          position: 'absolute', inset: 0,
          backgroundImage: 'url(/images/hero-bg.jpg)',
          backgroundSize: 'cover',
          backgroundPosition: 'center top',
        }} />
        <div style={{
          position: 'absolute', inset: 0,
          background: 'linear-gradient(135deg, rgba(26,5,51,0.92) 0%, rgba(61,18,120,0.85) 40%, rgba(106,27,154,0.75) 70%, rgba(155,89,208,0.6) 100%)',
        }} />

        <div style={{ position: 'relative', zIndex: 1, maxWidth: 1200, margin: '0 auto', padding: '8rem 1.5rem 5rem', width: '100%' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr auto', gap: '4rem', alignItems: 'center' }}>
            <motion.div initial="hidden" animate="visible" variants={stagger}>
              <motion.div variants={fadeUp} style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                background: 'rgba(181,123,224,0.2)',
                border: '1px solid rgba(181,123,224,0.4)',
                borderRadius: 50, padding: '8px 16px',
                marginBottom: 24, color: '#D8C4F0', fontSize: 14, fontWeight: 600,
              }}>
                <Shield size={16} style={{ color: '#B57BE0' }} />
                Women's Safety · Empowerment · Rewards
              </motion.div>

              <motion.h1 variants={fadeUp} style={{
                fontSize: 'clamp(2.5rem, 5vw, 4rem)',
                fontWeight: 900,
                color: '#fff',
                lineHeight: 1.1,
                marginBottom: 24,
                letterSpacing: -1,
              }}>
                It's easier to look forward
                <br />
                <span style={{
                  background: 'linear-gradient(135deg, #D8C4F0, #B57BE0)',
                  WebkitBackgroundClip: 'text',
                  WebkitTextFillColor: 'transparent',
                  backgroundClip: 'text',
                }}>
                  when you don't have to
                </span>
                <br />
                watch your back.
              </motion.h1>

              <motion.p variants={fadeUp} style={{
                fontSize: 18, color: 'rgba(255,255,255,0.8)',
                lineHeight: 1.7, marginBottom: 40, maxWidth: 560,
              }}>
                Safer is an all-in-one women's safety, empowerment, and rewards app. One tap connects you to vetted guardians nearby — via voice or video — who stay with you until you feel safe. No time limit. No judgment.
              </motion.p>

              <motion.div variants={fadeUp} style={{ display: 'flex', flexWrap: 'wrap', gap: 16 }}>
                <Link to="/how-it-works" style={{
                  display: 'inline-flex', alignItems: 'center', gap: 8,
                  padding: '14px 32px', borderRadius: 50,
                  background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                  color: '#fff', fontWeight: 700, fontSize: 16,
                  textDecoration: 'none',
                  boxShadow: '0 8px 30px rgba(155,89,208,0.5)',
                }}>
                  See How It Works <ArrowRight size={18} />
                </Link>
                <Link to="/grant-funding" style={{
                  display: 'inline-flex', alignItems: 'center', gap: 8,
                  padding: '14px 32px', borderRadius: 50,
                  background: 'rgba(255,255,255,0.12)',
                  border: '1px solid rgba(255,255,255,0.3)',
                  color: '#fff', fontWeight: 700, fontSize: 16,
                  textDecoration: 'none',
                  backdropFilter: 'blur(8px)',
                }}>
                  Support Our Mission 💜
                </Link>
              </motion.div>

              {/* App store badges placeholder */}
              <motion.div variants={fadeUp} style={{ marginTop: 32, display: 'flex', gap: 12, flexWrap: 'wrap' }}>
                <div style={{
                  background: 'rgba(255,255,255,0.1)',
                  border: '1px solid rgba(255,255,255,0.2)',
                  borderRadius: 12, padding: '10px 20px',
                  color: 'rgba(255,255,255,0.7)', fontSize: 13, fontWeight: 600,
                }}>
                  📱 iOS — Coming Soon
                </div>
                <div style={{
                  background: 'rgba(255,255,255,0.1)',
                  border: '1px solid rgba(255,255,255,0.2)',
                  borderRadius: 12, padding: '10px 20px',
                  color: 'rgba(255,255,255,0.7)', fontSize: 13, fontWeight: 600,
                }}>
                  🤖 Android — Coming Soon
                </div>
              </motion.div>
            </motion.div>

            {/* Phone mockup */}
            <motion.div
              initial={{ opacity: 0, x: 60 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8, delay: 0.3 }}
              style={{ display: 'flex', gap: 16 }}
              className="hero-phones"
            >
              <div style={{
                background: '#1a0533',
                borderRadius: 36,
                padding: 8,
                boxShadow: '0 30px 80px rgba(0,0,0,0.6), 0 0 0 1px rgba(181,123,224,0.3)',
                transform: 'translateY(20px)',
              }}>
                <img
                  src="/images/screen-home-map.jpeg"
                  alt="Safer home map screen"
                  style={{ width: 200, borderRadius: 28, display: 'block' }}
                />
              </div>
              <div style={{
                background: '#1a0533',
                borderRadius: 36,
                padding: 8,
                boxShadow: '0 30px 80px rgba(0,0,0,0.6), 0 0 0 1px rgba(181,123,224,0.3)',
                transform: 'translateY(-20px)',
              }}>
                <img
                  src="/images/screen-safecall.jpeg"
                  alt="Safer safe call screen"
                  style={{ width: 200, borderRadius: 28, display: 'block' }}
                />
              </div>
            </motion.div>
          </div>
        </div>

        <style>{`
          @media (max-width: 900px) {
            .hero-phones { display: none !important; }
          }
        `}</style>
      </section>

      {/* Stats Bar */}
      <section style={{ background: 'linear-gradient(135deg, #6A1B9A, #9B59D0)', padding: '3rem 1.5rem' }}>
        <div style={{ maxWidth: 1200, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '2rem' }}>
            {stats.map((s, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                style={{ textAlign: 'center' }}
              >
                <div style={{ fontSize: 'clamp(2rem, 4vw, 3rem)', fontWeight: 900, color: '#fff', lineHeight: 1 }}>{s.value}</div>
                <div style={{ color: 'rgba(255,255,255,0.75)', fontSize: 14, marginTop: 8, lineHeight: 1.4 }}>{s.label}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* The Problem / Mission */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1200, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '5rem', alignItems: 'center' }}
            className="two-col"
          >
            <motion.div variants={fadeUp}>
              <div style={{
                display: 'inline-block',
                background: 'rgba(155,89,208,0.1)',
                color: '#9B59D0',
                borderRadius: 50,
                padding: '6px 16px',
                fontSize: 13,
                fontWeight: 700,
                letterSpacing: 1.5,
                textTransform: 'uppercase',
                marginBottom: 20,
              }}>
                The Mission
              </div>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', lineHeight: 1.2, marginBottom: 24 }}>
                A new way of women's safety and empowerment
              </h2>
              <p style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 20 }}>
                Every woman deserves to feel safe — walking home at night, on campus, at work, anywhere. Yet millions face unsafe situations daily with no immediate support system.
              </p>
              <p style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 32 }}>
                Safer bridges that gap with a community of vetted guardians, real-time connection technology, and empowerment resources — all in one app. Not just safety. Not just wellness. Both, together.
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
                {[
                  'Vetted guardians trained through a 40-hour advocacy course',
                  'No time limit — guardians stay until you feel safe',
                  'Safety + Empowerment + Rewards in one platform',
                  'Built for universities, corporates, and individuals',
                ].map((item, i) => (
                  <div key={i} style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                    <CheckCircle size={20} style={{ color: '#9B59D0', flexShrink: 0, marginTop: 2 }} />
                    <span style={{ color: '#374151', fontSize: 15 }}>{item}</span>
                  </div>
                ))}
              </div>
            </motion.div>

            <motion.div variants={fadeUp}>
              <img
                src="/images/guardian-network.jpg"
                alt="Guardian network"
                style={{ width: '100%', borderRadius: 24, boxShadow: '0 20px 60px rgba(155,89,208,0.25)' }}
              />
            </motion.div>
          </motion.div>
        </div>
        <style>{`
          @media (max-width: 768px) {
            .two-col { grid-template-columns: 1fr !important; gap: 2rem !important; }
          }
        `}</style>
      </section>

      {/* Features Grid */}
      <section style={{ padding: '6rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1200, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ textAlign: 'center', marginBottom: '4rem' }}
          >
            <motion.div variants={fadeUp} style={{
              display: 'inline-block',
              background: 'rgba(155,89,208,0.1)',
              color: '#9B59D0',
              borderRadius: 50,
              padding: '6px 16px',
              fontSize: 13,
              fontWeight: 700,
              letterSpacing: 1.5,
              textTransform: 'uppercase',
              marginBottom: 20,
            }}>
              App Features
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Everything a woman needs to feel safe
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', maxWidth: 600, margin: '0 auto' }}>
              Safer is the only app that combines real-time safety, personal empowerment, and lifestyle rewards in one seamless experience.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem' }}>
            {features.map((f, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                style={{
                  background: '#fff',
                  borderRadius: 20,
                  padding: '2rem',
                  boxShadow: '0 4px 20px rgba(155,89,208,0.08)',
                  border: '1px solid rgba(155,89,208,0.1)',
                  transition: 'transform 0.2s, box-shadow 0.2s',
                }}
                whileHover={{ y: -4, boxShadow: '0 12px 40px rgba(155,89,208,0.2)' }}
              >
                <div style={{
                  width: 56, height: 56, borderRadius: 16,
                  background: `${f.color}15`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: f.color, marginBottom: 20,
                }}>
                  {f.icon}
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 18, color: '#1a1a2e', marginBottom: 12 }}>{f.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7 }}>{f.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works — Quick Preview */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1200, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ textAlign: 'center', marginBottom: '4rem' }}
          >
            <motion.div variants={fadeUp} style={{
              display: 'inline-block',
              background: 'rgba(155,89,208,0.1)',
              color: '#9B59D0',
              borderRadius: 50,
              padding: '6px 16px',
              fontSize: 13,
              fontWeight: 700,
              letterSpacing: 1.5,
              textTransform: 'uppercase',
              marginBottom: 20,
            }}>
              How It Works
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Safety in four simple steps
            </motion.h2>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '2rem' }}>
            {howSteps.map((step, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.15 }}
                style={{ textAlign: 'center', padding: '2rem 1.5rem' }}
              >
                <div style={{
                  width: 64, height: 64, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 20px',
                  fontSize: 20, fontWeight: 900, color: '#fff',
                  boxShadow: '0 8px 24px rgba(155,89,208,0.35)',
                }}>
                  {step.num}
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 18, color: '#1a1a2e', marginBottom: 12 }}>{step.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7 }}>{step.desc}</p>
              </motion.div>
            ))}
          </div>

          <div style={{ textAlign: 'center', marginTop: '3rem' }}>
            <Link to="/how-it-works" style={{
              display: 'inline-flex', alignItems: 'center', gap: 8,
              padding: '14px 32px', borderRadius: 50,
              background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
              color: '#fff', fontWeight: 700, fontSize: 16,
              textDecoration: 'none',
              boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
            }}>
              Full App Walkthrough <ArrowRight size={18} />
            </Link>
          </div>
        </div>
      </section>

      {/* Competitive Advantage */}
      <section style={{ padding: '6rem 1.5rem', background: 'linear-gradient(135deg, #1a0533, #3d1278)' }}>
        <div style={{ maxWidth: 900, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ textAlign: 'center', marginBottom: '3rem' }}
          >
            <motion.div variants={fadeUp} style={{
              display: 'inline-block',
              background: 'rgba(181,123,224,0.2)',
              color: '#D8C4F0',
              borderRadius: 50,
              padding: '6px 16px',
              fontSize: 13,
              fontWeight: 700,
              letterSpacing: 1.5,
              textTransform: 'uppercase',
              marginBottom: 20,
            }}>
              The Sweet Spot
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
              The only all-in-one platform
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.7)', fontSize: 17, maxWidth: 500, margin: '0 auto' }}>
              Competitors do one thing. Safer does all three.
            </motion.p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            style={{
              background: 'rgba(255,255,255,0.06)',
              border: '1px solid rgba(181,123,224,0.2)',
              borderRadius: 20,
              overflow: 'hidden',
            }}
          >
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr style={{ background: 'rgba(155,89,208,0.2)' }}>
                  <th style={{ padding: '16px 24px', textAlign: 'left', color: 'rgba(255,255,255,0.7)', fontSize: 14, fontWeight: 600 }}>App</th>
                  <th style={{ padding: '16px 24px', textAlign: 'center', color: 'rgba(255,255,255,0.7)', fontSize: 14, fontWeight: 600 }}>Safety</th>
                  <th style={{ padding: '16px 24px', textAlign: 'center', color: 'rgba(255,255,255,0.7)', fontSize: 14, fontWeight: 600 }}>Empowerment</th>
                  <th style={{ padding: '16px 24px', textAlign: 'center', color: 'rgba(255,255,255,0.7)', fontSize: 14, fontWeight: 600 }}>Rewards</th>
                </tr>
              </thead>
              <tbody>
                {competitors.map((c, i) => (
                  <tr key={i} style={{
                    borderTop: '1px solid rgba(255,255,255,0.08)',
                    background: c.highlight ? 'rgba(155,89,208,0.15)' : 'transparent',
                  }}>
                    <td style={{ padding: '16px 24px', color: c.highlight ? '#D8C4F0' : 'rgba(255,255,255,0.7)', fontWeight: c.highlight ? 800 : 400, fontSize: 15 }}>{c.name}</td>
                    {['safety', 'empowerment', 'rewards'].map(key => (
                      <td key={key} style={{ padding: '16px 24px', textAlign: 'center', fontSize: 20 }}>
                        {c[key] ? '✅' : '❌'}
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </motion.div>
        </div>
      </section>

      {/* App Screenshots */}
      <section style={{ padding: '6rem 1.5rem', background: '#F9F5FF', overflow: 'hidden' }}>
        <div style={{ maxWidth: 1200, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ textAlign: 'center', marginBottom: '4rem' }}
          >
            <motion.div variants={fadeUp} style={{
              display: 'inline-block',
              background: 'rgba(155,89,208,0.1)',
              color: '#9B59D0',
              borderRadius: 50,
              padding: '6px 16px',
              fontSize: 13,
              fontWeight: 700,
              letterSpacing: 1.5,
              textTransform: 'uppercase',
              marginBottom: 20,
            }}>
              App Preview
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              See Safer in action
            </motion.h2>
          </motion.div>

          <div style={{ display: 'flex', gap: '1.5rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            {[
              { src: '/images/screen-home-map.jpeg', label: 'Live Guardian Map' },
              { src: '/images/screen-safecall.jpeg', label: 'Safe Call — Video Grid' },
              { src: '/images/screen-safecall-map.jpeg', label: 'Safe Call — Map View' },
              { src: '/images/screen-howto.jpeg', label: 'How To Use' },
            ].map((s, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 40 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                style={{ textAlign: 'center' }}
              >
                <div style={{
                  background: '#1a0533',
                  borderRadius: 32,
                  padding: 8,
                  boxShadow: '0 20px 60px rgba(155,89,208,0.25)',
                  display: 'inline-block',
                }}>
                  <img src={s.src} alt={s.label} style={{ width: 160, borderRadius: 24, display: 'block' }} />
                </div>
                <div style={{ marginTop: 12, fontSize: 13, fontWeight: 600, color: '#6B7280' }}>{s.label}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Grant / Funding CTA */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 900, margin: '0 auto', textAlign: 'center' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
          >
            <motion.div variants={fadeUp} style={{
              display: 'inline-block',
              background: 'rgba(155,89,208,0.1)',
              color: '#9B59D0',
              borderRadius: 50,
              padding: '6px 16px',
              fontSize: 13,
              fontWeight: 700,
              letterSpacing: 1.5,
              textTransform: 'uppercase',
              marginBottom: 20,
            }}>
              Support the Mission
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 24 }}>
              Help us build the full Safer app
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 16, maxWidth: 700, margin: '0 auto 16px' }}>
              The Safer prototype is built. The vision is clear. Now we need grant funding and community support to bring the full production app to life — with real-time guardian calls, backend infrastructure, and global reach.
            </motion.p>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 40, maxWidth: 700, margin: '0 auto 40px' }}>
              Your donation supports <strong style={{ color: '#9B59D0' }}>EmbeddedOS Foundation</strong> — a 501(c)(3) nonprofit — to build the technology that powers Safer.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
              <Link to="/grant-funding#donate" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '16px 40px', borderRadius: 50,
                background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                color: '#fff', fontWeight: 700, fontSize: 17,
                textDecoration: 'none',
                boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
              }}>
                Donate Now 💜
              </Link>
              <Link to="/grant-funding" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '16px 40px', borderRadius: 50,
                border: '2px solid #9B59D0',
                color: '#9B59D0', fontWeight: 700, fontSize: 17,
                textDecoration: 'none',
              }}>
                View Grant Details <ChevronRight size={18} />
              </Link>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
