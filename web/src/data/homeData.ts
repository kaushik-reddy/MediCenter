// Local demo data for the Home screen. Mirrors the reference design exactly.
// This will later be backed by a real store / API.

export type DoseStatus = 'taken' | 'upcoming' | 'pending' | 'late' | 'missed' | 'skipped' | 'snoozed'

export interface ScheduleItem {
  id: string
  time: string // display time e.g. "08:30 AM"
  name: string
  detail: string // e.g. "1 Capsule · After Food"
  status: DoseStatus
}

export interface NextDose {
  id?: string // med id (when derived from the shared store)
  inLabel: string // "01:45"
  atTime: string // "10:30 AM"
  name: string // "Paracetamol 650mg"
  detail: string // "1 Tablet · After Food"
}

export const nextDose: NextDose = {
  inLabel: '00:00',
  atTime: '',
  name: '',
  detail: '',
}

export const todaySchedule: ScheduleItem[] = []

export interface WeekProgress {
  percent: number
  streakDays: number
  /** 1 = full, 0.5 = half, 0 = empty, index 0=Mon .. 6=Sun */
  week: number[]
  weekLabels: string[]
}

export const weekProgress: WeekProgress = {
  percent: 0,
  streakDays: 0,
  week: [0, 0, 0, 0, 0, 0, 0],
  weekLabels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
}
