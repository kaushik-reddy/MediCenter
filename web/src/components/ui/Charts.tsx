/** Lightweight SVG charts (no external dependency). */

export function GaugeRing({
  percent,
  size = 120,
  stroke = 11,
  color = 'var(--green-500)',
  track = 'var(--border)',
  label,
  sub,
}: {
  percent: number
  size?: number
  stroke?: number
  color?: string
  track?: string
  label?: string
  sub?: string
}) {
  const r = (100 - stroke) / 2
  const c = 2 * Math.PI * r
  const offset = c * (1 - percent / 100)
  return (
    <div className="relative" style={{ width: size, height: size }}>
      <svg viewBox="0 0 100 100" className="h-full w-full -rotate-90">
        <circle cx="50" cy="50" r={r} fill="none" stroke={track} strokeWidth={stroke} />
        <circle
          cx="50"
          cy="50"
          r={r}
          fill="none"
          stroke={color}
          strokeWidth={stroke}
          strokeLinecap="round"
          strokeDasharray={c}
          strokeDashoffset={offset}
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        {label && <span className="text-[22px] font-extrabold leading-none text-text">{label}</span>}
        {sub && <span className="mt-0.5 text-[10.5px] text-text-muted">{sub}</span>}
      </div>
    </div>
  )
}

export interface DonutSeg {
  value: number
  color: string
}
export function DonutChart({
  segments,
  size = 120,
  stroke = 16,
  centerLabel,
  centerSub,
}: {
  segments: DonutSeg[]
  size?: number
  stroke?: number
  centerLabel?: string
  centerSub?: string
}) {
  const total = segments.reduce((s, x) => s + x.value, 0) || 1
  const r = (100 - stroke) / 2
  const c = 2 * Math.PI * r
  let acc = 0
  return (
    <div className="relative" style={{ width: size, height: size }}>
      <svg viewBox="0 0 100 100" className="h-full w-full -rotate-90">
        {segments.map((s, i) => {
          const len = (s.value / total) * c
          const el = (
            <circle
              key={i}
              cx="50"
              cy="50"
              r={r}
              fill="none"
              stroke={s.color}
              strokeWidth={stroke}
              strokeDasharray={`${len} ${c - len}`}
              strokeDashoffset={-acc}
            />
          )
          acc += len
          return el
        })}
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        {centerLabel && <span className="text-[20px] font-extrabold leading-none text-text">{centerLabel}</span>}
        {centerSub && <span className="mt-0.5 text-[10px] text-text-muted">{centerSub}</span>}
      </div>
    </div>
  )
}

export function BarChart({
  data,
  labels,
  colors,
  height = 120,
  max = 100,
  suffix = '%',
}: {
  data: number[]
  labels: string[]
  colors?: string[]
  height?: number
  max?: number
  suffix?: string
}) {
  return (
    <div className="flex items-end justify-between gap-1.5" style={{ height }}>
      {data.map((v, i) => (
        <div key={i} className="flex flex-1 flex-col items-center gap-1">
          <span className="text-[9px] font-semibold text-text-muted">{v}{suffix}</span>
          <div className="flex w-full flex-1 items-end">
            <div
              className="w-full rounded-t-md"
              style={{ height: `${(v / max) * 100}%`, backgroundColor: colors?.[i] ?? 'var(--brand-500)' }}
            />
          </div>
          <span className="text-[10px] text-text-muted">{labels[i]}</span>
        </div>
      ))}
    </div>
  )
}

export function AreaLine({
  data,
  height = 110,
  color = 'var(--brand-500)',
}: {
  data: number[]
  height?: number
  color?: string
}) {
  const w = 300
  const h = 100
  const max = Math.max(...data, 1)
  const min = Math.min(...data, 0)
  const range = max - min || 1
  const step = w / (data.length - 1)
  const pts = data.map((v, i) => [i * step, h - ((v - min) / range) * (h - 10) - 5])
  const line = pts.map((p, i) => `${i === 0 ? 'M' : 'L'} ${p[0]} ${p[1]}`).join(' ')
  const area = `${line} L ${w} ${h} L 0 ${h} Z`
  return (
    <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="none" className="w-full" style={{ height }}>
      <defs>
        <linearGradient id="areaFill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor={color} stopOpacity="0.28" />
          <stop offset="1" stopColor={color} stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={area} fill="url(#areaFill)" />
      <path d={line} fill="none" stroke={color} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
      {pts.map((p, i) => (
        <circle key={i} cx={p[0]} cy={p[1]} r="3" fill={color} />
      ))}
    </svg>
  )
}

export function Sparkline({ data, color = 'var(--brand-500)', height = 34 }: { data: number[]; color?: string; height?: number }) {
  const w = 100
  const h = 30
  const max = Math.max(...data, 1)
  const min = Math.min(...data, 0)
  const range = max - min || 1
  const step = w / (data.length - 1)
  const line = data.map((v, i) => `${i === 0 ? 'M' : 'L'} ${i * step} ${h - ((v - min) / range) * h}`).join(' ')
  return (
    <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="none" className="w-full" style={{ height }}>
      <path d={line} fill="none" stroke={color} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  )
}
