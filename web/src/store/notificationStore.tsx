import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react'

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
}

const NotificationStore = createContext<NotificationStoreValue | undefined>(undefined)

/** Empty by default — real notifications populate as the user uses the app. */
const SEED: AppNotification[] = []

export function NotificationProvider({ children }: { children: ReactNode }) {
  const [notifications, setNotifications] = useState<AppNotification[]>(SEED)

  const markRead = useCallback(
    (id: string) => setNotifications((prev) => prev.map((n) => (n.id === id ? { ...n, unread: false } : n))),
    [],
  )
  const markAllRead = useCallback(
    () => setNotifications((prev) => prev.map((n) => ({ ...n, unread: false }))),
    [],
  )

  const value = useMemo<NotificationStoreValue>(
    () => ({
      notifications,
      unreadCount: notifications.filter((n) => n.unread).length,
      markRead,
      markAllRead,
    }),
    [notifications, markRead, markAllRead],
  )

  return <NotificationStore.Provider value={value}>{children}</NotificationStore.Provider>
}

export function useNotifications() {
  const ctx = useContext(NotificationStore)
  if (!ctx) throw new Error('useNotifications must be used within NotificationProvider')
  return ctx
}
