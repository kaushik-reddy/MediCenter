import { useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronRight, ShoppingCart, BellRing, Package } from 'lucide-react'
import { SectionHeader } from '../../components/ui/SectionHeader'
import { MedThumb } from './MedThumb'
import { useShell } from '../../components/shell/shellContext'
import { useMeds, medDetail, type RefillView } from '../../store/medStore'
import { ReorderModal, SetReminderModal } from '../flows/FlowModals'

function RefillCard({ item }: { item: RefillView }) {
  const { openModal } = useShell()
  const isLow = item.refillStatus !== 'refill'
  const accent = isLow ? 'text-red-500' : 'text-amber-500'
  const btnRing = isLow ? 'ring-red-500 text-red-500' : 'ring-amber-500 text-amber-500'
  return (
    <div
      className="w-[240px] shrink-0 snap-start rounded-2xl p-3"
      style={{ backgroundColor: item.tint }}
    >
      <div className="flex gap-2.5">
        <MedThumb
          kind={item.kind}
          tint="#ffffff"
          colors={item.pillColors}
          className="h-[52px] w-[52px]"
        />
        <div className="min-w-0 flex-1">
          <div className="flex items-center justify-between gap-1">
            <h4 className="truncate text-[14px] font-bold text-text">{item.name}</h4>
            <ChevronRight size={16} className="shrink-0 text-text-faint" />
          </div>
          <p className={`mt-0.5 flex items-center gap-1 text-[12px] font-semibold ${accent}`}>
            {!isLow && <span className="text-[8px]">●</span>}
            {item.statusLabel}
          </p>
          <p className="truncate text-[11px] text-text-muted">{medDetail(item)}</p>
        </div>
      </div>

      <button
        type="button"
        onClick={() =>
          openModal(isLow ? <ReorderModal name={item.name} medId={item.id} /> : <SetReminderModal name={item.name} />)
        }
        className={`mt-2.5 flex w-full items-center justify-center gap-1.5 rounded-xl bg-surface/70 py-2 text-[12.5px] font-bold ring-1 ${btnRing} active:scale-[0.98]`}
      >
        {isLow ? <ShoppingCart size={14} /> : <BellRing size={14} />}
        {isLow ? 'Reorder' : 'Set Reminder'}
      </button>
    </div>
  )
}

export function RefillCarousel() {
  const scrollRef = useRef<HTMLDivElement>(null)
  const [active, setActive] = useState(0)
  const navigate = useNavigate()
  const { refill } = useMeds()

  const onScroll = () => {
    const el = scrollRef.current
    if (!el) return
    setActive(Math.round(el.scrollLeft / (el.clientWidth * 0.66)))
  }

  if (refill.length === 0) return null

  return (
    <div className="rounded-[18px] bg-surface p-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
      <SectionHeader icon={Package} title="Refill & Low Stock" actionLabel="View all" onAction={() => navigate('/inventory')} />
      <div
        ref={scrollRef}
        onScroll={onScroll}
        className="no-scrollbar -mx-1 flex snap-x snap-mandatory gap-3 overflow-x-auto px-1"
      >
        {refill.map((item) => (
          <RefillCard key={item.id} item={item} />
        ))}
      </div>
      <div className="mt-3 flex justify-center gap-1.5">
        {refill.map((_, i) => (
          <span
            key={i}
            className={`h-1.5 rounded-full transition-all ${
              i === active ? 'w-4 bg-brand-500' : 'w-1.5 bg-border-strong'
            }`}
          />
        ))}
      </div>
    </div>
  )
}
