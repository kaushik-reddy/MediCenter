// Local demo data for the Calendar screen (May 2024). Mirrors the reference.

export type DotColor = 'green' | 'amber' | 'red'

export interface DayCell {
  day: number
  inMonth: boolean
  today?: boolean
  dots?: DotColor[]
}

// May 2024 starts on Wednesday. Grid is Sun..Sat.
export const monthLabel = 'May 2024'
export const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

const g: DotColor[] = ['green']
const rawDays: DayCell[] = [
  { day: 28, inMonth: false },
  { day: 29, inMonth: false },
  { day: 30, inMonth: false },
  { day: 1, inMonth: true, dots: g },
  { day: 2, inMonth: true, dots: g },
  { day: 3, inMonth: true, dots: ['amber', 'red'] },
  { day: 4, inMonth: true },
  { day: 5, inMonth: true, dots: g },
  { day: 6, inMonth: true, dots: g },
  { day: 7, inMonth: true, dots: ['red'] },
  { day: 8, inMonth: true, dots: g },
  { day: 9, inMonth: true, dots: ['amber'] },
  { day: 10, inMonth: true, dots: g },
  { day: 11, inMonth: true },
  { day: 12, inMonth: true, dots: g },
  { day: 13, inMonth: true, dots: g },
  { day: 14, inMonth: true, dots: g },
  { day: 15, inMonth: true, dots: g },
  { day: 16, inMonth: true, dots: ['amber'] },
  { day: 17, inMonth: true, dots: g },
  { day: 18, inMonth: true, dots: g },
  { day: 19, inMonth: true, dots: g },
  { day: 20, inMonth: true, today: true, dots: g },
  { day: 21, inMonth: true, dots: g },
  { day: 22, inMonth: true, dots: ['red'] },
  { day: 23, inMonth: true, dots: g },
  { day: 24, inMonth: true, dots: g },
  { day: 25, inMonth: true, dots: g },
  { day: 26, inMonth: true, dots: g },
  { day: 27, inMonth: true, dots: ['amber'] },
  { day: 28, inMonth: true, dots: g },
  { day: 29, inMonth: true, dots: g },
  { day: 30, inMonth: true, dots: g },
  { day: 31, inMonth: true, dots: g },
  { day: 1, inMonth: false },
]

// Empty by default — no adherence dots until the user logs doses.
export const days: DayCell[] = rawDays.map((d) => ({ day: d.day, inMonth: d.inMonth, today: d.today }))
// Suppress unused-var noise from the seed helper.
void g

export type TimeOfDay = 'morning' | 'noon' | 'night'
export interface DayMed {
  id: string
  name: string
  detail: string
  time: string
  when: TimeOfDay
  status: 'taken' | 'late' | 'missed'
}

export const selectedDayLabel = 'Monday, 20 May 2024'
export const selectedDayStats = { taken: 0, late: 0, missed: 0 }
export const selectedDayMeds: DayMed[] = []

export const quickStats = {
  month: 'May 2024',
  takenDays: 0,
  lateDays: 0,
  missedDays: 0,
  adherence: 0,
}
