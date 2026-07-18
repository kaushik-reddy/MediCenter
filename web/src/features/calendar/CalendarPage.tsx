import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { MarkAsTakenModal, InfoModal } from '../flows/FlowModals'
import { useMeds } from '../../store/medStore'
import {
  ChevronLeft,
  ChevronRight,
  ChevronDown,
  BarChart3,
  Check,
  Clock,
  X,
  Sunrise,
  Sun,
  Moon,
  CalendarDays,
  TrendingUp,
} from 'lucide-react'
import {
  days,
  weekdays,
  selectedDayStats,
  selectedDayMeds,
  quickStats,
  type DotColor,
  type DayCell,
  type DayMed,
} from '../../data/calendarData'

const dotClass: Record<DotColor, string> = {
  green: 'bg-green-500',
  amber: 'bg-amber-500',
  red: 'bg-red-500',
}

// Demo adherence dots for May 2024, keyed by day-of-month.
const mayDots: Record<number, DotColor[]> = {}
days.forEach((c) => {
  if (c.inMonth && c.dots) mayDots[c.day] = c.dots
})

interface ViewMonth {
  y: number
  m: number
}

export function CalendarPage() {
  const { openDrawer } = useShell()
  const [view, setView] = useState<ViewMonth>({ y: 2024, m: 4 }) // May 2024
  const [selected, setSelected] = useState(20)

  const prevMonth = () => setView((v) => (v.m === 0 ? { y: v.y - 1, m: 11 } : { y: v.y, m: v.m - 1 }))
  const nextMonth = () => setView((v) => (v.m === 11 ? { y: v.y + 1, m: 0 } : { y: v.y, m: v.m + 1 }))
  const goToday = () => {
    setView({ y: 2024, m: 4 })
    setSelected(20)
  }

  const selectedLabel = new Date(view.y, view.m, selected).toLocaleDateString('en-US', {
    weekday: 'long',
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  })

  return (
    <div className="flex min-h-full flex-col">
      <TopBar
        title="Calendar"
        subtitle="Track your medication history by date"
        onMenu={openDrawer}
        notificationCount={0}
      />

      <div className="space-y-3 px-4 pt-1">
        <MonthCard
          view={view}
          selected={selected}
          onSelect={setSelected}
          onPrev={prevMonth}
          onNext={nextMonth}
          onToday={goToday}
        />
        <DaySummaryCard label={selectedLabel} />
        <QuickStatsCard />
        <Banner />
      </div>
    </div>
  )
}

function MonthCard({
  view,
  selected,
  onSelect,
  onPrev,
  onNext,
  onToday,
}: {
  view: ViewMonth
  selected: number
  onSelect: (d: number) => void
  onPrev: () => void
  onNext: () => void
  onToday: () => void
}) {
  const label = new Date(view.y, view.m, 1).toLocaleDateString('en-US', { month: 'long', year: 'numeric' })
  const firstDow = new Date(view.y, view.m, 1).getDay()
  const daysInMonth = new Date(view.y, view.m + 1, 0).getDate()
  const prevMonthDays = new Date(view.y, view.m, 0).getDate()
  const isMay2024 = view.y === 2024 && view.m === 4

  const cells: DayCell[] = []
  for (let i = 0; i < firstDow; i++) {
    cells.push({ day: prevMonthDays - firstDow + 1 + i, inMonth: false })
  }
  for (let d = 1; d <= daysInMonth; d++) {
    cells.push({ day: d, inMonth: true, today: isMay2024 && d === 20, dots: isMay2024 ? mayDots[d] : undefined })
  }
  const trailing = (7 - (cells.length % 7)) % 7
  for (let i = 1; i <= trailing; i++) cells.push({ day: i, inMonth: false })

  return (
    <div className="rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
      <div className="mb-3 flex items-center justify-between">
        <button onClick={onPrev} className="grid h-8 w-8 place-items-center rounded-full bg-surface-2 text-text active:scale-95">
          <ChevronLeft size={17} />
        </button>
        <div className="flex items-center gap-2">
          <h2 className="text-[16px] font-bold text-text">{label}</h2>
          <button onClick={onNext} className="grid h-8 w-8 place-items-center rounded-full bg-surface-2 text-text active:scale-95">
            <ChevronRight size={17} />
          </button>
        </div>
        <button onClick={onToday} className="rounded-xl border border-brand-500/40 px-3 py-1.5 text-[12px] font-semibold text-brand-500 active:scale-95">
          Today
        </button>
      </div>

      <div className="grid grid-cols-7 border-b border-border pb-2">
        {weekdays.map((d) => (
          <div key={d} className="text-center text-[11px] font-medium text-text-muted">
            {d}
          </div>
        ))}
      </div>

      <div className="grid grid-cols-7 gap-y-1.5 pt-2">
        {cells.map((cell, i) => (
          <button
            key={i}
            type="button"
            onClick={() => cell.inMonth && onSelect(cell.day)}
            className="flex flex-col items-center gap-0.5 py-0.5"
          >
            {cell.today ? (
              <span className="grid h-8 w-8 place-items-center rounded-full bg-brand-500 text-[13px] font-bold text-white">
                {cell.day}
              </span>
            ) : (
              <span
                className={`grid h-8 w-8 place-items-center rounded-full text-[13px] font-semibold ${
                  cell.inMonth ? 'text-text' : 'text-text-faint'
                } ${selected === cell.day && cell.inMonth ? 'ring-2 ring-brand-500' : ''}`}
              >
                {cell.day}
              </span>
            )}
            <span className="flex h-1.5 items-center gap-0.5">
              {cell.dots?.map((c, j) => (
                <span key={j} className={`h-1.5 w-1.5 rounded-full ${dotClass[c]}`} />
              ))}
            </span>
          </button>
        ))}
      </div>

      <div className="mt-2 flex items-center justify-between rounded-xl border border-border px-3 py-2">
        <Legend color="bg-green-500" label="Taken" />
        <Legend color="bg-amber-500" label="Late" />
        <Legend color="bg-red-500" label="Missed" />
        <Legend color="bg-text-faint" label="No Data" />
      </div>
    </div>
  )
}

