import { useMemo, useState } from 'react'
import {
  Bell,
  BellOff,
  Check,
  CheckCheck,
  Star,
  Pill,
  Clock,
  Megaphone,
  Settings as Gear,
  ShieldAlert,
  Settings2,
} from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Chips } from '../../components/ui/Chips'
import { Banner } from '../../components/ui/Banner'
import { MarkAsTakenModal, SetReminderModal, NotificationChannelsModal } from '../flows/FlowModals'
import { useNotifications, type AppNotification, type NotifIcon } from '../../store/notificationStore'

type Notif = AppNotification

const iconMap: Record<NotifIcon, { icon: typeof Bell; bg: string; fg: string }> = {
  bell: { icon: Bell, bg: 'bg-brand-soft', fg: 'text-brand-500' },
  check: { icon: Check, bg: 'bg-green-soft', fg: 'text-green-500' },
  star: { icon: Star, bg: 'bg-amber-soft', fg: 'text-amber-500' },
  pill: { icon: Pill, bg: 'bg-red-soft', fg: 'text-red-500' },
  clock: { icon: Clock, bg: 'bg-amber-soft', fg: 'text-amber-500' },
  megaphone: { icon: Megaphone, bg: 'bg-brand-soft', fg: 'text-brand-500' },
  gear: { icon: Gear, bg: 'bg-surface-2', fg: 'text-text-muted' },
  shield: { icon: ShieldAlert, bg: 'bg-amber-soft', fg: 'text-amber-500' },
}

export function NotificationsPage() {
  const { openDrawer, openModal } = useShell()
  const { notifications: items, unreadCount, markRead, markAllRead } = useNotifications()
  const [chip, setChip] = useState('All')

  const groups = useMemo(() => {
    const order: string[] = []
    const map = new Map<string, Notif[]>()
    for (const n of items) {
      if (!map.has(n.group)) {
        map.set(n.group, [])
        order.push(n.group)
      }
      map.get(n.group)!.push(n)
    }
    return order.map((label) => ({ label, items: map.get(label)! }))
  }, [items])

  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Notifications" subtitle="Stay updated with your health" onMenu={openDrawer} />

      <div className="space-y-3 px-4 pt-1">
        <Chips
          items={[
            { label: 'All', count: items.length },
            { label: 'Reminders', count: items.filter((n) => n.action === 'take' || n.action === 'reschedule').length },
            { label: 'Medication', count: items.filter((n) => n.icon === 'pill' || n.icon === 'check').length },
            { label: 'System', count: items.filter((n) => n.icon === 'gear' || n.icon === 'shield').length },
          ]}
          active={chip}
          onChange={setChip}
        />

        {unreadCount > 0 && (
          <button
            onClick={markAllRead}
            className="flex w-full items-center justify-center gap-1.5 rounded-xl border border-brand-500/40 py-2.5 text-[13px] font-bold text-brand-500 active:scale-[0.99]"
          >
            <CheckCheck size={16} />
            Mark all as read
          </button>
        )}

        {groups.length === 0 ? (
          <EmptyState />
        ) : (
          groups.map((g) => (
            <div key={g.label}>
              <h2 className="mb-2 px-1 text-[13px] font-bold text-text-muted">{g.label}</h2>
              <div className="overflow-hidden rounded-[18px] bg-surface shadow-[var(--shadow-card)] ring-1 ring-border">
                {g.items.map((n, i) => (
                  <Row
                    key={n.id}
                    n={n}
                    last={i === g.items.length - 1}
                    onOpen={() => markRead(n.id)}
                    onTake={() => {
                      markRead(n.id)
                      openModal(<MarkAsTakenModal name={n.title} />)
                    }}
                    onReschedule={() => {
                      markRead(n.id)
                      openModal(<SetReminderModal name={n.subtitle} />)
                    }}
                  />
                ))}
              </div>
            </div>
          ))
        )}

        <Banner
          icon={<Bell size={18} />}
          title="Never miss important updates"
          subtitle="Manage your notification preferences"
          action={
            <button onClick={() => openModal(<NotificationChannelsModal />)} className="flex shrink-0 items-center gap-1.5 rounded-xl border border-brand-500/40 px-2.5 py-2 text-[12px] font-semibold text-brand-500 active:scale-95">
              <Settings2 size={14} /> Manage
            </button>
          }
        />
      </div>
    </div>
  )
}

function EmptyState() {
  return (
    <div className="flex flex-col items-center justify-center rounded-[18px] bg-surface px-6 py-12 text-center ring-1 ring-border">
      <span className="mb-3 grid h-14 w-14 place-items-center rounded-full bg-surface-2 text-text-faint">
        <BellOff size={24} />
      </span>
      <p className="text-[14px] font-bold text-text">No notifications yet</p>
      <p className="mt-1 max-w-[220px] text-[12px] text-text-muted">
        Reminders and health updates will show up here as you use the app.
      </p>
    </div>
  )
}

function Row({
  n,
  last,
  onOpen,
  onTake,
  onReschedule,
}: {
  n: Notif
  last: boolean
  onOpen: () => void
  onTake: () => void
  onReschedule: () => void
}) {
  const m = iconMap[n.icon]
  const Icon = m.icon
  return (
    <div
      onClick={onOpen}
      className={`flex cursor-pointer items-start gap-3 px-3.5 py-3 ${last ? '' : 'border-b border-border'} ${n.unread ? 'bg-brand-soft/30' : ''}`}
    >
      <span className={`grid h-10 w-10 shrink-0 place-items-center rounded-full ${m.bg} ${m.fg}`}>
        <Icon size={18} />
      </span>
      <div className="min-w-0 flex-1">
        <div className="flex items-start justify-between gap-2">
          <p className="text-[14px] font-bold text-text">{n.title}</p>
          <span className="shrink-0 text-[11px] text-text-faint">{n.time}</span>
        </div>
        <p className="text-[12.5px] text-text-muted">{n.subtitle}</p>
        <div className="mt-2 flex items-center gap-2">
          {n.action === 'take' && (
            <button onClick={(e) => { e.stopPropagation(); onTake() }} className="rounded-lg border border-brand-500/40 px-3 py-1.5 text-[12px] font-semibold text-brand-500 active:scale-95">
              Mark as Taken
            </button>
          )}
          {n.action === 'reschedule' && (
            <button onClick={(e) => { e.stopPropagation(); onReschedule() }} className="rounded-lg border border-red-500/40 px-3 py-1.5 text-[12px] font-semibold text-red-500 active:scale-95">
              Reschedule
            </button>
          )}
          {n.unread && (
            <button onClick={(e) => { e.stopPropagation(); onOpen() }} className="text-[11.5px] font-semibold text-text-muted active:scale-95">
              Mark as read
            </button>
          )}
        </div>
      </div>
      {n.unread && <span className="mt-1.5 h-2 w-2 shrink-0 rounded-full bg-brand-500" />}
    </div>
  )
}
