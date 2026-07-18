// Local demo data for the Medications screen. Mirrors the reference design.

export type PillKind = 'capsule' | 'softgel' | 'tablet'
export type ScheduleColor = 'green' | 'purple'
/** on = filled, ring = outlined, off = faint (not scheduled) */
export type DayState = 'on' | 'ring' | 'off'

export interface Medication {
  id: string
  name: string
  dose: string // "1 Tablet"
  food: string // "After Food"
  foodIcon: 'food' | 'moon'
  time: string // "10:30 AM"
  color: ScheduleColor
  kind: PillKind
  /** thumbnail tint + pill colors */
  tint: string
  pillColors: [string, string]
  days: DayState[] // length 7, Mon..Sun
}

const WEEK_MTF: DayState[] = ['on', 'on', 'on', 'on', 'on', 'ring', 'off']

export const medications: Medication[] = [
  {
    id: 'm1',
    name: 'Paracetamol 650mg',
    dose: '1 Tablet',
    food: 'After Food',
    foodIcon: 'food',
    time: '10:30 AM',
    color: 'green',
    kind: 'capsule',
    tint: '#e7f6ee',
    pillColors: ['#22c55e', '#ffffff'],
    days: WEEK_MTF,
  },
  {
    id: 'm2',
    name: 'Vitamin D3 60K',
    dose: '1 Capsule',
    food: 'After Food',
    foodIcon: 'food',
    time: '08:30 AM',
    color: 'green',
    kind: 'softgel',
    tint: '#fdf3d8',
    pillColors: ['#fbbf24', '#f59e0b'],
    days: WEEK_MTF,
  },
  {
    id: 'm3',
    name: 'B-Complex',
    dose: '1 Tablet',
    food: 'After Dinner',
    foodIcon: 'food',
    time: '08:30 PM',
    color: 'purple',
    kind: 'tablet',
    tint: '#fde7f0',
    pillColors: ['#ec4899', '#f472b6'],
    days: WEEK_MTF,
  },
  {
    id: 'm4',
    name: 'Omega 3',
    dose: '1 Capsule',
    food: 'After Food',
    foodIcon: 'food',
    time: '09:00 AM',
    color: 'green',
    kind: 'capsule',
    tint: '#e6f0fd',
    pillColors: ['#3b82f6', '#ffffff'],
    days: WEEK_MTF,
  },
  {
    id: 'm5',
    name: 'Cetirizine 10mg',
    dose: '1 Tablet',
    food: 'Before Bed',
    foodIcon: 'moon',
    time: '09:30 PM',
    color: 'purple',
    kind: 'tablet',
    tint: '#eef0f3',
    pillColors: ['#e5e7eb', '#f3f4f6'],
    days: WEEK_MTF,
  },
]

export interface RefillItem {
  id: string
  name: string
  status: 'low' | 'refill'
  statusLabel: string // "Low Stock (3 left)" / "Refill in 5 days"
  detail: string
  tint: string
  kind: PillKind
  pillColors: [string, string]
}

export const refillItems: RefillItem[] = [
  {
    id: 'r1',
    name: 'B-Complex',
    status: 'low',
    statusLabel: 'Low Stock (3 left)',
    detail: '1 Tablet · After Dinner',
    tint: '#fdecef',
    kind: 'tablet',
    pillColors: ['#ec4899', '#f472b6'],
  },
  {
    id: 'r2',
    name: 'Vitamin D3 60K',
    status: 'refill',
    statusLabel: 'Refill in 5 days',
    detail: '1 Capsule · After Food',
    tint: '#fdf3d8',
    kind: 'softgel',
    pillColors: ['#fbbf24', '#f59e0b'],
  },
]
