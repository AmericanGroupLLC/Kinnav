import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Heart, Shield, Code, Globe, CheckCircle, ArrowRight, ExternalLink, DollarSign, Users, Zap, Lock } from 'lucide-react'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: 'easeOut' } },
}

const stagger = { visible: { transition: { staggerChildren: 0.12 } } }

const fundingGoals = [
  {
    icon: <Code size={24} />,
    title: 'Real-Time Backend Infrastructure',
    amount: '$45,000',
    desc: 'Firebase/Supabase backend, authentication, guardian geo-queries, and database architecture for production deployment.',
    color: '#9B59D0',
  },
  {
    icon: <Zap size={24} />,
    title: 'Safe Call — Voice & Video System',
    amount: '$35,000',
    desc: 'Agora RTC or Twilio integration for real multi-party voice and video calls. The core life-safety feature.',
    color: '#7B3FBE',
  },
  {
    icon: <Globe size={24} />,
    title: 'Guardian Network Launch',
    amount: '$25,000',
    desc: 'Guardian vetting workflow, 40-hour course platform, payment infrastructure, and NGO partnerships.',
    color: '#B57BE0',
  },
  {
    icon: <Lock size={24} />,
    title: 'Security, Compliance & Legal',
    amount: '$20,000',
    desc: 'GDPR/CCPA compliance, encryption, independent safety/legal review, and app store submissions.',
    color: '#6A1B9A',
  },
  {
    icon: <Users size={24} />,
    title: 'Push Notifications & Emergency',
    amount: '$15,000',
    desc: 'FCM/APNs push notifications, emergency dial integration, safety contact alerts, and background location.',
    color: '#E53935',
  },
  {
    icon: <Shield size={24} />,
    title: 'QA, Testing & App Store Launch',
    amount: '$10,000',
    desc: 'Full test suite, CI/CD pipeline, crash reporting, analytics, and iOS/Android store listings.',
    color: '#43A047',
  },
]

const grantOpportunities = [
  {
    name: 'Violence Against Women Act (VAWA) Grants',
    org: 'U.S. Department of Justice',
    focus: 'Technology solutions for women\'s safety and violence prevention',
    fit: 'High',
  },
  {
    name: 'Safety and Justice Challenge',
    org: 'MacArthur Foundation',
    focus: 'Innovative community safety solutions',
    fit: 'High',
  },
  {
    name: 'Women\'s Safety & Empowerment Fund',
    org: 'Various Foundations',
    focus: 'Apps and platforms empowering women in vulnerable situations',
    fit: 'High',
  },
  {
    name: 'Tech for Social Good Grants',
    org: 'Google.org / Microsoft Philanthropies',
    focus: 'Nonprofit technology solving social challenges',
    fit: 'Medium-High',
  },
  {
    name: 'Campus Safety Innovation Grants',
    org: 'U.S. Department of Education',
    focus: 'University and campus safety technology',
    fit: 'Medium-High',
  },
  {
    name: 'Open Source Foundation Grants',
    org: 'Mozilla Foundation / Linux Foundation',
    focus: 'Open-source safety and privacy tools',
    fit: 'Medium',
  },
]

const impactMetrics = [
  { value: '1 in 3', label: 'Women experience physical or sexual violence globally' },
  { value: '81%', label: 'Of women have experienced sexual harassment' },
  { value: '$3.99/mo', label: 'Subscription — accessible to all women' },
  { value: '40hrs', label: 'Guardian training — professional, vetted support' },
]

const donationTiers = [
  {
    amount: '$25',
    title: 'Supporter',
    perks: ['Your name in our donor wall', 'Safer newsletter updates', 'Early access waitlist priority'],
    color: '#B57BE0',
  },
  {
    amount: '$100',
    title: 'Guardian Sponsor',
    perks: ['All Supporter perks', 'Sponsor one guardian\'s training materials', 'Quarterly impact report', 'Safer sticker pack'],
    color: '#9B59D0',
    featured: true,
  },
  {
    amount: '$500',
    title: 'Safety Champion',
    perks: ['All Guardian Sponsor perks', 'Sponsor a campus ambassador', 'Logo on website (organizations)', 'Direct team call'],
    color: '#6A1B9A',
  },
  {
    amount: 'Custom',
    title: 'Grant Partner',
    perks: ['Custom grant partnership', 'Co-branded impact reporting', 'Advisory board consideration', 'Full recognition package'],
    color: '#1a0533',
  },
]

