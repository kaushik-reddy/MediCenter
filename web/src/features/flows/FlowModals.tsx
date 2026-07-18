import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Check, Pill, AlarmClock, AlertTriangle, Trash2, ShoppingCart, SlidersHorizontal, BellRing, Pencil, Moon, Clock, Frown, Meh, Smile, CalendarClock, SkipForward } from 'lucide-react'
import { Modal, Field, ModalActions } from '../../components/ui/Modal'
import { Dropdown } from '../../components/ui/Dropdown'
import { Toggle } from '../../components/ui/Toggle'
import { useShell } from '../../components/shell/shellContext'
import { useMeds } from '../../store/medStore'

/* ------------------------------------------------------------------ */
/* Mark as Taken — mood check-in                                       */
/* ------------------------------------------------------------------ */
const MOODS = [Frown, Frown, Meh, Smile, Smile]

export function MarkAsTakenModal({ name, medId }: { name?: string; medId?: string }) {
  const { closeModal } = useShell()
  const { markTaken } = useMeds()
  const navigate = useNavigate()
  const [mood, setMood] = useState(3)
  const [note, setNote] = useState('')
  const done = () => {
    if (medId) markTaken(medId)
    closeModal()
  }
  return (
    <Modal
      icon={<Check size={26} strokeWidth={3} />}
      iconBg="bg-green-soft"
      iconFg="text-green-500"
      title="Great! Medicine Taken"
      subtitle={name ? `${name} marked as taken` : 'Your dose has been recorded'}
    >
      <p className="mb-2 text-center text-[13px] font-semibold text-text">How did you feel?</p>
      <div className="mb-1 flex justify-between px-1">
        {MOODS.map((MoodIcon, i) => (
          <button
            key={i}
            onClick={() => setMood(i)}
            aria-label={['Very poor', 'Poor', 'Neutral', 'Good', 'Great'][i]}
            className={`grid h-11 w-11 place-items-center rounded-full transition-all ${
              mood === i ? 'scale-110 bg-brand-soft ring-2 ring-brand-500' : 'opacity-70'
            }`}
          >
            <MoodIcon size={22} strokeWidth={mood === i ? 2.5 : 2} />
          </button>
        ))}
      </div>
      <div className="mb-3 flex justify-between px-1 text-[10px] text-text-muted">
        <span>Poor</span>
        <span>Great</span>
      </div>
      <Field label="Add a note (optional)" value={note} onChange={setNote} placeholder="How are you feeling?" />
      <button
        onClick={done}
        className="mt-1 w-full rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
      >
        Done
      </button>
      <button
        onClick={() => {
          done()
          navigate('/history')
        }}
        className="mt-2 w-full text-center text-[13px] font-semibold text-brand-500"
      >
        View History
      </button>
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Add Medication                                                      */
/* ------------------------------------------------------------------ */
export function AddMedicationModal() {
  const { closeModal } = useShell()
  const { addMedication } = useMeds()
  const [name, setName] = useState('')
  const [form, setForm] = useState('Tablet')
  const [dosage, setDosage] = useState('')
  const [notes, setNotes] = useState('')
  const [schedule, setSchedule] = useState(true)
  return (
    <Modal icon={<Pill size={22} />} title="Add New Medication" subtitle="Enter your medicine details">
      <Field label="Medication Name" value={name} onChange={setName} placeholder="e.g. Paracetamol 650mg" />
      <SelectField label="Select Form" value={form} onChange={setForm} options={['Tablet', 'Capsule', 'Syrup', 'Injection', 'Other']} />
      <Field label="Dosage" value={dosage} onChange={setDosage} placeholder="e.g. 1 Tablet" />
      <Field label="Notes (optional)" value={notes} onChange={setNotes} placeholder="Any instructions" />
      <div className="mb-3 flex items-center justify-between rounded-xl bg-surface-2 px-3.5 py-3">
        <div>
          <p className="text-[13.5px] font-semibold text-text">Add to Schedule</p>
          <p className="text-[11.5px] text-text-muted">Get reminders for this medicine</p>
        </div>
        <Toggle on={schedule} onChange={setSchedule} />
      </div>
      <ModalActions
        primaryLabel="Save Medication"
        onPrimary={() => {
          addMedication({ name, form, dosage })
          closeModal()
        }}
      />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Set Reminder                                                        */
/* ------------------------------------------------------------------ */
const DAYS = ['M', 'T', 'W', 'T', 'F', 'S', 'S']
export function SetReminderModal({ name }: { name?: string }) {
  const [hh, setHh] = useState('08')
  const [mm, setMm] = useState('30')
  const [ap, setAp] = useState('AM')
  const [days, setDays] = useState<boolean[]>([true, true, true, true, true, false, false])
  return (
    <Modal icon={<AlarmClock size={22} />} title="Set Reminder Time" subtitle={name ?? 'Choose when to be reminded'}>
      <div className="mb-4 flex items-center justify-center gap-2">
        <TimeBox value={hh} onChange={setHh} options={hours} ariaLabel="Hour" />
        <span className="text-[24px] font-bold text-text">:</span>
        <TimeBox value={mm} onChange={setMm} options={minutes} ariaLabel="Minute" />
        <TimeBox value={ap} onChange={setAp} options={['AM', 'PM']} ariaLabel="AM or PM" />
      </div>
      <p className="mb-2 text-[12.5px] font-semibold text-text-muted">Repeat</p>
      <div className="mb-4 flex justify-between">
        {DAYS.map((d, i) => (
          <button
            key={i}
            onClick={() => setDays((p) => p.map((v, j) => (j === i ? !v : v)))}
            className={`grid h-9 w-9 place-items-center rounded-full text-[13px] font-bold ${
              days[i] ? 'bg-brand-500 text-white' : 'bg-surface-2 text-text-muted'
            }`}
          >
            {d}
          </button>
        ))}
      </div>
      <ModalActions primaryLabel="Save Reminder" />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Confirm / Skip dose                                                 */
/* ------------------------------------------------------------------ */
export function ConfirmSkipModal() {
  return (
    <Modal
      icon={<AlertTriangle size={24} />}
      iconBg="bg-amber-soft"
      iconFg="text-amber-500"
      title="Are you sure?"
      subtitle="Do you want to skip this dose?"
    >
      <div className="mb-3 rounded-xl bg-amber-soft px-3.5 py-3 text-[12.5px] text-amber-500">
        Skipping doses may affect your treatment. This will be recorded in your history.
      </div>
      <ModalActions primaryLabel="Skip Dose" secondaryLabel="Go Back" primaryClass="bg-amber-500 text-white" />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Delete confirmation                                                 */
/* ------------------------------------------------------------------ */
export function DeleteModal({ name, medId }: { name?: string; medId?: string }) {
  const { closeModal } = useShell()
  const { deleteMedication } = useMeds()
  return (
    <Modal
      icon={<Trash2 size={22} />}
      iconBg="bg-red-soft"
      iconFg="text-red-500"
      title="Delete Medication"
      subtitle={name ? `Remove ${name}?` : 'This action cannot be undone'}
    >
      <div className="mb-3 rounded-xl bg-red-soft px-3.5 py-3 text-[12.5px] text-red-500">
        This will permanently remove the medicine and all its reminders.
      </div>
      <ModalActions
        primaryLabel="Delete"
        secondaryLabel="Cancel"
        primaryClass="bg-red-500 text-white"
        onPrimary={() => {
          if (medId) deleteMedication(medId)
          closeModal()
        }}
      />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Medication options (tap a med card)                                 */
/* ------------------------------------------------------------------ */
export function MedicationOptionsModal({ name, medId }: { name: string; medId?: string }) {
  const { openModal } = useShell()
  const opt = 'flex w-full items-center gap-3 rounded-xl px-3.5 py-3 text-left text-[14px] font-semibold active:scale-[0.99]'
  return (
    <Modal icon={<Pill size={22} />} title={name} subtitle="Choose an action">
      <div className="space-y-2">
        <button className={`${opt} bg-green-soft text-green-500`} onClick={() => openModal(<MarkAsTakenModal name={name} medId={medId} />)}>
          <Check size={18} strokeWidth={3} /> Mark as Taken
        </button>
        <button className={`${opt} bg-brand-soft text-brand-500`} onClick={() => openModal(<SetReminderModal name={name} />)}>
          <BellRing size={18} /> Set Reminder
        </button>
        <button className={`${opt} bg-surface-2 text-text`} onClick={() => openModal(<AddMedicationModal />)}>
          <Pencil size={18} /> Edit Medication
        </button>
        <button className={`${opt} bg-red-soft text-red-500`} onClick={() => openModal(<DeleteModal name={name} medId={medId} />)}>
          <Trash2 size={18} /> Delete
        </button>
      </div>
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Reorder                                                             */
/* ------------------------------------------------------------------ */
export function ReorderModal({ name, medId }: { name: string; medId?: string }) {
  const { closeModal } = useShell()
  const { reorder } = useMeds()
  const [qty, setQty] = useState(30)
  return (
    <Modal icon={<ShoppingCart size={22} />} title="Reorder Medicine" subtitle={name}>
      <div className="mb-4 flex items-center justify-between rounded-xl bg-surface-2 px-3.5 py-3">
        <span className="text-[13.5px] font-semibold text-text">Quantity</span>
        <div className="flex items-center gap-3">
          <button onClick={() => setQty((q) => Math.max(1, q - 1))} className="grid h-8 w-8 place-items-center rounded-full bg-surface text-brand-500 ring-1 ring-border">−</button>
          <span className="w-8 text-center text-[16px] font-bold text-text">{qty}</span>
          <button onClick={() => setQty((q) => q + 1)} className="grid h-8 w-8 place-items-center rounded-full bg-brand-500 text-white">+</button>
        </div>
      </div>
      <ModalActions
        primaryLabel="Place Order"
        onPrimary={() => {
          if (medId) reorder(medId)
          closeModal()
        }}
      />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Filter                                                              */
/* ------------------------------------------------------------------ */
export function FilterModal() {
  const [active, setActive] = useState('All')
  const chips = ['All', 'Tablet', 'Capsule', 'Syrup', 'Before Food', 'After Food', 'Morning', 'Night']
  return (
    <Modal icon={<SlidersHorizontal size={20} />} title="Filter" subtitle="Refine your medicine list">
      <div className="mb-4 flex flex-wrap gap-2">
        {chips.map((c) => (
          <button
            key={c}
            onClick={() => setActive(c)}
            className={`rounded-full px-3.5 py-2 text-[12.5px] font-semibold ${
              active === c ? 'bg-brand-500 text-white' : 'bg-surface-2 text-text-muted'
            }`}
          >
            {c}
          </button>
        ))}
      </div>
      <ModalActions primaryLabel="Apply Filters" secondaryLabel="Reset" />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Snooze                                                              */
/* ------------------------------------------------------------------ */
const SNOOZE_MINUTES: Record<string, number> = {
  '5 minutes': 5,
  '15 minutes': 15,
  '30 minutes': 30,
  '1 hour': 60,
  Custom: 15,
}
export function SnoozeModal({ name, medId }: { name?: string; medId?: string }) {
  const { closeModal } = useShell()
  const { snoozeDose } = useMeds()
  const [choice, setChoice] = useState('15 minutes')
  const opts = ['5 minutes', '15 minutes', '30 minutes', '1 hour', 'Custom']
  return (
    <Modal icon={<Moon size={22} />} title="Snooze Reminder" subtitle={name ? `Remind me about ${name} in` : 'Remind me again in'}>
      <div className="mb-2 space-y-1.5">
        {opts.map((o) => (
          <button
            key={o}
            onClick={() => setChoice(o)}
            className={`flex w-full items-center justify-between rounded-xl px-3.5 py-3 text-[14px] font-semibold ${
              choice === o ? 'bg-brand-soft text-brand-500' : 'bg-surface-2 text-text'
            }`}
          >
            {o}
            {choice === o && <Check size={17} strokeWidth={3} />}
          </button>
        ))}
      </div>
      <ModalActions
        primaryLabel="Snooze"
        onPrimary={() => {
          if (medId) snoozeDose(medId, SNOOZE_MINUTES[choice] ?? 15)
          closeModal()
        }}
      />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Reschedule a dose                                                   */
/* ------------------------------------------------------------------ */
function parseTime(time?: string): { hh: string; mm: string; ap: string } {
  const m = time?.match(/(\d+):(\d+)\s*(AM|PM)/i)
  if (!m) return { hh: '09', mm: '00', ap: 'AM' }
  return { hh: m[1].padStart(2, '0'), mm: m[2].padStart(2, '0'), ap: m[3].toUpperCase() }
}
export function RescheduleDoseModal({ name, medId, current }: { name?: string; medId?: string; current?: string }) {
  const { closeModal } = useShell()
  const { rescheduleDose } = useMeds()
  const init = parseTime(current)
  const [hh, setHh] = useState(init.hh)
  const [mm, setMm] = useState(init.mm)
  const [ap, setAp] = useState(init.ap)
  return (
    <Modal icon={<CalendarClock size={22} />} title="Reschedule Dose" subtitle={name ?? 'Pick a new time for today'}>
      <div className="mb-4 flex items-center justify-center gap-2">
        <TimeBox value={hh} onChange={setHh} options={hours} ariaLabel="Hour" />
        <span className="text-[24px] font-bold text-text">:</span>
        <TimeBox value={mm} onChange={setMm} options={minutes} ariaLabel="Minute" />
        <TimeBox value={ap} onChange={setAp} options={['AM', 'PM']} ariaLabel="AM or PM" />
      </div>
      <ModalActions
        primaryLabel="Reschedule"
        onPrimary={() => {
          if (medId) rescheduleDose(medId, `${hh}:${mm} ${ap}`)
          closeModal()
        }}
      />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Dose actions (tap a schedule row) — Take / Snooze / Reschedule / Skip */
/* ------------------------------------------------------------------ */
export function DoseActionsModal({ name, medId, time }: { name: string; medId?: string; time?: string }) {
  const { openModal, closeModal } = useShell()
  const { skipDose } = useMeds()
  const opt = 'flex w-full items-center gap-3 rounded-xl px-3.5 py-3 text-left text-[14px] font-semibold active:scale-[0.99]'
  return (
    <Modal icon={<Pill size={22} />} title={name} subtitle={time ? `Scheduled for ${time}` : 'Choose an action'}>
      <div className="space-y-2">
        <button className={`${opt} bg-green-soft text-green-500`} onClick={() => openModal(<MarkAsTakenModal name={name} medId={medId} />)}>
          <Check size={18} strokeWidth={3} /> Mark as Taken
        </button>
        <button className={`${opt} bg-brand-soft text-brand-500`} onClick={() => openModal(<SnoozeModal name={name} medId={medId} />)}>
          <Moon size={18} /> Snooze
        </button>
        <button className={`${opt} text-yellow-500`} style={{ backgroundColor: 'rgba(234,179,8,0.12)' }} onClick={() => openModal(<RescheduleDoseModal name={name} medId={medId} current={time} />)}>
          <CalendarClock size={18} /> Reschedule
        </button>
        <button
          className={`${opt} text-orange-500`}
          style={{ backgroundColor: 'rgba(249,115,22,0.12)' }}
          onClick={() => {
            if (medId) skipDose(medId)
            closeModal()
          }}
        >
          <SkipForward size={18} /> Skip Dose
        </button>
      </div>
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Notification Channels                                               */
/* ------------------------------------------------------------------ */
export function NotificationChannelsModal() {
  const [ch, setCh] = useState<Record<string, boolean>>({
    Push: true,
    Email: true,
    WhatsApp: true,
    SMS: false,
    'Phone Call': false,
  })
  return (
    <Modal icon={<BellRing size={22} />} title="Notification Channels" subtitle="How should we reach you?">
      <div className="mb-3 space-y-2">
        {Object.keys(ch).map((k) => (
          <div key={k} className="flex items-center justify-between rounded-xl bg-surface-2 px-3.5 py-3">
            <span className="text-[14px] font-semibold text-text">{k}</span>
            <Toggle on={ch[k]} onChange={(v) => setCh((p) => ({ ...p, [k]: v }))} />
          </div>
        ))}
      </div>
      <p className="mb-3 rounded-xl bg-brand-soft px-3.5 py-2.5 text-[11.5px] text-brand-500">
        You'll always receive critical alerts even if channels are turned off.
      </p>
      <ModalActions primaryLabel="Save Preferences" />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Reminder options (3-dot / tap a reminder)                           */
/* ------------------------------------------------------------------ */
export function ReminderOptionsModal({ name }: { name: string }) {
  const { openModal } = useShell()
  const opt = 'flex w-full items-center gap-3 rounded-xl px-3.5 py-3 text-left text-[14px] font-semibold active:scale-[0.99]'
  return (
    <Modal icon={<AlarmClock size={22} />} title={name} subtitle="Reminder options">
      <div className="space-y-2">
        <button className={`${opt} bg-brand-soft text-brand-500`} onClick={() => openModal(<SetReminderModal name={name} />)}>
          <Clock size={18} /> Edit Time
        </button>
        <button className={`${opt} bg-surface-2 text-text`} onClick={() => openModal(<SnoozeModal />)}>
          <Moon size={18} /> Snooze
        </button>
        <button className={`${opt} bg-surface-2 text-text`} onClick={() => openModal(<NotificationChannelsModal />)}>
          <BellRing size={18} /> Notification Channels
        </button>
        <button className={`${opt} bg-red-soft text-red-500`} onClick={() => openModal(<DeleteModal name={name} />)}>
          <Trash2 size={18} /> Delete Reminder
        </button>
      </div>
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Generic info / feature modal                                        */
/* ------------------------------------------------------------------ */
export function InfoModal({ title, message, icon }: { title: string; message: string; icon?: React.ReactNode }) {
  const { closeModal } = useShell()
  return (
    <Modal icon={icon ?? <BellRing size={22} />} title={title} subtitle={message}>
      <button
        onClick={closeModal}
        className="mt-1 w-full rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
      >
        Got it
      </button>
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Period selector                                                     */
/* ------------------------------------------------------------------ */
export function PeriodModal({ onSelect }: { onSelect?: (p: string) => void }) {
  const { closeModal } = useShell()
  const [choice, setChoice] = useState('This Week')
  const opts = ['Today', 'This Week', 'This Month', 'Last 3 Months', 'This Year']
  return (
    <Modal icon={<Clock size={22} />} title="Select Period" subtitle="Choose a time range">
      <div className="mb-2 space-y-1.5">
        {opts.map((o) => (
          <button
            key={o}
            onClick={() => setChoice(o)}
            className={`flex w-full items-center justify-between rounded-xl px-3.5 py-3 text-[14px] font-semibold ${
              choice === o ? 'bg-brand-soft text-brand-500' : 'bg-surface-2 text-text'
            }`}
          >
            {o}
            {choice === o && <Check size={17} strokeWidth={3} />}
          </button>
        ))}
      </div>
      <ModalActions primaryLabel="Apply" onPrimary={() => { onSelect?.(choice); closeModal() }} />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Date range                                                          */
/* ------------------------------------------------------------------ */
export function DateRangeModal() {
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  return (
    <Modal icon={<Clock size={22} />} title="Select Date Range" subtitle="Filter by custom dates">
      <div className="flex gap-3">
        <div className="flex-1"><Field label="From" value={from} onChange={setFrom} placeholder="01 May 2025" /></div>
        <div className="flex-1"><Field label="To" value={to} onChange={setTo} placeholder="17 May 2025" /></div>
      </div>
      <ModalActions primaryLabel="Apply Range" />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Log out                                                             */
/* ------------------------------------------------------------------ */
export function LogoutModal() {
  return (
    <Modal
      icon={<Trash2 size={22} />}
      iconBg="bg-red-soft"
      iconFg="text-red-500"
      title="Log Out"
      subtitle="Are you sure you want to log out?"
    >
      <ModalActions primaryLabel="Log Out" secondaryLabel="Cancel" primaryClass="bg-red-500 text-white" />
    </Modal>
  )
}

/* ------------------------------------------------------------------ */
/* Small helpers                                                       */
/* ------------------------------------------------------------------ */
const hours = Array.from({ length: 12 }, (_, i) => String(i + 1).padStart(2, '0'))
const minutes = Array.from({ length: 60 }, (_, i) => String(i).padStart(2, '0'))

function SelectField({
  label,
  value,
  onChange,
  options,
}: {
  label: string
  value: string
  onChange: (v: string) => void
  options: string[]
}) {
  return (
    <label className="mb-3 block">
      <span className="mb-1 block text-[12.5px] font-semibold text-text-muted">{label}</span>
      <Dropdown value={value} onChange={onChange} options={options} />
    </label>
  )
}

function TimeBox({ value, onChange, options, ariaLabel }: { value: string; onChange: (v: string) => void; options: string[]; ariaLabel?: string }) {
  return <Dropdown variant="time" value={value} onChange={onChange} options={options} ariaLabel={ariaLabel} />
}