function Legend({ color, label }: { color: string; label: string }) {
  return (
    <div className="flex items-center gap-1.5">
      <span className={`h-2 w-2 rounded-full ${color}`} />
      <span className="text-[11px] font-medium text-text-muted">{label}</span>
    </div>
  )
}

function DaySummaryCard({ label }: { label: string }) {
  const { openModal } = useShell()
  const navigate = useNavigate()
  return (
    <div className="rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
      <div className="mb-3 flex items-center justify-between">
        <h2 className="text-[15px] font-bold text-text">{label}</h2>
        <button
          onClick={() =>
            openModal(
              <InfoModal
                title={label}
                message={`${selectedDayStats.taken} taken · ${selectedDayStats.late} late · ${selectedDayStats.missed} missed`}
              />,
            )
          }
          className="flex items-center gap-1.5 rounded-xl border border-brand-500/40 px-2.5 py-1.5 text-[12px] font-semibold text-brand-500 active:scale-95"
        >
          <BarChart3 size={14} />
          Summary
        </button>
      </div>

      <div className="mb-3 grid grid-cols-3 gap-2">
        <StatTile bg="bg-green-soft" fg="text-green-500" icon={<Check size={16} />} n={selectedDayStats.taken} label="Taken" />
        <StatTile bg="bg-amber-soft" fg="text-amber-500" icon={<Clock size={16} />} n={selectedDayStats.late} label="Late" />
        <StatTile bg="bg-red-soft" fg="text-red-500" icon={<X size={16} />} n={selectedDayStats.missed} label="Missed" />
      </div>

      <div>
        {selectedDayMeds.map((med, i) => (
          <DayMedRow key={med.id} med={med} last={i === selectedDayMeds.length - 1} />
        ))}
      </div>

      <button
        onClick={() => navigate('/history')}
        className="mt-1 flex w-full items-center justify-center gap-1 border-t border-border pt-2.5 text-[13px] font-semibold text-brand-500"
      >
        View All
        <ChevronDown size={15} />
      </button>
    </div>
  )
}

function StatTile({
  bg,
  fg,
  icon,
  n,
  label,
}: {
  bg: string
  fg: string
  icon: React.ReactNode
  n: number
  label: string
}) {
  return (
    <div className={`flex items-center gap-2 rounded-2xl px-3 py-2.5 ${bg}`}>
      <span className={`grid h-8 w-8 place-items-center rounded-full bg-surface/70 ${fg}`}>{icon}</span>
      <div>
        <div className={`text-[18px] font-extrabold leading-none ${fg}`}>{n}</div>
        <div className="text-[11px] text-text-muted">{label}</div>
      </div>
    </div>
  )
}

