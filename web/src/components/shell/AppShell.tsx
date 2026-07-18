import { useEffect, useState, type ReactNode } from 'react'
import { Outlet, useLocation } from 'react-router-dom'
import { BottomNav } from './BottomNav'
import { Drawer } from './Drawer'
import { DeviceViewport } from './DeviceViewport'
import { ShellContext } from './shellContext'

export function AppShell() {
  const [drawerOpen, setDrawerOpen] = useState(false)
  const [modal, setModal] = useState<ReactNode | null>(null)
  const location = useLocation()

  // Land each page at the top so it eases in cleanly.
  useEffect(() => {
    document.querySelector('[data-app-scroll]')?.scrollTo({ top: 0 })
  }, [location.pathname])

  return (
    <ShellContext.Provider
      value={{
        openDrawer: () => setDrawerOpen(true),
        closeDrawer: () => setDrawerOpen(false),
        openModal: (node) => setModal(node),
        closeModal: () => setModal(null),
      }}
    >
      <DeviceViewport
        bottomBar={<BottomNav />}
        overlay={
          <>
            <Drawer open={drawerOpen} onClose={() => setDrawerOpen(false)} />
            {modal}
          </>
        }
      >
        {/* Keyed by route so each page eases in smoothly when landed. */}
        <div key={location.pathname} className="page-enter">
          <Outlet />
        </div>
      </DeviceViewport>
    </ShellContext.Provider>
  )
}
