import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Search, SlidersHorizontal, Pill, Leaf } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { MedicationCard } from './MedicationCard'
import { RefillCarousel } from './RefillCarousel'
import { TipOfDay } from '../home/TipOfDay'
import { useMeds } from '../../store/medStore'
import { FilterModal } from '../flows/FlowModals'
type Tab = 'medications' | 'supplements'

export function MedicationsPage() {
  const { openDrawer, openModal } = useShell()
  const { meds } = useMeds()
  const navigate = useNavigate()
  const [tab, setTab] = useState<Tab>('medications')
  const [query, setQuery] = useState('')

  const filtered = meds.filter(
    (m) =>
      m.name.toLowerCase().includes(query.toLowerCase()) &&
      (tab === 'supplements' ? m.category === 'supplement' : m.category === 'medication'),
  )

  return (
    <div className="flex min-h-full flex-col">
      <TopBar
        title="Medications"
        subtitle="Manage all your medicines in one place."
        onMenu={openDrawer}
        notificationCount={0}
      />

      <div className="space-y-3 px-4 pt-1">
        {/* Tabs */}
        <div className="flex rounded-2xl bg-surface p-1.5 shadow-[var(--shadow-card)] ring-1 ring-border">
          <TabButton
            active={tab === 'medications'}
            onClick={() => setTab('medications')}
            icon={<Pill size={16} />}
            label="My Medications"
          />
          <TabButton
            active={tab === 'supplements'}
            onClick={() => setTab('supplements')}
            icon={<Leaf size={16} />}
            label="Supplements"
          />
        </div>

        {/* Search + Filter */}
        <div className="flex gap-2.5">
          <div className="flex flex-1 items-center gap-2 rounded-2xl bg-surface px-3.5 shadow-[var(--shadow-card)] ring-1 ring-border">
            <Search size={17} className="text-text-faint" />
            <input
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search medication"
              className="w-full bg-transparent py-3 text-[14px] text-text outline-none placeholder:text-text-faint"
            />
          </div>
          <button
            type="button"
            onClick={() => openModal(<FilterModal />)}
            className="flex items-center gap-1.5 rounded-2xl bg-surface px-4 text-[13px] font-semibold text-brand-500 shadow-[var(--shadow-card)] ring-1 ring-brand-500/40 active:scale-95"
          >
            <SlidersHorizontal size={15} />
            Filter
          </button>
        </div>

        {/* Medication list */}
        <div className="space-y-3">
          {filtered.map((med) => (
            <MedicationCard key={med.id} med={med} onClick={() => navigate(`/medications/${med.id}`)} />
          ))}
          {filtered.length === 0 && (
            <p className="rounded-2xl bg-surface py-8 text-center text-[13px] text-text-muted ring-1 ring-border">
              No {tab === 'supplements' ? 'supplements' : 'medications'} found.
            </p>
          )}
        </div>

        {/* Refill & Low Stock */}
        <RefillCarousel />

        {/* Tip of the day */}
        <div className="pt-1">
          <TipOfDay text="Store medicines in a cool, dry place and away from direct sunlight." />
        </div>
      </div>
    </div>
  )
}

function TabButton({
  active,
  onClick,
  icon,
  label,
}: {
  active: boolean
  onClick: () => void
  icon: React.ReactNode
  label: string
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`flex flex-1 items-center justify-center gap-1.5 rounded-xl py-2.5 text-[13.5px] font-bold transition-colors ${
        active ? 'bg-brand-soft text-brand-500' : 'text-text-muted'
      }`}
    >
      {icon}
      {label}
    </button>
  )
}
