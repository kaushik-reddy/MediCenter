import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import { sampleNotifications } from '../data/sampleData'

export type NotifIcon = 'bell' | 'check' | 'star' | 'pill' | 'clock' | 'megaphone' | 'gear' | 'shield'

export interface AppNotification {
  id: string
  icon: NotifIcon
  title: string
  subtitle: string
  time: string
  group: string
  unread?: boolean
  action?: 'take' | 'reschedule'
}

interface NotificationStoreValue {
  notifications: AppNotification[]
  unreadCount: number
  markRead: (id: string) => void
  markAllRead: () => void
  loadSample: () => void
  clear: () => void
}

const NotificationStore = createContext<NotificationStoreValue | undefined>(undefined)

const STORAGE_KEY = 'medicenter.notifications'

function load(): AppNotification[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? (JSON.parse(raw) as AppNotification[]) : []
  } catch {
    return []
  }
}

export function NotificationProvider({ children }: { children: ReactNode }) {
  const [notifications, setNotifications] = useState<AppNotification[]>(load)

  useEffect(() => {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(notifications))
    } catch {
      /* ignore quota errors */
    }
  }, [notifications])

  const markRead = useCallback(
    (id: string) => setNotifications((prev) => prev.map((n) => (n.id === id ? { ...n, unread: false } : n))),
    [],
  )
  const markAllRead = useCallback(
    () => setNotifications((prev) => prev.map((n) => ({ ...n, unread: false }))),
    [],
  )
  const loadSample = useCallback(() => setNotifications(sampleNotifications.map((n) => ({ ...n }))), [])
  const clear = useCallback(() => setNotifications([]), [])

  const value = useMemo<NotificationStoreValue>(
    () => ({
      notifications,
      unreadCount: notifications.filter((n) => n.unread).length,
      markRead,
      markAllRead,
      loadSample,
      clear,
    }),
    [notifications, markRead, markAllRead, loadSample, clear],
  )

  return <NotificationStore.Provider value={value}>{children}</NotificationStore.Provider>
}

export function useNotifications() {
  const ctx = useContext(NotificationStore)
  if (!ctx) throw new Error('useNotifications must be used within NotificationProvider')
  return ctx
}
