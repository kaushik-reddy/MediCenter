import { useState } from 'react'
import {
  ArrowLeft,
  ArrowRight,
  X,
  Search,
  Pill,
  ScanLine,
  Check,
  ChevronRight,
  Lightbulb,
  Sunrise,
  Sun,
  Moon,
  Clock,
  CalendarDays,
  CalendarRange,
  CalendarClock,
  CalendarCheck,
  Minus,
  Plus,
  Syringe,
  FlaskConical,
  MoreHorizontal,
  Bell,
} from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { useMeds } from '../../store/medStore'
import { Dropdown } from '../../components/ui/Dropdown'
import { Toggle } from '../../components/ui/Toggle'

const STEPS = ['Medicine Details', 'Dosage & Form', 'Frequency', 'Reminder Times', 'Stock & Refill', 'Review & Save']
const POPULAR = ['Paracetamol', 'Vitamin D3', 'Calcium', 'Ibuprofen', 'B-Complex']
const FORMS = [
  { key: 'Tablet', icon: Pill },
  { key: 'Capsule', icon: Pill },
  { key: 'Syrup', icon: FlaskConical },
  { key: 'Injection', icon: Syringe },
  { key: 'Other', icon: MoreHorizontal },
]
const HOW = [
  { key: 'Before Food', tint: 'text-amber-500' },
  { key: 'After Food', tint: 'text-brand-500' },
  { key: 'With Food', tint: 'text-text-muted' },
]
const FREQ = [
  { key: 'Every Day', hint: '', icon: CalendarDays },
  { key: 'Alternate Days', hint: 'e.g. Mon, Wed, Fri', icon: CalendarRange },
  { key: 'Weekly', hint: 'e.g. Every Monday', icon: CalendarCheck },
  { key: 'Custom Days', hint: 'Choose specific days', icon: CalendarClock },
  { key: 'Custom Schedule', hint: 'Set a repeating pattern', icon: CalendarClock },
]

interface RTime {
  id: string
  label: string
  time: string
  icon: typeof Sun
}

