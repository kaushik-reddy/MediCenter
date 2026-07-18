interface ToggleProps {
  on: boolean
  onChange?: (v: boolean) => void
}

/** Purple pill toggle switch. */
export function Toggle({ on, onChange }: ToggleProps) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={on}
      onClick={() => onChange?.(!on)}
      className={`relative h-7 w-[46px] shrink-0 rounded-full transition-colors ${
        on ? 'bg-brand-500' : 'bg-border-strong'
      }`}
    >
      <span
        className={`absolute top-0.5 h-6 w-6 rounded-full bg-white shadow transition-all ${
          on ? 'left-[18px]' : 'left-0.5'
        }`}
      />
    </button>
  )
}