export default function GrantFunding() {
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
        <div style={{
          position: 'absolute', inset: 0,
          backgroundImage: 'url(/images/grant-fundraising.jpg)',
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          opacity: 0.15,
        }} />
        <div style={{ position: 'relative', zIndex: 1, maxWidth: 800, margin: '0 auto' }}>
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
              Grant & Funding
            </motion.div>
            <motion.h1 variants={fadeUp} style={{
              fontSize: 'clamp(2rem, 4vw, 3.5rem)',
              fontWeight: 900,
              color: '#fff',
              lineHeight: 1.15,
              marginBottom: 20,
            }}>
              Help Build the Future of<br />Women's Safety Technology
            </motion.h1>
            <motion.p variants={fadeUp} style={{ fontSize: 18, color: 'rgba(255,255,255,0.8)', lineHeight: 1.7, marginBottom: 40 }}>
              The Safer prototype is complete. We need grant funding and community donations to build the full production app — real guardian calls, real-time infrastructure, and global reach.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
              <a href="#donate" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                color: '#fff', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
                boxShadow: '0 8px 30px rgba(155,89,208,0.5)',
              }}>
                Donate Now 💜
              </a>
              <a href="#grant-opportunities" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                background: 'rgba(255,255,255,0.12)',
                border: '1px solid rgba(255,255,255,0.3)',
                color: '#fff', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
              }}>
                Grant Opportunities
              </a>
            </motion.div>
          </motion.div>
        </div>
      </section>

      {/* Impact Stats */}
      <section style={{ background: 'linear-gradient(135deg, #6A1B9A, #9B59D0)', padding: '3rem 1.5rem' }}>
        <div style={{ maxWidth: 1100, margin: '0 auto' }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '2rem' }}>
            {impactMetrics.map((m, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                style={{ textAlign: 'center' }}
              >
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
                Development Partner
              </div>
              <h2 style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
                Built by EmbeddedOS Foundation
              </h2>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 20 }}>
                The Safer app is developed by <strong style={{ color: '#9B59D0' }}>EmbeddedOS (EoS) Research Foundation</strong> — a 501(c)(3) nonprofit organization dedicated to building open-source technology for social good.
              </p>
              <p style={{ fontSize: 16, color: '#4B5563', lineHeight: 1.8, marginBottom: 32 }}>
                Your donations and grants go directly to EmbeddedOS Foundation to fund the engineering work required to bring Safer from a working prototype to a full production application — with real guardian calls, backend infrastructure, and global deployment.
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 32 }}>
                {[
                  '501(c)(3) tax-exempt nonprofit — donations are tax-deductible',
                  'Open-source development — transparent, auditable code',
                  'Community-driven — built by engineers, for the community',
                  'Deployed across 52+ hardware platforms globally',
                ].map((item, i) => (
                  <div key={i} style={{ display: 'flex', alignItems: 'flex-start', gap: 12 }}>
                    <CheckCircle size={18} style={{ color: '#9B59D0', flexShrink: 0, marginTop: 2 }} />
                    <span style={{ color: '#374151', fontSize: 15 }}>{item}</span>
                  </div>
                ))}
              </div>
              <a
                href="https://www.embeddedos.org/"
                target="_blank"
                rel="noopener noreferrer"
                style={{
                  display: 'inline-flex', alignItems: 'center', gap: 8,
                  padding: '12px 28px', borderRadius: 50,
                  border: '2px solid #9B59D0',
                  color: '#9B59D0', fontWeight: 700, fontSize: 15,
                  textDecoration: 'none',
                }}
              >
                Visit EmbeddedOS.org <ExternalLink size={16} />
              </a>
            </motion.div>

            <motion.div variants={fadeUp}>
              <div style={{
                background: 'linear-gradient(135deg, #F4ECFA, #EDE3F6)',
                borderRadius: 24,
                padding: '3rem 2.5rem',
                border: '1px solid rgba(155,89,208,0.15)',
                textAlign: 'center',
              }}>
                <div style={{
                  width: 80, height: 80, borderRadius: 20,
                  background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 24px',
                  fontSize: 36,
                }}>
                  🛡️
                </div>
                <h3 style={{ fontWeight: 900, fontSize: 24, color: '#1a1a2e', marginBottom: 12 }}>EmbeddedOS Foundation</h3>
                <div style={{
                  display: 'inline-block',
                  background: 'rgba(155,89,208,0.1)',
                  color: '#9B59D0',
                  borderRadius: 50,
                  padding: '4px 14px',
                  fontSize: 13,
                  fontWeight: 700,
                  marginBottom: 20,
                }}>
                  501(c)(3) Nonprofit
                </div>
                <p style={{ color: '#6B7280', fontSize: 15, lineHeight: 1.7, marginBottom: 24 }}>
                  "The Operating System for Every Device" — built by embedded engineers, for any embedded hardware. Every design decision prioritizes reliability, security, and developer experience.
                </p>
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', textAlign: 'left' }}>
                  {[
                    { label: 'Products', value: '13 repos' },
                    { label: 'Platforms', value: '52+' },
                    { label: 'Patents', value: '2 pending' },
                    { label: 'Status', value: 'Open Source' },
                  ].map((stat, i) => (
                    <div key={i} style={{
                      background: '#fff',
                      borderRadius: 12,
                      padding: '12px 16px',
                      border: '1px solid rgba(155,89,208,0.1)',
                    }}>
                      <div style={{ fontSize: 12, color: '#9B7AB0', fontWeight: 600, textTransform: 'uppercase', letterSpacing: 1 }}>{stat.label}</div>
                      <div style={{ fontSize: 18, fontWeight: 800, color: '#9B59D0', marginTop: 4 }}>{stat.value}</div>
                    </div>
                  ))}
                </div>
              </div>
            </motion.div>
          </motion.div>
        </div>
        <style>{`
          @media (max-width: 768px) {
            .two-col { grid-template-columns: 1fr !important; gap: 2rem !important; }
          }
        `}</style>
      </section>

      {/* Funding Goals */}
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
              Funding Roadmap
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Where your funding goes
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', maxWidth: 600, margin: '0 auto' }}>
              Total target: <strong style={{ color: '#9B59D0' }}>$150,000</strong> to bring Safer from prototype to production. Every dollar is tracked and reported.
            </motion.p>
          </motion.div>

          {/* Progress bar */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            style={{
              background: '#fff',
              borderRadius: 20,
              padding: '2rem',
              boxShadow: '0 4px 20px rgba(155,89,208,0.1)',
              border: '1px solid rgba(155,89,208,0.1)',
              marginBottom: '3rem',
            }}
          >
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 12 }}>
              <span style={{ fontWeight: 700, fontSize: 16, color: '#1a1a2e' }}>Fundraising Goal: $150,000</span>
              <span style={{ fontWeight: 700, fontSize: 16, color: '#9B59D0' }}>Help us reach it!</span>
            </div>
            <div style={{ background: '#EDE3F6', borderRadius: 50, height: 12, overflow: 'hidden' }}>
              <motion.div
                initial={{ width: 0 }}
                whileInView={{ width: '8%' }}
                viewport={{ once: true }}
                transition={{ duration: 1.5, ease: 'easeOut' }}
                style={{ height: '100%', background: 'linear-gradient(90deg, #B57BE0, #9B59D0)', borderRadius: 50 }}
              />
            </div>
            <div style={{ fontSize: 13, color: '#9B7AB0', marginTop: 8 }}>Early stage — every donation counts toward our goal</div>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', gap: '1.5rem' }}>
            {fundingGoals.map((goal, i) => (
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
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 16 }}>
                  <div style={{
                    width: 48, height: 48, borderRadius: 12,
                    background: `${goal.color}15`,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    color: goal.color,
                  }}>
                    {goal.icon}
                  </div>
                  <div style={{ fontWeight: 900, fontSize: 20, color: goal.color }}>{goal.amount}</div>
                </div>
                <h3 style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 10 }}>{goal.title}</h3>
                <p style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.7 }}>{goal.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Grant Opportunities */}
      <section id="grant-opportunities" style={{ padding: '6rem 1.5rem', background: '#fff' }}>
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
              Grant Opportunities
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 16 }}>
              Aligned grant programs
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#6B7280', maxWidth: 600, margin: '0 auto' }}>
              Safer aligns with multiple federal, foundation, and corporate grant programs focused on women's safety and nonprofit technology.
            </motion.p>
          </motion.div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
            {grantOpportunities.map((grant, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.08 }}
                style={{
                  background: '#F9F5FF',
                  borderRadius: 16,
                  padding: '1.5rem 2rem',
                  border: '1px solid rgba(155,89,208,0.1)',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '2rem',
                  flexWrap: 'wrap',
                }}
              >
                <div style={{ flex: 1, minWidth: 200 }}>
                  <div style={{ fontWeight: 800, fontSize: 16, color: '#1a1a2e', marginBottom: 4 }}>{grant.name}</div>
                  <div style={{ fontSize: 13, color: '#9B59D0', fontWeight: 600 }}>{grant.org}</div>
                </div>
                <div style={{ flex: 2, minWidth: 200 }}>
                  <div style={{ fontSize: 14, color: '#6B7280' }}>{grant.focus}</div>
                </div>
                <div style={{
                  background: grant.fit === 'High' ? 'rgba(67,160,71,0.1)' : 'rgba(255,152,0,0.1)',
                  color: grant.fit === 'High' ? '#2E7D32' : '#E65100',
                  borderRadius: 50,
                  padding: '4px 14px',
                  fontSize: 13,
                  fontWeight: 700,
                  whiteSpace: 'nowrap',
                }}>
                  {grant.fit} Fit
                </div>
              </motion.div>
            ))}
          </div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            style={{
              marginTop: '3rem',
              background: 'linear-gradient(135deg, #F4ECFA, #EDE3F6)',
              borderRadius: 20,
              padding: '2.5rem',
              border: '1px solid rgba(155,89,208,0.2)',
              textAlign: 'center',
            }}
          >
            <h3 style={{ fontWeight: 900, fontSize: 22, color: '#1a1a2e', marginBottom: 12 }}>Are you a grant officer or foundation?</h3>
            <p style={{ color: '#6B7280', fontSize: 16, marginBottom: 24 }}>
              We welcome partnership inquiries from foundations, government agencies, and corporate social responsibility programs aligned with women's safety and empowerment.
            </p>
            <a href="mailto:support@safecodeg.com" style={{
              display: 'inline-flex', alignItems: 'center', gap: 8,
              padding: '12px 28px', borderRadius: 50,
              background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
              color: '#fff', fontWeight: 700, fontSize: 15,
              textDecoration: 'none',
            }}>
              Contact for Grant Partnership <ArrowRight size={16} />
            </a>
          </motion.div>
        </div>
      </section>

      {/* Donation Tiers */}
      <section id="donate" style={{ padding: '6rem 1.5rem', background: 'linear-gradient(135deg, #1a0533, #3d1278)' }}>
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
              Donate
            </motion.div>
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.8rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
              Choose your level of support
            </motion.h2>
            <motion.p variants={fadeUp} style={{ color: 'rgba(255,255,255,0.7)', fontSize: 17, maxWidth: 600, margin: '0 auto' }}>
              All donations go to EmbeddedOS Foundation (501c3) to fund Safer development. Tax-deductible.
            </motion.p>
          </motion.div>

          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '1.5rem' }}>
            {donationTiers.map((tier, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: i * 0.1 }}
                style={{
                  background: tier.featured ? 'linear-gradient(135deg, #B57BE0, #9B59D0)' : 'rgba(255,255,255,0.06)',
                  border: tier.featured ? 'none' : '1px solid rgba(181,123,224,0.2)',
                  borderRadius: 24,
                  padding: '2.5rem 2rem',
                  position: 'relative',
                  textAlign: 'center',
                }}
              >
                {tier.featured && (
                  <div style={{
                    position: 'absolute', top: -14, left: '50%', transform: 'translateX(-50%)',
                    background: '#E91E8C', color: '#fff', borderRadius: 50,
                    padding: '5px 18px', fontSize: 12, fontWeight: 700,
                    whiteSpace: 'nowrap',
                  }}>
                    Most Popular
                  </div>
                )}
                <div style={{
                  fontSize: 'clamp(2rem, 4vw, 3rem)',
                  fontWeight: 900,
                  color: '#fff',
                  lineHeight: 1,
                  marginBottom: 8,
                }}>
                  {tier.amount}
                </div>
                <div style={{ fontSize: 16, fontWeight: 700, color: 'rgba(255,255,255,0.8)', marginBottom: 24 }}>{tier.title}</div>
                <div style={{ display: 'flex', flexDirection: 'column', gap: 10, marginBottom: 32, textAlign: 'left' }}>
                  {tier.perks.map((perk, j) => (
                    <div key={j} style={{ display: 'flex', alignItems: 'flex-start', gap: 10 }}>
                      <Heart size={14} style={{ color: tier.featured ? 'rgba(255,255,255,0.9)' : '#B57BE0', flexShrink: 0, marginTop: 2, fill: 'currentColor' }} />
                      <span style={{ fontSize: 14, color: 'rgba(255,255,255,0.8)', lineHeight: 1.5 }}>{perk}</span>
                    </div>
                  ))}
                </div>
                <a
                  href="mailto:support@safecodeg.com?subject=Donation%20Inquiry"
                  style={{
                    display: 'block',
                    padding: '12px 24px',
                    borderRadius: 50,
                    background: tier.featured ? 'rgba(255,255,255,0.2)' : 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                    border: tier.featured ? '1px solid rgba(255,255,255,0.3)' : 'none',
                    color: '#fff',
                    fontWeight: 700,
                    fontSize: 15,
                    textDecoration: 'none',
                    transition: 'all 0.2s',
                  }}
                >
                  {tier.amount === 'Custom' ? 'Contact Us' : `Donate ${tier.amount}`}
                </a>
              </motion.div>
            ))}
          </div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            style={{
              marginTop: '3rem',
              background: 'rgba(255,255,255,0.06)',
              border: '1px solid rgba(181,123,224,0.2)',
              borderRadius: 20,
              padding: '2rem',
              textAlign: 'center',
            }}
          >
            <div style={{ color: 'rgba(255,255,255,0.6)', fontSize: 14, lineHeight: 1.7 }}>
              <strong style={{ color: '#D8C4F0' }}>EmbeddedOS Foundation</strong> is a registered 501(c)(3) nonprofit organization.
              All donations are tax-deductible to the extent permitted by law.
              For wire transfers, checks, or large grant disbursements, contact{' '}
              <a href="mailto:support@safecodeg.com" style={{ color: '#B57BE0' }}>support@safecodeg.com</a>.
            </div>
          </motion.div>
        </div>
      </section>

      {/* Pitch Deck CTA */}
      <section style={{ padding: '6rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 800, margin: '0 auto', textAlign: 'center' }}>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true }}
            variants={stagger}
          >
            <motion.h2 variants={fadeUp} style={{ fontSize: 'clamp(1.8rem, 3vw, 2.5rem)', fontWeight: 900, color: '#1a1a2e', marginBottom: 20 }}>
              Want the full pitch deck?
            </motion.h2>
            <motion.p variants={fadeUp} style={{ fontSize: 17, color: '#4B5563', lineHeight: 1.8, marginBottom: 40 }}>
              We have a comprehensive pitch deck covering the market opportunity, competitive landscape, business model, team, and funding ask. Contact us to request it.
            </motion.p>
            <motion.div variants={fadeUp} style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
              <a href="mailto:saferapp3@gmail.com?subject=Pitch%20Deck%20Request" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                color: '#fff', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
                boxShadow: '0 8px 30px rgba(155,89,208,0.4)',
              }}>
                Request Pitch Deck <ArrowRight size={18} />
              </a>
              <a href="mailto:support@safecodeg.com" style={{
                display: 'inline-flex', alignItems: 'center', gap: 8,
                padding: '14px 32px', borderRadius: 50,
                border: '2px solid #9B59D0',
                color: '#9B59D0', fontWeight: 700, fontSize: 16,
                textDecoration: 'none',
              }}>
                Partner With Us
              </a>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
