import { useState } from 'react'
import { ShieldCheck, Search, Phone, MessageSquare, MoreVertical, Plus, UserPlus } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Chips } from '../../components/ui/Chips'
import { Banner } from '../../components/ui/Banner'
import { Modal, Field, ModalActions } from '../../components/ui/Modal'
import { InfoModal } from '../flows/FlowModals'

interface Contact {
  id: string
  name: string
  rel: string
  phone: string
  img: number
  primary: boolean
  order?: number
}
const primary: Contact[] = [
  { id: 'c1', name: 'Anita Reddy', rel: 'Mother', phone: '+91 98765 43210', img: 45, primary: true, order: 1 },
  { id: 'c2', name: 'Dr. Sharma', rel: 'Family Doctor', phone: '+91 98765 11111', img: 60, primary: true, order: 2 },
  { id: 'c3', name: 'Ravi Reddy', rel: 'Brother', phone: '+91 98765 22222', img: 13, primary: true, order: 3 },
]
const secondary: Contact[] = [
  { id: 'c4', name: 'Priya Sharma', rel: 'Friend', phone: '+91 98765 33333', img: 20, primary: false },
  { id: 'c5', name: 'Apollo Hospital', rel: 'Emergency', phone: '1066', img: 50, primary: false },
]

export function EmergencyContactsPage() {
  const { openDrawer, openModal } = useShell()
  const [chip, setChip] = useState('All')
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Emergency Contacts" subtitle="Your safety, our priority" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Banner icon={<ShieldCheck size={18} />} title="You're protected" subtitle="5 emergency contacts are ready to help" />

        <div className="flex items-center gap-2 rounded-2xl bg-surface px-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
          <Search size={16} className="text-text-faint" />
          <input placeholder="Search contacts" className="w-full bg-transparent py-3 text-[13.5px] text-text outline-none placeholder:text-text-faint" />
        </div>

        <Chips items={[{ label: 'All', count: 5 }, { label: 'Family', count: 3 }, { label: 'Friends', count: 2 }, { label: 'Others', count: 0 }]} active={chip} onChange={setChip} />

        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-text">Primary Contacts</h2>
          <button onClick={() => openModal(<InfoModal title="Reorder Contacts" message="Drag to reorder your primary emergency contacts." />)} className="text-[12.5px] font-semibold text-brand-500">Reorder</button>
        </div>
        <div className="space-y-2.5">
          {primary.map((c) => <ContactRow key={c.id} c={c} onAction={openModal} />)}
        </div>

        <h2 className="pt-1 text-[15px] font-bold text-text">Secondary Contacts</h2>
        <div className="space-y-2.5">
          {secondary.map((c) => <ContactRow key={c.id} c={c} onAction={openModal} />)}
        </div>

        <button
          onClick={() => openModal(<AddContactModal />)}
          className="flex w-full items-center justify-center gap-1.5 rounded-2xl border-2 border-dashed border-brand-500/40 py-3.5 text-[13.5px] font-bold text-brand-500 active:scale-[0.99]"
        >
          <Plus size={16} /> Add Emergency Contact
        </button>
      </div>
    </div>
  )
}

function ContactRow({ c, onAction }: { c: Contact; onAction: (node: React.ReactNode) => void }) {
  return (
    <div className="flex items-center gap-3 rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
      {c.order != null && (
        <span className="grid h-6 w-6 shrink-0 place-items-center rounded-full bg-brand-500 text-[11px] font-bold text-white">{c.order}</span>
      )}
      <img src={`https://i.pravatar.cc/80?img=${c.img}`} alt="" className="h-11 w-11 shrink-0 rounded-full object-cover" />
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <p className="truncate text-[14px] font-bold text-text">{c.name}</p>
          <span className={`shrink-0 rounded-full px-1.5 py-0.5 text-[9.5px] font-semibold ${c.primary ? 'bg-green-soft text-green-500' : 'bg-amber-soft text-amber-500'}`}>
            {c.primary ? 'Primary' : 'Secondary'}
          </span>
        </div>
        <p className="truncate text-[11.5px] text-text-muted">{c.rel} · {c.phone}</p>
      </div>
      <button onClick={() => onAction(<InfoModal title={`Call ${c.name}`} message={c.phone} icon={<Phone size={22} />} />)} className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-green-soft text-green-500 active:scale-95"><Phone size={15} /></button>
      <button onClick={() => onAction(<InfoModal title={`Message ${c.name}`} message={c.phone} icon={<MessageSquare size={22} />} />)} className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-brand-soft text-brand-500 active:scale-95"><MessageSquare size={15} /></button>
      <button onClick={() => onAction(<InfoModal title={c.name} message={`${c.rel} · ${c.phone}`} />)} className="grid h-8 w-6 shrink-0 place-items-center text-text-faint"><MoreVertical size={16} /></button>
    </div>
  )
}

function AddContactModal() {
  const [name, setName] = useState('')
  const [rel, setRel] = useState('')
  const [phone, setPhone] = useState('')
  return (
    <Modal icon={<UserPlus size={22} />} title="Add Contact" subtitle="Add an emergency contact">
      <Field label="Full Name" value={name} onChange={setName} placeholder="e.g. Anita Reddy" />
      <Field label="Relationship" value={rel} onChange={setRel} placeholder="e.g. Mother" />
      <Field label="Phone Number" value={phone} onChange={setPhone} placeholder="+91 98765 43210" />
      <ModalActions primaryLabel="Save Contact" />
    </Modal>
  )
}
