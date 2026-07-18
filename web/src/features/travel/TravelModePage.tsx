import { useState } from 'react'
import { Plane, Check, MapPin, Clock, Bell } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Card } from '../../components/ui/Card'
import { Toggle } from '../../components/ui/Toggle'
import { Modal, Field, ModalActions } from '../../components/ui/Modal'

export function TravelModePage() {
  const { openDrawer, openModal } = useShell()
  const [on, setOn] = useState(true)
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Travel Mode" subtitle="Stay on track, wherever you go" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <div className="flex items-center gap-3 rounded-[18px] bg-brand-soft px-3.5 py-3.5">
          <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-surface/70 text-brand-500"><Plane size={18} /></span>
          <div className="min-w-0 flex-1">
            <p className="text-[13.5px] font-bold text-brand-500">Never miss your medicines</p>
            <p className="text-[12px] text-text-muted">Adjusts reminders to your current time zone</p>
          </div>
          <Toggle on={on} onChange={setOn} />
        </div>

        {on && (
          <Card>
            <div className="mb-3 flex items-center gap-2">
              <span className="grid h-10 w-10 place-items-center rounded-xl bg-brand-soft text-brand-500"><Plane size={18} /></span>
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-[15px] font-bold text-green-500">Active</span>
                  <span className="rounded-full bg-green-soft px-2 py-0.5 text-[10px] font-semibold text-green-500">● Live</span>
                </div>
                <p className="text-[11.5px] text-text-muted">Reminders adjusted to current time zone</p>
              </div>
            </div>
            <div className="grid grid-cols-3 gap-2">
              <Info icon={<Clock size={14} />} value="10:30 AM" label="Local Time" />
              <Info icon={<MapPin size={14} />} value="GMT+5:30" label="Time Zone" />
              <Info icon={<Bell size={14} />} value="1:00 PM" label="Next Dose" />
            </div>
          </Card>
        )}

        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">What Travel Mode does</h2>
          <div className="space-y-2.5">
            {[
              ['Adjusts to local time zone', 'Reminders follow you as you travel'],
              ['Keeps your schedule intact', 'Same doses, adjusted times'],
              ['Smart notifications', 'No duplicate or missed alerts'],
              ['Works offline', 'No internet needed while abroad'],
            ].map(([t, s]) => (
              <div key={t} className="flex items-start gap-3">
                <span className="mt-0.5 grid h-6 w-6 shrink-0 place-items-center rounded-full bg-green-soft text-green-500"><Check size={14} strokeWidth={3} /></span>
                <div>
                  <p className="text-[13.5px] font-semibold text-text">{t}</p>
                  <p className="text-[11.5px] text-text-muted">{s}</p>
                </div>
              </div>
            ))}
          </div>
        </Card>

        <div className="rounded-xl bg-brand-soft px-3.5 py-2.5 text-[12px] text-brand-500">
          Travel Mode stays active until you turn it off. Home time zone: GMT+5:30
        </div>

        <button
          onClick={() => openModal(<ConfigureTravelModal />)}
          className="flex w-full items-center justify-center gap-2 rounded-2xl bg-brand-gradient py-3.5 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
        >
          <Plane size={16} /> Configure Travel Mode
        </button>
        <button onClick={() => setOn(false)} className="w-full text-center text-[13px] font-semibold text-brand-500">Turn Off Travel Mode</button>
      </div>
    </div>
  )
}

function Info({ icon, value, label }: { icon: React.ReactNode; value: string; label: string }) {
  return (
    <div className="rounded-xl bg-surface-2 px-2 py-2.5 text-center">
      <span className="mx-auto mb-1 grid h-7 w-7 place-items-center rounded-full bg-surface text-brand-500">{icon}</span>
      <div className="text-[12.5px] font-bold text-text">{value}</div>
      <div className="text-[10px] text-text-muted">{label}</div>
    </div>
  )
}

function ConfigureTravelModal() {
  const [dest, setDest] = useState('Dubai, UAE')
  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  return (
    <Modal icon={<Plane size={22} />} title="Configure Travel Mode" subtitle="Set your destination">
      <Field label="Destination" value={dest} onChange={setDest} placeholder="Where are you going?" />
      <div className="flex gap-3">
        <div className="flex-1"><Field label="From" value={from} onChange={setFrom} placeholder="24 May" /></div>
        <div className="flex-1"><Field label="To" value={to} onChange={setTo} placeholder="31 May" /></div>
      </div>
      <ModalActions primaryLabel="Activate" />
    </Modal>
  )
}
