interface ChipsProps {
  items: { label: string; count?: number }[]
  active: string
  onChange: (label: string) => void
}

/** Horizontal scrollable filter chips row. */
export function Chips({ items, active, onChange }: ChipsProps) {
  return (
    <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
      {items.map((c) => (
        <button
          key={c.label}
          onClick={() => onChange(c.label)}
          className={`flex shrink-0 items-center gap-1.5 rounded-full px-3.5 py-2 text-[12.5px] font-semibold transition-colors ${
            active === c.label
              ? 'bg-brand-500 text-white'
              : 'bg-surface text-text-muted ring-1 ring-border'
          }`}
        >
          {c.label}
          {c.count != null && (
            <span
              className={`rounded-full px-1.5 text-[10px] font-bold ${
                active === c.label ? 'bg-white/25 text-white' : 'bg-surface-2 text-text-muted'
              }`}
            >
              {c.count}
            </span>
          )}
        </button>
      ))}
    </div>
  )
}
