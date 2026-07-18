// Sample dataset for stress-testing the app (loaded on demand from Settings).
// Kept separate from the empty defaults so the app still starts blank.
import type { Med } from '../store/medStore'
import type { AppNotification } from '../store/notificationStore'
import type { HistoryGroup, HistoryRow } from './historyData'
import type { DayState } from './medicationsData'

const EVERYDAY: DayState[] = ['on', 'on', 'on', 'on', 'on', 'on', 'on']
const WEEKDAYS: DayState[] = ['on', 'on', 'on', 'on', 'on', 'off', 'off']

/** ~12 medicines & supplements spread across the day. */
export const sampleMeds: Med[] = [
  { id: 'sm1', name: 'Paracetamol 650mg', dose: '1 Tablet', food: 'After Food', foodIcon: 'food', time: '06:30 AM', color: 'green', kind: 'tablet', tint: '#e7f6ee', pillColors: ['#22c55e', '#ffffff'], days: EVERYDAY, category: 'medication', stock: 18, total: 30, status: 'taken' },
  { id: 'sm2', name: 'Vitamin D3 60K', dose: '1 Capsule', food: 'After Food', foodIcon: 'food', time: '08:00 AM', color: 'green', kind: 'softgel', tint: '#fdf3d8', pillColors: ['#fbbf24', '#f59e0b'], days: WEEKDAYS, category: 'supplement', stock: 5, total: 12, status: 'taken' },
  { id: 'sm3', name: 'Metformin 500mg', dose: '1 Tablet', food: 'After Breakfast', foodIcon: 'food', time: '08:30 AM', color: 'purple', kind: 'tablet', tint: '#ede9fe', pillColors: ['#8b5cf6', '#c4b5fd'], days: EVERYDAY, category: 'medication', stock: 42, total: 60, status: 'taken' },
  { id: 'sm4', name: 'Omega 3 Fish Oil', dose: '2 Capsules', food: 'After Food', foodIcon: 'food', time: '09:00 AM', color: 'green', kind: 'capsule', tint: '#e6f0fd', pillColors: ['#3b82f6', '#ffffff'], days: EVERYDAY, category: 'supplement', stock: 24, total: 30, status: 'pending' },
  { id: 'sm5', name: 'Amoxicillin 500mg', dose: '1 Capsule', food: 'Before Food', foodIcon: 'food', time: '12:30 PM', color: 'purple', kind: 'capsule', tint: '#fde7f0', pillColors: ['#ec4899', '#f472b6'], days: EVERYDAY, category: 'medication', stock: 8, total: 21, status: 'upcoming' },
  { id: 'sm6', name: 'Multivitamin', dose: '1 Tablet', food: 'After Lunch', foodIcon: 'food', time: '01:00 PM', color: 'green', kind: 'tablet', tint: '#e7f6ee', pillColors: ['#10b981', '#6ee7b7'], days: EVERYDAY, category: 'supplement', stock: 60, total: 90, status: 'upcoming' },
  { id: 'sm7', name: 'Atorvastatin 20mg', dose: '1 Tablet', food: 'After Food', foodIcon: 'food', time: '02:00 PM', color: 'purple', kind: 'tablet', tint: '#eef0f3', pillColors: ['#6366f1', '#a5b4fc'], days: EVERYDAY, category: 'medication', stock: 3, total: 30, status: 'pending' },
  { id: 'sm8', name: 'Calcium + D3', dose: '1 Tablet', food: 'After Lunch', foodIcon: 'food', time: '02:30 PM', color: 'green', kind: 'tablet', tint: '#fdf3d8', pillColors: ['#f59e0b', '#fcd34d'], days: WEEKDAYS, category: 'supplement', stock: 15, total: 30, status: 'pending' },
  { id: 'sm9', name: 'Losartan 50mg', dose: '1 Tablet', food: 'After Food', foodIcon: 'food', time: '06:00 PM', color: 'purple', kind: 'tablet', tint: '#ede9fe', pillColors: ['#7c3aed', '#c4b5fd'], days: EVERYDAY, category: 'medication', stock: 27, total: 30, status: 'pending' },
  { id: 'sm10', name: 'B-Complex Forte', dose: '1 Tablet', food: 'After Dinner', foodIcon: 'food', time: '08:30 PM', color: 'green', kind: 'tablet', tint: '#fde7f0', pillColors: ['#ec4899', '#f9a8d4'], days: EVERYDAY, category: 'supplement', stock: 0, total: 30, status: 'pending' },
  { id: 'sm11', name: 'Pantoprazole 40mg', dose: '1 Tablet', food: 'Before Dinner', foodIcon: 'food', time: '09:00 PM', color: 'purple', kind: 'capsule', tint: '#e6f0fd', pillColors: ['#2563eb', '#93c5fd'], days: EVERYDAY, category: 'medication', stock: 11, total: 30, status: 'pending' },
  { id: 'sm12', name: 'Cetirizine 10mg', dose: '1 Tablet', food: 'Before Bed', foodIcon: 'moon', time: '10:00 PM', color: 'purple', kind: 'tablet', tint: '#eef0f3', pillColors: ['#e5e7eb', '#f3f4f6'], days: EVERYDAY, category: 'medication', stock: 6, total: 10, status: 'pending' },
]

