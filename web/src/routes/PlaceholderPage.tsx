import { useShell } from '../components/shell/shellContext'
import { TopBar } from '../components/shell/TopBar'
import { Construction } from 'lucide-react'

interface PlaceholderPageProps {
  title: string
  subtitle?: string
}

/**
 * Temporary page used while we build each screen one-by-one.
 * Keeps the app shell (top bar, drawer, bottom nav) fully navigable.
 */
export function PlaceholderPage({ title, subtitle }: PlaceholderPageProps) {
  const { openDrawer } = useShell()
  return (
    <>
      <TopBar title={title} subtitle={subtitle} onMenu={openDrawer} notificationCount={0} />
      <div className="grid place-items-center px-6 py-24 text-center">
        <div className="mb-5 grid h-20 w-20 place-items-center rounded-3xl bg-brand-soft text-brand-500">
          <Construction size={34} />
        </div>
        <h2 className="text-lg font-bold text-text">{title}</h2>
        <p className="mt-1 max-w-[240px] text-sm text-text-muted">
          This screen is queued. We'll build it pixel-for-pixel from your reference designs.
        </p>
      </div>
    </>
  )
}
