import { useState } from 'react'
import { Check, Clock, X, CalendarDays, Lightbulb, BadgeCheck } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Chips } from '../../components/ui/Chips'
import { Card } from '../../components/ui/Card'
import { Banner } from '../../components/ui/Banner'
import { GaugeRing, DonutChart, BarChart, AreaLine } from '../../components/ui/Charts'

export function AnalyticsPage() {
  const { openDrawer } = useShell()
  const [range, setRange] = useState('30 Days')

  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Analytics" subtitle="Understand your medication habits" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        <Chips
          items={[{ label: '7 Days' }, { label: '30 Days' }, { label: '3 Months' }, { label: '6 Months' }, { label: '1 Year' }]}
          active={range}
          onChange={setRange}
        />

        {/* Overall adherence */}
        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">Overall Adherence</h2>
          <div className="flex items-center gap-4">
            <GaugeRing percent={92} label="92%" sub="Adherence" size={110} />
            <div className="flex-1 space-y-2">
              <p className="flex items-center gap-1 text-[13px] font-semibold text-green-500"><BadgeCheck size={15} /> Great job</p>
              <div className="rounded-xl bg-green-soft px-3 py-2">
                <div className="text-[15px] font-extrabold text-green-500">↑ 12%</div>
                <div className="text-[10.5px] text-text-muted">vs last period</div>
              </div>
              <div className="rounded-xl bg-brand-soft px-3 py-2">
                <div className="text-[15px] font-extrabold text-brand-500">85%</div>
                <div className="text-[10.5px] text-text-muted">Your Goal</div>
              </div>
            </div>
          </div>
        </Card>

        {/* Stat tiles */}
        <div className="grid grid-cols-2 gap-2.5">
          <StatTile bg="bg-green-soft" fg="text-green-500" icon={<Check size={15} />} n="28" label="Doses Taken" sub="On Time 24" />
          <StatTile bg="bg-amber-soft" fg="text-amber-500" icon={<Clock size={15} />} n="5" label="Late" sub="Avg 22 mins" />
          <StatTile bg="bg-red-soft" fg="text-red-500" icon={<X size={15} />} n="2" label="Missed" />
          <StatTile bg="bg-brand-soft" fg="text-brand-500" icon={<CalendarDays size={15} />} n="18" label="Days Tracked" />
        </div>

        {/* Adherence over time */}
        <Card>
          <h2 className="mb-1 text-[15px] font-bold text-text">Adherence Over Time</h2>
          <p className="mb-2 text-[12px] text-text-muted">Daily · 92% average</p>
          <AreaLine data={[70, 82, 78, 90, 85, 95, 88, 92, 100, 90]} />
        </Card>

        {/* Doses by time of day */}
        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">Doses by Time of Day</h2>
          <div className="flex items-center gap-4">
            <DonutChart
              segments={[
                { value: 12, color: 'var(--brand-500)' },
                { value: 8, color: 'var(--amber-500)' },
                { value: 8, color: 'var(--green-500)' },
              ]}
              centerLabel="28"
              centerSub="Total"
              size={110}
            />
            <div className="flex-1 space-y-2">
              <Legend color="bg-brand-500" label="Morning" value="12" />
              <Legend color="bg-amber-500" label="Afternoon" value="8" />
              <Legend color="bg-green-500" label="Evening" value="8" />
            </div>
          </div>
        </Card>

        {/* Weekly adherence */}
        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">Weekly Adherence</h2>
          <BarChart
            data={[100, 90, 100, 80, 95, 70, 100]}
            labels={['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']}
            colors={['#22c55e', '#22c55e', '#22c55e', '#f59e0b', '#22c55e', '#ef4444', '#22c55e']}
          />
        </Card>

        <Banner
          icon={<Lightbulb size={18} />}
          title="You're most consistent on weekdays"
          subtitle="Try setting a weekend reminder"
          showChevron
        />
      </div>
    </div>
  )
}

function StatTile({ bg, fg, icon, n, label, sub }: { bg: string; fg: string; icon: React.ReactNode; n: string; label: string; sub?: string }) {
  return (
    <div className={`rounded-2xl p-3 ${bg}`}>
      <div className="flex items-center gap-2">
        <span className={fg}>{icon}</span>
        <span className={`text-[20px] font-extrabold ${fg}`}>{n}</span>
      </div>
      <div className="mt-0.5 text-[12px] font-medium text-text">{label}</div>
      {sub && <div className="text-[10.5px] text-text-muted">{sub}</div>}
    </div>
  )
}

function Legend({ color, label, value }: { color: string; label: string; value: string }) {
  return (
    <div className="flex items-center gap-2">
      <span className={`h-2.5 w-2.5 rounded-full ${color}`} />
      <span className="flex-1 text-[12.5px] text-text">{label}</span>
      <span className="text-[12.5px] font-bold text-text">{value}</span>
    </div>
  )
}
