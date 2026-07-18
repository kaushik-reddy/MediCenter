import type { LucideIcon } from 'lucide-react'
import { ChevronRight } from 'lucide-react'

interface SectionHeaderProps {
  icon?: LucideIcon
  title: string
  actionLabel?: string
  onAction?: () => void
}

/** Schedule section heading with an optional view-all action. */
export function SectionHeader({ icon: Icon, title, actionLabel, onAction }: SectionHeaderProps) {
  return (
    <div className="mb-2.5 flex items-center justify-between">
      <div className="flex items-center gap-2">
        {Icon && <Icon size={17} className="text-brand-500" strokeWidth={2.2} />}
        <h2 className="text-[15px] font-bold text-text">{title}</h2>
      </div>
      {actionLabel && (
        <button
          type="button"
          onClick={onAction}
          className="flex items-center gap-0.5 text-[12.5px] font-semibold text-brand-500 active:opacity-70"
        >
          {actionLabel}
          <ChevronRight size={14} />
        </button>
      )}
    </div>
  )
}
