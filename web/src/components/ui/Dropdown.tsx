import { useEffect, useLayoutEffect, useRef, useState } from 'react'
import { ChevronDown, Check } from 'lucide-react'

interface DropdownProps {
  value: string
  onChange: (v: string) => void
  options: string[]
  /** Visual style of the trigger. */
  variant?: 'field' | 'time'
  /** Optional aria label for the time variant (no visible label). */
  ariaLabel?: string
}

/**
 * Custom dropdown that matches the app's popup design (rounded surface,
 * brand-soft selection, float shadow) instead of the native OS <select>.
 */
export function Dropdown({ value, onChange, options, variant = 'field', ariaLabel }: DropdownProps) {
  const [open, setOpen] = useState(false)
  const ref = useRef<HTMLDivElement>(null)
  const selectedRef = useRef<HTMLButtonElement>(null)
  const isTime = variant === 'time'

  useEffect(() => {
    if (!open) return
    const onDoc = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false)
    }
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setOpen(false)
    }
    document.addEventListener('mousedown', onDoc)
    document.addEventListener('keydown', onKey)
    return () => {
      document.removeEventListener('mousedown', onDoc)
      document.removeEventListener('keydown', onKey)
    }
  }, [open])

  // Keep the selected option in view when a long list opens (e.g. minutes).
  useLayoutEffect(() => {
    if (open) selectedRef.current?.scrollIntoView({ block: 'center' })
  }, [open])

  return (
    <div ref={ref} className={`relative ${isTime ? 'inline-block' : ''}`}>
      <button
        type="button"
        aria-label={ariaLabel}
        aria-haspopup="listbox"
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
        className={
          isTime
            ? `flex items-center gap-1 rounded-2xl px-4 py-3 text-[22px] font-bold text-brand-500 outline-none transition-colors active:scale-[0.98] ${open ? 'bg-brand-500/15 ring-2 ring-brand-500' : 'bg-brand-soft'}`
            : `flex w-full items-center justify-between rounded-xl border bg-surface-2 px-3.5 py-3 text-[14px] text-text outline-none transition-colors active:scale-[0.99] ${open ? 'border-brand-500' : 'border-border'}`
        }
      >
        <span>{value}</span>
        <ChevronDown
          size={16}
          className={`transition-transform ${open ? 'rotate-180' : ''} ${isTime ? 'text-brand-500/70' : 'text-text-faint'}`}
        />
      </button>

      {open && (
        <div
          role="listbox"
          className={`absolute z-[80] mt-2 max-h-56 overflow-y-auto rounded-2xl border border-border bg-surface p-1.5 shadow-[var(--shadow-float)] animate-[fadeIn_0.12s_ease] ${
            isTime ? 'left-1/2 w-[96px] -translate-x-1/2' : 'left-0 right-0'
          }`}
        >
          {options.map((o) => {
            const selected = o === value
            return (
              <button
                key={o}
                ref={selected ? selectedRef : undefined}
                type="button"
                role="option"
                aria-selected={selected}
                onClick={() => {
                  onChange(o)
                  setOpen(false)
                }}
                className={`flex w-full items-center gap-2 rounded-xl px-3 py-2.5 text-[14px] font-semibold ${
                  isTime ? 'justify-center' : 'justify-between text-left'
                } ${selected ? 'bg-brand-soft text-brand-500' : 'text-text active:bg-surface-2'}`}
              >
                <span>{o}</span>
                {selected && !isTime && <Check size={16} strokeWidth={3} className="text-brand-500" />}
              </button>
            )
          })}
        </div>
      )}
    </div>
  )
}
