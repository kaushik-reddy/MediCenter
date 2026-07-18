import type { LucideIcon } from 'lucide-react'
import { ChevronRight } from 'lucide-react'
import type { ReactNode } from 'react'

/** Card container that groups settings rows with dividers. */
export function SettingsGroup({ children }: { children: ReactNode }) {
  return (
    <div className="overflow-hidden rounded-[18px] bg-surface shadow-[var(--shadow-card)] ring-1 ring-border">
      {children}
    </div>
  )
}

interface SettingsRowProps {
  icon: LucideIcon
  iconBg?: string
  iconFg?: string
  title: string
  subtitle?: string
  onClick?: () => void
  /** Right side: defaults to a chevron. Provide a node for toggle/pill. */
  trailing?: ReactNode
  last?: boolean
}

export function SettingsRow({
  icon: Icon,
  iconBg = 'bg-brand-soft',
  iconFg = 'text-brand-500',
  title,
  subtitle,
  onClick,
  trailing,
  last,
}: SettingsRowProps) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`flex w-full items-center gap-3 px-3.5 py-3 text-left active:bg-surface-2 ${
        last ? '' : 'border-b border-border'
      }`}
    >
      <span className={`grid h-10 w-10 shrink-0 place-items-center rounded-xl ${iconBg} ${iconFg}`}>
        <Icon size={19} strokeWidth={2} />
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-[14.5px] font-semibold text-text">{title}</p>
        {subtitle && <p className="truncate text-[12px] text-text-muted">{subtitle}</p>}
      </div>
      {trailing ?? <ChevronRight size={18} className="shrink-0 text-text-faint" />}
    </button>
  )
}

/** Section label above a group (e.g. "Account"). */
export function SettingsSectionLabel({ children }: { children: ReactNode }) {
  return <h2 className="px-1 pb-2 pt-1 text-[14px] font-bold text-text">{children}</h2>
}
