import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'

const fadeUp = { hidden: { opacity: 0, y: 30 }, visible: { opacity: 1, y: 0, transition: { duration: 0.5 } } }

const Section = ({ title, children }) => (
  <div style={{ marginBottom: '2.5rem' }}>
    <h2 style={{ fontSize: 22, fontWeight: 800, color: '#1a1a2e', marginBottom: 16, paddingBottom: 10, borderBottom: '2px solid #EDE3F6' }}>{title}</h2>
    {children}
  </div>
)
const P = ({ children }) => <p style={{ color: '#4B5563', fontSize: 16, lineHeight: 1.8, marginBottom: 12 }}>{children}</p>

export default function Terms() {
  return (
    <div style={{ paddingTop: 72 }}>
      <section style={{ background: 'linear-gradient(135deg, #1a0533, #3d1278)', padding: '4rem 1.5rem', textAlign: 'center' }}>
        <div style={{ maxWidth: 700, margin: '0 auto' }}>
          <motion.h1 initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} style={{ fontSize: 'clamp(2rem, 4vw, 3rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
            Terms of Service
          </motion.h1>
          <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.2 }} style={{ color: 'rgba(255,255,255,0.7)', fontSize: 16 }}>
            Last updated: July 2025 · Safer — mysaferapp.com
          </motion.p>
        </div>
      </section>

      <section style={{ padding: '5rem 1.5rem', background: '#fff' }}>
        <div style={{ maxWidth: 800, margin: '0 auto' }}>
          <motion.div initial="hidden" animate="visible" variants={{ visible: { transition: { staggerChildren: 0.08 } } }}>
            <motion.div variants={fadeUp}>
              <Section title="1. Acceptance of Terms">
                <P>By accessing or using the Safer application ("App") or website at mysaferapp.com ("Site"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use the App or Site. These Terms apply to all users, including visitors, registered users, and guardians.</P>
                <P>Safer is developed by EmbeddedOS (EoS) Research Foundation, a 501(c)(3) nonprofit organization.</P>
              </Section>

              <Section title="2. Eligibility">
                <P>You must be at least 18 years of age to use Safer. By using the App, you represent and warrant that you are 18 or older. The App includes an age verification step during onboarding. We do not knowingly permit minors to use the App.</P>
              </Section>

              <Section title="3. Description of Service">
                <P>Safer is a women's safety, empowerment, and rewards platform that connects users with vetted guardians via voice call, video call, text message, or emergency escalation. The App also provides self-care and empowerment modules, a rewards program, and community features.</P>
                <P><strong>IMPORTANT — LIFE SAFETY NOTICE:</strong> Safer is a supplementary safety tool and is NOT a substitute for emergency services. In any life-threatening emergency, call 911 (or your local emergency number) immediately. Safer does not guarantee response times, guardian availability, or call quality. The App is provided as-is and should not be relied upon as your sole means of safety.</P>
              </Section>

              <Section title="4. Guardian Program">
                <P>Guardians are independent volunteers and contractors who have completed a 40-hour advocacy training course and passed a vetting process. Guardians are not employees of EmbeddedOS Foundation. Safer does not guarantee the conduct, qualifications, or availability of any guardian.</P>
                <P>By becoming a guardian, you agree to: complete the required training, maintain accurate availability status, treat all users with dignity and respect, and comply with all applicable laws and our Guardian Code of Conduct.</P>
              </Section>

              <Section title="5. User Conduct">
                <P>You agree not to: use the App for any unlawful purpose; harass, abuse, or harm other users or guardians; provide false information during registration; attempt to circumvent the age verification system; use the App to make false emergency calls; or reverse-engineer, decompile, or disassemble any part of the App.</P>
              </Section>

              <Section title="6. Subscription and Payments">
                <P>Safer offers subscription plans at $3.99/month or $39.99/year, processed through Apple App Store or Google Play Store. All payments are subject to the terms of the respective app store. Subscriptions auto-renew unless cancelled at least 24 hours before the renewal date. Refunds are handled per the applicable app store policy.</P>
              </Section>

              <Section title="7. Intellectual Property">
                <P>The Safer name, logo, app design, and content are the property of Safer. The underlying App code is open-source under the MIT License, developed by EmbeddedOS Foundation. User-generated content (profile information, feedback) remains your property, but you grant us a license to use it to operate the service.</P>
              </Section>

              <Section title="8. Disclaimer of Warranties">
                <P>THE APP IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND. TO THE MAXIMUM EXTENT PERMITTED BY LAW, WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT. WE DO NOT WARRANT THAT THE APP WILL BE UNINTERRUPTED, ERROR-FREE, OR THAT GUARDIANS WILL BE AVAILABLE WHEN NEEDED.</P>
              </Section>

              <Section title="9. Limitation of Liability">
                <P>TO THE MAXIMUM EXTENT PERMITTED BY LAW, SAFER AND EMBEDDEDOS FOUNDATION SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING FROM YOUR USE OF THE APP, INCLUDING ANY FAILURE OF THE SAFETY FEATURES TO PREVENT HARM. OUR TOTAL LIABILITY SHALL NOT EXCEED THE AMOUNT YOU PAID FOR THE SERVICE IN THE PAST 12 MONTHS.</P>
              </Section>

              <Section title="10. Governing Law">
                <P>These Terms are governed by the laws of the United States. Any disputes shall be resolved through binding arbitration in accordance with the American Arbitration Association rules, except that either party may seek injunctive relief in a court of competent jurisdiction.</P>
              </Section>

              <Section title="11. Changes to Terms">
                <P>We may update these Terms at any time. We will notify you of material changes via the App or email. Continued use of the App after changes constitutes acceptance of the updated Terms.</P>
              </Section>

              <Section title="12. Contact">
                <div style={{ background: '#F9F5FF', borderRadius: 16, padding: '1.5rem 2rem', border: '1px solid rgba(155,89,208,0.15)', marginTop: 16 }}>
                  <div style={{ fontWeight: 700, color: '#1a1a2e', marginBottom: 8 }}>Safer</div>
                  <div style={{ color: '#6B7280', fontSize: 15, marginBottom: 4 }}>Email: <a href="mailto:saferapp3@gmail.com" style={{ color: '#9B59D0' }}>saferapp3@gmail.com</a></div>
                  <div style={{ color: '#6B7280', fontSize: 15 }}>Website: <a href="https://mysaferapp.com" style={{ color: '#9B59D0' }}>mysaferapp.com</a></div>
                </div>
              </Section>

              <div style={{ marginTop: 32, padding: '1.5rem', background: '#F9F5FF', borderRadius: 16, border: '1px solid rgba(155,89,208,0.1)' }}>
                <p style={{ color: '#6B7280', fontSize: 14, lineHeight: 1.7 }}>
                  Also see our <Link to="/privacy" style={{ color: '#9B59D0' }}>Privacy Policy</Link> for information about how we collect and use your data.
                </p>
              </div>
            </motion.div>
          </motion.div>
        </div>
      </section>
    </div>
  )
}
