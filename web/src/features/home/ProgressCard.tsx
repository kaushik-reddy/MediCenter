import { Flame, TrendingUp } from 'lucide-react'
import { Card } from '../../components/ui/Card'
import type { WeekProgress } from '../../data/homeData'

function ProgressRing({ percent }: { percent: number }) {
  const r = 46
  const c = 2 * Math.PI * r
  const offset = c * (1 - percent / 100)
  return (
    <div className="relative h-[84px] w-[84px] shrink-0">
      <svg viewBox="0 0 104 104" className="h-full w-full -rotate-90">
        <circle cx="52" cy="52" r={r} fill="none" stroke="var(--border)" strokeWidth="9" />
        <circle
          cx="52"
          cy="52"
          r={r}
          fill="none"
          stroke="var(--green-500)"
          strokeWidth="9"
          strokeLinecap="round"
          strokeDasharray={c}
          strokeDashoffset={offset}
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-[19px] font-extrabold leading-none text-text">{percent}%</span>
        <span className="mt-0.5 text-[10px] text-text-muted">This Week</span>
      </div>
    </div>
  )
}

function WeekDots({ week, labels }: { week: number[]; labels: string[] }) {
  return (
    <div className="mt-2 flex gap-[3px]">
      {week.map((v, i) => (
        <div key={i} className="flex flex-col items-center gap-1">
          {v === 1 ? (
            <span className="grid h-5 w-5 place-items-center rounded-full bg-green-500 text-white">
              <svg viewBox="0 0 24 24" className="h-3 w-3" fill="none">
                <path
                  d="M5 12l4 4 10-10"
                  stroke="currentColor"
                  strokeWidth="3"
                  strokeLinecap="round"
                  strokeLinejoin="round"
                />
              </svg>
            </span>
          ) : v === 0.5 ? (
            <span
              className="h-5 w-5 rounded-full border-2 border-green-500"
              style={{
                backgroundImage: 'linear-gradient(90deg, var(--green-500) 50%, transparent 50%)',
              }}
            />
          ) : (
            <span className="h-5 w-5 rounded-full border-2 border-border-strong" />
          )}
          <span className="text-[10px] font-medium text-text-muted">{labels[i]}</span>
        </div>
      ))}
    </div>
  )
}

export function ProgressCard({ progress }: { progress: WeekProgress }) {
  return (
    <Card>
      <div className="mb-2.5 flex items-center gap-2">
        <TrendingUp size={17} className="text-brand-500" strokeWidth={2.2} />
        <h2 className="text-[15px] font-bold text-text">Your Progress</h2>
      </div>

      <div className="flex items-center gap-2.5">
        <ProgressRing percent={progress.percent} />

        <div className="min-w-0 flex-1">
          <p className="text-[12.5px] leading-snug text-text">
            <span className="font-bold text-green-500">Great job! </span>
            You're staying consistent.
          </p>
          <WeekDots week={progress.week} labels={progress.weekLabels} />
        </div>

        <div className="flex w-[68px] shrink-0 flex-col items-center justify-center gap-0.5 rounded-2xl bg-[#fff5f0] px-2 py-3.5 dark:bg-[#2a1f18]">
          <div className="flex items-center gap-1">
            <Flame size={18} className="text-[#f97316]" fill="currentColor" />
            <span className="text-[20px] font-extrabold text-[#f97316]">
              {progress.streakDays}
            </span>
          </div>
          <span className="text-[10px] font-medium text-text-muted">Day Streak</span>
        </div>
      </div>
    </Card>
  )
}
