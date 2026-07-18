import { Check, Clock, SkipForward, Moon } from 'lucide-react'
import { CalendarDays } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { SectionHeader } from '../../components/ui/SectionHeader'
import { Card } from '../../components/ui/Card'
import type { DoseStatus, ScheduleItem } from '../../data/homeData'

interface StatusMeta {
  circle: string
  icon: 'check' | 'clock' | 'skip' | 'moon' | 'none'
  time: string
  pillBg: string
  pillText: string
  label: string
  pillIcon?: 'check'
}

function metaFor(status: DoseStatus): StatusMeta {
  switch (status) {
    case 'taken':
      return {
        circle: 'bg-green-500 text-white',
        icon: 'check',
        time: 'text-green-500',
        pillBg: 'bg-green-soft',
        pillText: 'text-green-500',
        label: 'Taken',
        pillIcon: 'check',
      }
    case 'upcoming':
      return {
        circle: 'bg-brand-500 text-white',
        icon: 'clock',
        time: 'text-brand-500',
        pillBg: 'bg-brand-soft',
        pillText: 'text-brand-500',
        label: 'Upcoming',
      }
    case 'late':
      return {
        circle: 'bg-amber-500 text-white',
        icon: 'clock',
        time: 'text-amber-500',
        pillBg: 'bg-amber-soft',
        pillText: 'text-amber-500',
        label: 'Late',
      }
    case 'missed':
      return {
        circle: 'bg-red-500 text-white',
        icon: 'none',
        time: 'text-red-500',
        pillBg: 'bg-red-soft',
        pillText: 'text-red-500',
        label: 'Missed',
      }
    case 'skipped':
      return {
        circle: 'bg-orange-500 text-white',
        icon: 'skip',
        time: 'text-orange-500',
        pillBg: 'bg-orange-500/10',
        pillText: 'text-orange-500',
        label: 'Skipped',
      }
    case 'snoozed':
      return {
        circle: 'bg-brand-500 text-white',
        icon: 'moon',
        time: 'text-brand-500',
        pillBg: 'bg-brand-soft',
        pillText: 'text-brand-500',
        label: 'Snoozed',
      }
    case 'pending':
    default:
      return {
        circle: 'border-2 border-border-strong bg-surface text-transparent',
        icon: 'none',
        time: 'text-text',
        pillBg: 'bg-surface-2',
        pillText: 'text-text-muted',
        label: 'Pending',
      }
  }
}

export function TodaySchedule({ items, onOptions }: { items: ScheduleItem[]; onOptions?: (item: ScheduleItem) => void }) {
  const navigate = useNavigate()
  return (
    <Card>
      <SectionHeader
        icon={CalendarDays}
        title="Today's Schedule"
        actionLabel="View all"
        onAction={() => navigate('/calendar')}
      />

      {items.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-8 text-center">
          <span className="mb-2 grid h-11 w-11 place-items-center rounded-full bg-surface-2 text-text-faint">
            <CalendarDays size={20} />
          </span>
          <p className="text-[13px] font-semibold text-text">No doses scheduled</p>
          <p className="mt-0.5 text-[11.5px] text-text-muted">Add a medication to see today's schedule.</p>
        </div>
      ) : (
        <div className="relative">
          {/* dotted connector rail behind the status circles */}
          <div className="absolute bottom-6 left-[27px] top-6 w-px border-l-2 border-dashed border-border" />

          <div className="space-y-2">
            {items.map((item) => {
              const m = metaFor(item.status)
              return (
                <button
                  key={item.id}
                  type="button"
                  onClick={() => onOptions?.(item)}
                  className="flex w-full items-center gap-2.5 rounded-[14px] border border-border bg-surface px-2.5 py-2.5 text-left active:scale-[0.99]"
                >
                  <div
                    className={`relative z-10 grid h-8 w-8 shrink-0 place-items-center rounded-full ${m.circle}`}
                  >
                    {m.icon === 'check' && <Check size={15} strokeWidth={3} />}
                    {m.icon === 'clock' && <Clock size={14} strokeWidth={2.5} />}
                    {m.icon === 'skip' && <SkipForward size={14} strokeWidth={2.5} />}
                    {m.icon === 'moon' && <Moon size={14} strokeWidth={2.5} />}
                  </div>

                  <span className={`w-[58px] shrink-0 whitespace-nowrap text-[12px] font-bold tabular-nums ${m.time}`}>
                    {item.time}
                  </span>

                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[13.5px] font-bold text-text">{item.name}</p>
                    <p className="truncate text-[11.5px] text-text-muted">{item.detail}</p>
                  </div>

                  <span
                    className={`flex w-[74px] shrink-0 items-center justify-center gap-1 rounded-full py-1 text-[10px] font-semibold ${m.pillBg} ${m.pillText}`}
                  >
                    {m.pillIcon === 'check' && <Check size={10} strokeWidth={3} />}
                    {m.label}
                  </span>
                </button>
              )
            })}
          </div>
        </div>
      )}
    </Card>
  )
}
