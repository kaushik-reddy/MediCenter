import { useEffect, useState, type ReactNode } from 'react'

/**
 * App shell layout.
 *
 * Mobile / PWA (the important case):
 *   - The shell is a `fixed inset-0` element, so top:0 AND bottom:0 pin it to the
 *     real viewport edges (no measured height that iOS can under-report). The
 *     bottom nav sits at the shell's bottom edge = the true bottom of the screen.
 *   - Compact density applies only to the scrollable page layer (never the nav).
 *
 * Desktop: the same column inside a centered, phone-sized device frame (no scaling).
 */
const DESKTOP_BREAKPOINT = 1024

/** Compact density for phones, without scaling the fixed navigation. */
const MOBILE_SCALE = 0.78
const MOBILE_NAV_RESERVE = 'calc(90px + env(safe-area-inset-bottom))'

export function DeviceViewport({
  children,
  bottomBar,
  overlay,
}: {
  children: ReactNode
  bottomBar?: ReactNode
  overlay?: ReactNode
}) {
  const [isDesktop, setIsDesktop] = useState(
    typeof window !== 'undefined' ? window.innerWidth >= DESKTOP_BREAKPOINT : false,
  )

  useEffect(() => {
    const update = () => setIsDesktop(window.innerWidth >= DESKTOP_BREAKPOINT)
    update()
    window.addEventListener('resize', update)
    window.addEventListener('orientationchange', update)
    return () => {
      window.removeEventListener('resize', update)
      window.removeEventListener('orientationchange', update)
    }
  }, [])

  if (isDesktop) {
    return (
      <div className="flex min-h-dvh items-center justify-center bg-bg lg:bg-[radial-gradient(circle_at_top,rgba(124,92,252,0.12),transparent_60%)]">
        <div
          className="relative flex flex-col overflow-hidden rounded-[46px] bg-bg shadow-[var(--shadow-float)] ring-1 ring-border"
          style={{ width: 400, height: 'min(880px, calc(100dvh - 48px))' }}
        >
          <div data-app-scroll className="no-scrollbar min-h-0 flex-1 overflow-y-auto pb-5">{children}</div>
          {bottomBar}
          {overlay}
        </div>
      </div>
    )
  }

  // Mobile: `fixed inset-0` fills the true viewport top-to-bottom, so the nav
  // at the shell's bottom edge is always glued to the real bottom of the screen.
  return (
    <div className="fixed inset-0 overflow-hidden bg-bg">
      <div
        data-app-scroll
        className="no-scrollbar absolute inset-x-0 top-0 overflow-y-auto overflow-x-hidden"
        style={{ bottom: bottomBar ? MOBILE_NAV_RESERVE : 0 }}
      >
        <div
          className="bg-bg"
          style={{
            zoom: MOBILE_SCALE,
            width: '100%',
            minHeight: '100%',
            paddingBottom: bottomBar ? undefined : 'env(safe-area-inset-bottom)',
          }}
        >
          {children}
        </div>
      </div>

      {bottomBar && <div className="absolute inset-x-0 bottom-0 z-40 bg-bg">{bottomBar}</div>}

      {overlay}
    </div>
  )
}

