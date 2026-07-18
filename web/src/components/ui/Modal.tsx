import type { ReactNode } from 'react'
import { X } from 'lucide-react'
import { useShell } from '../shell/shellContext'

interface ModalProps {
  children: ReactNode
  onClose?: () => void
  /** Optional icon shown in a colored circle at the top. */
  icon?: ReactNode
  iconBg?: string
  iconFg?: string
  title?: string
  subtitle?: string
  /** Hide the default close (X) button. */
  hideClose?: boolean
}

/**
 * Centered card popup with a scrim, matching the reference pop-up sheets.
 * Rendered inside the overlay layer so it sits above the bottom nav.
 */
export function Modal({
  children,
  onClose,
  icon,
  iconBg = 'bg-brand-soft',
  iconFg = 'text-brand-500',
  title,
  subtitle,
  hideClose,
}: ModalProps) {
  const { closeModal } = useShell()
  const close = onClose ?? closeModal

  return (
    <div className="pointer-events-auto absolute inset-0 z-[60] flex items-end justify-center p-3 sm:items-center sm:p-5">
      <div
        className="absolute inset-0 bg-black/40 backdrop-blur-md animate-[fadeIn_0.2s_ease]"
        onClick={close}
      />
      <div className="relative z-10 flex max-h-[calc(100%-1rem)] w-full max-w-[380px] flex-col overflow-hidden rounded-[24px] bg-surface shadow-[var(--shadow-float)]">
        {!hideClose && (
          <button
            type="button"
            onClick={close}
            aria-label="Close"
            className="absolute right-4 top-4 z-10 grid h-8 w-8 place-items-center rounded-full bg-surface-2 text-text-muted active:scale-95"
          >
            <X size={16} />
          </button>
        )}

        <div className="no-scrollbar overflow-y-auto p-5">
          {icon && (
            <div className={`mx-auto mb-3 grid h-14 w-14 place-items-center rounded-2xl ${iconBg} ${iconFg}`}>
              {icon}
            </div>
          )}
          {title && <h3 className="text-center text-[18px] font-bold text-text">{title}</h3>}
          {subtitle && (
            <p className="mx-auto mt-1 max-w-[280px] text-center text-[13px] text-text-muted">{subtitle}</p>
          )}

          <div className={icon || title ? 'mt-4' : ''}>{children}</div>
        </div>
      </div>
    </div>
  )
}

/** Text input field used inside modals/forms. */
export function Field({
  label,
  value,
  onChange,
  placeholder,
  type = 'text',
}: {
  label: string
  value: string
  onChange: (v: string) => void
  placeholder?: string
  type?: string
}) {
  return (
    <label className="mb-3 block">
      <span className="mb-1 block text-[12.5px] font-semibold text-text-muted">{label}</span>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="w-full rounded-xl border border-border bg-surface-2 px-3.5 py-3 text-[14px] text-text outline-none focus:border-brand-500"
      />
    </label>
  )
}

/** Primary / secondary action buttons row for modals. */
export function ModalActions({
  primaryLabel,
  onPrimary,
  secondaryLabel = 'Cancel',
  onSecondary,
  primaryClass = 'bg-brand-gradient text-white',
}: {
  primaryLabel: string
  onPrimary?: () => void
  secondaryLabel?: string
  onSecondary?: () => void
  primaryClass?: string
}) {
  const { closeModal } = useShell()
  return (
    <div className="mt-2 flex gap-3">
      <button
        type="button"
        onClick={onSecondary ?? closeModal}
        className="flex-1 rounded-xl border border-border py-3 text-[14px] font-bold text-text active:scale-[0.98]"
      >
        {secondaryLabel}
      </button>
      <button
        type="button"
        onClick={onPrimary ?? closeModal}
        className={`flex-1 rounded-xl py-3 text-[14px] font-bold shadow-md active:scale-[0.98] ${primaryClass}`}
      >
        {primaryLabel}
      </button>
    </div>
  )
}
