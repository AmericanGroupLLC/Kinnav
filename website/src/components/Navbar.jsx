import { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Menu, X } from 'lucide-react'

const navLinks = [
  { to: '/', label: 'Home' },
  { to: '/how-it-works', label: 'How It Works' },
  { to: '/about', label: 'About' },
]

export default function Navbar() {
  const [open, setOpen] = useState(false)
  const [scrolled, setScrolled] = useState(false)
  const location = useLocation()

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20)
    window.addEventListener('scroll', onScroll)
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  // Close the mobile menu on navigation. The state update belongs in an
  // effect body rather than a callback here, so the rule is silenced
  // deliberately: there is nothing to react to but the route change itself.
  // eslint-disable-next-line react-hooks/set-state-in-effect
  useEffect(() => setOpen(false), [location])

  const isHome = location.pathname === '/'
  const navBg = scrolled || !isHome
    ? 'bg-white/95 backdrop-blur-md shadow-lg shadow-purple-100/50'
    : 'bg-transparent'

  const textColor = (scrolled || !isHome) ? '#374151' : 'rgba(255,255,255,0.9)'
  const activeColor = '#BF6EEE'
  const logoColor = (scrolled || !isHome) ? '#7B2FB8' : '#fff'
  const logoSubColor = (scrolled || !isHome) ? '#BF6EEE' : 'rgba(255,255,255,0.8)'
  const mobileIconColor = (scrolled || !isHome) ? '#7B2FB8' : '#fff'

  return (
    <nav
      style={{
        position: 'fixed', top: 0, left: 0, right: 0, zIndex: 50,
        transition: 'all 0.3s ease',
      }}
      className={navBg}
    >
      <div style={{ maxWidth: 1200, margin: '0 auto', padding: '0 1.5rem' }}>
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', height: 72 }}>
          {/* Logo */}
          <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: 10, textDecoration: 'none' }}>
            <img src="/images/kinnav_icon.png" alt="Kinnav" style={{ width: 40, height: 40, borderRadius: 10 }} />
            <div>
              <div style={{ fontWeight: 800, fontSize: 20, color: logoColor, lineHeight: 1 }}>Kinnav</div>
              <div style={{ fontSize: 10, color: logoSubColor, letterSpacing: 1.5, textTransform: 'uppercase', fontWeight: 600 }}>Women's Safety App</div>
            </div>
          </Link>

          {/* Desktop links */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }} className="nav-desktop">
            {navLinks.map(link => {
              const active = location.pathname === link.to
              return (
                <Link
                  key={link.to}
                  to={link.to}
                  style={{
                    padding: '8px 16px',
                    borderRadius: 8,
                    fontWeight: 600,
                    fontSize: 15,
                    textDecoration: 'none',
                    color: active ? activeColor : textColor,
                    background: active ? 'rgba(191,110,238,0.1)' : 'transparent',
                    transition: 'all 0.2s',
                  }}
                >
                  {link.label}
                </Link>
              )
            })}
            <Link
              to="/waitlist"
              style={{
                marginLeft: 8,
                padding: '10px 24px',
                borderRadius: 50,
                fontWeight: 700,
                fontSize: 15,
                textDecoration: 'none',
                color: '#fff',
                background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)',
                boxShadow: '0 4px 15px rgba(191,110,238,0.4)',
                transition: 'all 0.2s',
              }}
            >
              Join Waitlist 💜
            </Link>
          </div>

          {/* Mobile menu button */}
          <button
            onClick={() => setOpen(!open)}
            style={{
              display: 'none',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              color: mobileIconColor,
              padding: 8,
            }}
            className="nav-mobile-btn"
            aria-label="Toggle menu"
          >
            {open ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>

      {/* Mobile menu */}
      {open && (
        <div style={{
          background: '#fff',
          borderTop: '1px solid #EFE0FB',
          padding: '1rem 1.5rem',
          boxShadow: '0 8px 30px rgba(191,110,238,0.15)',
        }}>
          {navLinks.map(link => (
            <Link
              key={link.to}
              to={link.to}
              style={{
                display: 'block',
                padding: '12px 16px',
                borderRadius: 8,
                fontWeight: 600,
                fontSize: 16,
                textDecoration: 'none',
                color: location.pathname === link.to ? '#BF6EEE' : '#374151',
                background: location.pathname === link.to ? 'rgba(191,110,238,0.08)' : 'transparent',
                marginBottom: 4,
              }}
            >
              {link.label}
            </Link>
          ))}
          <Link
            to="/waitlist"
            style={{
              display: 'block',
              width: '100%',
              marginTop: 12,
              padding: '12px 24px',
              borderRadius: 50,
              fontWeight: 700,
              fontSize: 16,
              textDecoration: 'none',
              color: '#fff',
              background: 'linear-gradient(135deg, #D4A5F5, #BF6EEE)',
              textAlign: 'center',
            }}
          >
            Join Waitlist 💜
          </Link>
        </div>
      )}

      <style>{`
        @media (max-width: 768px) {
          .nav-desktop { display: none !important; }
          .nav-mobile-btn { display: block !important; }
        }
        @media (min-width: 769px) {
          .nav-mobile-btn { display: none !important; }
        }
      `}</style>
    </nav>
  )
}
