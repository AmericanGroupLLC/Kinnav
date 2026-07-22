import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Phone, Video, MessageSquare, AlertTriangle, Map, Shield, Users, BookOpen, Gift, Star, ArrowRight } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}

const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const callTypes = [
  { icon: <Phone size={24} />, title: 'Voice Call', desc: 'Audio-only call with nearby guardians. Private, immediate, and discreet.', color: '#9B59D0' },
  { icon: <Video size={24} />, title: 'Video Call', desc: 'Face-to-face with guardians. They can see your environment and stay present.', color: '#7B3FBE' },
  { icon: <MessageSquare size={24} />, title: 'Text Message', desc: 'Chat with a guardian when you can\'t speak. Quick replies, always available.', color: '#B57BE0' },
  { icon: <AlertTriangle size={24} />, title: 'Emergency', desc: 'Immediate escalation — video call + police notification. For critical situations.', color: '#E53935' },
]

const guardianSteps = [
  { num: '01', title: 'Apply to Become a Guardian', desc: 'Women 18+ can apply through the app. Background check and eligibility review.' },
  { num: '02', title: 'Complete 40-Hour Course', desc: 'Virtual advocacy training through NGO-certified programs. Learn to support women in crisis.' },
  { num: '03', title: 'Get Verified & Go Online', desc: 'Once verified, you appear on the guardian map. Toggle availability when you\'re ready to help.' },
  { num: '04', title: 'Earn for Helping', desc: 'Guardians are paid for their time and support. A meaningful way to earn while making a difference.' },
]

const modules = [
  { title: 'Safety Planning', topics: ['Types of abuse', 'Emotional safety', 'Physical safety', 'Future without fear'] },
  { title: 'Self Defense', topics: ['Basic techniques', 'Situational awareness', 'Escape strategies', 'Confidence building'] },
  { title: 'Assertive Communication', topics: ['Setting boundaries', 'Saying no', 'Conflict de-escalation', 'Workplace safety'] },
  { title: 'Tech Abuse Awareness', topics: ['Digital safety', 'Online harassment', 'Privacy protection', 'Reporting tools'] },
  { title: 'Self Care & Wellness', topics: ['Sleep strategies', 'Reflective practices', 'Low-cost self care', 'Mindfulness'] },
  { title: 'Workforce & Career', topics: ['Professionalism', 'Career development', 'Financial training', 'ESL support'] },
]

const rewards = [
  'Meditation & Mindfulness', 'Yoga Classes', 'Dance Therapy', 'Counseling Sessions',
  'Healthy Cooking', 'Visual Arts & Theater', 'Career Coaching', 'ESL Training',
  'Financial Training', 'Computer Skills', 'Entrepreneurship', 'Wellness Deals',
]

