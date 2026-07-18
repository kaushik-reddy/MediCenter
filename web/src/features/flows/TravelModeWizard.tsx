import { useState } from 'react'
import { MapPin, X, CalendarDays, Globe, Clock, Plane, Bell, RotateCcw, Check, Search } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { Dropdown } from '../../components/ui/Dropdown'
import { WizardShell, WField, WPanel } from './WizardShell'

const STEPS = ['Destination', 'Time Zone', 'Review', 'Confirm']
const ZONES = [
  { z: '(GMT +4:00) Gulf Standard Time', city: 'Dubai, UAE' },
  { z: '(GMT +3:00) Moscow Standard Time', city: 'Moscow, Russia' },
  { z: '(GMT +1:00) Central European Time', city: 'Paris, France' },
  { z: '(GMT -5:00) Eastern Time', city: 'New York, USA' },
]

export function TravelModeWizard() {
  const { closeModal } = useShell()
  const [step, setStep] = useState(0)
  const [dest, setDest] = useState('Dubai, UAE')
  const [from, setFrom] = useState('May 20, 2025')
  const [to, setTo] = useState('May 27, 2025')
  const [zone, setZone] = useState('(GMT +4:00) Gulf Standard Time')
  const [behavior, setBehavior] = useState<'local' | 'home'>('local')
  const [notifyBefore, setNotifyBefore] = useState(true)
  const [autoDisable, setAutoDisable] = useState(true)

  return (
    <WizardShell
      title="Travel Mode Setup"
      subtitle="Configure your travel preferences"
      steps={STEPS}
      step={step}
      onBack={() => setStep((s) => s - 1)}
      onNext={() => setStep((s) => s + 1)}
      onSave={closeModal}
      isLast={step === STEPS.length - 1}
      saveLabel="Done"
    >
      {step === 0 && (
        <>
          <WPanel>
            <div className="mb-3 flex items-center gap-2.5">
              <span className="grid h-9 w-9 place-items-center rounded-xl bg-brand-soft text-brand-500"><MapPin size={17} /></span>
              <div>
                <h3 className="text-[14px] font-bold text-text">Where are you going?</h3>
                <p className="text-[11px] text-text-muted">Select your destination to adjust reminders</p>
              </div>
            </div>
            <div className="flex items-center gap-2 rounded-xl border border-brand-500/40 bg-brand-soft px-3 py-2.5">
              <MapPin size={16} className="text-brand-500" />
              <div className="min-w-0 flex-1">
                <p className="text-[13px] font-bold text-text">{dest}</p>
                <p className="text-[11px] text-text-muted">United Arab Emirates</p>
              </div>
              <button onClick={() => setDest('')} className="text-text-faint"><X size={16} /></button>
            </div>
          </WPanel>
          <WPanel>
            <div className="mb-2 flex items-center gap-2">
              <CalendarDays size={16} className="text-brand-500" />
              <h3 className="text-[13.5px] font-bold text-text">Travel Dates</h3>
            </div>
            <div className="flex gap-2">
              <div className="flex-1"><WField label="From" value={from} onChange={setFrom} /></div>
              <div className="flex-1"><WField label="To" value={to} onChange={setTo} /></div>
            </div>
          </WPanel>
          <WPanel>
            <div className="mb-2 flex items-center gap-2">
              <Globe size={16} className="text-brand-500" />
              <h3 className="text-[13.5px] font-bold text-text">Time Zone</h3>
            </div>
            <Dropdown value={zone} onChange={setZone} options={ZONES.map((z) => z.z)} />
          </WPanel>
          <WPanel>
            <div className="mb-2 flex items-center gap-2">
              <Clock size={16} className="text-brand-500" />
              <h3 className="text-[13.5px] font-bold text-text">Reminder Behavior</h3>
            </div>
            <div className="space-y-2">
              <RadioRow on={behavior === 'local'} onClick={() => setBehavior('local')} title="Adjust to local time" sub="Reminders shown at your usual times in the new time zone" />
              <RadioRow on={behavior === 'home'} onClick={() => setBehavior('home')} title="Keep home time" sub="Reminders follow your home time zone (GMT +5:30)" />
            </div>
          </WPanel>
          <WPanel>
            <h3 className="mb-2 text-[13.5px] font-bold text-text">Additional Options</h3>
            <OptionToggle icon={<Bell size={15} />} title="Notify me before travel" sub="Get a reminder to prepare before you leave" on={notifyBefore} onChange={setNotifyBefore} />
            <OptionToggle icon={<RotateCcw size={15} />} title="Auto disable on return" sub="Turn off Travel Mode when I return home" on={autoDisable} onChange={setAutoDisable} />
          </WPanel>
        </>
      )}

      {step === 1 && (
        <WPanel>
          <div className="mb-3 flex items-center gap-2 rounded-xl border border-border bg-surface-2 px-3">
            <Search size={15} className="text-text-faint" />
            <input placeholder="Search time zone or city" className="w-full bg-transparent py-2.5 text-[13px] text-text outline-none placeholder:text-text-faint" />
          </div>
          <div className="space-y-2">
            {ZONES.map((z) => {
              const on = zone === z.z
              return (
                <button key={z.z} onClick={() => setZone(z.z)} className={`flex w-full items-center gap-3 rounded-xl border px-3 py-2.5 text-left ${on ? 'border-brand-500/50 bg-brand-soft' : 'border-border bg-surface-2'}`}>
                  <span className={`grid h-5 w-5 shrink-0 place-items-center rounded-full border-2 ${on ? 'border-brand-500' : 'border-border'}`}>
                    {on && <span className="h-2.5 w-2.5 rounded-full bg-brand-500" />}
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className={`block text-[13px] font-bold ${on ? 'text-brand-500' : 'text-text'}`}>{z.z}</span>
                    <span className="block text-[11px] text-text-muted">{z.city}</span>
                  </span>
                </button>
              )
            })}
          </div>
        </WPanel>
      )}

      {step === 2 && (
        <WPanel>
          <h3 className="mb-1 text-[15px] font-bold text-text">Review Your Settings</h3>
          <p className="mb-3 text-[11.5px] text-text-muted">Please review your travel details</p>
          <div className="divide-y divide-border">
            <ReviewRow icon={<MapPin size={14} />} title={dest || 'Destination'} sub="United Arab Emirates" />
            <ReviewRow icon={<CalendarDays size={14} />} title={`${from} - ${to}`} sub="7 days" />
            <ReviewRow icon={<Globe size={14} />} title={zone} sub="Time Zone" />
            <ReviewRow icon={<Clock size={14} />} title={behavior === 'local' ? 'Adjust to local time' : 'Keep home time'} sub="Reminder Behavior" />
          </div>
        </WPanel>
      )}

      {step === 3 && (
        <div className="flex flex-col items-center px-2 py-6 text-center">
          <div className="relative mb-4">
            <span className="grid h-20 w-20 place-items-center rounded-full bg-brand-gradient text-white"><Plane size={34} /></span>
            <span className="absolute -bottom-1 -right-1 grid h-8 w-8 place-items-center rounded-full bg-green-500 text-white ring-4 ring-bg"><Check size={16} strokeWidth={3} /></span>
          </div>
          <h3 className="text-[19px] font-extrabold text-text">You're all set!</h3>
          <p className="mt-1 max-w-[240px] text-[12.5px] text-text-muted">Travel Mode is active. We'll adjust your reminders to {zone}.</p>
          <div className="mt-4 flex w-full items-center gap-2 rounded-xl bg-green-soft px-3.5 py-3 text-left">
            <Clock size={16} className="shrink-0 text-green-500" />
            <div>
              <p className="text-[12.5px] font-bold text-green-500">Active until {to}</p>
              <p className="text-[11px] text-text-muted">You'll be notified before your travel ends.</p>
            </div>
          </div>
        </div>
      )}
    </WizardShell>
  )
}

