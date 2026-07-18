import { ShieldAlert, X, Plus, Search, ChevronRight, AlertTriangle, Save, Share2 } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Card } from '../../components/ui/Card'
import { Banner } from '../../components/ui/Banner'
import { MedThumb } from '../medications/MedThumb'
import { Modal } from '../../components/ui/Modal'
import { InfoModal } from '../flows/FlowModals'

const selected = [
  { id: 's1', name: 'Paracetamol 650mg', form: 'Tablet', kind: 'capsule' as const, tint: '#e7f6ee', colors: ['#22c55e', '#ffffff'] as [string, string] },
  { id: 's2', name: 'Ibuprofen 400mg', form: 'Tablet', kind: 'tablet' as const, tint: '#e6f0fd', colors: ['#3b82f6', '#ffffff'] as [string, string] },
]

const recent = [
  { id: 'c1', a: 'Paracetamol', b: 'Ibuprofen', ago: '2 days ago', risk: 'High Risk', tone: 'red' as const },
  { id: 'c2', a: 'Vitamin D3', b: 'Calcium', ago: '5 days ago', risk: 'No Interaction', tone: 'green' as const },
  { id: 'c3', a: 'Aspirin', b: 'Omega 3', ago: '1 week ago', risk: 'Moderate Risk', tone: 'amber' as const },
]

const riskTone: Record<string, string> = {
  red: 'bg-red-soft text-red-500',
  green: 'bg-green-soft text-green-500',
  amber: 'bg-amber-soft text-amber-500',
}

export function InteractionCheckerPage() {
  const { openDrawer, openModal } = useShell()
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Interaction Checker" subtitle="Check interactions between medicines" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Card>
          <div className="mb-3 flex items-center gap-2">
            <ShieldAlert size={18} className="text-brand-500" />
            <h2 className="text-[15px] font-bold text-text">Check for interactions</h2>
          </div>
          <div className="space-y-2">
            {selected.map((m) => (
              <div key={m.id} className="flex items-center gap-3 rounded-2xl bg-surface-2 p-2">
                <MedThumb kind={m.kind} tint={m.tint} colors={m.colors} className="h-9 w-9" />
                <div className="min-w-0 flex-1">
                  <p className="truncate text-[13.5px] font-bold text-text">{m.name}</p>
                  <p className="text-[11px] text-text-muted">{m.form}</p>
                </div>
                <button onClick={() => openModal(<InfoModal title="Remove Medicine" message={`Remove ${m.name} from the interaction check?`} />)} className="grid h-7 w-7 place-items-center rounded-full text-text-faint"><X size={15} /></button>
              </div>
            ))}
          </div>
          <button onClick={() => openModal(<InfoModal title="Add Medicine" message="Search and add another medicine to check for interactions." icon={<Plus size={22} />} />)} className="mt-2 flex w-full items-center justify-center gap-1.5 rounded-2xl border-2 border-dashed border-border py-2.5 text-[13px] font-semibold text-text-muted">
            <Plus size={15} /> Add Another Medicine
          </button>
          <button
            onClick={() => openModal(<InteractionResultModal />)}
            className="mt-3 flex w-full items-center justify-center gap-2 rounded-2xl bg-brand-gradient py-3 text-[14px] font-bold text-white shadow-md active:scale-[0.98]"
          >
            <Search size={16} /> Check Interactions
          </button>
        </Card>

        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-text">Recent Checks</h2>
          <button onClick={() => openModal(<InfoModal title="Recent Checks" message="You have 3 recent interaction checks in your history." />)} className="text-[12.5px] font-semibold text-brand-500">View All</button>
        </div>
        <div className="overflow-hidden rounded-[18px] bg-surface shadow-[var(--shadow-card)] ring-1 ring-border">
          {recent.map((r, i) => (
            <button
              key={r.id}
              onClick={() => openModal(<InteractionResultModal />)}
              className={`flex w-full items-center gap-3 px-3.5 py-3 text-left ${i === recent.length - 1 ? '' : 'border-b border-border'}`}
            >
              <div className="flex -space-x-1.5">
                <span className="h-7 w-7 rounded-full bg-green-500 ring-2 ring-surface" />
                <span className="h-7 w-7 rounded-full bg-blue-500 ring-2 ring-surface" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="truncate text-[13.5px] font-bold text-text">{r.a} + {r.b}</p>
                <p className="text-[11.5px] text-text-muted">Checked {r.ago}</p>
              </div>
              <span className={`shrink-0 rounded-full px-2 py-0.5 text-[10.5px] font-semibold ${riskTone[r.tone]}`}>{r.risk}</span>
              <ChevronRight size={16} className="text-text-faint" />
            </button>
          ))}
        </div>

        <Banner icon={<ShieldAlert size={18} />} title="Why check interactions?" subtitle="Some medicines can affect each other. Stay safe." />
      </div>
    </div>
  )
}

function InteractionResultModal() {
  const { openModal, closeModal } = useShell()
  return (
    <Modal hideClose>
      <div className="mb-3 flex items-start gap-3 rounded-2xl bg-red-soft p-3">
        <AlertTriangle size={22} className="shrink-0 text-red-500" />
        <div>
          <p className="text-[15px] font-bold text-red-500">High Risk Interaction</p>
          <p className="text-[12px] text-text-muted">Paracetamol + Ibuprofen</p>
        </div>
      </div>
      <p className="mb-1 text-[13px] font-bold text-text">What this means</p>
      <p className="mb-3 text-[12.5px] text-text-muted">
        Taking these together may increase the risk of stomach bleeding and kidney strain. Consult your doctor before combining.
      </p>
      <p className="mb-1 text-[13px] font-bold text-text">Possible Side Effects</p>
      <ul className="mb-3 space-y-1 text-[12.5px] text-text-muted">
        <li>• Stomach irritation or bleeding</li>
        <li>• Increased kidney load</li>
        <li>• Dizziness or nausea</li>
      </ul>
      <div className="mb-4 rounded-xl bg-amber-soft px-3.5 py-2.5 text-[12.5px] text-amber-500">
        Space out doses and take with food. Talk to your doctor for alternatives.
      </div>
      <div className="flex gap-3">
        <button onClick={closeModal} className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-brand-gradient py-3 text-[14px] font-bold text-white">
          <Save size={16} /> Save Report
        </button>
        <button onClick={() => openModal(<InteractionResultModal />)} className="flex flex-1 items-center justify-center gap-2 rounded-xl border border-border py-3 text-[14px] font-bold text-text">
          <Share2 size={16} /> Share
        </button>
      </div>
    </Modal>
  )
}
