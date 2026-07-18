import { NavLink } from 'react-router-dom'
import { Menu, Bell, User } from 'lucide-react'
import { useNotifications } from '../../store/notificationStore'

interface TopBarProps {
  title: string
  subtitle?: string
  onMenu: () => void
  /** show greeting style (big) instead of centered title */
  variant?: 'title' | 'greeting'
  /** @deprecated the badge now reflects the global unread count from the store */
  notificationCount?: number
}

export function TopBar({
  title,
  subtitle,
  onMenu,
  variant = 'title',
}: TopBarProps) {
  const { unreadCount } = useNotifications()
  const notificationCount = unreadCount
  return (
    <header
      className="sticky top-0 z-30 border-b border-border bg-bg/95 px-4 pb-2 shadow-[0_7px_18px_-16px_rgba(15,23,42,0.55)] backdrop-blur-xl"
      style={{ paddingTop: 'calc(0.5rem + env(safe-area-inset-top))' }}
    >
      <div className="flex items-center gap-2">
        <button
          type="button"
          onClick={onMenu}
          aria-label="Open menu"
          className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-surface text-text shadow-[var(--shadow-card)] active:scale-95"
        >
          <Menu size={18} />
        </button>

        <div className="min-w-0 flex-1">
          {variant === 'greeting' ? (
            <>
              <h1 className="truncate text-[17px] font-extrabold leading-tight text-text">
                {title}
              </h1>
              {subtitle && <p className="truncate text-[12px] text-text-muted">{subtitle}</p>}
            </>
          ) : (
            <>
              <h1 className="truncate text-[17px] font-bold leading-tight text-text">{title}</h1>
              {subtitle && <p className="truncate text-[11.5px] text-text-muted">{subtitle}</p>}
            </>
          )}
        </div>

        <NavLink
          to="/notifications"
          aria-label="Notifications"
          className="relative grid h-9 w-9 shrink-0 place-items-center rounded-full bg-surface text-text shadow-[var(--shadow-card)] active:scale-95"
        >
          <Bell size={17} />
          {notificationCount > 0 && (
            <span className="absolute -right-0.5 -top-0.5 grid h-[16px] min-w-[16px] place-items-center rounded-full bg-red-500 px-1 text-[9px] font-bold text-white">
              {notificationCount > 9 ? '9+' : notificationCount}
            </span>
          )}
        </NavLink>

        <NavLink to="/profile" aria-label="Profile" className="shrink-0 active:scale-95">
          <span className="grid h-9 w-9 place-items-center rounded-full border-2 border-surface bg-surface-2 text-text-faint shadow-[var(--shadow-card)]">
            <User size={17} />
          </span>
        </NavLink>
      </div>
    </header>
  )
}