function RadioRow({ on, onClick, title, sub }: { on: boolean; onClick: () => void; title: string; sub: string }) {
  return (
    <button onClick={onClick} className={`flex w-full items-start gap-3 rounded-xl border px-3 py-2.5 text-left ${on ? 'border-brand-500/50 bg-brand-soft' : 'border-border bg-surface-2'}`}>
      <span className={`mt-0.5 grid h-5 w-5 shrink-0 place-items-center rounded-full border-2 ${on ? 'border-brand-500' : 'border-border'}`}>
        {on && <span className="h-2.5 w-2.5 rounded-full bg-brand-500" />}
      </span>
      <span className="min-w-0 flex-1">
        <span className={`block text-[13px] font-bold ${on ? 'text-brand-500' : 'text-text'}`}>{title}</span>
        <span className="block text-[11px] text-text-muted">{sub}</span>
      </span>
    </button>
  )
}

function OptionToggle({ icon, title, sub, on, onChange }: { icon: React.ReactNode; title: string; sub: string; on: boolean; onChange: (v: boolean) => void }) {
  return (
    <div className="flex items-center gap-3 py-2">
      <span className="grid h-8 w-8 shrink-0 place-items-center rounded-lg bg-brand-soft text-brand-500">{icon}</span>
      <div className="min-w-0 flex-1">
        <p className="text-[12.5px] font-semibold text-text">{title}</p>
        <p className="text-[10.5px] text-text-muted">{sub}</p>
      </div>
      <button
        onClick={() => onChange(!on)}
        className={`relative h-6 w-11 shrink-0 rounded-full transition-colors ${on ? 'bg-brand-500' : 'bg-surface-2 ring-1 ring-border'}`}
      >
        <span className={`absolute top-0.5 h-5 w-5 rounded-full bg-white shadow transition-all ${on ? 'left-[22px]' : 'left-0.5'}`} />
      </button>
    </div>
  )
}

function ReviewRow({ icon, title, sub }: { icon: React.ReactNode; title: string; sub: string }) {
  return (
    <div className="flex items-center gap-2.5 py-2.5">
      <span className="grid h-8 w-8 shrink-0 place-items-center rounded-lg bg-brand-soft text-brand-500">{icon}</span>
      <div className="min-w-0">
        <p className="truncate text-[12.5px] font-bold text-text">{title}</p>
        <p className="text-[10.5px] text-text-muted">{sub}</p>
      </div>
    </div>
  )
}
