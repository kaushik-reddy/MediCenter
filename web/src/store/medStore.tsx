import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import type { PillKind, ScheduleColor, DayState } from '../data/medicationsData'
import type { DoseStatus, ScheduleItem, NextDose } from '../data/homeData'
import type { HistoryRow, HistoryGroup } from '../data/historyData'
import { sampleMeds, buildSampleHistory } from '../data/sampleData'

/**
 * Unified medication model — the single source of truth shared by every page
 * (Home, Medications, Inventory, Reminders, Calendar, History). A superset of
 * the old per-page shapes so existing cards can consume it directly.
 */
export interface Med {
  id: string
  name: string
  dose: string // "1 Tablet"
  food: string // "After Food"
  foodIcon: 'food' | 'moon'
  time: string // "10:30 AM"
  color: ScheduleColor
  kind: PillKind
  tint: string
  pillColors: [string, string]
  days: DayState[]
  category: 'medication' | 'supplement'
  stock: number
  total: number
  status: DoseStatus // today's dose status
}

const WEEK_MTF: DayState[] = ['on', 'on', 'on', 'on', 'on', 'ring', 'off']

/** Empty by default — the user adds their own medications. */
const SEED: Med[] = []

/** A fixed "current time" so the demo derives a stable next-dose countdown. */
const NOW_MIN = 8 * 60 + 45 // 08:45

export function timeToMinutes(t: string): number {
  const m = t.match(/(\d+):(\d+)\s*(AM|PM)/i)
  if (!m) return 0
  let h = parseInt(m[1], 10) % 12
  if (/PM/i.test(m[3])) h += 12
  return h * 60 + parseInt(m[2], 10)
}

export function minutesToTime(total: number): string {
  const wrapped = ((total % 1440) + 1440) % 1440
  const h24 = Math.floor(wrapped / 60)
  const mm = wrapped % 60
  const ap = h24 >= 12 ? 'PM' : 'AM'
  const h12 = h24 % 12 === 0 ? 12 : h24 % 12
  return `${String(h12).padStart(2, '0')}:${String(mm).padStart(2, '0')} ${ap}`
}

export function medDetail(med: Med): string {
  return `${med.dose} · ${med.food}`
}

export interface RefillView extends Med {
  refillStatus: 'low' | 'refill' | 'out'
  statusLabel: string
}

function refillOf(med: Med): RefillView | null {
  const ratio = med.total ? med.stock / med.total : 0
  if (med.stock === 0) return { ...med, refillStatus: 'out', statusLabel: 'Out of stock' }
  if (med.stock <= 5) return { ...med, refillStatus: 'low', statusLabel: `Low Stock (${med.stock} left)` }
  if (ratio <= 0.45) return { ...med, refillStatus: 'refill', statusLabel: 'Refill soon' }
  return null
}

interface MedStoreValue {
  meds: Med[]
  history: HistoryGroup[]
  todaySchedule: ScheduleItem[]
  nextDose: NextDose | null
  refill: RefillView[]
  todayLog: HistoryRow[]
  takenCount: number
  pendingCount: number
  markTaken: (id: string) => void
  skipDose: (id: string) => void
  snoozeDose: (id: string, minutes: number) => void
  rescheduleDose: (id: string, time: string) => void
  addMedication: (input: { name: string; form?: string; dosage?: string; supplement?: boolean }) => void
  deleteMedication: (id: string) => void
  reorder: (id: string) => void
  loadSampleData: () => void
  clearAll: () => void
}

const MedStore = createContext<MedStoreValue | undefined>(undefined)

const KIND_FROM_FORM: Record<string, PillKind> = {
  Tablet: 'tablet',
  Capsule: 'capsule',
  Syrup: 'softgel',
  Injection: 'softgel',
  Other: 'tablet',
}

const MEDS_KEY = 'medicenter.meds'
const HISTORY_KEY = 'medicenter.history'

function loadMeds(): Med[] {
  try {
    const raw = localStorage.getItem(MEDS_KEY)
    return raw ? (JSON.parse(raw) as Med[]) : SEED
  } catch {
    return SEED
  }
}

function loadHistory(): HistoryGroup[] {
  try {
    const raw = localStorage.getItem(HISTORY_KEY)
    return raw ? (JSON.parse(raw) as HistoryGroup[]) : []
  } catch {
    return []
  }
}

