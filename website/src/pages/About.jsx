import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Shield, Heart, Users, Star, Globe, ArrowRight } from 'lucide-react'

const fadeUp = { hidden: { opacity: 0, y: 30 }, visible: { opacity: 1, y: 0, transition: { duration: 0.55 } } }
const stagger = { visible: { transition: { staggerChildren: 0.1 } } }

const team = [
  {
    name: 'Shivani',
    role: 'Founder & Survivor',
    bio: 'A survivor herself, Shivani built Kinnav to ensure no woman ever faces an unsafe situation alone.',
    emoji: '💜',
    color: '#9B59D0',
  },
  {
    name: 'Vanshika',
    role: 'Marketing & Community',
    bio: 'Vanshika connects the Kinnav mission with the women who need it most through community and storytelling.',
    emoji: '🌟',
    color: '#B57BE0',
  },
]

const roles = [
  { title: 'Guardian', icon: <Shield size={24} />, desc: 'Vetted women 18+ who complete a 40-hour course and get paid to support others.', color: '#9B59D0' },
  { title: 'Community Manager', icon: <Users size={24} />, desc: 'Lead your local community — bring women together and champion safety.', color: '#7B3FBE' },
  { title: 'Campus Ambassador', icon: <Star size={24} />, desc: 'Bring Kinnav to your university and make campus safer for everyone.', color: '#B57BE0' },
  { title: 'Reward Partner', icon: <Heart size={24} />, desc: 'Wellness brands offering yoga, counseling, and coaching to Kinnav members.', color: '#6A1B9A' },
  { title: 'NGO Partner', icon: <Globe size={24} />, desc: 'Advocacy orgs creating empowerment content and earning per engagement.', color: '#E91E8C' },
  { title: 'Institutional Partner', icon: <Star size={24} />, desc: 'Universities and corporations adopting Kinnav for their communities.', color: '#43A047' },
]

const values = [
  { icon: '🛡️', title: 'Safety First', desc: 'Every feature starts with: does this make women safer?' },
  { icon: '💜', title: 'No Judgment', desc: 'Guardians stay until you feel safe — no time limit, no questions.' },
  { icon: '🤝', title: 'Community', desc: 'Safety is collective. We build communities that protect each other.' },
  { icon: '⚡', title: 'Empowerment', desc: 'Safety is about protection and building confidence.' },
  { icon: '🌍', title: 'Accessible', desc: 'At $3.99/month — designed for every woman who needs it.' },
  { icon: '🔓', title: 'Transparent', desc: 'Clear policies, plain-language terms, and no hidden use of your data.' },
]

