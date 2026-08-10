import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'

const fadeUp = {
  hidden: { opacity: 0, y: 30 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
}

const Section = ({ title, children }) => (
  <div style={{ marginBottom: '2.5rem' }}>
    <h2 style={{ fontSize: 22, fontWeight: 800, color: '#1a1a2e', marginBottom: 16, paddingBottom: 10, borderBottom: '2px solid #EFE0FB' }}>{title}</h2>
    {children}
  </div>
)

const P = ({ children }) => (
  <p style={{ color: '#4B5563', fontSize: 16, lineHeight: 1.8, marginBottom: 12 }}>{children}</p>
)

export default function PrivacyPolicy() {
  return (
    <div style={{ paddingTop: 72 }}>
      {/* Header */}
      <section style={{
        background: 'linear-gradient(135deg, #1E0838, #4A1690)',
        padding: '4rem 1.5rem',
        textAlign: 'center',
      }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.h1
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            style={{ fontSize: 'clamp(2rem, 4vw, 3rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}
          >
            Privacy Policy
          </motion.h1>
          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.2 }}
            style={{ color: 'rgba(255,255,255,0.7)', fontSize: 16 }}
          >
            Last updated: July 2025 · Kinnav — kinnav.com
          </motion.p>
        </div>
      </section>

      {/* Content */}
      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={{ visible: { transition: { staggerChildren: 0.1 } } }}>
            <motion.div variants={fadeUp}>
              <Section title="1. Introduction">
                <P>
                  Kinnav ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use the Kinnav mobile application and website (kinnav.com). Please read this policy carefully. If you disagree with its terms, please discontinue use of the app.
                </P>

              </Section>

              <Section title="2. Information We Collect">
                <P><strong>Personal Information:</strong> Name, phone number, email address, date of birth (month/year), gender identity, spoken languages, and profile photo — provided during registration and profile setup.</P>
                <P><strong>Location Data:</strong> Precise GPS location when the app is in use (foreground and, with permission, background). Location is used to show nearby guardians and to share your location with safety contacts during a Safe Call. We do not store precise location history beyond what is necessary for active calls.</P>
                <P><strong>Call Data:</strong> Call type (voice/video/text/emergency), duration, participating guardians, and whether police were added. This is stored as call history on your device and, when a backend is active, on our servers.</P>
                <P><strong>Safety Contacts:</strong> Names, phone numbers, and relationship labels of contacts you add. This data is stored locally and used only to notify contacts during a Safe Call.</P>
                <P><strong>Usage Data:</strong> Module completion progress, redeemed rewards, subscription status, and app interaction events for analytics and crash reporting.</P>
              </Section>

              <Section title="3. How We Use Your Information">
                <P>We use your information to: provide and improve the Kinnav service; connect you with nearby guardians; notify your safety contacts during emergencies; personalize your empowerment module experience; process subscription payments; send push notifications relevant to your safety; and comply with legal obligations.</P>
                <P>We do not sell your personal information to third parties. We do not use your precise location for advertising purposes.</P>
              </Section>

              <Section title="4. Data Sharing">
                <P><strong>Guardians:</strong> When you initiate a Safe Call, your general location and profile name are shared with guardians who join the call. This is essential to the service.</P>
                <P><strong>Safety Contacts:</strong> Your live location is shared with your designated safety contacts when a Safe Call begins.</P>
                <P><strong>Service Providers:</strong> We use third-party providers for authentication (Firebase), real-time communication (Agora/Twilio), maps (Google Maps), push notifications (FCM/APNs), and payments (App Store/Play Store). These providers have their own privacy policies.</P>
                <P><strong>Legal Requirements:</strong> We may disclose information if required by law, court order, or to protect the safety of users or the public.</P>
              </Section>

              <Section title="5. Data Security">
                <P>We implement industry-standard security measures including HTTPS encryption in transit, secure token storage (iOS Keychain / Android Keystore), and PII minimization. However, no method of transmission over the internet is 100% secure.</P>
                <P>Authentication tokens (JWTs) are stored in device secure enclaves and never in plain storage. We implement automatic token refresh and session expiration.</P>
              </Section>

              <Section title="6. Your Rights (GDPR / CCPA)">
                <P>Depending on your jurisdiction, you may have the right to: access your personal data; correct inaccurate data; request deletion of your account and data; opt out of certain data processing; and data portability.</P>
                <P>To exercise these rights, visit our <Link to="/contact" style={{ color: '#BF6EEE' }}>Contact page</Link>. We will respond within 30 days.</P>
              </Section>

              <Section title="7. Children's Privacy">
                <P>Kinnav is intended for users 18 years of age and older. We do not knowingly collect personal information from minors. If you believe a minor has provided us with personal information, please contact us immediately.</P>
              </Section>

              <Section title="8. Data Retention">
                <P>We retain your personal data for as long as your account is active or as needed to provide services. Call history is retained for 12 months. You may request deletion of your account and associated data at any time through the app or by emailing us.</P>
              </Section>

              <Section title="9. Changes to This Policy">
                <P>We may update this Privacy Policy from time to time. We will notify you of significant changes via the app or email. Continued use of Kinnav after changes constitutes acceptance of the updated policy.</P>
              </Section>

              <Section title="10. Contact Us">
                <P>If you have questions about this Privacy Policy or our data practices, please contact:</P>
                <div style={{
                  background: '#FAF5FF',
                  borderRadius: 16,
                  padding: '1.5rem 2rem',
                  border: '1px solid rgba(191,110,238,0.15)',
                  marginTop: 16,
                }}>
                  <div style={{ fontWeight: 700, color: '#1a1a2e', marginBottom: 8 }}>Kinnav</div>
                  <div style={{ color: '#6B7280', fontSize: 15, marginBottom: 4 }}>
                    <Link to="/contact" style={{ color: '#BF6EEE' }}>Contact Us</Link>
                  </div>
                  <div style={{ color: '#6B7280', fontSize: 15 }}>
                    Website: <a href="https://kinnav.com" style={{ color: '#BF6EEE' }}>kinnav.com</a>
                  </div>
                </div>
              </Section>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
