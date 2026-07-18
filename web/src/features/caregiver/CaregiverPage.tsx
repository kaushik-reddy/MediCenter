import { useState } from 'react'
import { Users, UserPlus, ShieldCheck, Check, Clock, X, ChevronRight, Bell } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Chips } from '../../components/ui/Chips'
import { Banner } from '../../components/ui/Banner'
import { Modal, Field, ModalActions } from '../../components/ui/Modal'
import { Toggle } from '../../components/ui/Toggle'
import { InfoModal } from '../flows/FlowModals'

interface Person {
  id: string
  name: string
  img: number
  status: 'attention' | 'good'
  meds: number
  updated: string
  missed: number
  late: number
  taken: number
}
const people: Person[] = [
  { id: 'p1', name: 'Mom', img: 45, status: 'attention', meds: 5, updated: '10 min ago', missed: 1, late: 1, taken: 3 },
  { id: 'p2', name: 'Dad', img: 12, status: 'attention', meds: 4, updated: '25 min ago', missed: 0, late: 2, taken: 2 },
  { id: 'p3', name: 'Grandma', img: 32, status: 'good', meds: 6, updated: '5 min ago', missed: 0, late: 0, taken: 6 },
]
const activity = [
  { id: 'ac1', img: 45, text: 'Mom missed Paracetamol 650mg', time: '8:30 AM', tone: 'red' },
  { id: 'ac2', img: 12, text: 'Dad took Vitamin D3 late', time: '9:15 AM', tone: 'amber' },
  { id: 'ac3', img: 32, text: 'Grandma took all morning doses', time: '7:00 AM', tone: 'green' },
]

