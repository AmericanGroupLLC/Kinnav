import { useState, useEffect } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Menu, X, Shield } from 'lucide-react'

const navLinks = [
  { to: '/', label: 'Home' },
  { to: '/how-it-works', label: 'How It Works' },
  { to: '/grant-funding', label: 'Grant & Funding' },
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

  useEffect(() => setOpen(false), [location])

  const navBg = scrolled
    ? 'bg-white/95 backdrop-blur-md shadow-lg shadow-purple-100/50'
    : 'bg-transparent'

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
            <img src="/images/safer_icon.png" alt="Safer" style={{ width: 40, height: 40, borderRadius: 10 }} />
            <div>
              <div style={{ fontWeight: 800, fontSize: 20, color: scrolled ? '#6A1B9A' : '#fff', lineHeight: 1 }}>Safer</div>
              <div style={{ fontSize: 10, color: scrolled ? '#9B59D0' : 'rgba(255,255,255,0.8)', letterSpacing: 1.5, textTransform: 'uppercase', fontWeight: 600 }}>Women's Safety App</div>
            </div>
          </Link>

          {/* Desktop links */}
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }} className="hidden-mobile">
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
                    color: active ? '#9B59D0' : (scrolled ? '#374151' : 'rgba(255,255,255,0.9)'),
                    background: active ? 'rgba(155,89,208,0.1)' : 'transparent',
                    transition: 'all 0.2s',
                  }}
                >
                  {link.label}
                </Link>
              )
            })}
            <a
              href="/grant-funding#donate"
              style={{
                marginLeft: 8,
                padding: '10px 24px',
                borderRadius: 50,
                fontWeight: 700,
                fontSize: 15,
                textDecoration: 'none',
                color: '#fff',
                background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
                boxShadow: '0 4px 15px rgba(155,89,208,0.4)',
                transition: 'all 0.2s',
              }}
            >
              Donate Now 💜
            </a>
          </div>

          {/* Mobile menu button */}
          <button
            onClick={() => setOpen(!open)}
            style={{
              display: 'none',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              color: scrolled ? '#6A1B9A' : '#fff',
              padding: 8,
            }}
            className="show-mobile"
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
          borderTop: '1px solid #EDE3F6',
          padding: '1rem 1.5rem',
          boxShadow: '0 8px 30px rgba(155,89,208,0.15)',
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
                color: location.pathname === link.to ? '#9B59D0' : '#374151',
                background: location.pathname === link.to ? 'rgba(155,89,208,0.08)' : 'transparent',
                marginBottom: 4,
              }}
            >
              {link.label}
            </Link>
          ))}
          <a
            href="/grant-funding#donate"
            style={{
              display: 'block',
              marginTop: 12,
              padding: '12px 24px',
              borderRadius: 50,
              fontWeight: 700,
              fontSize: 16,
              textDecoration: 'none',
              color: '#fff',
              background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
              textAlign: 'center',
            }}
          >
            Donate Now 💜
          </a>
        </div>
      )}

      <style>{`
        @media (max-width: 768px) {
          .hidden-mobile { display: none !important; }
          .show-mobile { display: block !important; }
        }
        @media (min-width: 769px) {
          .show-mobile { display: none !important; }
        }
      `}</style>
    </nav>
  )
}
