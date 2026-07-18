import { useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import {
  ArrowLeft,
  Pencil,
  Camera,
  Tablets,
  FileText,
  CalendarDays,
  CalendarClock,
  Utensils,
  Moon,
  Stethoscope,
  Sunrise,
  ChevronRight,
  Check,
  Clock,
  X,
  TrendingUp,
  AlertTriangle,
  Info,
  ShieldAlert,
  Bell,
  Trash2,
  Pause,
} from 'lucide-react'
import { TopBar } from '../../components/shell/TopBar'
import { useShell } from '../../components/shell/shellContext'
import { useMeds } from '../../store/medStore'
import { MedThumb } from '../medications/MedThumb'
import { DeleteModal } from '../flows/FlowModals'

export function MedicineDetailPage() {
  const { id } = useParams()
  const navigate = useNavigate()
  const { openDrawer, openModal } = useShell()
  const { meds } = useMeds()
  const med = meds.find((m) => m.id === id)
  const [note, setNote] = useState('')

  if (!med) {
    return (
      <div className="flex min-h-full flex-col">
        <TopBar title="Medicine Details" subtitle="View and manage your medicine" onMenu={openDrawer} />
        <div className="grid flex-1 place-items-center px-6 text-center">
          <div>
            <p className="text-[14px] font-bold text-text">Medicine not found</p>
            <button onClick={() => navigate('/medications')} className="mt-3 rounded-xl bg-brand-gradient px-4 py-2 text-[13px] font-bold text-white">
              Back to Medications
            </button>
          </div>
        </div>
      </div>
    )
  }

  const pct = med.total ? Math.round((med.stock / med.total) * 100) : 0
  const FoodIcon = med.foodIcon === 'moon' ? Moon : Utensils
  const categoryLabel = med.category === 'supplement' ? 'Supplement' : 'Pain Reliever'

  return (
    <div className="flex min-h-full flex-col">
      {/* Header */}
      <header
        className="sticky top-0 z-30 flex items-center gap-2 border-b border-border bg-bg/95 px-4 pb-2 backdrop-blur-xl"
        style={{ paddingTop: 'calc(0.5rem + env(safe-area-inset-top))' }}
      >
        <button onClick={() => navigate(-1)} className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-surface text-text shadow-[var(--shadow-card)] active:scale-95">
          <ArrowLeft size={18} />
        </button>
        <div className="min-w-0 flex-1">
          <h1 className="truncate text-[17px] font-bold text-text">Medicine Details</h1>
          <p className="truncate text-[11.5px] text-text-muted">View and manage your medicine</p>
        </div>
      </header>

      <div className="space-y-3 px-4 pt-2">
        {/* Hero */}
        <div className="rounded-[20px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
          <div className="flex gap-3">
            <div className="relative shrink-0">
              <MedThumb kind={med.kind} tint={med.tint} colors={med.pillColors} className="h-[112px] w-[128px] rounded-2xl" />
              <span className="absolute bottom-1.5 right-1.5 grid h-7 w-7 place-items-center rounded-full bg-brand-500 text-white ring-2 ring-surface">
                <Camera size={13} />
              </span>
            </div>
            <div className="min-w-0 flex-1">
              <div className="flex items-start justify-between gap-2">
                <h2 className="text-[17px] font-bold leading-tight text-text">{med.name}</h2>
                <button className="flex shrink-0 items-center gap-1 text-[12px] font-semibold text-brand-500"><Pencil size={12} /> Edit</button>
              </div>
              <span className="mt-1 inline-block rounded-full bg-green-soft px-2 py-0.5 text-[10.5px] font-semibold text-green-500">{categoryLabel}</span>
              <p className="mt-1.5 text-[11.5px] leading-snug text-text-muted">
                Used to relieve mild to moderate pain such as headache, body ache, and fever.
              </p>
              <div className="mt-2 flex gap-1.5">
                <Chip icon={<Tablets size={12} />} label={med.kind === 'tablet' ? 'Tablet' : med.kind === 'capsule' ? 'Capsule' : 'Syrup'} />
                <Chip icon={<FileText size={12} />} label="Prescription" />
              </div>
            </div>
          </div>
        </div>

        {/* Info row */}
        <div className="grid grid-cols-4 gap-2 rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
          <InfoTile icon={<CalendarDays size={14} />} fg="text-green-500" bg="bg-green-soft" label="Start Date" value="10 May 2024" />
          <InfoTile icon={<CalendarClock size={14} />} fg="text-brand-500" bg="bg-brand-soft" label="End Date" value="10 Jun 2024" />
          <InfoTile icon={<FoodIcon size={14} />} fg="text-amber-500" bg="bg-amber-soft" label="Take" value={med.food} />
          <InfoTile icon={<Stethoscope size={14} />} fg="text-blue-500" bg="bg-blue-soft" label="Prescribed By" value="Dr. Sharma" />
        </div>

        {/* Schedule */}
        <Section title="Schedule" action="View All" onAction={() => navigate('/reminders')}>
          <div className="flex items-stretch">
            <ScheduleSlot icon={<Sunrise size={16} className="text-amber-500" />} time={med.time} dose={med.dose} food="After Breakfast" />
          </div>
        </Section>

        {/* Stock & Refill */}
        <Section title="Stock & Refill">
          <div className="flex items-center gap-3">
            <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-brand-soft text-brand-500"><CalendarDays size={20} /></span>
            <div className="min-w-0 flex-1">
              <p className="text-[15px] font-extrabold text-brand-500">{med.stock} <span className="text-[12px] font-semibold text-text">Tablets Left</span></p>
              <p className="text-[11px] text-text-muted">Out of {med.total} Tablets</p>
              <div className="mt-1.5 h-1.5 w-full overflow-hidden rounded-full bg-surface-2">
                <div className="h-full rounded-full bg-brand-500" style={{ width: `${pct}%` }} />
              </div>
              <p className="mt-1 text-[10.5px] font-semibold text-brand-500">{pct}% Remaining</p>
            </div>
            <div className="shrink-0 text-right">
              <span className="grid h-9 w-9 place-items-center rounded-full bg-brand-soft text-brand-500"><Bell size={15} /></span>
            </div>
          </div>
        </Section>

        {/* Stats */}
        <div className="grid grid-cols-4 gap-2 rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
          <StatTile icon={<Check size={14} />} fg="text-green-500" bg="bg-green-soft" n="0" label="Doses Taken" />
          <StatTile icon={<Clock size={14} />} fg="text-amber-500" bg="bg-amber-soft" n="0" label="Late Doses" />
          <StatTile icon={<X size={14} />} fg="text-red-500" bg="bg-red-soft" n="0" label="Missed Doses" />
          <StatTile icon={<TrendingUp size={14} />} fg="text-brand-500" bg="bg-brand-soft" n="—" label="Adherence" />
        </div>

        {/* Information */}
        <Section title="Information">
          <div className="space-y-2">
            <InfoRow icon={<AlertTriangle size={15} />} title="Side Effects" sub="Nausea, Rash, Stomach upset (rare)" />
            <InfoRow icon={<Info size={15} />} title="Important Notes" sub="Do not exceed the recommended dose." />
            <InfoRow icon={<ShieldAlert size={15} />} title="Interactions" sub="Avoid alcohol while taking this medicine." />
          </div>
        </Section>

        {/* My Notes */}
        <Section title="My Notes" action="+ Add Note" onAction={() => setNote(note)}>
          <div className="rounded-xl bg-surface-2 p-3">
            <textarea
              value={note}
              onChange={(e) => setNote(e.target.value)}
              placeholder="Add a note about this medicine…"
              className="h-16 w-full resize-none bg-transparent text-[12.5px] text-text outline-none placeholder:text-text-faint"
            />
          </div>
        </Section>

        {/* Footer */}
        <div className="flex gap-3 pb-2 pt-1">
          <button
            onClick={() => openModal(<DeleteModal name={med.name} medId={med.id} />)}
            className="flex flex-1 items-center justify-center gap-2 rounded-2xl border border-red-500/50 py-3 text-[14px] font-bold text-red-500 active:scale-[0.98]"
          >
            <Trash2 size={16} /> Delete Medicine
          </button>
          <button className="flex flex-1 items-center justify-center gap-2 rounded-2xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]">
            <Pause size={16} /> Pause Medicine
          </button>
        </div>
      </div>
    </div>
  )
}

function Chip({ icon, label }: { icon: React.ReactNode; label: string }) {
  return (
    <span className="flex items-center gap-1 rounded-lg border border-border bg-surface-2 px-2 py-1 text-[10.5px] font-semibold text-text-muted">
      {icon}
      {label}
    </span>
  )
}

function InfoTile({ icon, fg, bg, label, value }: { icon: React.ReactNode; fg: string; bg: string; label: string; value: string }) {
  return (
    <div className="flex flex-col items-center text-center">
      <span className={`mb-1 grid h-8 w-8 place-items-center rounded-full ${bg} ${fg}`}>{icon}</span>
      <span className="text-[9px] text-text-muted">{label}</span>
      <span className="text-[10px] font-bold text-text">{value}</span>
    </div>
  )
}

function StatTile({ icon, fg, bg, n, label }: { icon: React.ReactNode; fg: string; bg: string; n: string; label: string }) {
  return (
    <div className="flex flex-col items-center text-center">
      <span className={`mb-1 grid h-8 w-8 place-items-center rounded-full ${bg} ${fg}`}>{icon}</span>
      <span className={`text-[15px] font-extrabold ${fg}`}>{n}</span>
      <span className="text-[9px] text-text-muted">{label}</span>
    </div>
  )
}

function Section({ title, action, onAction, children }: { title: string; action?: string; onAction?: () => void; children: React.ReactNode }) {
  return (
    <div className="rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
      <div className="mb-3 flex items-center justify-between">
        <h2 className="text-[15px] font-bold text-text">{title}</h2>
        {action && (
          <button onClick={onAction} className="flex items-center gap-0.5 text-[12.5px] font-semibold text-brand-500">
            {action} {action === 'View All' && <ChevronRight size={13} />}
          </button>
        )}
      </div>
      {children}
    </div>
  )
}

function ScheduleSlot({ icon, time, dose, food }: { icon: React.ReactNode; time: string; dose: string; food: string }) {
  return (
    <div className="flex flex-1 flex-col items-center gap-1 text-center">
      {icon}
      <span className="text-[14px] font-bold text-text">{time}</span>
      <span className="text-[11px] text-text-muted">{dose}</span>
      <span className="rounded-full bg-green-soft px-2 py-0.5 text-[9.5px] font-semibold text-green-500">{food}</span>
    </div>
  )
}

function InfoRow({ icon, title, sub }: { icon: React.ReactNode; title: string; sub: string }) {
  return (
    <button className="flex w-full items-center gap-3 rounded-xl bg-surface-2 px-3 py-2.5 text-left">
      <span className="grid h-8 w-8 shrink-0 place-items-center rounded-lg bg-brand-soft text-brand-500">{icon}</span>
      <span className="min-w-0 flex-1">
        <span className="block text-[13px] font-bold text-text">{title}</span>
        <span className="block truncate text-[11px] text-text-muted">{sub}</span>
      </span>
      <ChevronRight size={16} className="shrink-0 text-text-faint" />
    </button>
  )
}
