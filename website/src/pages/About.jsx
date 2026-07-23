import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Shield, Heart, Users, Star, Globe, ArrowRight, ExternalLink } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}

const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const team = [
  {
    name: 'Shivani',
    role: 'Founder & Survivor',
    bio: 'Shivani founded Safer from personal experience. A survivor herself, she built this app to ensure no woman ever has to face an unsafe situation alone. Her vision drives every product decision.',
    emoji: '💜',
    color: '#9B59D0',
  },
  {
    name: 'Vishal',
    role: 'Full Stack Engineer',
    bio: 'Vishal leads the technical architecture of Safer — from the Flutter mobile app to the backend service layer. He ensures the app is reliable, fast, and ready for production scale.',
    emoji: '⚡',
    color: '#7B3FBE',
  },
  {
    name: 'Vanshika',
    role: 'Marketing & Digital Native',
    bio: 'Vanshika drives Safer\'s community growth, digital presence, and brand storytelling. She connects the mission with the women who need it most.',
    emoji: '🌟',
    color: '#B57BE0',
  },
]

const communityRoles = [
  {
    title: 'Community Manager',
    icon: <Users size={28} />,
    desc: 'A community is only as strong as its members. As a Community Manager, you take the lead in strengthening your local community — creating strong bonds, bringing women together, improving their sense of belonging and confidence. Be a champion of change for all women in your area.',
    color: '#9B59D0',
  },
  {
    title: 'Campus Ambassador',
    icon: <Star size={28} />,
    desc: 'Bring Safer to your university and create a safer campus environment. Campus Ambassadors organize awareness events, recruit guardians, and ensure every student knows help is one tap away.',
    color: '#7B3FBE',
  },
  {
    title: 'Guardian',
    icon: <Shield size={28} />,
    desc: 'Vetted women 18+ who complete a 40-hour advocacy course. Guardians are the heart of Safer — they answer calls, provide support, and stay with users until they feel safe. Guardians are paid for their time and commitment.',
    color: '#B57BE0',
  },
  {
    title: 'Reward Partner',
    icon: <Heart size={28} />,
    desc: 'Wellness and lifestyle brands that provide discounts and services to Safer users. Reward Partners help women access yoga, counseling, career coaching, and more — reinforcing that safety and wellbeing go hand in hand.',
    color: '#6A1B9A',
  },
  {
    title: 'NGO / Nonprofit Volunteer',
    icon: <Globe size={28} />,
    desc: 'NGOs and advocacy organizations create self-empowerment content for the app\'s modules. They earn revenue per-click and impression, creating a sustainable model for mission-driven content creation.',
    color: '#E91E8C',
  },
  {
    title: 'Institutional Partner',
    icon: <Star size={28} />,
    desc: 'Universities, private schools, and corporations can adopt Safer as a campus or employee safety program. Institutional partners receive customized deployment, reporting, and community management support.',
    color: '#43A047',
  },
]

const values = [
  { title: 'Safety First', desc: 'Every feature, every decision starts with one question: does this make women safer?', icon: '🛡️' },
  { title: 'No Judgment', desc: 'Guardians stay with users until they feel safe — no time limit, no questions asked.', icon: '💜' },
  { title: 'Community Power', desc: 'Safety is a collective responsibility. We build communities that protect each other.', icon: '🤝' },
  { title: 'Empowerment', desc: 'Safety is not just about protection — it\'s about building confidence and capability.', icon: '⚡' },
  { title: 'Accessibility', desc: 'At $3.99/month, Safer is designed to be accessible to every woman who needs it.', icon: '🌍' },
  { title: 'Open & Transparent', desc: 'Built on open-source foundations by EmbeddedOS Foundation — transparent by design.', icon: '🔓' },
]

