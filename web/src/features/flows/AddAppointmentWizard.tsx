import { useState } from 'react'
import { Stethoscope, CalendarDays, Clock, Timer, MapPin, FileText, Bell, Check, User } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { Dropdown } from '../../components/ui/Dropdown'
import { WizardShell, WField, WLabel, WPanel, WNote } from './WizardShell'

const STEPS = ['Doctor Details', 'Appointment', 'Additional Info', 'Review']

export function AddAppointmentWizard() {
  const { closeModal } = useShell()
  const [step, setStep] = useState(0)
  const [doctor, setDoctor] = useState('')
  const [spec, setSpec] = useState('General Physician')
  const [hospital, setHospital] = useState('')
  const [date, setDate] = useState('24 May 2024')
  const [time, setTime] = useState('11:30 AM')
  const [duration, setDuration] = useState('20 min')
  const [purpose, setPurpose] = useState('')
  const [notes, setNotes] = useState('')

  return (
    <WizardShell
      title="Add Appointment"
      subtitle="Book a doctor visit"
      steps={STEPS}
      step={step}
      onBack={() => setStep((s) => s - 1)}
      onNext={() => setStep((s) => s + 1)}
      onSave={closeModal}
      isLast={step === STEPS.length - 1}
      canNext={step === 0 ? doctor.trim().length > 0 : true}
      saveLabel="Confirm Appointment"
    >
      {step === 0 && (
        <WPanel>
          <div className="mb-3 flex items-center gap-2.5">
            <span className="grid h-10 w-10 place-items-center rounded-xl bg-brand-soft text-brand-500"><Stethoscope size={18} /></span>
            <div>
              <h3 className="text-[15px] font-bold text-text">Doctor Details</h3>
              <p className="text-[11.5px] text-text-muted">Who are you visiting?</p>
            </div>
          </div>
          <WField label="Doctor Name" value={doctor} onChange={setDoctor} placeholder="Search doctor name" icon={<User size={15} />} />
          <WLabel>Specialization</WLabel>
          <div className="mb-3">
            <Dropdown value={spec} onChange={setSpec} options={['General Physician', 'Cardiologist', 'Dermatologist', 'Orthopedic', 'Dentist', 'ENT', 'Neurologist']} />
          </div>
          <WField label="Hospital / Clinic" value={hospital} onChange={setHospital} placeholder="Search hospital or clinic" icon={<MapPin size={15} />} />
        </WPanel>
      )}

      {step === 1 && (
        <WPanel>
          <div className="mb-3 flex items-center gap-2.5">
            <span className="grid h-10 w-10 place-items-center rounded-xl bg-brand-soft text-brand-500"><CalendarDays size={18} /></span>
            <div>
              <h3 className="text-[15px] font-bold text-text">Appointment Details</h3>
              <p className="text-[11.5px] text-text-muted">When is your visit?</p>
            </div>
          </div>
          <WField label="Date" value={date} onChange={setDate} icon={<CalendarDays size={15} />} />
          <WField label="Time" value={time} onChange={setTime} icon={<Clock size={15} />} />
          <WLabel>Duration</WLabel>
          <Dropdown value={duration} onChange={setDuration} options={['15 min', '20 min', '30 min', '45 min', '1 hour']} />
        </WPanel>
      )}

      {step === 2 && (
        <WPanel>
          <div className="mb-3 flex items-center gap-2.5">
            <span className="grid h-10 w-10 place-items-center rounded-xl bg-brand-soft text-brand-500"><FileText size={18} /></span>
            <div>
              <h3 className="text-[15px] font-bold text-text">Additional Information</h3>
              <p className="text-[11.5px] text-text-muted">Optional details for this visit</p>
            </div>
          </div>
          <WField label="Purpose (Optional)" value={purpose} onChange={setPurpose} placeholder="e.g. Follow-up, Consultation" />
          <WLabel>Notes (Optional)</WLabel>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Add any notes for this visit"
            className="h-20 w-full resize-none rounded-xl border border-border bg-surface-2 px-3 py-2.5 text-[13.5px] text-text outline-none placeholder:text-text-faint"
          />
        </WPanel>
      )}

      {step === 3 && (
        <WPanel>
          <div className="mb-3">
            <h3 className="text-[15px] font-bold text-text">Review &amp; Confirm</h3>
            <p className="text-[11.5px] text-text-muted">Review your appointment details</p>
          </div>
          <div className="mb-3 flex items-center gap-3 rounded-2xl bg-surface-2 p-3">
            <span className="grid h-11 w-11 shrink-0 place-items-center rounded-2xl bg-brand-500 text-white"><Stethoscope size={20} /></span>
            <div className="min-w-0">
              <p className="truncate text-[14px] font-bold text-text">{doctor || 'Doctor'}</p>
              <p className="truncate text-[11.5px] text-text-muted">{spec}</p>
            </div>
          </div>
          <div className="divide-y divide-border">
            <ReviewRow icon={<Clock size={14} />} value={`${date} · ${time}`} />
            <ReviewRow icon={<Timer size={14} />} value={duration} />
            <ReviewRow icon={<MapPin size={14} />} value={hospital || 'Not set'} />
            <ReviewRow icon={<Bell size={14} />} value="Reminder 1 day before" />
            {purpose && <ReviewRow icon={<FileText size={14} />} value={purpose} />}
          </div>
          <WNote text="You'll receive a reminder before your appointment." />
        </WPanel>
      )}
    </WizardShell>
  )
}

function ReviewRow({ icon, value }: { icon: React.ReactNode; value: string }) {
  return (
    <div className="flex items-center gap-2 py-2">
      <span className="text-text-faint">{icon}</span>
      <span className="text-[12.5px] font-semibold text-text">{value}</span>
      <Check size={14} className="ml-auto text-green-500" />
    </div>
  )
}