export default function HowItWorks() {
  return (
    <div style={{ paddingTop: 72 }}>
      {/* Hero */}
      <section style={{
        background: 'linear-gradient(135deg, #1a0533 0%, #3d1278 50%, #6A1B9A 100%)',
        padding: '5rem 1.5rem',
        textAlign: 'center',
      }}>
        <div style={{ maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
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
              App Walkthrough
            </motion.div>
            <motion.h1 variants={fadeUp} style={{
              fontSize: 'clamp(2rem, 4vw, 3.5rem)',
              fontWeight: 900,
              color: '#fff',
              lineHeight: 1.15,
              marginBottom: 20,
            }}>
              How Safer Works
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.75)', lineHeight: 1.7 }}>
              From the moment you open the app to the moment you feel safe — here's exactly what happens.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Main Flow */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '5rem', alignItems: 'center', marginBottom: '6rem' }} className="two-col">
            <motion.div initial={{ opacity: 0, x: -40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}>
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
                Step 1
              </div>
              <h2 style={{ fontSize: 'clamp(1.6rem, 3vw, 2.4rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Open the app & see guardians nearby
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 20 }}>
                The home screen shows a live map with vetted guardians nearby. You can see their avatars, how many are online, and their distance from you — all in real time.
              </p>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8 }}>
                A first-run coach mark guides new users: "You will see yourself and nearby guardians on the map." The large purple CALL GUARDIANS button is always front and center.
              </p>
            </motion.div>
            <motion.div initial={{ opacity: 0, x: 40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}
              style={{ display: 'flex', justifyContent: 'center' }}>
              <div style={{
                background: '#1a0533', borderRadius: 36, padding: 10,
                boxShadow: '0 30px 80px rgba(155,89,208,0.3)',
              }}>
                <img src="/images/screen-home-map.jpeg" alt="Home map screen" style={{ width: 240, borderRadius: 28 }} />
              </div>
            </motion.div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '5rem', alignItems: 'center', marginBottom: '6rem' }} className="two-col two-col-reverse">
            <motion.div initial={{ opacity: 0, x: -40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}
              style={{ display: 'flex', justifyContent: 'center' }}>
              <div style={{
                background: '#1a0533', borderRadius: 36, padding: 10,
                boxShadow: '0 30px 80px rgba(155,89,208,0.3)',
              }}>
                <img src="/images/screen-safecall-map.jpeg" alt="Safe call map screen" style={{ width: 240, borderRadius: 28 }} />
              </div>
            </motion.div>
            <motion.div initial={{ opacity: 0, x: 40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}>
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
                Step 2
              </div>
              <h2 style={{ fontSize: 'clamp(1.6rem, 3vw, 2.4rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Choose how to connect
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 24 }}>
                Tap CALL GUARDIANS and choose your contact method. Slide to activate and guardians are immediately notified.
              </p>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                {callTypes.map((ct, i) => (
                  <div key={i} style={{
                    background: '#F9F5FF',
                    borderRadius: 12,
                    padding: '1rem',
                    border: `1px solid ${ct.color}20`,
                  }}>
                    <div style={{ color: ct.color, marginBottom: 8 }}>{ct.icon}</div>
                    <div style={{ fontWeight: 700, fontSize: 14, color: '#1a1a2e', marginBottom: 4 }}>{ct.title}</div>
                    <div style={{ fontSize: 13, color: '#6B7280', lineHeight: 1.5 }}>{ct.desc}</div>
                  </div>
                ))}
              </div>
            </motion.div>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '5rem', alignItems: 'center' }} className="two-col">
            <motion.div initial={{ opacity: 0, x: -40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}>
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
                Step 3
              </div>
              <h2 style={{ fontSize: 'clamp(1.6rem, 3vw, 2.4rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Guardians join your Safe Call
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 20 }}>
                Multiple guardians join a multi-party call. You can see them on the map converging toward your location, then switch to a video grid view to see their faces.
              </p>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8 }}>
                Add police to the call if needed. Your safety contacts are automatically notified with your live location. Guardians stay with you — no time limit, no judgment.
              </p>
            </motion.div>
            <motion.div initial={{ opacity: 0, x: 40 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }}
              style={{ display: 'flex', justifyContent: 'center' }}>
              <div style={{
                background: '#1a0533', borderRadius: 36, padding: 10,
                boxShadow: '0 30px 80px rgba(155,89,208,0.3)',
              }}>
                <img src="/images/screen-safecall.jpeg" alt="Safe call video grid" style={{ width: 240, borderRadius: 28 }} />
              </div>
            </motion.div>
          </div>
        </div>

        <style>{`
          @media (max-width: 768px) {
            .two-col { grid-template-columns: 1fr !important; gap: 2rem !important; }
            .two-col-reverse > *:first-child { order: 2; }
            .two-col-reverse > *:last-child { order: 1; }
          }
        `}</style>
      </section>

      {/* Become a Guardian */}
      <section style={{ padding: '6rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
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
              Guardian Program
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Become a Guardian
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', maxWidth: 600, margin: '0 auto' }}>
              Vetted women 18+ who complete a 40-hour advocacy course. Get paid for helping. Be part of a movement.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '2rem' }}>
            {guardianSteps.map((step, i) => (
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
                }}
              >
                <div style={{
                  fontSize: 36, fontWeight: 900,
                  background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                  WebkitBackgroundClip: 'text',
                  WebkitTextFillColor: 'transparent',
                  backgroundClip: 'text',
                  marginBottom: 16,
                }}>
                  {step.num}
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 17, color: '#1a1a2e', marginBottom: 12 }}>{step.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7 }}>{step.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Empowerment Modules */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '5rem', alignItems: 'start' }}
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
                Empowerment
              </div>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Self Care & Empowerment Modules
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 32 }}>
                Beyond safety, Safer empowers women with structured learning modules covering everything from self-defense to career development. NGO-created content, accessible anytime.
              </p>
              <img
                src="/images/empowerment-modules.jpg"
                alt="Empowerment modules"
                style={{ width: '100%', borderRadius: 20, boxShadow: '0 20px 60px rgba(155,89,208,0.2)' }}
              />
            </motion.div>

            <motion.div variants={fadeUp}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                {modules.map((m, i) => (
                  <div key={i} style={{
                    background: '#F9F5FF',
                    borderRadius: 16,
                    padding: '1.25rem',
                    border: '1px solid rgba(155,89,208,0.1)',
                  }}>
                    <div style={{ fontWeight: 800, fontSize: 14, color: '#9B59D0', marginBottom: 10 }}>{m.title}</div>
                    {m.topics.map((t, j) => (
                      <div key={j} style={{ fontSize: 12, color: '#6B7280', marginBottom: 4, display: 'flex', alignItems: 'center', gap: 6 }}>
                        <span style={{ width: 4, height: 4, borderRadius: '50%', background: '#B57BE0', flexShrink: 0 }} />
                        {t}
                      </div>
                    ))}
                  </div>
                ))}
              </div>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Rewards */}
      <section style={{ padding: '6rem 1.5rem', background: 'linear-gradient(135deg, #6A1B9A, #9B59D0)' }}>
        <div style={{ maxWidth: 900, margin: '0 auto', textAlign: 'center' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
          >
            <motion.div variants={fadeUp} style={{
              display: 'inline-block',
              background: 'rgba(255,255,255,0.15)',
              color: '#fff',
              borderRadius: 50,
              padding: '6px 16px',
              fontSize: 13,
              fontWeight: 700,
              letterSpacing: 1.5,
              textTransform: 'uppercase',
              marginBottom: 20,
            }}>
              Rewards Program
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
              Wellness & Lifestyle Rewards
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.8)', fontSize: 17, marginBottom: 40, maxWidth: 600, margin: '0 auto 40px' }}>
              Safer rewards you for staying empowered. Earn discounts and access to wellness services just for using the app.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', flexWrap: 'wrap', gap: 12, justifyContent: 'center' }}>
              {rewards.map((r, i) => (
                <span key={i} style={{
                  background: 'rgba(255,255,255,0.15)',
                  border: '1px solid rgba(255,255,255,0.25)',
                  borderRadius: 50,
                  padding: '8px 16px',
                  color: '#fff',
                  fontSize: 14,
                  fontWeight: 600,
                }}>
                  {r}
                </span>
              ))}
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Subscription */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 800, margin: '0 auto', textAlign: 'center' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
          >
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Simple, affordable pricing
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', marginBottom: 48 }}>
              Full access to all safety features, empowerment modules, and rewards.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '2rem', maxWidth: 600, margin: '0 auto' }} className="two-col">
              {[
                { period: 'Monthly', price: '$3.99', sub: 'per month', badge: null },
                { period: 'Annual', price: '$39.99', sub: 'per year — save 17%', badge: 'Best Value' },
              ].map((plan, i) => (
                <div key={i} style={{
                  background: i === 1 ? 'linear-gradient(135deg, #B57BE0, #9B59D0)' : '#F9F5FF',
                  borderRadius: 24,
                  padding: '2.5rem 2rem',
                  border: i === 1 ? 'none' : '2px solid rgba(155,89,208,0.15)',
                  position: 'relative',
                  textAlign: 'center',
                }}>
                  {plan.badge && (
                    <div style={{
                      position: 'absolute', top: -12, left: '50%', transform: 'translateX(-50%)',
                      background: '#E91E8C', color: '#fff', borderRadius: 50,
                      padding: '4px 16px', fontSize: 12, fontWeight: 700,
                    }}>
                      {plan.badge}
                    </div>
                  )}
                  <div style={{ fontSize: 16, fontWeight: 700, color: i === 1 ? 'rgba(255,255,255,0.8)' : '#9B59D0', marginBottom: 8 }}>{plan.period}</div>
                  <div style={{ fontSize: 48, fontWeight: 900, color: i === 1 ? '#fff' : '#1a1a2e', lineHeight: 1 }}>{plan.price}</div>
                  <div style={{ fontSize: 14, color: i === 1 ? 'rgba(255,255,255,0.7)' : '#9B7AB0', marginTop: 8 }}>{plan.sub}</div>
                </div>
              ))}
            </motion.div>
            <motion.p variants={fadeUp} style={{ marginTop: 32, fontSize: 15, color: '#9B7AB0' }}>
              Join the early access waitlist — be first when Safer launches.
            </motion.p>
            <motion.div variants={fadeUp} style={{ marginTop: 24 }}>
              <Link to="/grant-funding" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                color: '#fff', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
                boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
              }}>
                Support the Build <ArrowRight size={18} />
              </Link>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
