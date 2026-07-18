import { useShell } from '../../components/shell/shellContext'
import { useNavigate } from 'react-router-dom'
import { TopBar } from '../../components/shell/TopBar'
import { Search, Calendar, SlidersHorizontal, Check, Clock, X, ChevronDown, BarChart3 } from 'lucide-react'
import { ClipboardChartIllustration } from '../../components/illustrations/Illustrations'
import { FilterModal, PeriodModal, DateRangeModal } from '../flows/FlowModals'
import { useMeds } from '../../store/medStore'
import {
  historySummary,
  historyGroups,
  type HistoryGroup,
  type HistoryRow,
} from '../../data/historyData'

export function HistoryPage() {
  const { openDrawer } = useShell()
  const { todayLog } = useMeds()
  const todayGroup: HistoryGroup = {
    label: 'Today',
    date: historyGroups[0]?.date ?? 'Today',
    rows: todayLog,
  }
  const groups: HistoryGroup[] = [todayGroup, ...historyGroups.filter((g) => g.label !== 'Today')].filter(
    (g) => g.rows.length > 0,
  )
  return (
    <div className="flex min-h-full flex-col">
      <TopBar
        title="History"
        subtitle="Your medication history and activity."
        onMenu={openDrawer}
        notificationCount={0}
      />

      <div className="space-y-3 px-4 pt-1">
        <SummaryCard />
        <SearchRow />
        {groups.length === 0 ? (
          <div className="flex flex-col items-center justify-center rounded-[18px] bg-surface px-6 py-12 text-center ring-1 ring-border">
            <span className="mb-3 grid h-14 w-14 place-items-center rounded-full bg-surface-2 text-text-faint">
              <BarChart3 size={24} />
            </span>
            <p className="text-[14px] font-bold text-text">No history yet</p>
            <p className="mt-1 max-w-[220px] text-[12px] text-text-muted">
              Your dose history will appear here once you start tracking medicines.
            </p>
          </div>
        ) : (
          groups.map((group) => <Group key={group.label} group={group} />)
        )}
        <InsightsBanner />
      </div>
    </div>
  )
}

function SummaryCard() {
  const { openModal } = useShell()
  const s = historySummary
  return (
    <div className="rounded-[18px] bg-brand-soft p-4">
      <div className="flex gap-4">
        <div className="flex-1">
          <button onClick={() => openModal(<PeriodModal />)} className="flex items-center gap-1 text-[13px] font-semibold text-brand-500">
            {s.period}
            <ChevronDown size={14} />
          </button>
          <div className="mt-1 text-[34px] font-extrabold leading-none text-brand-500">{s.percent}%</div>
          <div className="text-[13px] font-medium text-text">Taken on time</div>
          <div className="mt-2 h-2 w-full overflow-hidden rounded-full bg-surface/70">
            <div className="h-full rounded-full bg-brand-500" style={{ width: `${s.percent}%` }} />
          </div>
          <div className="mt-1.5 text-[11.5px] text-text-muted">{s.dosesText}</div>
        </div>

        <div className="flex gap-2">
          <MiniStat bg="bg-green-soft" fg="text-green-500" icon={<Check size={15} />} n={s.taken} label="Taken" />
          <MiniStat bg="bg-amber-soft" fg="text-amber-500" icon={<Clock size={15} />} n={s.late} label="Late" />
          <MiniStat bg="bg-red-soft" fg="text-red-500" icon={<X size={15} />} n={s.missed} label="Missed" />
        </div>
      </div>
    </div>
  )
}

function MiniStat({
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
    <div className="flex w-[52px] flex-col items-center">
      <span className={`grid h-9 w-9 place-items-center rounded-xl ${bg} ${fg}`}>{icon}</span>
      <div className={`mt-1 text-[17px] font-extrabold leading-none ${fg}`}>{n}</div>
      <div className="text-[10.5px] text-text-muted">{label}</div>
    </div>
  )
}

