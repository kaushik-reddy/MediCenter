import { useLocation, useNavigate } from 'react-router-dom'
import { Plus } from 'lucide-react'
import { BOTTOM_TABS } from '../../config/navigation'
import { useShell } from './shellContext'
import { AddMedicationWizard } from '../../features/flows/AddMedicationWizard'

export function BottomNav() {
  const navigate = useNavigate()
  const location = useLocation()
  const { openModal } = useShell()

  const isActive = (path: string) =>
    path === '/' ? location.pathname === '/' : location.pathname.startsWith(path)

  const left = BOTTOM_TABS.slice(0, 2)
  const right = BOTTOM_TABS.slice(2)

  return (
    <nav className="w-full shrink-0">
      <div
        className="relative w-full px-4"
        style={{ paddingBottom: '0px' }}
      >
        <div className="relative mx-2 flex items-center justify-between rounded-[28px] bg-surface px-4 py-2.5 shadow-[var(--shadow-float)] ring-1 ring-border">
          <div className="flex flex-1 justify-around">
            {left.map((tab) => (
              <TabButton key={tab.key} tab={tab} active={isActive(tab.path)} onClick={() => navigate(tab.path)} />
            ))}
          </div>

          {/* Spacer for the center FAB */}
          <div className="w-16 shrink-0" />

          <div className="flex flex-1 justify-around">
            {right.map((tab) => (
              <TabButton key={tab.key} tab={tab} active={isActive(tab.path)} onClick={() => navigate(tab.path)} />
            ))}
          </div>

          {/* Center + FAB */}
          <button
            type="button"
            aria-label="Add medication"
            onClick={() => openModal(<AddMedicationWizard />)}
            className="absolute left-1/2 top-0 grid h-14 w-14 -translate-x-1/2 -translate-y-1/2 place-items-center rounded-full bg-brand-gradient text-white shadow-[0_10px_24px_-6px_rgba(109,79,224,0.7)] ring-4 ring-bg active:scale-95"
          >
            <Plus size={26} strokeWidth={2.5} />
          </button>
        </div>
      </div>
    </nav>
  )
}

function TabButton({
  tab,
  active,
  onClick,
}: {
  tab: (typeof BOTTOM_TABS)[number]
  active: boolean
  onClick: () => void
}) {
  const Icon = tab.icon
  return (
    <button
      type="button"
      onClick={onClick}
      className="flex flex-col items-center gap-0.5 px-1 py-1"
      aria-current={active ? 'page' : undefined}
    >
      <Icon
        size={22}
        strokeWidth={active ? 2.4 : 2}
        className={active ? 'text-brand-500' : 'text-text-faint'}
      />
      <span
        className={`text-[10px] font-semibold ${active ? 'text-brand-500' : 'text-text-faint'}`}
      >
        {tab.label}
      </span>
    </button>
  )
}
