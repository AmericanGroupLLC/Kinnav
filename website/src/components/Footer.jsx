import { Link } from 'react-router-dom'
import { Heart, Mail, Globe, Share2 } from 'lucide-react'

export default function Footer() {
  const year = new Date().getFullYear()

  return (
    <footer style={{
      background: 'linear-gradient(135deg, #1a0533 0%, #3d1278 100%)',
      color: '#fff',
      paddingTop: '4rem',
      paddingBottom: '2rem',
    }}>
      <div style={{ maxWidth: 1200, margin: '0 auto', padding: '0 1.5rem' }}>
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
          gap: '3rem',
          marginBottom: '3rem',
        }}>
          {/* Brand column */}
          <div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 16 }}>
              <img src="/images/kinnav_icon.png" alt="Kinnav" style={{ width: 44, height: 44, borderRadius: 10 }} />
              <div>
                <div style={{ fontWeight: 800, fontSize: 22, lineHeight: 1 }}>Kinnav</div>
                <div style={{ fontSize: 11, color: 'rgba(255,255,255,0.6)', letterSpacing: 1.5, textTransform: 'uppercase' }}>Women's Safety App</div>
              </div>
            </div>
            <p style={{ color: 'rgba(255,255,255,0.7)', fontSize: 14, lineHeight: 1.7, marginBottom: 20 }}>
              An all-in-one women's safety, empowerment, and rewards platform — built to help women feel safe, anywhere, anytime.
            </p>
            <div style={{ display: 'flex', gap: 12 }}>
              {[
                { icon: <Share2 size={18} />, href: 'https://instagram.com/kinnav', label: 'Instagram' },
                { icon: <Globe size={18} />, href: 'https://x.com/kinnav', label: 'Twitter/X' },
              ].map(s => (
                <a key={s.label} href={s.href} target="_blank" rel="noopener noreferrer"
                  aria-label={s.label}
                  style={{
                    width: 36, height: 36, borderRadius: 8,
                    background: 'rgba(255,255,255,0.1)',
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                    color: '#fff', textDecoration: 'none',
                    transition: 'background 0.2s',
                  }}
                >
                  {s.icon}
                </a>
              ))}
            </div>
          </div>

          {/* Quick links */}
          <div>
            <h4 style={{ fontWeight: 700, fontSize: 14, letterSpacing: 1.5, textTransform: 'uppercase', color: '#B57BE0', marginBottom: 16 }}>Quick Links</h4>
            {[
              { to: '/', label: 'Home' },
              { to: '/how-it-works', label: 'How It Works' },
              { to: '/waitlist', label: 'Join Waitlist' },
              { to: '/about', label: 'About Us' },
              { to: '/contact', label: 'Contact' },
            ].map(l => (
              <Link key={l.to} to={l.to} style={{
                display: 'block', color: 'rgba(255,255,255,0.7)', textDecoration: 'none',
                fontSize: 14, marginBottom: 10, transition: 'color 0.2s',
              }}>
                {l.label}
              </Link>
            ))}
          </div>

          {/* App features */}
          <div>
            <h4 style={{ fontWeight: 700, fontSize: 14, letterSpacing: 1.5, textTransform: 'uppercase', color: '#B57BE0', marginBottom: 16 }}>App Features</h4>
            {[
              'Live Guardian Map',
              'Safe Call System',
              'Support Chat',
              'Empowerment Modules',
              'Rewards Program',
              'Guardian Network',
            ].map(f => (
              <div key={f} style={{ color: 'rgba(255,255,255,0.7)', fontSize: 14, marginBottom: 10 }}>
                <span style={{ color: '#B57BE0', marginRight: 8 }}>›</span>{f}
              </div>
            ))}
          </div>

          {/* Contact & Legal */}
          <div>
            <h4 style={{ fontWeight: 700, fontSize: 14, letterSpacing: 1.5, textTransform: 'uppercase', color: '#B57BE0', marginBottom: 16 }}>Contact & Legal</h4>
            <Link to="/contact" style={{ display: 'flex', alignItems: 'center', gap: 8, color: 'rgba(255,255,255,0.7)', textDecoration: 'none', fontSize: 14, marginBottom: 20 }}>
              <Mail size={14} style={{ color: '#B57BE0' }} /> Contact Us
            </Link>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 20 }}>
              {[
                { to: '/privacy', label: 'Privacy Policy' },
                { to: '/terms', label: 'Terms of Service' },
                { to: '/contact', label: 'Contact Us' },
              ].map(l => (
                <Link key={l.to} to={l.to} style={{ color: 'rgba(255,255,255,0.5)', textDecoration: 'none', fontSize: 13 }}>{l.label}</Link>
              ))}
            </div>

          </div>
        </div>

        {/* App store badges */}
        <div style={{ borderTop: '1px solid rgba(255,255,255,0.08)', paddingTop: '1.5rem', paddingBottom: '1.5rem', display: 'flex', gap: 12, flexWrap: 'wrap', justifyContent: 'center' }}>
          <div style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 10, padding: '8px 18px', color: 'rgba(255,255,255,0.5)', fontSize: 13, fontWeight: 600 }}>
            📱 iOS App — Coming Soon
          </div>
          <div style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 10, padding: '8px 18px', color: 'rgba(255,255,255,0.5)', fontSize: 13, fontWeight: 600 }}>
            🤖 Android App — Coming Soon
          </div>
          <div style={{ background: 'rgba(155,89,208,0.15)', border: '1px solid rgba(181,123,224,0.3)', borderRadius: 10, padding: '8px 18px', color: '#B57BE0', fontSize: 13, fontWeight: 700 }}>
            <Link to="/waitlist" style={{ color: 'inherit', textDecoration: 'none' }}>💜 Join Waitlist — Get Early Access</Link>
          </div>
        </div>

        {/* Bottom bar */}
        <div style={{
          borderTop: '1px solid rgba(255,255,255,0.08)',
          paddingTop: '1.5rem',
          display: 'flex',
          flexWrap: 'wrap',
          justifyContent: 'space-between',
          alignItems: 'center',
          gap: 12,
        }}>
          <div style={{ color: 'rgba(255,255,255,0.4)', fontSize: 13 }}>
            © {year} Kinnav. All rights reserved.
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, color: 'rgba(255,255,255,0.4)', fontSize: 13 }}>
            Made with <Heart size={13} style={{ color: '#B57BE0', fill: '#B57BE0' }} /> for women's safety worldwide
          </div>
        </div>
      </div>
    </footer>
  )
}
