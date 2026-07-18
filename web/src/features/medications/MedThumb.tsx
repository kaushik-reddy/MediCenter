import type { PillKind } from '../../data/medicationsData'

interface MedThumbProps {
  kind: PillKind
  tint: string
  colors: [string, string]
  className?: string
}

/** A rounded tinted tile with a small 3D-ish pill illustration. */
export function MedThumb({ kind, tint, colors, className = '' }: MedThumbProps) {
  return (
    <div
      className={`grid shrink-0 place-items-center overflow-hidden rounded-2xl ${className}`}
      style={{ backgroundColor: tint }}
    >
      <svg viewBox="0 0 64 64" className="h-[72%] w-[72%]" aria-hidden>
        <defs>
          <linearGradient id={`g-${colors[0].replace('#', '')}`} x1="0" y1="0" x2="1" y2="1">
            <stop offset="0" stopColor={colors[0]} />
            <stop offset="1" stopColor={shade(colors[0], -12)} />
          </linearGradient>
        </defs>

        {kind === 'capsule' && (
          <g transform="rotate(-35 32 32)">
            <rect x="10" y="24" width="44" height="18" rx="9" fill="#ffffff" />
            <path d="M10 24 h22 v18 h-22 a9 9 0 0 1 0 -18 Z" fill={`url(#g-${colors[0].replace('#', '')})`} />
            <rect x="15" y="27" width="12" height="4" rx="2" fill="#ffffff" opacity="0.5" />
            <ellipse cx="46" cy="33" rx="6" ry="7" fill="#ffffff" opacity="0.7" />
          </g>
        )}

        {kind === 'softgel' && (
          <g transform="rotate(-30 32 32)">
            <ellipse cx="32" cy="32" rx="22" ry="13" fill={`url(#g-${colors[0].replace('#', '')})`} />
            <ellipse cx="25" cy="28" rx="7" ry="3.5" fill="#ffffff" opacity="0.55" />
          </g>
        )}

        {kind === 'tablet' && (
          <g>
            <ellipse cx="32" cy="34" rx="22" ry="18" fill={shade(colors[0], -10)} />
            <ellipse cx="32" cy="30" rx="22" ry="18" fill={colors[0]} />
            <path d="M12 30 h40" stroke={shade(colors[0], -18)} strokeWidth="2" strokeLinecap="round" />
            <ellipse cx="24" cy="22" rx="7" ry="3.5" fill="#ffffff" opacity="0.5" />
          </g>
        )}
      </svg>
    </div>
  )
}

/** Lighten/darken a hex color by percent (-100..100). */
function shade(hex: string, percent: number): string {
  const n = parseInt(hex.replace('#', ''), 16)
  const r = (n >> 16) & 0xff
  const g = (n >> 8) & 0xff
  const b = n & 0xff
  const t = percent < 0 ? 0 : 255
  const p = Math.abs(percent) / 100
  const nr = Math.round((t - r) * p) + r
  const ng = Math.round((t - g) * p) + g
  const nb = Math.round((t - b) * p) + b
  return `#${((1 << 24) + (nr << 16) + (ng << 8) + nb).toString(16).slice(1)}`
}