export function CaregiverPage() {
  const { openDrawer, openModal } = useShell()
  const [chip, setChip] = useState('All')
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Caregiver Mode" subtitle="Stay updated with your loved ones" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Banner
          icon={<Users size={18} />}
          title="Connected with 3 people"
          subtitle="You're helping them stay on track"
          action={
            <button onClick={() => openModal(<AddCaregiverModal />)} className="flex shrink-0 items-center gap-1 rounded-xl bg-brand-gradient px-3 py-2 text-[12px] font-bold text-white">
              <UserPlus size={13} /> Invite
            </button>
          }
        />

        <Chips items={[{ label: 'All', count: 3 }, { label: 'Needs Attention', count: 2 }, { label: 'All Good', count: 1 }]} active={chip} onChange={setChip} />

        {people.map((p) => (
          <div key={p.id} className="rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
            <div className="flex items-center gap-3">
              <img src={`https://i.pravatar.cc/80?img=${p.img}`} alt="" className="h-11 w-11 rounded-full object-cover" />
              <div className="min-w-0 flex-1">
                <div className="flex items-center gap-2">
                  <p className="text-[15px] font-bold text-text">{p.name}</p>
                  <span className={`rounded-full px-2 py-0.5 text-[10px] font-semibold ${p.status === 'attention' ? 'bg-amber-soft text-amber-500' : 'bg-green-soft text-green-500'}`}>
                    {p.status === 'attention' ? 'Needs Attention' : 'All Good'}
                  </span>
                </div>
                <p className="text-[11.5px] text-text-muted">{p.meds} medications · Updated {p.updated}</p>
              </div>
            </div>
            <div className="mt-3 grid grid-cols-3 gap-2">
              <MiniStat bg="bg-red-soft" fg="text-red-500" icon={<X size={13} />} n={p.missed} label="Missed" />
              <MiniStat bg="bg-amber-soft" fg="text-amber-500" icon={<Clock size={13} />} n={p.late} label="Late" />
              <MiniStat bg="bg-green-soft" fg="text-green-500" icon={<Check size={13} />} n={p.taken} label="Taken" />
            </div>
            <div className="mt-3 flex gap-2">
              <button onClick={() => openModal(<SendReminderModal name={p.name} />)} className="flex-1 rounded-xl bg-brand-gradient py-2.5 text-[12.5px] font-bold text-white">Send Reminder</button>
              <button onClick={() => openModal(<InfoModal title={p.name} message={`${p.meds} medications · ${p.taken} taken, ${p.late} late, ${p.missed} missed today.`} />)} className="flex items-center gap-1 rounded-xl border border-border px-3 py-2.5 text-[12.5px] font-semibold text-text">View Details <ChevronRight size={14} /></button>
            </div>
          </div>
        ))}

        <Banner icon={<ShieldCheck size={18} />} title="Care with confidence" subtitle="Your loved ones' data is private and secure." />

        <h2 className="pt-1 text-[15px] font-bold text-text">Recent Activity</h2>
        <div className="overflow-hidden rounded-[18px] bg-surface shadow-[var(--shadow-card)] ring-1 ring-border">
          {activity.map((a, i) => (
            <div key={a.id} className={`flex items-center gap-3 px-3.5 py-3 ${i === activity.length - 1 ? '' : 'border-b border-border'}`}>
              <img src={`https://i.pravatar.cc/60?img=${a.img}`} alt="" className="h-9 w-9 rounded-full object-cover" />
              <p className="min-w-0 flex-1 truncate text-[13px] font-medium text-text">{a.text}</p>
              <span className={`shrink-0 text-[11px] font-semibold ${a.tone === 'red' ? 'text-red-500' : a.tone === 'amber' ? 'text-amber-500' : 'text-green-500'}`}>{a.time}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}

function MiniStat({ bg, fg, icon, n, label }: { bg: string; fg: string; icon: React.ReactNode; n: number; label: string }) {
  return (
    <div className={`flex flex-col items-center rounded-xl py-2 ${bg}`}>
      <span className={fg}>{icon}</span>
      <span className={`text-[15px] font-extrabold ${fg}`}>{n}</span>
      <span className="text-[10px] text-text-muted">{label}</span>
    </div>
  )
}

function SendReminderModal({ name }: { name: string }) {
  const [ch, setCh] = useState<Record<string, boolean>>({ Push: true, WhatsApp: true, SMS: false, 'Phone Call': false })
  return (
    <Modal icon={<Bell size={22} />} title="Send Reminder" subtitle={`Nudge ${name} about their medicine`}>
      <div className="mb-3 space-y-2">
        {Object.keys(ch).map((k) => (
          <div key={k} className="flex items-center justify-between rounded-xl bg-surface-2 px-3.5 py-3">
            <span className="text-[14px] font-semibold text-text">{k}</span>
            <Toggle on={ch[k]} onChange={(v) => setCh((p) => ({ ...p, [k]: v }))} />
          </div>
        ))}
      </div>
      <ModalActions primaryLabel="Send Reminder" />
    </Modal>
  )
}

function AddCaregiverModal() {
  const [name, setName] = useState('')
  const [phone, setPhone] = useState('')
  const [perms, setPerms] = useState<Record<string, boolean>>({ 'View Schedule': true, 'Receive Alerts': true, 'Manage Inventory': false })
  return (
    <Modal icon={<UserPlus size={22} />} title="Add Caregiver" subtitle="Invite someone to help">
      <Field label="Name" value={name} onChange={setName} placeholder="e.g. Mom" />
      <Field label="Phone" value={phone} onChange={setPhone} placeholder="+91 98765 43210" />
      <p className="mb-2 text-[12.5px] font-semibold text-text-muted">Permissions</p>
      <div className="mb-3 space-y-2">
        {Object.keys(perms).map((k) => (
          <div key={k} className="flex items-center justify-between rounded-xl bg-surface-2 px-3.5 py-3">
            <span className="text-[14px] font-semibold text-text">{k}</span>
            <Toggle on={perms[k]} onChange={(v) => setPerms((p) => ({ ...p, [k]: v }))} />
          </div>
        ))}
      </div>
      <ModalActions primaryLabel="Send Invitation" />
    </Modal>
  )
}
