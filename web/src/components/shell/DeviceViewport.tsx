import { useEffect, useState, type CSSProperties, type ReactNode } from 'react'

/**
 * App shell layout.
 *
 * Mobile / PWA (the important case):
 *   - The shell is sized/positioned from `window.visualViewport`, which reports
 *     the true visible area (excluding the browser's top/bottom toolbars and the
 *     on-screen keyboard). This keeps the bottom nav glued to the real visible
 *     bottom edge in the browser AND when installed as a PWA, at any height.
 *   - Compact density applies only to the scrollable page layer (never the nav).
 *
 * Desktop: the same column inside a centered, phone-sized device frame (no scaling).
 */
const DESKTOP_BREAKPOINT = 1024

/** Compact density for phones, without scaling the fixed navigation. */
const MOBILE_SCALE = 0.78
const MOBILE_NAV_RESERVE = 'calc(76px + env(safe-area-inset-bottom))'

interface ViewportRect {
  width: number
  height: number
  offsetTop: number
  offsetLeft: number
}

function readViewport(): ViewportRect {
  const vv = typeof window !== 'undefined' ? window.visualViewport : null
  return {
    width: Math.round(vv?.width ?? window.innerWidth),
    height: Math.round(vv?.height ?? window.innerHeight),
    offsetTop: Math.round(vv?.offsetTop ?? 0),
    offsetLeft: Math.round(vv?.offsetLeft ?? 0),
  }
}

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
  const [vp, setVp] = useState<ViewportRect>(() =>
    typeof window !== 'undefined'
      ? readViewport()
      : { width: 390, height: 844, offsetTop: 0, offsetLeft: 0 },
  )

  useEffect(() => {
    const update = () => {
      setIsDesktop(window.innerWidth >= DESKTOP_BREAKPOINT)
      setVp(readViewport())
    }
    update()
    window.addEventListener('resize', update)
    window.addEventListener('orientationchange', update)
    const vv = window.visualViewport
    vv?.addEventListener('resize', update)
    vv?.addEventListener('scroll', update)
    return () => {
      window.removeEventListener('resize', update)
      window.removeEventListener('orientationchange', update)
      vv?.removeEventListener('resize', update)
      vv?.removeEventListener('scroll', update)
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

  // Mobile: the shell exactly matches the visible viewport, so the nav at its
  // bottom edge is always glued to the real visible bottom of the screen.
  const shellStyle: CSSProperties = {
    position: 'fixed',
    left: vp.offsetLeft,
    top: vp.offsetTop,
    width: vp.width,
    height: vp.height,
  }

  return (
    <div className="overflow-hidden bg-bg" style={shellStyle}>
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

