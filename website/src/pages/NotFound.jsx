import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
import { Home, ArrowLeft, Shield } from 'lucide-react'

export default function NotFound() {
  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #1a0533 0%, #3d1278 50%, #6A1B9A 100%)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: '2rem 1.5rem', textAlign: 'center',
    }}>
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        style={{ maxWidth: 500 }}
      >
        <div style={{ fontSize: 80, marginBottom: 16 }}>💜</div>
        <div style={{
          fontSize: 'clamp(5rem, 15vw, 9rem)',
          fontWeight: 900, color: 'rgba(255,255,255,0.15)',
          lineHeight: 1, marginBottom: 8,
        }}>404</div>
        <h1 style={{ fontSize: 'clamp(1.5rem, 3vw, 2.2rem)', fontWeight: 900, color: '#fff', marginBottom: 16 }}>
          Page Not Found
        </h1>
        <p style={{ color: 'rgba(255,255,255,0.65)', fontSize: 17, lineHeight: 1.7, marginBottom: 40 }}>
          The page you're looking for doesn't exist. It may have been moved, deleted, or the URL might be incorrect.
        </p>
        <div style={{ display: 'flex', gap: 16, justifyContent: 'center', flexWrap: 'wrap' }}>
          <Link to="/" style={{
            display: 'inline-flex', alignItems: 'center', gap: 8,
            padding: '14px 32px', borderRadius: 50,
            background: 'linear-gradient(135deg, #B57BE0, #9B59D0)',
            color: '#fff', fontWeight: 700, fontSize: 16,
            textDecoration: 'none',
            boxShadow: '0 8px 30px rgba(155,89,208,0.5)',
          }}>
            <Home size={18} /> Go Home
          </Link>
          <button
            onClick={() => window.history.back()}
            style={{
              display: 'inline-flex', alignItems: 'center', gap: 8,
              padding: '14px 32px', borderRadius: 50,
              background: 'rgba(255,255,255,0.1)',
              border: '1px solid rgba(255,255,255,0.25)',
              color: '#fff', fontWeight: 700, fontSize: 16,
              cursor: 'pointer',
            }}
          >
            <ArrowLeft size={18} /> Go Back
          </button>
        </div>
        <div style={{ marginTop: 48, display: 'flex', gap: 24, justifyContent: 'center', flexWrap: 'wrap' }}>
          {[
            { to: '/how-it-works', label: 'How It Works' },
            { to: '/grant-funding', label: 'Donate' },
            { to: '/about', label: 'About Us' },
          ].map(l => (
            <Link key={l.to} to={l.to} style={{ color: 'rgba(255,255,255,0.5)', textDecoration: 'none', fontSize: 14, fontWeight: 600, transition: 'color 0.2s' }}>
              {l.label}
            </Link>
          ))}
        </div>
      </motion.div>
    </div>
  )
}