export default function About() {
  return (
    <div style={{ paddingTop: 72 }}>
      {/* Hero */}
      <section style={{ background: 'linear-gradient(135deg, #1a0533 0%, #3d1278 50%, #6A1B9A 100%)', padding: '4.5rem 1.5rem', textAlign: 'center' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={stagger}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(181,123,224,0.2)', color: '#D8C4F0', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              About Kinnav
            </motion.div>
            <motion.h1 variants={fadeUp} style={{ fontSize: 'clamp(2rem, 4vw, 3rem)', fontWeight: 900, color: '#fff', lineHeight: 1.15, marginBottom: 16 }}>
              Built by women, for women
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: 'rgba(255,255,255,0.7)', lineHeight: 1.7 }}>
              Kinnav exists so no woman ever has to face an unsafe situation alone.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Mission */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '4rem', alignItems: 'center' }} className="two-col">
            <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
              <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
                Our Mission
              </motion.div>
              <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Safety + Empowerment + Rewards
              </motion.h2>
              <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.8, marginBottom: 16 }}>
                Every woman deserves to feel safe — walking home, on campus, at work, anywhere. Kinnav bridges that gap with vetted guardians, real-time connection, and empowerment resources.
              </motion.p>
              <motion.p variants={fadeUp} style={{ color: '#6B7280', fontSize: 16, lineHeight: 1.8, fontStyle: 'italic' }}>
                "It's easier to look forward when you don't have to watch your back."
              </motion.p>
            </motion.div>
            <motion.div initial={{ opacity: 0, x: 30 }} whileInView={{ opacity: 1, x: 0 }} viewport={{ once: true }} transition={{ duration: 0.6 }}>
              <img src="/images/guardian-network.jpg" alt="Guardian network" style={{ width: '100%', borderRadius: 24, boxShadow: '0 20px 60px rgba(155,89,208,0.2)' }} />
            </motion.div>
          </div>
        </div>
        <style>{`@media (max-width: 768px) { .two-col { grid-template-columns: 1fr !important; gap: 2rem !important; } }`}</style>
      </section>

      {/* Team */}
      <section style={{ padding: '5rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              The Team
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e' }}>
              Who's building Kinnav
            </motion.h2>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem' }}>
            {team.map((m, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.1 }}
                style={{ background: '#fff', borderRadius: 20, padding: '2rem', boxShadow: '0 4px 20px rgba(155,89,208,0.08)', textAlign: 'center' }}>
                <div style={{ width: 64, height: 64, borderRadius: '50%', background: `${m.color}18`, fontSize: 28, display: 'flex', alignItems: 'center', justifyContent: 'center', margin: '0 auto 16px' }}>{m.emoji}</div>
                <div style={{ fontWeight: 800, fontSize: 20, color: '#1a1a2e', marginBottom: 4 }}>{m.name}</div>
                <div style={{ fontSize: 13, fontWeight: 600, color: m.color, marginBottom: 12, textTransform: 'uppercase', letterSpacing: 1 }}>{m.role}</div>
                <div style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.7 }}>{m.bio}</div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Values */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              Our Values
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e' }}>
              What we stand for
            </motion.h2>
          </motion.div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))', gap: '1.25rem' }}>
            {values.map((v, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 15 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.07 }}
                style={{ background: '#F9F5FF', borderRadius: 16, padding: '1.5rem', display: 'flex', gap: 14, alignItems: 'flex-start' }}>
                <span style={{ fontSize: 24, flexShrink: 0 }}>{v.icon}</span>
                <div>
                  <div style={{ fontWeight: 800, fontSize: 15, color: '#1a1a2e', marginBottom: 5 }}>{v.title}</div>
                  <div style={{ color: '#6B7280', fontSize: 13, lineHeight: 1.6 }}>{v.desc}</div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Community Roles */}
      <section style={{ padding: '5rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger} style={{ textAlign: 'center', marginBottom: '3rem' }}>
            <motion.div variants={fadeUp} style={{ display: 'inline-block', background: 'rgba(155,89,208,0.1)', color: '#9B59D0', borderRadius: 50, padding: '5px 16px', fontSize: 12, fontWeight: 700, letterSpacing: 1.5, textTransform: 'uppercase', marginBottom: 16 }}>
              Community
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#1a1a2e' }}>
              Ways to get involved
            </motion.h2>
          </motion.div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.25rem' }}>
            {roles.map((r, i) => (
              <motion.div key={i} initial={{ opacity: 0, y: 15 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * 0.07 }}
                style={{ background: '#fff', borderRadius: 18, padding: '1.5rem', display: 'flex', gap: 14, alignItems: 'flex-start', boxShadow: '0 4px 20px rgba(155,89,208,0.07)' }}>
                <div style={{ width: 44, height: 44, borderRadius: 12, background: `${r.color}15`, color: r.color, display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>{r.icon}</div>
                <div>
                  <div style={{ fontWeight: 800, fontSize: 15, color: '#1a1a2e', marginBottom: 6 }}>{r.title}</div>
                  <div style={{ color: '#6B7280', fontSize: 13, lineHeight: 1.6 }}>{r.desc}</div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section style={{ padding: '5rem 1.5rem', background: 'linear-gradient(135deg, #1a0533, #3d1278)', textAlign: 'center' }}>
        <div style={{ maxWidth: 600, margin: '0 auto' }}>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} variants={stagger}>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.6rem, 2.5vw, 2.2rem)', fontWeight: 900, color: '#fff', marginBottom: 14 }}>
              Join the Kinnav community
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.65)', fontSize: 16, marginBottom: 28 }}>
              Be part of the movement to make women safer everywhere.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 14, justifyContent: 'center', flexWrap: 'wrap' }}>
              <Link to="/contact" style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '13px 30px', borderRadius: 50, background: 'linear-gradient(135deg, #B57BE0, #9B59D0)', color: '#fff', fontWeight: 700, fontSize: 15, textDecoration: 'none' }}>
                Get in Touch <ArrowRight size={16} />
              </Link>
              <Link to="/waitlist" style={{ display: 'inline-flex', alignItems: 'center', gap: 8, padding: '13px 30px', borderRadius: 50, border: '1px solid rgba(255,255,255,0.3)', color: '#fff', fontWeight: 700, fontSize: 15, textDecoration: 'none' }}>
                Join the Waitlist
              </Link>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
