import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Search, SlidersHorizontal, Bell, MoreVertical, ChevronRight, Plus } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Chips } from '../../components/ui/Chips'
import { Banner } from '../../components/ui/Banner'
import { useMeds, medDetail, timeToMinutes, type Med } from '../../store/medStore'
import { SetReminderModal, ReminderOptionsModal, FilterModal } from '../flows/FlowModals'

type Color = 'purple' | 'orange' | 'green' | 'red'
interface Reminder {
  id: string
  time: string
  color: Color
  name: string
  detail: string
  status?: { label: string; tone: 'green' | 'orange' }
  today?: boolean
}

function toReminder(m: Med): Reminder {
  const min = timeToMinutes(m.time)
  const color: Color = m.foodIcon === 'moon' ? 'purple' : min < 11 * 60 ? 'green' : min < 17 * 60 ? 'orange' : 'red'
  return {
    id: m.id,
    time: m.time,
    color,
    name: m.name,
    detail: medDetail(m),
    status: m.status === 'taken' ? { label: 'Taken', tone: 'green' } : undefined,
    today: true,
  }
}

const colorMap: Record<Color, { bg: string; fg: string }> = {
  purple: { bg: 'bg-brand-soft', fg: 'text-brand-500' },
  orange: { bg: 'bg-amber-soft', fg: 'text-amber-500' },
  green: { bg: 'bg-green-soft', fg: 'text-green-500' },
  red: { bg: 'bg-red-soft', fg: 'text-red-500' },
}

export function RemindersPage() {
  const { openDrawer, openModal } = useShell()
  const { meds } = useMeds()
  const navigate = useNavigate()
  const [chip, setChip] = useState('All')
  const reminders = [...meds].sort((a, b) => timeToMinutes(a.time) - timeToMinutes(b.time)).map(toReminder)
  const pending = reminders.filter((r) => !r.status).length

  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Medication Reminders" subtitle="Never miss your medicines" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Banner
          icon={<Bell size={18} />}
          title="Stay on track!"
          subtitle={`You have ${pending} reminder${pending === 1 ? '' : 's'} left today`}
          showChevron
        />

        <Chips
          items={[
            { label: 'All', count: reminders.length },
            { label: 'Today', count: reminders.length },
            { label: 'Pending', count: pending },
            { label: 'Taken', count: reminders.length - pending },
          ]}
          active={chip}
          onChange={setChip}
        />

        <div className="flex gap-2.5">
          <div className="flex flex-1 items-center gap-2 rounded-2xl bg-surface px-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
            <Search size={16} className="text-text-faint" />
            <input placeholder="Search reminders" className="w-full bg-transparent py-3 text-[13.5px] text-text outline-none placeholder:text-text-faint" />
          </div>
          <button onClick={() => openModal(<FilterModal />)} className="flex items-center gap-1.5 rounded-2xl bg-surface px-4 text-[13px] font-semibold text-brand-500 shadow-[var(--shadow-card)] ring-1 ring-brand-500/40 active:scale-95">
            <SlidersHorizontal size={15} />
            Filter
          </button>
        </div>

        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-text">Today's Reminders</h2>
          <button onClick={() => navigate('/calendar')} className="flex items-center gap-0.5 text-[12.5px] font-semibold text-brand-500">
            View Calendar <ChevronRight size={14} />
          </button>
        </div>

        <div className="space-y-2.5">
          {reminders.map((r) => (
            <ReminderRow key={r.id} r={r} onOptions={() => openModal(<ReminderOptionsModal name={r.name} />)} onBell={() => openModal(<SetReminderModal name={r.name} />)} />
          ))}
        </div>

        <Banner
          icon={<Bell size={18} />}
          title="Set up more reminders"
          subtitle="Add reminders for all your medicines"
          action={
            <button
              onClick={() => openModal(<SetReminderModal />)}
              className="flex shrink-0 items-center gap-1 rounded-xl bg-brand-gradient px-3 py-2 text-[12px] font-bold text-white active:scale-95"
            >
              <Plus size={14} /> Add Reminder
            </button>
          }
        />
      </div>
    </div>
  )
}

function ReminderRow({ r, onOptions, onBell }: { r: Reminder; onOptions: () => void; onBell: () => void }) {
  const c = colorMap[r.color]
  return (
    <div className="flex items-center gap-3 rounded-[18px] bg-surface p-2.5 shadow-[var(--shadow-card)] ring-1 ring-border">
      <div className={`flex w-[70px] shrink-0 flex-col items-center justify-center rounded-2xl py-3 ${c.bg}`}>
        <span className={`text-[13px] font-extrabold ${c.fg}`}>{r.time.split(' ')[0]}</span>
        <span className={`text-[10px] font-bold ${c.fg}`}>{r.time.split(' ')[1]}</span>
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-[14.5px] font-bold text-text">{r.name}</p>
        <p className="truncate text-[12px] text-text-muted">{r.detail}</p>
        {r.status && (
          <span className={`mt-1 inline-block rounded-full px-2 py-0.5 text-[10.5px] font-semibold ${r.status.tone === 'green' ? 'bg-green-soft text-green-500' : 'bg-amber-soft text-amber-500'}`}>
            {r.status.label}
          </span>
        )}
        {r.today && <span className="mt-1 inline-block rounded-full bg-brand-soft px-2 py-0.5 text-[10.5px] font-semibold text-brand-500">Today</span>}
      </div>
      <button onClick={onBell} className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-brand-soft text-brand-500 active:scale-95">
        <Bell size={16} />
      </button>
      <button onClick={onOptions} className="grid h-9 w-8 shrink-0 place-items-center text-text-faint active:scale-95">
        <MoreVertical size={18} />
      </button>
    </div>
  )
}
