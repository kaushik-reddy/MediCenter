// Local demo data for the History screen. Mirrors the reference.

export type HistoryStatus = 'on-time' | 'late' | 'missed'

export interface HistoryRow {
  id: string
  time: string
  name: string
  detail: string
  status: HistoryStatus
  badge: string // "On Time" | "15m Late" | "Missed"
}

export interface HistoryGroup {
  label: string
  date: string
  rows: HistoryRow[]
}

export const historySummary = {
  period: 'This Week',
  percent: 0,
  taken: 0,
  late: 0,
  missed: 0,
  dosesText: '0 of 0 doses taken',
}

export const historyGroups: HistoryGroup[] = []
