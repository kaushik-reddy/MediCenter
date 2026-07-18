import { useState } from 'react'
import { User, Camera, Phone, Mail, MapPin, Bell, HeartPulse, MapPinned, Check } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { Dropdown } from '../../components/ui/Dropdown'
import { WizardShell, WField, WLabel, WPanel } from './WizardShell'

const STEPS = ['Personal', 'Contact', 'Preferences', 'Review']

interface Pref {
  key: string
  title: string
  sub: string
  icon: typeof Bell
}
const PREFS: Pref[] = [
  { key: 'notify', title: 'Notify in Emergencies', sub: 'Send alerts and notifications', icon: Bell },
  { key: 'medical', title: 'Share Medical Information', sub: 'Share allergies, conditions & meds', icon: HeartPulse },
  { key: 'location', title: 'Share Live Location', sub: 'Share your location during emergencies', icon: MapPinned },
]

export function AddContactWizard() {
  const { closeModal } = useShell()
  const [step, setStep] = useState(0)
  const [name, setName] = useState('')
  const [rel, setRel] = useState('Family')
  const [priority, setPriority] = useState('Primary')
  const [phone, setPhone] = useState('')
  const [altPhone, setAltPhone] = useState('')
  const [email, setEmail] = useState('')
  const [address, setAddress] = useState('')
  const [prefs, setPrefs] = useState<Record<string, boolean>>({ notify: true, medical: true, location: true })
  const [notes, setNotes] = useState('')

  const toggle = (k: string) => setPrefs((p) => ({ ...p, [k]: !p[k] }))

  return (
    <WizardShell
      title="Add Contact"
      subtitle="Add an emergency contact"
      steps={STEPS}
      step={step}
      onBack={() => setStep((s) => s - 1)}
      onNext={() => setStep((s) => s + 1)}
      onSave={closeModal}
      isLast={step === STEPS.length - 1}
      canNext={step === 0 ? name.trim().length > 0 : true}
      saveLabel="Save Contact"
    >
      {step === 0 && (
        <WPanel>
          <h3 className="mb-3 text-[15px] font-bold text-text">Personal Information</h3>
          <div className="mb-4 flex justify-center">
            <button className="relative">
              <span className="grid h-20 w-20 place-items-center rounded-full border-4 border-surface bg-surface-2 text-text-faint"><User size={30} /></span>
              <span className="absolute -bottom-1 -right-1 grid h-7 w-7 place-items-center rounded-full bg-brand-500 text-white ring-2 ring-surface"><Camera size={13} /></span>
            </button>
          </div>
          <WField label="Full Name" value={name} onChange={setName} placeholder="Enter full name" />
          <WLabel>Relationship</WLabel>
          <div className="mb-3">
            <Dropdown value={rel} onChange={setRel} options={['Family', 'Spouse', 'Parent', 'Sibling', 'Friend', 'Doctor', 'Other']} />
          </div>
          <WLabel>Priority</WLabel>
          <Dropdown value={priority} onChange={setPriority} options={['Primary', 'Secondary']} />
          <p className="mt-2 text-[11px] text-text-muted">Primary contacts are notified first</p>
        </WPanel>
      )}

      {step === 1 && (
        <WPanel>
          <h3 className="mb-3 text-[15px] font-bold text-text">Contact Information</h3>
          <WField label="Phone Number" value={phone} onChange={setPhone} placeholder="+91 Enter phone number" type="tel" icon={<Phone size={15} />} />
          <WField label="Alternate Phone (Optional)" value={altPhone} onChange={setAltPhone} placeholder="Enter alternate number" type="tel" icon={<Phone size={15} />} />
          <WField label="Email (Optional)" value={email} onChange={setEmail} placeholder="Enter email address" type="email" icon={<Mail size={15} />} />
          <WField label="Address (Optional)" value={address} onChange={setAddress} placeholder="Enter address" icon={<MapPin size={15} />} />
        </WPanel>
      )}

      {step === 2 && (
        <WPanel>
          <h3 className="mb-3 text-[15px] font-bold text-text">Emergency Preferences</h3>
          <div className="mb-3 space-y-2">
            {PREFS.map((p) => {
              const Icon = p.icon
              const on = prefs[p.key]
              return (
                <button
                  key={p.key}
                  onClick={() => toggle(p.key)}
                  className={`flex w-full items-center gap-3 rounded-xl border px-3 py-2.5 text-left ${on ? 'border-brand-500/50 bg-brand-soft' : 'border-border bg-surface-2'}`}
                >
                  <Icon size={17} className={on ? 'text-brand-500' : 'text-text-muted'} />
                  <span className="min-w-0 flex-1">
                    <span className="block text-[13px] font-bold text-text">{p.title}</span>
                    <span className="block text-[11px] text-text-muted">{p.sub}</span>
                  </span>
                  <span className={`grid h-5 w-5 shrink-0 place-items-center rounded-md border-2 ${on ? 'border-brand-500 bg-brand-500 text-white' : 'border-border'}`}>
                    {on && <Check size={11} strokeWidth={3} />}
                  </span>
                </button>
              )
            })}
          </div>
          <WLabel>Additional Notes (Optional)</WLabel>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Add any additional notes about this contact"
            className="h-20 w-full resize-none rounded-xl border border-border bg-surface-2 px-3 py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
        </WPanel>
      )}

      {step === 3 && (
        <WPanel>
          <h3 className="mb-3 text-[15px] font-bold text-text">Review &amp; Save</h3>
          <div className="mb-3 flex items-center gap-3 rounded-2xl bg-surface-2 p-3">
            <span className="grid h-12 w-12 shrink-0 place-items-center rounded-full bg-brand-500 text-white"><User size={22} /></span>
            <div className="min-w-0">
              <p className="truncate text-[14px] font-bold text-text">{name || 'Contact'}</p>
              <p className="truncate text-[11.5px] text-text-muted">{rel}</p>
            </div>
            <span className="ml-auto shrink-0 rounded-full bg-green-soft px-2 py-0.5 text-[10px] font-semibold text-green-500">{priority}</span>
          </div>
          <div className="divide-y divide-border">
            {phone && <ReviewRow icon={<Phone size={14} />} value={phone} />}
            {email && <ReviewRow icon={<Mail size={14} />} value={email} />}
            {address && <ReviewRow icon={<MapPin size={14} />} value={address} />}
          </div>
          <div className="mt-2 space-y-1.5">
            {PREFS.filter((p) => prefs[p.key]).map((p) => (
              <div key={p.key} className="flex items-center gap-2 text-[12px] font-medium text-green-500">
                <Check size={13} strokeWidth={3} /> {p.title}
              </div>
            ))}
          </div>
        </WPanel>
      )}
    </WizardShell>
  )
}

function ReviewRow({ icon, value }: { icon: React.ReactNode; value: string }) {
  return (
    <div className="flex items-center gap-2 py-2">
      <span className="text-text-faint">{icon}</span>
      <span className="truncate text-[12.5px] font-semibold text-text">{value}</span>
    </div>
  )
}
