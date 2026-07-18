import { useEffect } from 'react'
import { NavLink, useLocation, useNavigate } from 'react-router-dom'
import { X, Moon, Sun, LogOut, HeartPulse, User } from 'lucide-react'
import { DRAWER_GROUPS } from '../../config/navigation'
import { useTheme } from '../../theme/ThemeProvider'
import { useProfile } from '../../store/profileStore'
import { APP_VERSION } from '../../version'

interface DrawerProps {
  open: boolean
  onClose: () => void
}

export function Drawer({ open, onClose }: DrawerProps) {
  const location = useLocation()
  const navigate = useNavigate()
  const { resolved, toggle } = useTheme()
  const { profile } = useProfile()

  // Close on route change
  useEffect(() => {
    onClose()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [location.pathname])

  // Lock scroll when open
  useEffect(() => {
    if (open) {
      document.body.style.overflow = 'hidden'
    } else {
      document.body.style.overflow = ''
    }
    return () => {
      document.body.style.overflow = ''
    }
  }, [open])

  const isActive = (path: string) =>
    path === '/' ? location.pathname === '/' : location.pathname.startsWith(path)

  return (
    <div
      className={`absolute inset-0 z-50 ${open ? 'pointer-events-auto' : 'pointer-events-none'}`}
      aria-hidden={!open}
    >
      {/* Scrim */}
      <div
        onClick={onClose}
        className={`absolute inset-0 bg-black/40 backdrop-blur-md transition-opacity duration-300 ${
          open ? 'opacity-100' : 'opacity-0'
        }`}
      />

      {/* Panel */}
      <aside
        className={`absolute left-0 top-0 flex h-full w-[82%] max-w-[340px] flex-col bg-bg-elevated shadow-2xl transition-transform duration-300 ease-out ${
          open ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {/* Header */}
        <div
          className="bg-brand-gradient px-5 pb-5 text-white"
          style={{ paddingTop: 'calc(1.25rem + env(safe-area-inset-top))' }}
        >
          <div className="mb-4 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <div className="grid h-9 w-9 place-items-center rounded-xl bg-white/20">
                <HeartPulse size={20} />
              </div>
              <span className="text-lg font-bold">MediCenter</span>
            </div>
            <button
              type="button"
              onClick={onClose}
              aria-label="Close menu"
              className="grid h-9 w-9 place-items-center rounded-full bg-white/15 active:scale-95"
            >
              <X size={18} />
            </button>
          </div>

          <button
            type="button"
            onClick={() => navigate('/profile')}
            className="flex w-full items-center gap-3 rounded-2xl bg-white/15 p-3 text-left active:scale-[0.99]"
          >
            <span className="grid h-11 w-11 place-items-center overflow-hidden rounded-full border-2 border-white/60 bg-white/15">
              {profile.avatar ? (
                <img src={profile.avatar} alt="Profile" className="h-full w-full object-cover" />
              ) : (
                <User size={20} />
              )}
            </span>
            <div className="min-w-0">
              <p className="truncate font-semibold">{profile.name || 'Your Name'}</p>
              <p className="truncate text-xs text-white/80">{profile.email || 'Tap to set up profile'}</p>
            </div>
          </button>
        </div>

        {/* Nav groups */}
        <nav className="no-scrollbar flex-1 overflow-y-auto px-3 py-4">
          {DRAWER_GROUPS.map((group) => (
            <div key={group.title} className="mb-4">
              {group.title && (
                <p className="px-3 pb-1.5 text-[11px] font-semibold uppercase tracking-wider text-text-faint">
                  {group.title}
                </p>
              )}
              <div className="space-y-0.5">
                {group.items.map((item) => {
                  const Icon = item.icon
                  const active = isActive(item.path)
                  return (
                    <NavLink
                      key={item.key}
                      to={item.path}
                      className={`flex items-center gap-3 rounded-xl px-3 py-2.5 text-[14px] font-medium transition-colors ${
                        active
                          ? 'bg-brand-soft text-brand-500'
                          : 'text-text hover:bg-surface-2'
                      }`}
                    >
                      <Icon size={19} strokeWidth={2.1} />
                      {item.label}
                    </NavLink>
                  )
                })}
              </div>
            </div>
          ))}
        </nav>

        {/* Footer */}
        <div className="space-y-1 border-t border-border px-3 py-3">
          <button
            type="button"
            onClick={toggle}
            className="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-[14px] font-medium text-text hover:bg-surface-2"
          >
            {resolved === 'dark' ? <Sun size={19} /> : <Moon size={19} />}
            {resolved === 'dark' ? 'Light Mode' : 'Dark Mode'}
          </button>
          <button
            type="button"
            className="flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-[14px] font-medium text-red-500 hover:bg-red-soft"
          >
            <LogOut size={19} />
            Log Out
          </button>
          <p className="pt-1 text-center text-[11px] text-text-faint">MediCenter {APP_VERSION}</p>
        </div>
      </aside>
    </div>
  )
}
