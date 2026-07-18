import { ChevronRight, Clock, Pill, Utensils, Moon } from 'lucide-react'
import { MedThumb } from './MedThumb'
import type { DayState, Medication } from '../../data/medicationsData'

const DAY_LABELS = ['M', 'T', 'W', 'T', 'F', 'S', 'S']

function WeekdayStrip({ days, color }: { days: DayState[]; color: 'green' | 'purple' }) {
  const on = color === 'green' ? 'bg-green-500' : 'bg-brand-500'
  const ring = color === 'green' ? 'border-green-500 text-green-500' : 'border-brand-500 text-brand-500'
  return (
    <div className="flex items-center gap-1.5">
      {days.map((state, i) => {
        if (state === 'on') {
          return (
            <span
              key={i}
              className={`grid h-6 w-6 place-items-center rounded-full text-[11px] font-bold text-white ${on}`}
            >
              {DAY_LABELS[i]}
            </span>
          )
        }
        if (state === 'ring') {
          return (
            <span
              key={i}
              className={`grid h-6 w-6 place-items-center rounded-full border-2 bg-transparent text-[11px] font-bold ${ring}`}
            >
              {DAY_LABELS[i]}
            </span>
          )
        }
        return (
          <span key={i} className="grid h-6 w-6 place-items-center text-[11px] font-semibold text-text-faint">
            {DAY_LABELS[i]}
          </span>
        )
      })}
    </div>
  )
}

export function MedicationCard({ med, onClick }: { med: Medication; onClick?: () => void }) {
  const timeColor = med.color === 'green' ? 'text-green-500' : 'text-brand-500'
  const stripBg = med.color === 'green' ? 'bg-green-soft' : 'bg-brand-soft'
  const FoodIcon = med.foodIcon === 'moon' ? Moon : Utensils

  return (
    <button
      type="button"
      onClick={onClick}
      className="flex w-full items-start gap-3 rounded-[18px] bg-surface p-3 text-left shadow-[var(--shadow-card)] ring-1 ring-border active:scale-[0.99]"
    >
      <MedThumb kind={med.kind} tint={med.tint} colors={med.pillColors} className="h-[68px] w-[68px]" />

      <div className="min-w-0 flex-1">
        <div className="flex items-center justify-between gap-2">
          <h3 className="truncate text-[16px] font-bold text-text">{med.name}</h3>
          <ChevronRight size={18} className="shrink-0 text-text-faint" />
        </div>

        <div className="mt-1 flex items-center gap-1.5 text-[12px] text-text-muted">
          <Pill size={13} />
          <span>{med.dose}</span>
          <span className="text-text-faint">·</span>
          <FoodIcon size={13} />
          <span>{med.food}</span>
        </div>

        <div className={`mt-2 flex items-center gap-2 rounded-xl px-2.5 py-1.5 ${stripBg}`}>
          <Clock size={14} className={timeColor} />
          <span className={`text-[12px] font-bold ${timeColor}`}>{med.time}</span>
          <div className="ml-auto">
            <WeekdayStrip days={med.days} color={med.color} />
          </div>
        </div>
      </div>
    </button>
  )
}