export function AddMedicationWizard() {
  const { closeModal } = useShell()
  const { addMedication } = useMeds()

  const [step, setStep] = useState(0)
  const [name, setName] = useState('')
  const [purpose, setPurpose] = useState('')
  const [form, setForm] = useState('Tablet')
  const [strength, setStrength] = useState('')
  const [unit, setUnit] = useState('mg')
  const [how, setHow] = useState('After Food')
  const [instructions, setInstructions] = useState('')
  const [freq, setFreq] = useState('Every Day')
  const [times, setTimes] = useState<RTime[]>([
    { id: 't1', label: 'Morning', time: '08:30 AM', icon: Sunrise },
    { id: 't2', label: 'Afternoon', time: '02:30 PM', icon: Sun },
    { id: 't3', label: 'Evening', time: '08:30 PM', icon: Moon },
  ])
  const [stock, setStock] = useState(20)
  const [refill, setRefill] = useState(true)
  const [refillLead, setRefillLead] = useState('5 Days before it runs out')

  const canNext = step === 0 ? name.trim().length > 0 : true
  const isLast = step === STEPS.length - 2 // Stock & Refill is the last input step (index 4)

  const save = () => {
    addMedication({ name: name.trim(), form, dosage: strength ? `${strength} ${unit}` : undefined })
    closeModal()
  }

  return (
    <div className="pointer-events-auto absolute inset-0 z-[60] flex flex-col">
      <div className="absolute inset-0 bg-black/40 backdrop-blur-md" onClick={closeModal} />

      <div className="relative z-10 m-3 flex min-h-0 flex-1 flex-col overflow-hidden rounded-[26px] bg-bg shadow-[var(--shadow-float)]">
        {/* Header */}
        <div className="flex items-center gap-2 px-4 pt-4 pb-3">
          <button
            type="button"
            onClick={() => (step > 0 ? setStep((s) => s - 1) : closeModal())}
            className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-2 text-text active:scale-95"
          >
            <ArrowLeft size={18} />
          </button>
          <div className="min-w-0 flex-1">
            <h2 className="truncate text-[18px] font-extrabold text-text">Add New Medication</h2>
            <p className="truncate text-[11.5px] text-text-muted">Step by step to set up your medicine</p>
          </div>
          <StepRing step={step + 1} total={5} />
          <button
            type="button"
            onClick={closeModal}
            className="grid h-9 w-9 shrink-0 place-items-center rounded-xl bg-surface-2 text-text active:scale-95"
          >
            <X size={18} />
          </button>
        </div>

        {/* Body: rail + content */}
        <div className="flex min-h-0 flex-1">
          <StepperRail current={step} />

          <div className="no-scrollbar min-h-0 flex-1 overflow-y-auto px-3 pb-3">
            {step === 0 && (
              <Step1
                name={name}
                setName={setName}
                purpose={purpose}
                setPurpose={setPurpose}
              />
            )}
            {step === 1 && (
              <Step2
                form={form}
                setForm={setForm}
                strength={strength}
                setStrength={setStrength}
                unit={unit}
                setUnit={setUnit}
                how={how}
                setHow={setHow}
                instructions={instructions}
                setInstructions={setInstructions}
              />
            )}
            {step === 2 && <Step3 freq={freq} setFreq={setFreq} />}
            {step === 3 && <Step4 times={times} setTimes={setTimes} />}
            {step === 4 && (
              <Step5
                stock={stock}
                setStock={setStock}
                refill={refill}
                setRefill={setRefill}
                refillLead={refillLead}
                setRefillLead={setRefillLead}
                summary={{ name, form, strength, unit, how, freq, times, stock }}
              />
            )}
          </div>
        </div>

        {/* Footer */}
        <div className="flex gap-3 border-t border-border px-4 py-3">
          <button
            type="button"
            onClick={() => (step > 0 ? setStep((s) => s - 1) : closeModal())}
            className="flex-1 rounded-xl border border-border py-3 text-[14px] font-bold text-text active:scale-[0.98]"
          >
            {step > 0 ? 'Back' : 'Cancel'}
          </button>
          {isLast ? (
            <button
              type="button"
              onClick={save}
              className="flex flex-[1.4] items-center justify-center gap-2 rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
            >
              <Check size={16} strokeWidth={3} /> Save Medication
            </button>
          ) : (
            <button
              type="button"
              disabled={!canNext}
              onClick={() => setStep((s) => s + 1)}
              className="flex flex-[1.4] items-center justify-center gap-2 rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98] disabled:opacity-50"
            >
              Next <ArrowRight size={16} />
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

/* ---- Header progress ring ---- */
function StepRing({ step, total }: { step: number; total: number }) {
  const r = 15
  const c = 2 * Math.PI * r
  const pct = Math.min(step, total) / total
  return (
    <div className="relative grid h-11 w-11 shrink-0 place-items-center">
      <svg viewBox="0 0 36 36" className="h-11 w-11 -rotate-90">
        <circle cx="18" cy="18" r={r} fill="none" stroke="var(--border)" strokeWidth="3" />
        <circle
          cx="18"
          cy="18"
          r={r}
          fill="none"
          stroke="var(--brand-500)"
          strokeWidth="3"
          strokeLinecap="round"
          strokeDasharray={c}
          strokeDashoffset={c * (1 - pct)}
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center leading-none">
        <span className="text-[10px] font-bold text-text-muted">Step</span>
        <span className="text-[11px] font-extrabold text-brand-500">
          {step}/{total}
        </span>
      </div>
    </div>
  )
}

/* ---- Left vertical stepper rail ---- */
function StepperRail({ current }: { current: number }) {
  return (
    <div className="relative w-[92px] shrink-0 pl-3 pr-1 pt-1">
      <div className="absolute bottom-4 left-[27px] top-5 w-px border-l-2 border-dashed border-border" />
      <div className="space-y-[26px]">
        {STEPS.map((label, i) => {
          const done = i < current
          const active = i === current
          return (
            <div key={label} className="relative flex items-start gap-2">
              <span
                className={`relative z-10 grid h-8 w-8 shrink-0 place-items-center rounded-full text-[12px] font-bold ${
                  active
                    ? 'bg-brand-500 text-white'
                    : done
                      ? 'bg-green-500 text-white'
                      : 'bg-surface-2 text-text-muted ring-1 ring-border'
                }`}
              >
                {done ? <Check size={14} strokeWidth={3} /> : i + 1}
              </span>
              <span
                className={`mt-1 text-[11px] font-semibold leading-tight ${
                  active ? 'text-brand-500' : done ? 'text-text' : 'text-text-faint'
                }`}
              >
                {label}
              </span>
            </div>
          )
        })}
      </div>
    </div>
  )
}

/* ---- Shared UI ---- */
function StepHead({ icon, title, sub }: { icon: React.ReactNode; title: string; sub: string }) {
  return (
    <div className="mb-3 flex items-center gap-2.5">
      <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-brand-soft text-brand-500">{icon}</span>
      <div>
        <h3 className="text-[15px] font-bold text-text">{title}</h3>
        <p className="text-[11.5px] text-text-muted">{sub}</p>
      </div>
    </div>
  )
}

function Panel({ children }: { children: React.ReactNode }) {
  return <div className="mb-3 rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">{children}</div>
}

function GreenNote({ text }: { text: string }) {
  return (
    <div className="mb-3 flex items-start gap-2 rounded-xl bg-green-soft px-3 py-2.5 text-[11.5px] font-medium text-green-500">
      <Check size={13} strokeWidth={3} className="mt-0.5 shrink-0" /> {text}
    </div>
  )
}

function Label({ children }: { children: React.ReactNode }) {
  return <p className="mb-1.5 text-[12.5px] font-semibold text-text">{children}</p>
}

/* ---- Step 1 ---- */
function Step1({
  name,
  setName,
  purpose,
  setPurpose,
}: {
  name: string
  setName: (v: string) => void
  purpose: string
  setPurpose: (v: string) => void
}) {
  return (
    <div className="pt-1">
      <Panel>
        <StepHead icon={<Search size={18} />} title="Medicine Details" sub="Search or enter your medicine name" />
        <div className="mb-3 flex items-center gap-2 rounded-xl border border-border bg-surface-2 px-3">
          <Search size={16} className="text-text-faint" />
          <input
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Search medicine"
            className="w-full bg-transparent py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
        </div>
        <p className="mb-1.5 text-[12px] font-semibold text-text">Popular Medicines</p>
        <div className="no-scrollbar mb-3 flex gap-2 overflow-x-auto">
          {POPULAR.map((p) => (
            <button
              key={p}
              onClick={() => setName(p)}
              className={`shrink-0 whitespace-nowrap rounded-full px-3 py-1.5 text-[12px] font-semibold ${
                name === p ? 'bg-brand-soft text-brand-500 ring-1 ring-brand-500/40' : 'bg-surface-2 text-text-muted'
              }`}
            >
              {p}
            </button>
          ))}
        </div>
        <div className="mb-3 flex items-center gap-2 text-[11px] font-semibold text-text-faint">
          <span className="h-px flex-1 bg-border" /> OR <span className="h-px flex-1 bg-border" />
        </div>
        <button className="flex w-full items-center gap-3 rounded-xl bg-brand-soft/60 p-3 text-left active:scale-[0.99]">
          <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-brand-gradient text-white">
            <ScanLine size={18} />
          </span>
          <span className="min-w-0 flex-1">
            <span className="block text-[13.5px] font-bold text-brand-500">Scan Medicine Pack</span>
            <span className="block text-[11.5px] text-text-muted">Scan the barcode on your medicine pack</span>
          </span>
          <ChevronRight size={16} className="text-text-faint" />
        </button>
      </Panel>

      <Panel>
        <Label>Medicine Name</Label>
        <div className="mb-3 flex items-center gap-2 rounded-xl border border-border bg-surface-2 px-3">
          <input
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. Paracetamol 650mg"
            className="w-full bg-transparent py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
          {name.trim() && (
            <span className="grid h-5 w-5 shrink-0 place-items-center rounded-full bg-green-500 text-white">
              <Check size={12} strokeWidth={3} />
            </span>
          )}
        </div>
        <Label>Purpose (Optional)</Label>
        <div className="relative mb-3">
          <textarea
            value={purpose}
            maxLength={120}
            onChange={(e) => setPurpose(e.target.value)}
            placeholder="Relieves pain and reduces fever."
            className="h-20 w-full resize-none rounded-xl border border-border bg-surface-2 px-3 py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
          <span className="absolute bottom-2 right-3 text-[10px] text-text-faint">{purpose.length}/120</span>
        </div>
        <GreenNote text="This information helps you remember why you take this medicine." />
      </Panel>

      <div className="rounded-[18px] bg-brand-soft/50 p-3.5">
        <div className="mb-2 flex items-center gap-2">
          <span className="grid h-8 w-8 place-items-center rounded-xl bg-surface text-brand-500"><Lightbulb size={16} /></span>
          <span className="text-[13.5px] font-bold text-text">Tips</span>
        </div>
        <ul className="space-y-1 text-[11.5px] text-text-muted">
          <li>• Add medicine exactly as written on the label</li>
          <li>• Include strength/dosage for accurate tracking</li>
          <li>• You can edit any details later</li>
        </ul>
      </div>
    </div>
  )
}

/* ---- Step 2 ---- */
function Step2(props: {
  form: string
  setForm: (v: string) => void
  strength: string
  setStrength: (v: string) => void
  unit: string
  setUnit: (v: string) => void
  how: string
  setHow: (v: string) => void
  instructions: string
  setInstructions: (v: string) => void
}) {
  const { form, setForm, strength, setStrength, unit, setUnit, how, setHow, instructions, setInstructions } = props
  return (
    <div className="pt-1">
      <Panel>
        <StepHead icon={<Pill size={18} />} title="Dosage & Form" sub="Enter how much and what form of medicine" />
        <Label>Form</Label>
        <div className="mb-3 grid grid-cols-5 gap-1.5">
          {FORMS.map((f) => {
            const Icon = f.icon
            const on = form === f.key
            return (
              <button
                key={f.key}
                onClick={() => setForm(f.key)}
                className={`flex flex-col items-center gap-1 rounded-xl py-2 text-[10px] font-semibold ${
                  on ? 'bg-brand-soft text-brand-500 ring-1 ring-brand-500/50' : 'bg-surface-2 text-text-muted'
                }`}
              >
                <Icon size={17} />
                {f.key}
              </button>
            )
          })}
        </div>
        <Label>Strength</Label>
        <div className="mb-3 flex gap-2">
          <input
            value={strength}
            onChange={(e) => setStrength(e.target.value)}
            placeholder="650"
            className="flex-1 rounded-xl border border-border bg-surface-2 px-3 py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
          <div className="w-24">
            <Dropdown value={unit} onChange={setUnit} options={['mg', 'g', 'ml', 'mcg', 'IU', '%']} />
          </div>
        </div>
        <Label>How to take</Label>
        <div className="grid grid-cols-3 gap-1.5">
          {HOW.map((h) => {
            const on = how === h.key
            return (
              <button
                key={h.key}
                onClick={() => setHow(h.key)}
                className={`flex flex-col items-center gap-1 rounded-xl py-2.5 text-[10.5px] font-semibold ${
                  on ? 'bg-brand-soft text-brand-500 ring-1 ring-brand-500/50' : 'bg-surface-2 text-text-muted'
                }`}
              >
                <Clock size={16} className={on ? 'text-brand-500' : h.tint} />
                {h.key}
              </button>
            )
          })}
        </div>
      </Panel>

      <Panel>
        <Label>Instructions (Optional)</Label>
        <div className="relative">
          <textarea
            value={instructions}
            maxLength={120}
            onChange={(e) => setInstructions(e.target.value)}
            placeholder="Take with a full glass of water."
            className="h-20 w-full resize-none rounded-xl border border-border bg-surface-2 px-3 py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
          <span className="absolute bottom-2 right-3 text-[10px] text-text-faint">{instructions.length}/120</span>
        </div>
      </Panel>
    </div>
  )
}

/* ---- Step 3 ---- */
function Step3({ freq, setFreq }: { freq: string; setFreq: (v: string) => void }) {
  return (
    <div className="pt-1">
      <Panel>
        <StepHead icon={<CalendarDays size={18} />} title="Frequency" sub="How often do you take this medicine?" />
        <div className="space-y-2">
          {FREQ.map((f) => {
            const Icon = f.icon
            const on = freq === f.key
            return (
              <button
                key={f.key}
                onClick={() => setFreq(f.key)}
                className={`flex w-full items-center gap-3 rounded-xl border px-3 py-2.5 text-left ${
                  on ? 'border-brand-500/50 bg-brand-soft' : 'border-border bg-surface-2'
                }`}
              >
                <Icon size={17} className={on ? 'text-brand-500' : 'text-text-muted'} />
                <span className="min-w-0 flex-1">
                  <span className={`block text-[13.5px] font-bold ${on ? 'text-brand-500' : 'text-text'}`}>{f.key}</span>
                  {f.hint && <span className="block text-[11px] text-text-muted">{f.hint}</span>}
                </span>
                <span
                  className={`grid h-5 w-5 shrink-0 place-items-center rounded-full border-2 ${
                    on ? 'border-brand-500 bg-brand-500 text-white' : 'border-border'
                  }`}
                >
                  {on && <Check size={11} strokeWidth={3} />}
                </span>
              </button>
            )
          })}
        </div>
      </Panel>
      <GreenNote text="You can change the frequency anytime later." />
    </div>
  )
}

/* ---- Step 4 ---- */
function Step4({ times, setTimes }: { times: RTime[]; setTimes: (t: RTime[]) => void }) {
  return (
    <div className="pt-1">
      <Panel>
        <StepHead icon={<Bell size={18} />} title="Reminder Times" sub="When do you want to be reminded?" />
        <div className="space-y-2">
          {times.map((t) => {
            const Icon = t.icon
            return (
              <div key={t.id} className="flex items-center gap-3 rounded-xl bg-surface-2 px-3 py-2.5">
                <Icon size={17} className={t.icon === Moon ? 'text-brand-500' : 'text-amber-500'} />
                <span className="flex-1 text-[13.5px] font-semibold text-text">{t.label}</span>
                <span className="text-[13.5px] font-bold text-text">{t.time}</span>
                <button
                  onClick={() => setTimes(times.filter((x) => x.id !== t.id))}
                  className="grid h-6 w-6 place-items-center rounded-full text-text-faint active:scale-95"
                >
                  <X size={15} />
                </button>
              </div>
            )
          })}
          <button
            onClick={() =>
              setTimes([...times, { id: `t${Date.now()}`, label: 'Custom', time: '12:00 PM', icon: Sun }])
            }
            className="flex w-full items-center justify-center gap-1.5 rounded-xl border-2 border-dashed border-brand-500/40 py-2.5 text-[12.5px] font-bold text-brand-500"
          >
            <Plus size={15} /> Add Another Time
          </button>
        </div>
      </Panel>
      <GreenNote text="You will receive a reminder at these times every day." />
    </div>
  )
}

/* ---- Step 5 ---- */
function Step5(props: {
  stock: number
  setStock: (n: number) => void
  refill: boolean
  setRefill: (b: boolean) => void
  refillLead: string
  setRefillLead: (v: string) => void
  summary: { name: string; form: string; strength: string; unit: string; how: string; freq: string; times: RTime[]; stock: number }
}) {
  const { stock, setStock, refill, setRefill, refillLead, setRefillLead, summary } = props
  const rows: [React.ReactNode, string, string][] = [
    [<Pill size={14} />, 'Medicine', summary.name || '—'],
    [<Pill size={14} />, 'Form', summary.form],
    [<FlaskConical size={14} />, 'Strength', summary.strength ? `${summary.strength} ${summary.unit}` : '—'],
    [<Clock size={14} />, 'How to take', summary.how],
    [<CalendarDays size={14} />, 'Frequency', summary.freq],
    [<Bell size={14} />, 'Reminder Times', summary.times.map((t) => t.time).join(', ') || '—'],
    [<CalendarCheck size={14} />, 'Stock', `${summary.stock} Tablets`],
    [<CalendarClock size={14} />, 'Refill Reminder', refill ? refillLead.toLowerCase() : 'Off'],
  ]
  return (
    <div className="pt-1">
      <Panel>
        <StepHead icon={<CalendarCheck size={18} />} title="Stock & Refill" sub="Manage your current stock and refills" />
        <Label>Current Stock</Label>
        <div className="mb-4 flex items-center justify-between rounded-xl bg-surface-2 px-3 py-2.5">
          <button onClick={() => setStock(Math.max(0, stock - 1))} className="grid h-8 w-8 place-items-center rounded-full bg-surface text-brand-500 ring-1 ring-border active:scale-95">
            <Minus size={15} />
          </button>
          <div className="text-center">
            <span className="text-[18px] font-extrabold text-text">{stock}</span>
            <span className="ml-1 text-[12px] text-text-muted">Tablets</span>
          </div>
          <button onClick={() => setStock(stock + 1)} className="grid h-8 w-8 place-items-center rounded-full bg-brand-500 text-white active:scale-95">
            <Plus size={15} />
          </button>
        </div>
        <div className="mb-3 flex items-center justify-between rounded-xl bg-surface-2 px-3 py-2.5">
          <div>
            <p className="text-[13px] font-semibold text-text">Refill Reminder</p>
            <p className="text-[11px] text-text-muted">Remind me when stock is low</p>
          </div>
          <Toggle on={refill} onChange={setRefill} />
        </div>
        {refill && (
          <>
            <Dropdown
              value={refillLead}
              onChange={setRefillLead}
              options={['3 Days before it runs out', '5 Days before it runs out', '1 Week before it runs out']}
            />
            <div className="mt-3 flex items-start gap-2 rounded-xl bg-brand-soft px-3 py-2.5 text-[11.5px] text-brand-500">
              <CalendarClock size={14} className="mt-0.5 shrink-0" /> We'll remind you to refill before it runs out.
            </div>
          </>
        )}
      </Panel>

      <Panel>
        <div className="mb-2">
          <h3 className="text-[14px] font-bold text-text">Preview Summary</h3>
          <p className="text-[11.5px] text-text-muted">Review your medication details</p>
        </div>
        <div className="divide-y divide-border">
          {rows.map(([icon, label, value]) => (
            <div key={label} className="flex items-center gap-2 py-2">
              <span className="text-text-faint">{icon}</span>
              <span className="flex-1 text-[12.5px] text-text-muted">{label}</span>
              <span className="max-w-[55%] truncate text-right text-[12.5px] font-semibold text-text">{value}</span>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  )
}
