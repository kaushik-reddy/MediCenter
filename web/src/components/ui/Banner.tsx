import type { ReactNode } from 'react'
import { ChevronRight } from 'lucide-react'

interface BannerProps {
  icon: ReactNode
  title: string
  subtitle?: string
  onClick?: () => void
  showChevron?: boolean
  action?: ReactNode
  className?: string
}

/** Lavender info banner used at the bottom of many pages. */
export function Banner({ icon, title, subtitle, onClick, showChevron, action, className = '' }: BannerProps) {
  const Wrapper = onClick ? 'button' : 'div'
  return (
    <Wrapper
      onClick={onClick}
      className={`flex w-full items-center gap-3 rounded-[18px] bg-brand-soft px-3.5 py-3.5 text-left ${className}`}
    >
      <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-surface/70 text-brand-500">
        {icon}
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-[13.5px] font-bold text-brand-500">{title}</p>
        {subtitle && <p className="text-[12px] text-text-muted">{subtitle}</p>}
      </div>
      {action}
      {showChevron && <ChevronRight size={17} className="shrink-0 text-brand-500" />}
    </Wrapper>
  )
}
