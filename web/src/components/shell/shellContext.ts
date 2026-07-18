import { createContext, useContext, type ReactNode } from 'react'

export interface ShellContextValue {
  openDrawer: () => void
  closeDrawer: () => void
  openModal: (node: ReactNode) => void
  closeModal: () => void
}

export const ShellContext = createContext<ShellContextValue | undefined>(undefined)

/**
 * Access the app shell (drawer + modal) controls.
 *
 * Lives in its own module (separate from the AppShell component) so that
 * React Fast Refresh never recreates the context when a page or modal file
 * changes — which previously caused "useShell must be used within AppShell".
 */
export function useShell() {
  const ctx = useContext(ShellContext)
  if (!ctx) throw new Error('useShell must be used within AppShell')
  return ctx
}
