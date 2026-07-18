import { useNavigate } from 'react-router-dom'
import { Stethoscope, Clock, ChevronRight, CheckCircle2, Calendar, Bell, Plus, Upload } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Banner } from '../../components/ui/Banner'
import { InfoModal } from '../flows/FlowModals'
import { AddAppointmentWizard } from '../flows/AddAppointmentWizard'

interface Appt {
  id: string
  mon: string
  day: string
  dow: string
  name: string
  spec: string
  hospital: string
  time: string
  duration: string
  status: 'confirmed' | 'completed'
}

const upcoming: Appt[] = [
  { id: 'a1', mon: 'MAY', day: '24', dow: 'FRI', name: 'Dr. Anjali Sharma', spec: 'Cardiologist', hospital: 'Apollo Hospital', time: '10:30 AM', duration: '30 min', status: 'confirmed' },
]
const past: Appt[] = [
  { id: 'a2', mon: 'MAY', day: '10', dow: 'FRI', name: 'Dr. Rajesh Kumar', spec: 'General Physician', hospital: 'Fortis', time: '4:00 PM', duration: '20 min', status: 'completed' },
  { id: 'a3', mon: 'APR', day: '28', dow: 'SUN', name: 'Dr. Meera Iyer', spec: 'Dermatologist', hospital: 'Max Clinic', time: '11:00 AM', duration: '30 min', status: 'completed' },
]

export function DoctorVisitsPage() {
  const { openDrawer, openModal } = useShell()
  const navigate = useNavigate()
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Doctor Visits" subtitle="Manage your appointments" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-text">Upcoming Appointments</h2>
          <button onClick={() => navigate('/calendar')} className="text-[12.5px] font-semibold text-brand-500">View Calendar</button>
        </div>

        {upcoming.map((a) => (
          <div key={a.id} className="rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
            <ApptRow a={a} />
            <div className="mt-3 flex items-center gap-2 rounded-xl bg-brand-soft px-3 py-2.5">
              <Bell size={15} className="text-brand-500" />
              <span className="flex-1 text-[12px] font-medium text-brand-500">Appointment in 2 days</span>
              <button onClick={() => openModal(<InfoModal title={a.name} message={`${a.spec} · ${a.hospital} · ${a.time}`} />)} className="text-[12px] font-semibold text-brand-500">View Details</button>
            </div>
          </div>
        ))}

        <div className="flex items-center justify-between pt-1">
          <h2 className="text-[15px] font-bold text-text">Past Appointments</h2>
          <button onClick={() => openModal(<InfoModal title="Past Appointments" message="You have 6 completed appointments in your history." />)} className="text-[12.5px] font-semibold text-brand-500">View All</button>
        </div>
        <div className="overflow-hidden rounded-[18px] bg-surface shadow-[var(--shadow-card)] ring-1 ring-border">
          {past.map((a, i) => (
            <div key={a.id} className={i === past.length - 1 ? 'p-3' : 'border-b border-border p-3'}>
              <ApptRow a={a} />
            </div>
          ))}
        </div>

        {/* Health summary */}
        <div className="grid grid-cols-2 gap-2.5">
          <Tile bg="bg-brand-soft" fg="text-brand-500" icon={<Calendar size={15} />} n="8" label="Total Visits" />
          <Tile bg="bg-green-soft" fg="text-green-500" icon={<CheckCircle2 size={15} />} n="6" label="Completed" />
          <Tile bg="bg-amber-soft" fg="text-amber-500" icon={<Clock size={15} />} n="2" label="Upcoming" />
          <Tile bg="bg-blue-soft" fg="text-blue-500" icon={<Stethoscope size={15} />} n="3" label="Doctors" />
        </div>

        <Banner
          icon={<Upload size={18} />}
          title="Keep all your health records in one place"
          subtitle="Upload prescriptions and reports"
          action={<button onClick={() => openModal(<InfoModal title="Upload Records" message="Upload prescriptions and reports to keep them in one place." icon={<Upload size={22} />} />)} className="shrink-0 rounded-xl border border-brand-500/40 px-2.5 py-2 text-[12px] font-semibold text-brand-500">Upload</button>}
        />
      </div>

      {/* Floating add */}
      <button
        onClick={() => openModal(<AddAppointmentModal />)}
        className="pointer-events-auto fixed bottom-24 right-5 z-10 flex items-center gap-1.5 rounded-full bg-brand-gradient px-4 py-3 text-[13px] font-bold text-white shadow-lg"
        style={{ position: 'absolute' }}
      >
        <Plus size={16} /> Add
      </button>
    </div>
  )
}

function ApptRow({ a }: { a: Appt }) {
  return (
    <div className="flex items-center gap-3">
      <div className="flex w-[52px] shrink-0 flex-col items-center rounded-2xl bg-brand-gradient py-2 text-white">
        <span className="text-[10px] font-bold">{a.mon}</span>
        <span className="text-[18px] font-extrabold leading-none">{a.day}</span>
        <span className="text-[9px]">{a.dow}</span>
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-[14.5px] font-bold text-text">{a.name}</p>
        <p className="truncate text-[12px] text-text-muted">{a.spec} · {a.hospital}</p>
        <p className="mt-0.5 flex items-center gap-1 text-[11.5px] text-text-muted">
          <Clock size={11} /> {a.time} · {a.duration}
        </p>
      </div>
      {a.status === 'confirmed' ? (
        <span className="shrink-0 rounded-full bg-green-soft px-2 py-0.5 text-[10.5px] font-semibold text-green-500">Confirmed</span>
      ) : (
        <span className="flex shrink-0 items-center gap-1 text-[11px] font-semibold text-green-500"><CheckCircle2 size={13} /> Completed</span>
      )}
      <ChevronRight size={16} className="shrink-0 text-text-faint" />
    </div>
  )
}

function Tile({ bg, fg, icon, n, label }: { bg: string; fg: string; icon: React.ReactNode; n: string; label: string }) {
  return (
    <div className={`flex items-center gap-2.5 rounded-2xl p-3 ${bg}`}>
      <span className={`grid h-9 w-9 place-items-center rounded-xl bg-surface/70 ${fg}`}>{icon}</span>
      <div>
        <div className={`text-[17px] font-extrabold ${fg}`}>{n}</div>
        <div className="text-[11px] text-text-muted">{label}</div>
      </div>
    </div>
  )
}

function AddAppointmentModal() {
  return <AddAppointmentWizard />
}
