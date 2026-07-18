import { useState } from 'react'
import { FileText, Heart, Droplet, Scale, Activity, Share2, Download, Stethoscope } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Card } from '../../components/ui/Card'
import { Banner } from '../../components/ui/Banner'
import { GaugeRing, AreaLine } from '../../components/ui/Charts'
import { Modal, ModalActions } from '../../components/ui/Modal'
import { InfoModal } from '../flows/FlowModals'

export function HealthReportsPage() {
  const { openDrawer, openModal } = useShell()
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Health Reports" subtitle="Your health, in detail" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Banner icon={<FileText size={18} />} title="Comprehensive Health Reports" subtitle="Everything about your health in one place" />

        <div className="grid grid-cols-2 gap-2.5">
          <Tile fg="text-brand-500" bg="bg-brand-soft" n="82" label="Health Score" delta="↑8 pts" />
          <Tile fg="text-green-500" bg="bg-green-soft" n="94%" label="Adherence" delta="↑6%" />
          <Tile fg="text-amber-500" bg="bg-amber-soft" n="3" label="Late Doses" delta="↓2" />
          <Tile fg="text-red-500" bg="bg-red-soft" n="2" label="Missed Doses" delta="↓1" />
        </div>

        <Card>
          <div className="mb-3 flex items-center justify-between">
            <h2 className="text-[15px] font-bold text-text">Health Overview</h2>
            <button onClick={() => openModal(<InfoModal title="Full Health Report" message="Your complete health report with all vitals and trends." />)} className="text-[12px] font-semibold text-brand-500">View Full Report</button>
          </div>
          <div className="space-y-2">
            <Vital icon={<Heart size={15} />} fg="text-red-500" name="Blood Pressure" value="118/76 mmHg" tag="Normal" />
            <Vital icon={<Droplet size={15} />} fg="text-blue-500" name="Blood Sugar (Fasting)" value="96 mg/dL" tag="Normal" />
            <Vital icon={<Scale size={15} />} fg="text-brand-500" name="Weight" value="72.5 kg" tag="↓1.2kg" tagTone="brand" />
            <Vital icon={<Activity size={15} />} fg="text-green-500" name="BMI" value="24.1" tag="Normal" />
          </div>
        </Card>

        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">Medication Adherence</h2>
          <div className="flex items-center gap-4">
            <GaugeRing percent={94} label="94%" sub="On Time" color="var(--green-500)" size={104} />
            <div className="flex-1 space-y-1.5">
              <Row color="bg-green-500" label="On Time" value="79%" />
              <Row color="bg-amber-500" label="Late" value="7%" />
              <Row color="bg-red-500" label="Missed" value="11%" />
              <Row color="bg-border-strong" label="Not Scheduled" value="3%" />
            </div>
          </div>
        </Card>

        <Card>
          <h2 className="mb-1 text-[15px] font-bold text-text">Trend Overview</h2>
          <p className="mb-2 text-[12px] text-text-muted">Jan – Jun</p>
          <AreaLine data={[60, 70, 65, 80, 88, 94]} />
        </Card>

        <div className="flex gap-3">
          <button
            onClick={() => openModal(<ExportReportModal />)}
            className="flex flex-1 items-center justify-center gap-2 rounded-2xl border border-border bg-surface py-3 text-[14px] font-bold text-text active:scale-[0.98]"
          >
            <Download size={16} /> Export
          </button>
          <button
            onClick={() => openModal(<ShareReportModal />)}
            className="flex flex-1 items-center justify-center gap-2 rounded-2xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
          >
            <Share2 size={16} /> Share Report
          </button>
        </div>

        <Banner
          icon={<Stethoscope size={18} />}
          title="Share with your doctor"
          subtitle="Keep your care team informed"
          onClick={() => openModal(<ShareReportModal />)}
          showChevron
        />
      </div>
    </div>
  )
}

function Tile({ fg, bg, n, label, delta }: { fg: string; bg: string; n: string; label: string; delta: string }) {
  return (
    <div className={`rounded-2xl p-3 ${bg}`}>
      <div className="flex items-baseline gap-1.5">
        <span className={`text-[20px] font-extrabold ${fg}`}>{n}</span>
        <span className={`text-[11px] font-semibold ${fg}`}>{delta}</span>
      </div>
      <div className="mt-0.5 text-[12px] font-medium text-text">{label}</div>
    </div>
  )
}
function Vital({ icon, fg, name, value, tag, tagTone = 'green' }: { icon: React.ReactNode; fg: string; name: string; value: string; tag: string; tagTone?: 'green' | 'brand' }) {
  return (
    <div className="flex items-center gap-3 rounded-2xl bg-surface-2 p-2.5">
      <span className={`grid h-9 w-9 shrink-0 place-items-center rounded-full bg-surface ${fg}`}>{icon}</span>
      <div className="min-w-0 flex-1">
        <p className="text-[13px] font-bold text-text">{name}</p>
        <p className="text-[12px] text-text-muted">{value}</p>
      </div>
      <span className={`shrink-0 rounded-full px-2 py-0.5 text-[10.5px] font-semibold ${tagTone === 'brand' ? 'bg-brand-soft text-brand-500' : 'bg-green-soft text-green-500'}`}>{tag}</span>
    </div>
  )
}
function Row({ color, label, value }: { color: string; label: string; value: string }) {
  return (
    <div className="flex items-center gap-2">
      <span className={`h-2.5 w-2.5 rounded-full ${color}`} />
      <span className="flex-1 text-[12px] text-text">{label}</span>
      <span className="text-[12px] font-bold text-text">{value}</span>
    </div>
  )
}

function ExportReportModal() {
  const [fmt, setFmt] = useState('PDF')
  return (
    <Modal icon={<Download size={22} />} title="Export Report" subtitle="Choose a format">
      <div className="mb-3 flex gap-2">
        {['PDF', 'Excel', 'CSV'].map((f) => (
          <button key={f} onClick={() => setFmt(f)} className={`flex-1 rounded-xl py-2.5 text-[13px] font-bold ${fmt === f ? 'bg-brand-soft text-brand-500 ring-1 ring-brand-500' : 'bg-surface-2 text-text-muted'}`}>{f}</button>
        ))}
      </div>
      <ModalActions primaryLabel="Export Report" />
    </Modal>
  )
}
function ShareReportModal() {
  const [via, setVia] = useState('Email')
  return (
    <Modal icon={<Share2 size={22} />} title="Share Report" subtitle="Send to your doctor">
      <div className="mb-3 flex gap-2">
        {['Email', 'Secure Link'].map((v) => (
          <button key={v} onClick={() => setVia(v)} className={`flex-1 rounded-xl py-2.5 text-[13px] font-bold ${via === v ? 'bg-brand-soft text-brand-500 ring-1 ring-brand-500' : 'bg-surface-2 text-text-muted'}`}>{v}</button>
        ))}
      </div>
      <ModalActions primaryLabel="Send Report" />
    </Modal>
  )
}
