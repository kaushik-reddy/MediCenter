import { type ReactNode } from 'react'
import { ArrowLeft, ArrowRight, X, Check } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'

interface WizardShellProps {
  title: string
  subtitle: string
  steps: string[]
  step: number
  onBack: () => void
  onNext: () => void
  onSave: () => void
  isLast: boolean
  canNext?: boolean
  nextLabel?: string
  saveLabel?: string
  saveIcon?: ReactNode
  children: ReactNode
}

/**
 * Reusable full-screen multi-step wizard with a top numbered stepper.
 * Used by Add Appointment, Add Contact, Travel Mode Setup, etc.
 */
export function WizardShell({
  title,
  subtitle,
  steps,
  step,
  onBack,
  onNext,
  onSave,
  isLast,
  canNext = true,
  nextLabel = 'Next',
  saveLabel = 'Save',
  saveIcon,
  children,
}: WizardShellProps) {
  const { closeModal } = useShell()
  return (
    <div className="pointer-events-auto absolute inset-0 z-[60] flex flex-col">
      <div className="absolute inset-0 bg-black/40 backdrop-blur-md" onClick={closeModal} />

      <div className="relative z-10 m-3 flex min-h-0 flex-1 flex-col overflow-hidden rounded-[26px] bg-bg shadow-[var(--shadow-float)]">
        {/* Header */}
        <div className="flex items-center gap-2 px-4 pt-4 pb-3">
          <button
            type="button"
            onClick={step > 0 ? onBack : closeModal}
            className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-2 text-text active:scale-95"
          >
            <ArrowLeft size={18} />
          </button>
          <div className="min-w-0 flex-1">
            <h2 className="truncate text-[18px] font-extrabold text-text">{title}</h2>
            <p className="truncate text-[11.5px] text-text-muted">{subtitle}</p>
          </div>
          <button
            type="button"
            onClick={closeModal}
            className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-2 text-text active:scale-95"
          >
            <X size={18} />
          </button>
        </div>

        {/* Top stepper */}
        <div className="flex items-start px-4 pb-1">
          {steps.map((label, i) => {
            const done = i < step
            const active = i === step
            return (
              <div key={label} className="flex flex-1 flex-col items-center">
                <div className="flex w-full items-center">
                  <span className={`h-0.5 flex-1 ${i === 0 ? 'opacity-0' : done || active ? 'bg-brand-500' : 'bg-border'}`} />
                  <span
                    className={`grid h-7 w-7 shrink-0 place-items-center rounded-full text-[11px] font-bold ${
                      active ? 'bg-brand-500 text-white' : done ? 'bg-green-500 text-white' : 'bg-surface-2 text-text-muted ring-1 ring-border'
                    }`}
                  >
                    {done ? <Check size={13} strokeWidth={3} /> : i + 1}
                  </span>
                  <span className={`h-0.5 flex-1 ${i === steps.length - 1 ? 'opacity-0' : done ? 'bg-brand-500' : 'bg-border'}`} />
                </div>
                <span className={`mt-1 text-center text-[9.5px] font-semibold leading-tight ${active ? 'text-brand-500' : done ? 'text-text' : 'text-text-faint'}`}>
                  {label}
                </span>
              </div>
            )
          })}
        </div>

        {/* Content */}
        <div className="no-scrollbar min-h-0 flex-1 overflow-y-auto px-4 pb-3 pt-2">{children}</div>

        {/* Footer */}
        <div className="flex gap-3 border-t border-border px-4 py-3">
          <button
            type="button"
            onClick={step > 0 ? onBack : closeModal}
            className="flex-1 rounded-xl border border-border py-3 text-[14px] font-bold text-text active:scale-[0.98]"
          >
            {step > 0 ? 'Back' : 'Cancel'}
          </button>
          {isLast ? (
            <button
              type="button"
              onClick={onSave}
              className="flex flex-[1.4] items-center justify-center gap-2 rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
            >
              {saveIcon ?? <Check size={16} strokeWidth={3} />} {saveLabel}
            </button>
          ) : (
            <button
              type="button"
              disabled={!canNext}
              onClick={onNext}
              className="flex flex-[1.4] items-center justify-center gap-2 rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98] disabled:opacity-50"
            >
              {nextLabel} <ArrowRight size={16} />
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

/* ---- Shared wizard field primitives ---- */
export function WLabel({ children }: { children: ReactNode }) {
  return <p className="mb-1.5 text-[12.5px] font-semibold text-text">{children}</p>
}

export function WField({
  label,
  value,
  onChange,
  placeholder,
  type = 'text',
  icon,
}: {
  label?: string
  value: string
  onChange: (v: string) => void
  placeholder?: string
  type?: string
  icon?: ReactNode
}) {
  return (
    <label className="mb-3 block">
      {label && <WLabel>{label}</WLabel>}
      <div className="flex items-center gap-2 rounded-xl border border-border bg-surface-2 px-3">
        {icon && <span className="text-text-faint">{icon}</span>}
        <input
          type={type}
          value={value}
          onChange={(e) => onChange(e.target.value)}
          placeholder={placeholder}
          className="w-full bg-transparent py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
        />
      </div>
    </label>
  )
}

export function WPanel({ children }: { children: ReactNode }) {
  return <div className="mb-3 rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">{children}</div>
}

export function WNote({ text }: { text: string }) {
  return (
    <div className="mb-3 flex items-start gap-2 rounded-xl bg-green-soft px-3 py-2.5 text-[11.5px] font-medium text-green-500">
      <Check size={13} strokeWidth={3} className="mt-0.5 shrink-0" /> {text}
    </div>
  )
}