function DayMedRow({ med, last }: { med: DayMed; last: boolean }) {
  const { openModal } = useShell()
  const { meds } = useMeds()
  const storeMed = meds.find((m) => m.name === med.name)
  const whenIcon =
    med.when === 'morning' ? <Sunrise size={15} /> : med.when === 'noon' ? <Sun size={15} /> : <Moon size={15} />
  const whenBg =
    med.when === 'morning' ? 'bg-green-soft text-green-500' : med.when === 'noon' ? 'bg-amber-soft text-amber-500' : 'bg-brand-soft text-brand-500'
  const badge =
    med.status === 'taken'
      ? 'bg-green-500 text-white'
      : med.status === 'late'
        ? 'bg-amber-500 text-white'
        : 'bg-red-500 text-white'
  const timeColor = med.status === 'late' ? 'text-amber-500' : 'text-text'
  const StatusIcon = med.status === 'missed' ? X : med.status === 'late' ? Clock : Check

  return (
    <button
      type="button"
      onClick={() => openModal(<MarkAsTakenModal name={med.name} medId={storeMed?.id} />)}
      className={`flex w-full items-center gap-3 py-2.5 text-left ${last ? '' : 'border-b border-border'}`}
    >
      <div className="relative">
        <span className={`grid h-9 w-9 place-items-center rounded-full ${whenBg}`}>{whenIcon}</span>
        <span className={`absolute -bottom-0.5 -right-0.5 grid h-4 w-4 place-items-center rounded-full ${badge}`}>
          <StatusIcon size={9} strokeWidth={3} />
        </span>
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-[14px] font-bold text-text">{med.name}</p>
        <p className="truncate text-[11.5px] text-text-muted">{med.detail}</p>
      </div>
      <span className={`text-[13px] font-bold ${timeColor}`}>{med.time}</span>
      <ChevronRight size={16} className="text-text-faint" />
    </button>
  )
}

function QuickStatsCard() {
  return (
    <div className="rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
      <h2 className="mb-3 text-[15px] font-bold text-text">
        Quick Stats <span className="text-[12px] font-normal text-text-muted">({quickStats.month})</span>
      </h2>
      <div className="grid grid-cols-2 gap-2.5">
        <QuickTile bg="bg-brand-soft" fg="text-brand-500" icon={<CalendarDays size={16} />} n={`${quickStats.takenDays}`} label="Taken Days" />
        <QuickTile bg="bg-amber-soft" fg="text-amber-500" icon={<Clock size={16} />} n={`${quickStats.lateDays}`} label="Late Days" />
        <QuickTile bg="bg-red-soft" fg="text-red-500" icon={<X size={16} />} n={`${quickStats.missedDays}`} label="Missed Days" />
        <QuickTile bg="bg-blue-soft" fg="text-blue-500" icon={<TrendingUp size={16} />} n={`${quickStats.adherence}%`} label="Adherence" />
      </div>
    </div>
  )
}

function QuickTile({
  bg,
  fg,
  icon,
  n,
  label,
}: {
  bg: string
  fg: string
  icon: React.ReactNode
  n: string
  label: string
}) {
  return (
    <div className={`flex items-center gap-2.5 rounded-2xl px-3 py-3 ${bg}`}>
      <span className={`grid h-9 w-9 place-items-center rounded-xl bg-surface/70 ${fg}`}>{icon}</span>
      <div>
        <div className={`text-[17px] font-extrabold leading-none ${fg}`}>{n}</div>
        <div className="mt-0.5 text-[11px] text-text-muted">{label}</div>
      </div>
    </div>
  )
}

function Banner() {
  const { openModal } = useShell()
  return (
    <button
      onClick={() => openModal(<InfoModal title="Keep it up!" message="You're building a healthy streak. Stay consistent to reach your goals." icon={<CalendarDays size={22} />} />)}
      className="flex w-full items-center gap-3 rounded-[18px] bg-brand-soft px-3.5 py-3 text-left"
    >
      <span className="grid h-9 w-9 place-items-center rounded-xl bg-surface/70 text-brand-500">
        <CalendarDays size={18} />
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-[13px] font-bold text-brand-500">Stay consistent!</p>
        <p className="text-[12px] text-text-muted">Great job! You're building a healthy streak.</p>
      </div>
      <ChevronRight size={17} className="text-brand-500" />
    </button>
  )
}
