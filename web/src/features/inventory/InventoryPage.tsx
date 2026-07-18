import { useState } from 'react'
import { Search, SlidersHorizontal, Package, ShoppingCart } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Chips } from '../../components/ui/Chips'
import { Banner } from '../../components/ui/Banner'
import { MedThumb } from '../medications/MedThumb'
import type { PillKind } from '../../data/medicationsData'
import { useMeds, medDetail, type Med } from '../../store/medStore'
import { ReorderModal, FilterModal } from '../flows/FlowModals'

type Status = 'healthy' | 'low' | 'critical'
interface Item {
  id: string
  name: string
  detail: string
  chips: string[]
  kind: PillKind
  tint: string
  colors: [string, string]
  status: Status
  left: number
  total: number
  refill: string
}

function toItem(m: Med): Item {
  const ratio = m.total ? m.stock / m.total : 0
  const status: Status = m.stock === 0 ? 'critical' : m.stock <= 5 || ratio <= 0.45 ? 'low' : 'healthy'
  const refill = status === 'critical' ? 'Out of stock' : status === 'low' ? 'Refill soon' : 'Well stocked'
  return {
    id: m.id,
    name: m.name,
    detail: medDetail(m),
    chips: [m.category === 'supplement' ? 'Supplement' : 'Medication', m.food],
    kind: m.kind,
    tint: m.tint,
    colors: m.pillColors,
    status,
    left: m.stock,
    total: m.total,
    refill,
  }
}

const statusMap: Record<Status, { label: string; badge: string; bar: string; count: string }> = {
  healthy: { label: 'Healthy', badge: 'bg-green-soft text-green-500', bar: 'bg-green-500', count: 'text-green-500' },
  low: { label: 'Low Stock', badge: 'bg-amber-soft text-amber-500', bar: 'bg-amber-500', count: 'text-amber-500' },
  critical: { label: 'Critical', badge: 'bg-red-soft text-red-500', bar: 'bg-red-500', count: 'text-red-500' },
}

export function InventoryPage() {
  const { openDrawer, openModal } = useShell()
  const { meds } = useMeds()
  const [chip, setChip] = useState('All')
  const items = meds.map(toItem)

  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Inventory & Refill" subtitle="Keep your medicines stocked" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Banner icon={<Package size={18} />} title="Never run out" subtitle="Track stock and set refill reminders" />

        <Chips
          items={[
            { label: 'All', count: items.length },
            { label: 'Low Stock', count: items.filter((i) => i.status === 'low').length },
            { label: 'Refill Due', count: items.filter((i) => i.status !== 'healthy').length },
            { label: 'Out of Stock', count: items.filter((i) => i.status === 'critical').length },
          ]}
          active={chip}
          onChange={setChip}
        />

        <div className="flex gap-2.5">
          <div className="flex flex-1 items-center gap-2 rounded-2xl bg-surface px-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
            <Search size={16} className="text-text-faint" />
            <input placeholder="Search medicines" className="w-full bg-transparent py-3 text-[13.5px] text-text outline-none placeholder:text-text-faint" />
          </div>
          <button onClick={() => openModal(<FilterModal />)} className="flex items-center gap-1.5 rounded-2xl bg-surface px-4 text-[13px] font-semibold text-brand-500 shadow-[var(--shadow-card)] ring-1 ring-brand-500/40 active:scale-95">
            <SlidersHorizontal size={15} />
            Filter
          </button>
        </div>

        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-text">My Medicines</h2>
          <span className="text-[12px] text-text-muted">Sort: Stock</span>
        </div>

        <div className="space-y-3">
          {items.map((it) => (
            <InventoryCard key={it.id} it={it} onReorder={() => openModal(<ReorderModal name={it.name} medId={it.id} />)} />
          ))}
        </div>
      </div>
    </div>
  )
}

function InventoryCard({ it, onReorder }: { it: Item; onReorder: () => void }) {
  const s = statusMap[it.status]
  const pct = Math.round((it.left / it.total) * 100)
  return (
    <div className="rounded-[18px] bg-surface p-3 shadow-[var(--shadow-card)] ring-1 ring-border">
      <div className="flex gap-3">
        <MedThumb kind={it.kind} tint={it.tint} colors={it.colors} className="h-[60px] w-[60px]" />
        <div className="min-w-0 flex-1">
          <div className="flex items-start justify-between gap-2">
            <h3 className="truncate text-[15px] font-bold text-text">{it.name}</h3>
            <span className={`shrink-0 rounded-full px-2 py-0.5 text-[10.5px] font-semibold ${s.badge}`}>{s.label}</span>
          </div>
          <p className="text-[12px] text-text-muted">{it.detail}</p>
          <div className="mt-1 flex gap-1.5">
            {it.chips.map((c) => (
              <span key={c} className="rounded-md bg-surface-2 px-1.5 py-0.5 text-[10px] font-medium text-text-muted">{c}</span>
            ))}
          </div>
        </div>
      </div>

      <div className="mt-3">
        <div className="flex items-baseline justify-between">
          <span className={`text-[15px] font-extrabold ${s.count}`}>
            {it.left} <span className="text-[11px] font-medium text-text-muted">tablets left</span>
          </span>
          <span className="text-[11px] text-text-muted">out of {it.total}</span>
        </div>
        <div className="mt-1.5 h-2 w-full overflow-hidden rounded-full bg-surface-2">
          <div className={`h-full rounded-full ${s.bar}`} style={{ width: `${pct}%` }} />
        </div>
        <div className="mt-2 flex items-center justify-between">
          <span className={`text-[12px] font-semibold ${s.count}`}>{it.refill}</span>
          <button onClick={onReorder} className="flex items-center gap-1.5 rounded-xl bg-brand-gradient px-3 py-1.5 text-[12px] font-bold text-white active:scale-95">
            <ShoppingCart size={13} /> Reorder
          </button>
        </div>
      </div>
    </div>
  )
}