function SearchRow() {
  const { openModal } = useShell()
  return (
    <div className="flex gap-2.5">
      <div className="flex flex-1 items-center gap-2 rounded-2xl bg-surface px-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
        <Search size={16} className="text-text-faint" />
        <input
          placeholder="Search medication"
          className="w-full bg-transparent py-3 text-[13.5px] text-text outline-none placeholder:text-text-faint"
        />
      </div>
      <button onClick={() => openModal(<DateRangeModal />)} className="flex items-center gap-1.5 rounded-2xl bg-surface px-3 text-[12.5px] font-semibold text-brand-500 shadow-[var(--shadow-card)] ring-1 ring-border active:scale-95">
        <Calendar size={14} />
        Date Range
      </button>
      <button onClick={() => openModal(<FilterModal />)} className="flex items-center gap-1.5 rounded-2xl bg-surface px-3 text-[12.5px] font-semibold text-brand-500 shadow-[var(--shadow-card)] ring-1 ring-brand-500/40 active:scale-95">
        <SlidersHorizontal size={14} />
        Filter
      </button>
    </div>
  )
}

function Group({ group }: { group: HistoryGroup }) {
  return (
    <div>
      <div className="mb-2 flex items-center gap-1.5 px-1">
        <span className="text-[13px] font-bold text-brand-500">{group.label}</span>
        <span className="text-[11px] text-text-faint">•</span>
        <span className="text-[13px] font-semibold text-text-muted">{group.date}</span>
      </div>

      <div className="relative rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
        {/* dotted connector rail */}
        <div className="absolute bottom-10 left-[31px] top-10 w-px border-l-2 border-dashed border-border" />
        {group.rows.map((row, i) => (
          <Row key={row.id} row={row} last={i === group.rows.length - 1} />
        ))}
      </div>
    </div>
  )
}

function Row({ row, last }: { row: HistoryRow; last: boolean }) {
  const circle =
    row.status === 'on-time'
      ? 'bg-green-500'
      : row.status === 'late'
        ? 'bg-amber-500'
        : 'bg-red-500'
  const timeColor =
    row.status === 'on-time'
      ? 'text-green-500'
      : row.status === 'late'
        ? 'text-amber-500'
        : 'text-red-500'
  const pill =
    row.status === 'on-time'
      ? 'bg-green-soft text-green-500'
      : row.status === 'late'
        ? 'bg-amber-soft text-amber-500'
        : 'bg-red-soft text-red-500'
  const Icon = row.status === 'missed' ? X : row.status === 'late' ? Clock : Check

  return (
    <div className={`flex items-center gap-3 py-2.5 ${last ? '' : 'border-b border-border'}`}>
      <span className={`relative z-10 grid h-9 w-9 shrink-0 place-items-center rounded-full text-white ${circle}`}>
        <Icon size={16} strokeWidth={3} />
      </span>
      <span className={`w-[62px] shrink-0 text-[13px] font-bold ${timeColor}`}>{row.time}</span>
      <div className="min-w-0 flex-1">
        <p className="truncate text-[14px] font-bold text-text">{row.name}</p>
        <p className="truncate text-[11.5px] text-text-muted">{row.detail}</p>
      </div>
      <span className={`shrink-0 rounded-full px-2.5 py-1 text-[11px] font-semibold ${pill}`}>{row.badge}</span>
    </div>
  )
}

function InsightsBanner() {
  const navigate = useNavigate()
  return (
    <div className="flex items-center gap-3 rounded-[18px] bg-brand-soft p-3.5">
      <ClipboardChartIllustration className="h-14 w-14 shrink-0" />
      <div className="min-w-0 flex-1">
        <p className="text-[13.5px] font-bold text-brand-500">See patterns, stay consistent</p>
        <p className="text-[12px] leading-snug text-text-muted">
          Track your history to build better habits and improve your health.
        </p>
      </div>
      <button
        onClick={() => navigate('/insights')}
        className="flex shrink-0 items-center gap-1.5 rounded-xl bg-surface px-3 py-2 text-[12px] font-semibold text-brand-500 ring-1 ring-border active:scale-95"
      >
        <BarChart3 size={14} />
        View Insights
      </button>
    </div>
  )
}