const HISTORY_DOSES = [
  { time: '06:30 AM', name: 'Paracetamol 650mg', detail: '1 Tablet · After Food' },
  { time: '08:00 AM', name: 'Vitamin D3 60K', detail: '1 Capsule · After Food' },
  { time: '08:30 AM', name: 'Metformin 500mg', detail: '1 Tablet · After Breakfast' },
  { time: '01:00 PM', name: 'Multivitamin', detail: '1 Tablet · After Lunch' },
  { time: '06:00 PM', name: 'Losartan 50mg', detail: '1 Tablet · After Food' },
  { time: '08:30 PM', name: 'B-Complex Forte', detail: '1 Tablet · After Dinner' },
  { time: '10:00 PM', name: 'Cetirizine 10mg', detail: '1 Tablet · Before Bed' },
]

function fmtDate(d: Date): string {
  return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

/** Build `days` days of dose history (default 30) — deterministic variety. */
export function buildSampleHistory(days = 30): HistoryGroup[] {
  const groups: HistoryGroup[] = []
  const today = new Date()
  for (let i = 0; i < days; i++) {
    const d = new Date(today)
    d.setDate(today.getDate() - i)
    const label = i === 0 ? 'Today' : i === 1 ? 'Yesterday' : d.toLocaleDateString('en-US', { weekday: 'short' })
    const rows: HistoryRow[] = HISTORY_DOSES.map((dose, j) => {
      const seed = (i * 7 + j * 13) % 11
      let status: HistoryRow['status'] = 'on-time'
      let badge = 'On Time'
      if (seed === 4) {
        status = 'late'
        badge = `${5 + ((i + j) % 4) * 5}m Late`
      } else if (seed === 9) {
        status = 'missed'
        badge = 'Missed'
      }
      return { id: `sh${i}-${j}`, time: dose.time, name: dose.name, detail: dose.detail, status, badge }
    })
    groups.push({ label, date: fmtDate(d), rows })
  }
  return groups
}

/** A busy notification feed — several unread for badge/count stress. */
export const sampleNotifications: AppNotification[] = [
  { id: 'sn1', icon: 'bell', title: 'Time for Omega 3 Fish Oil', subtitle: '2 Capsules · After Food', time: '9:00 AM', group: 'Today', unread: true, action: 'take' },
  { id: 'sn2', icon: 'check', title: 'Dose taken', subtitle: 'Metformin 500mg taken on time', time: '8:32 AM', group: 'Today', unread: true },
  { id: 'sn3', icon: 'pill', title: 'Low stock alert', subtitle: 'Atorvastatin 20mg has only 3 tablets left', time: '8:00 AM', group: 'Today', unread: true },
  { id: 'sn4', icon: 'clock', title: 'Missed dose', subtitle: 'You missed B-Complex Forte last night', time: '7:30 AM', group: 'Today', unread: true, action: 'reschedule' },
  { id: 'sn5', icon: 'star', title: '7 day streak', subtitle: "You've been consistent for a week", time: '7:00 AM', group: 'Today' },
  { id: 'sn6', icon: 'check', title: 'Dose taken', subtitle: 'Vitamin D3 60K taken on time', time: '8:02 AM', group: 'Today', unread: true },
  { id: 'sn7', icon: 'bell', title: 'Reminder: Amoxicillin 500mg', subtitle: 'Before lunch at 12:30 PM', time: '12:15 PM', group: 'Today' },
  { id: 'sn8', icon: 'megaphone', title: 'New feature: Insights', subtitle: 'Track your health trends over time', time: '10:00 AM', group: 'Today' },
  { id: 'sn9', icon: 'pill', title: 'Out of stock', subtitle: 'B-Complex Forte is out of stock — reorder now', time: 'Yesterday', group: 'Yesterday', unread: true },
  { id: 'sn10', icon: 'check', title: 'All doses taken', subtitle: 'You completed all 7 doses yesterday', time: 'Yesterday', group: 'Yesterday' },
  { id: 'sn11', icon: 'clock', title: 'Late dose', subtitle: 'Losartan 50mg taken 15m late', time: 'Yesterday', group: 'Yesterday' },
  { id: 'sn12', icon: 'star', title: 'Adherence milestone', subtitle: 'You hit 90% adherence this week', time: 'Yesterday', group: 'Yesterday' },
  { id: 'sn13', icon: 'bell', title: 'Refill reminder', subtitle: 'Calcium + D3 running low', time: 'Yesterday', group: 'Yesterday' },
  { id: 'sn14', icon: 'megaphone', title: 'Doctor visit soon', subtitle: 'Dr. Mehta on Friday at 4:00 PM', time: 'Yesterday', group: 'Yesterday' },
  { id: 'sn15', icon: 'gear', title: 'Settings updated', subtitle: 'Reminder preferences were saved', time: 'May 15', group: 'Earlier' },
  { id: 'sn16', icon: 'shield', title: 'Security tip', subtitle: 'Enable app lock to protect your data', time: 'May 14', group: 'Earlier' },
  { id: 'sn17', icon: 'check', title: 'Weekly report ready', subtitle: 'Your health report for last week is ready', time: 'May 13', group: 'Earlier' },
  { id: 'sn18', icon: 'pill', title: 'Prescription refilled', subtitle: 'Metformin 500mg refilled (60 tablets)', time: 'May 12', group: 'Earlier' },
  { id: 'sn19', icon: 'megaphone', title: 'Tip of the week', subtitle: 'Take medicines at the same time daily', time: 'May 11', group: 'Earlier' },
  { id: 'sn20', icon: 'star', title: '30 day streak', subtitle: 'A full month of consistency!', time: 'May 10', group: 'Earlier' },
]