export function MedProvider({ children }: { children: ReactNode }) {
  const [meds, setMeds] = useState<Med[]>(loadMeds)
  const [history, setHistory] = useState<HistoryGroup[]>(loadHistory)

  useEffect(() => {
    try {
      localStorage.setItem(MEDS_KEY, JSON.stringify(meds))
    } catch {
      /* ignore quota errors */
    }
  }, [meds])

  useEffect(() => {
    try {
      localStorage.setItem(HISTORY_KEY, JSON.stringify(history))
    } catch {
      /* ignore quota errors */
    }
  }, [history])

  const loadSampleData = useCallback(() => {
    setMeds(sampleMeds.map((m) => ({ ...m })))
    setHistory(buildSampleHistory(30))
  }, [])

  const clearAll = useCallback(() => {
    setMeds([])
    setHistory([])
  }, [])

  const markTaken = useCallback((id: string) => {
    setMeds((prev) =>
      prev.map((m) => (m.id === id ? { ...m, status: 'taken', stock: Math.max(0, m.stock - 1) } : m)),
    )
  }, [])

  const skipDose = useCallback((id: string) => {
    setMeds((prev) => prev.map((m) => (m.id === id ? { ...m, status: 'skipped' } : m)))
  }, [])

  const snoozeDose = useCallback((id: string, minutes: number) => {
    setMeds((prev) =>
      prev.map((m) =>
        m.id === id ? { ...m, status: 'snoozed', time: minutesToTime(timeToMinutes(m.time) + minutes) } : m,
      ),
    )
  }, [])

  const rescheduleDose = useCallback((id: string, time: string) => {
    setMeds((prev) => prev.map((m) => (m.id === id ? { ...m, status: 'pending', time } : m)))
  }, [])

  const addMedication = useCallback((input: { name: string; form?: string; dosage?: string; supplement?: boolean }) => {
    if (!input.name.trim()) return
    const kind = KIND_FROM_FORM[input.form ?? 'Tablet'] ?? 'tablet'
    const supplement = input.supplement ?? /vitamin|omega|calcium|b-complex|d3|supplement/i.test(input.name)
    const med: Med = {
      id: `m${Date.now()}`,
      name: input.name.trim(),
      dose: input.dosage?.trim() || '1 Tablet',
      food: 'After Food',
      foodIcon: 'food',
      time: '09:00 AM',
      color: supplement ? 'green' : 'purple',
      kind,
      tint: '#eef0f3',
      pillColors: ['#7c5cfc', '#a78bfa'],
      days: WEEK_MTF,
      category: supplement ? 'supplement' : 'medication',
      stock: 10,
      total: 10,
      status: 'pending',
    }
    setMeds((prev) => [med, ...prev])
  }, [])

  const deleteMedication = useCallback((id: string) => {
    setMeds((prev) => prev.filter((m) => m.id !== id))
  }, [])

  const reorder = useCallback((id: string) => {
    setMeds((prev) => prev.map((m) => (m.id === id ? { ...m, stock: m.total } : m)))
  }, [])

  const value = useMemo<MedStoreValue>(() => {
    const sorted = [...meds].sort((a, b) => timeToMinutes(a.time) - timeToMinutes(b.time))

    const todaySchedule: ScheduleItem[] = sorted.map((m) => ({
      id: m.id,
      time: m.time,
      name: m.name,
      detail: medDetail(m),
      status: m.status,
    }))

    const upcoming = sorted.filter(
      (m) => m.status !== 'taken' && m.status !== 'missed' && m.status !== 'skipped',
    )
    const nd = upcoming.find((m) => timeToMinutes(m.time) >= NOW_MIN) ?? upcoming[0] ?? null
    let nextDose: NextDose | null = null
    if (nd) {
      const diff = timeToMinutes(nd.time) - NOW_MIN
      const inLabel =
        diff > 0
          ? `${String(Math.floor(diff / 60)).padStart(2, '0')}:${String(diff % 60).padStart(2, '0')}`
          : '00:00'
      nextDose = { id: nd.id, inLabel, atTime: nd.time, name: nd.name, detail: medDetail(nd) }
    }

    const refill = meds.map(refillOf).filter((r): r is RefillView => r !== null)

    const todayLog: HistoryRow[] = [...meds]
      .filter((m) => m.status === 'taken')
      .sort((a, b) => timeToMinutes(a.time) - timeToMinutes(b.time))
      .map<HistoryRow>((m) => ({ id: `log-${m.id}`, time: m.time, name: m.name, detail: medDetail(m), status: 'on-time', badge: 'On Time' }))

    const takenCount = meds.filter((m) => m.status === 'taken').length
    const pendingCount = meds.filter((m) => m.status !== 'taken').length

    return { meds, history, todaySchedule, nextDose, refill, todayLog, takenCount, pendingCount, markTaken, skipDose, snoozeDose, rescheduleDose, addMedication, deleteMedication, reorder, loadSampleData, clearAll }
  }, [meds, history, markTaken, skipDose, snoozeDose, rescheduleDose, addMedication, deleteMedication, reorder, loadSampleData, clearAll])

  return <MedStore.Provider value={value}>{children}</MedStore.Provider>
}

export function useMeds() {
  const ctx = useContext(MedStore)
  if (!ctx) throw new Error('useMeds must be used within MedProvider')
  return ctx
}
