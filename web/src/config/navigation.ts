import type { LucideIcon } from 'lucide-react'
import {
  Home,
  Pill,
  CalendarDays,
  History,
  Plus,
  User,
  BellRing,
  Bell,
  Package,
  BarChart3,
  Activity,
  FileText,
  Stethoscope,
  ShieldAlert,
  Users,
  Phone,
  Plane,
  Settings,
} from 'lucide-react'

export interface NavItem {
  key: string
  label: string
  icon: LucideIcon
  path: string
}

/** Fixed bottom navigation. The center [+] is rendered separately as a FAB. */
export const BOTTOM_TABS: NavItem[] = [
  { key: 'home', label: 'Home', icon: Home, path: '/' },
  { key: 'medications', label: 'Medications', icon: Pill, path: '/medications' },
  // center + button occupies slot here
  { key: 'calendar', label: 'Calendar', icon: CalendarDays, path: '/calendar' },
  { key: 'history', label: 'History', icon: History, path: '/history' },
]

export const ADD_ACTION = {
  key: 'add',
  label: 'Add',
  icon: Plus,
  path: '/add',
}

/** Everything else lives under the top-left hamburger drawer. */
export interface DrawerGroup {
  title?: string
  items: NavItem[]
}

export const DRAWER_GROUPS: DrawerGroup[] = [
  {
    title: 'Overview',
    items: [
      { key: 'profile', label: 'Profile', icon: User, path: '/profile' },
      { key: 'reminders', label: 'Reminders', icon: BellRing, path: '/reminders' },
      { key: 'notifications', label: 'Notifications', icon: Bell, path: '/notifications' },
      { key: 'inventory', label: 'Inventory & Refill', icon: Package, path: '/inventory' },
    ],
  },
  {
    title: 'Health',
    items: [
      { key: 'analytics', label: 'Analytics', icon: BarChart3, path: '/analytics' },
      { key: 'insights', label: 'Health Insights', icon: Activity, path: '/insights' },
      { key: 'reports', label: 'Health Reports', icon: FileText, path: '/reports' },
      { key: 'visits', label: 'Doctor Visits', icon: Stethoscope, path: '/visits' },
      { key: 'interactions', label: 'Interaction Checker', icon: ShieldAlert, path: '/interactions' },
    ],
  },
  {
    title: 'Care & Safety',
    items: [
      { key: 'caregiver', label: 'Caregiver Mode', icon: Users, path: '/caregiver' },
      { key: 'contacts', label: 'Emergency Contacts', icon: Phone, path: '/contacts' },
      { key: 'travel', label: 'Travel Mode', icon: Plane, path: '/travel' },
    ],
  },
  {
    title: 'System',
    items: [{ key: 'settings', label: 'Settings', icon: Settings, path: '/settings' }],
  },
]

/** Flat list of all drawer items (handy for routing). */
export const ALL_DRAWER_ITEMS: NavItem[] = DRAWER_GROUPS.flatMap((g) => g.items)
