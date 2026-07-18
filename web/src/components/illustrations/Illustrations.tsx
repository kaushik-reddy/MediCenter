/** Decorative SVG illustrations approximating the reference 3D renders. */

export function PillGlassIllustration({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 200 150" fill="none" className={className} aria-hidden>
      <defs>
        <linearGradient id="glassBody" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#ffffff" stopOpacity="0.35" />
          <stop offset="1" stopColor="#ffffff" stopOpacity="0.12" />
        </linearGradient>
        <linearGradient id="waterFill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#bfe9ff" stopOpacity="0.85" />
          <stop offset="1" stopColor="#7fc7f5" stopOpacity="0.7" />
        </linearGradient>
        <linearGradient id="capGreen" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#4ade80" />
          <stop offset="1" stopColor="#22c55e" />
        </linearGradient>
      </defs>

      {/* Glass of water */}
      <g transform="translate(112 20)">
        <path
          d="M8 6 h72 l-7 108 a10 10 0 0 1 -10 9 h-38 a10 10 0 0 1 -10 -9 Z"
          fill="url(#glassBody)"
          stroke="#ffffff"
          strokeOpacity="0.5"
          strokeWidth="2"
        />
        <path d="M14 60 h60 l-4 54 a10 10 0 0 1 -10 9 h-32 a10 10 0 0 1 -10 -9 Z" fill="url(#waterFill)" />
        <ellipse cx="44" cy="8" rx="36" ry="7" fill="#ffffff" fillOpacity="0.5" />
        <ellipse cx="44" cy="60" rx="30" ry="5" fill="#ffffff" fillOpacity="0.4" />
        <rect x="20" y="20" width="6" height="80" rx="3" fill="#ffffff" fillOpacity="0.5" />
      </g>

      {/* Round white pill */}
      <g transform="translate(70 92)">
        <ellipse cx="26" cy="26" rx="26" ry="20" fill="#ffffff" />
        <ellipse cx="26" cy="22" rx="26" ry="20" fill="#f4f4fb" />
        <path d="M6 22 h40" stroke="#d7d7e6" strokeWidth="2" strokeLinecap="round" />
        <ellipse cx="18" cy="14" rx="8" ry="4" fill="#ffffff" />
      </g>

      {/* Green/white capsule */}
      <g transform="rotate(-28 60 70)">
        <rect x="18" y="58" width="86" height="34" rx="17" fill="#ffffff" />
        <path d="M18 58 h43 v34 h-43 a17 17 0 0 1 0 -34 Z" fill="url(#capGreen)" />
        <rect x="26" y="64" width="24" height="8" rx="4" fill="#ffffff" fillOpacity="0.45" />
      </g>
    </svg>
  )
}

export function TipGlassIllustration({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 80 80" fill="none" className={className} aria-hidden>
      <defs>
        <linearGradient id="tipWater" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#bfe9ff" stopOpacity="0.9" />
          <stop offset="1" stopColor="#7fc7f5" stopOpacity="0.8" />
        </linearGradient>
      </defs>
      {/* Glass */}
      <path
        d="M20 14 h34 l-4 46 a7 7 0 0 1 -7 6 h-12 a7 7 0 0 1 -7 -6 Z"
        fill="#ffffff"
        fillOpacity="0.65"
        stroke="#c9d6ea"
        strokeWidth="1.5"
      />
      <path d="M24 36 h26 l-3 24 a7 7 0 0 1 -7 6 h-6 a7 7 0 0 1 -7 -6 Z" fill="url(#tipWater)" />
      <ellipse cx="37" cy="15" rx="17" ry="3.5" fill="#ffffff" fillOpacity="0.7" />
      {/* Pills at base */}
      <circle cx="16" cy="66" r="8" fill="#f59e0b" />
      <circle cx="30" cy="70" r="7" fill="#8b5cf6" />
      <circle cx="44" cy="67" r="6.5" fill="#22c55e" />
      <circle cx="56" cy="70" r="6" fill="#ef4444" />
    </svg>
  )
}

export function ClipboardChartIllustration({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 80 80" fill="none" className={className} aria-hidden>
      <defs>
        <linearGradient id="clip" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#8b5cf6" />
          <stop offset="1" stopColor="#6d4fe0" />
        </linearGradient>
      </defs>
      <rect x="16" y="12" width="44" height="56" rx="8" fill="url(#clip)" />
      <rect x="22" y="18" width="32" height="44" rx="5" fill="#ffffff" />
      <rect x="32" y="7" width="16" height="9" rx="4" fill="#c4b5fd" />
      <circle cx="29" cy="28" r="2.5" fill="#22c55e" />
      <rect x="34" y="26.5" width="16" height="3" rx="1.5" fill="#e5e7eb" />
      <circle cx="29" cy="37" r="2.5" fill="#22c55e" />
      <rect x="34" y="35.5" width="16" height="3" rx="1.5" fill="#e5e7eb" />
      <circle cx="38" cy="52" r="10" fill="#ede9fe" />
      <path d="M38 52 L38 42 A10 10 0 0 1 47 57 Z" fill="#f59e0b" />
      <path d="M38 52 L47 57 A10 10 0 0 1 30 58 Z" fill="#7c5cfc" />
    </svg>
  )
}

export function ShieldCrossIllustration({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 90 90" fill="none" className={className} aria-hidden>
      <defs>
        <linearGradient id="shieldGrad" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#8b5cf6" />
          <stop offset="1" stopColor="#6d4fe0" />
        </linearGradient>
      </defs>
      {/* Sparkles / hearts */}
      <path d="M14 20 l2 4 4 2 -4 2 -2 4 -2 -4 -4 -2 4 -2 Z" fill="#a78bfa" />
      <path
        d="M20 40 c-2 -3 -7 -1 -6 3 c1 3 6 6 6 6 s5 -3 6 -6 c1 -4 -4 -6 -6 -3 Z"
        fill="#c4b5fd"
      />
      {/* Shield */}
      <path
        d="M56 16 l22 8 v20 c0 18 -12 28 -22 32 c-10 -4 -22 -14 -22 -32 V24 Z"
        fill="url(#shieldGrad)"
      />
      <path
        d="M56 22 l16 6 v16 c0 13 -9 21 -16 24 c-7 -3 -16 -11 -16 -24 V28 Z"
        fill="#ffffff"
        fillOpacity="0.12"
      />
      {/* Cross */}
      <g fill="#ffffff">
        <rect x="51" y="34" width="10" height="26" rx="3" />
        <rect x="43" y="42" width="26" height="10" rx="3" />
      </g>
    </svg>
  )
}