export default function About() {
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
              About Safer
            </motion.div>
            <motion.h1 variants={fadeUp} style={{
              fontSize: 'clamp(2rem, 4vw, 3.5rem)',
              fontWeight: 900,
              color: '#fff',
              lineHeight: 1.15,
              marginBottom: 20,
            }}>
              A movement, not just an app
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7 }}>
              Safer was born from lived experience. It's a platform built by women, for women — powered by community, technology, and an unshakeable belief that every woman deserves to feel safe.
            </motion.p>
          </motion.div>
        </div>
      </section>

      {/* Mission */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1000, margin: '0 auto' }}>
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
                Our Mission
              </div>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                "A new way of women's safety and empowerment"
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 20 }}>
                Safer exists to ensure that no woman ever has to face an unsafe situation alone. We combine real-time guardian support, empowerment education, and community rewards into one platform — because safety, growth, and wellbeing are inseparable.
              </p>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 32 }}>
                Our tagline says it best: <em style={{ color: '#9B59D0', fontStyle: 'italic' }}>"It's easier to look forward when you don't have to watch your back."</em>
              </p>
              <div style={{
                background: 'linear-gradient(135deg, #F4ECFA, #EDE3F6)',
                borderRadius: 16,
                padding: '1.5rem',
                border: '1px solid rgba(155,89,208,0.15)',
              }}>
                <div style={{ fontSize: 14, color: '#9B7AB0', fontWeight: 600, marginBottom: 8 }}>Developed by</div>
                <a href="https://www.embeddedos.org/" target="_blank" rel="noopener noreferrer"
                  style={{ display: 'flex', alignItems: 'center', gap: 8, textDecoration: 'none' }}>
                  <div style={{ fontWeight: 800, fontSize: 18, color: '#9B59D0' }}>EmbeddedOS Foundation</div>
                  <ExternalLink size={16} style={{ color: '#B57BE0' }} />
                </a>
                <div style={{ fontSize: 13, color: '#9B7AB0', marginTop: 4 }}>501(c)(3) Nonprofit · Open Source</div>
              </div>
            </motion.div>

            <motion.div variants={fadeUp}>
              <img
                src="/images/empowerment-modules.jpg"
                alt="Women empowerment"
                style={{ width: '100%', borderRadius: 24, boxShadow: '0 20px 60px rgba(155,89,208,0.2)' }}
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

      {/* Values */}
      <section style={{ padding: '6rem 1.5rem', background: '#F9F5FF' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
            style={{ textAlign: 'center', marginBottom: '4rem' }}
          >
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              What we stand for
            </motion.h2>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1.5rem' }}>
            {values.map((v, i) => (
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
                <div style={{ fontSize: 36, marginBottom: 16 }}>{v.icon}</div>
                <h3 style={{ fontWeight: 800, fontSize: 17, color: '#1a1a2e', marginBottom: 10 }}>{v.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7 }}>{v.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Team */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 1000, margin: '0 auto' }}>
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
              The Team
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Built by people who care
            </motion.h2>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '2rem' }}>
            {team.map((member, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.15 }}
                style={{
                  background: '#F9F5FF',
                  borderRadius: 24,
                  padding: '2.5rem 2rem',
                  border: '1px solid rgba(155,89,208,0.1)',
                  textAlign: 'center',
                }}
              >
                <div style={{
                  width: 80, height: 80, borderRadius: '50%',
                  background: `linear-gradient(135deg, ${member.color}30, ${member.color}60)`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 20px',
                  fontSize: 36,
                  border: `2px solid ${member.color}40`,
                }}>
                  {member.emoji}
                </div>
                <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 6 }}>{member.name}</h3>
                <div style={{ color: member.color, fontWeight: 700, fontSize: 14, marginBottom: 16 }}>{member.role}</div>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7 }}>{member.bio}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Community Roles */}
      <section style={{ padding: '6rem 1.5rem', background: 'linear-gradient(135deg, #1a0533, #3d1278)' }}>
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
              Community
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
              Join the Safer community
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.7)', fontSize: 17, maxWidth: 600, margin: '0 auto' }}>
              Safer is more than an app — it's a community ecosystem with multiple ways to contribute and grow.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem' }}>
            {communityRoles.map((role, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                style={{
                  background: 'rgba(255,255,255,0.06)',
                  border: '1px solid rgba(181,123,224,0.2)',
                  borderRadius: 20,
                  padding: '2rem',
                }}
              >
                <div style={{
                  width: 52, height: 52, borderRadius: 14,
                  background: `${role.color}25`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  color: role.color, marginBottom: 16,
                }}>
                  {role.icon}
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 17, color: '#fff', marginBottom: 12 }}>{role.title}</h3>
                <p style={{ color: 'rgba(255,255,255,0.65)', fontSize: 14, lineHeight: 1.7 }}>{role.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Contact */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 700, margin: '0 auto', textAlign: 'center' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
          >
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
              Get in touch
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 40 }}>
              Whether you're interested in partnering, becoming a guardian, applying for a community role, or supporting our mission — we'd love to hear from you.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
              <a href="mailto:saferapp3@gmail.com" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                color: '#fff', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
                boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
              }}>
                Email the Team
              </a>
              <a href="mailto:saferapp3@gmail.com?subject=App%20Support%20%E2%80%94%20Safer" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                border: '2px solid #9B59D0',
                color: '#9B59D0', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
              }}>
                App Support
              </a>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
