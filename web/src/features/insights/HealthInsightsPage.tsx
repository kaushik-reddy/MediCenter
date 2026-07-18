import { Activity, Heart, Droplet, Scale } from 'lucide-react'
import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { Card } from '../../components/ui/Card'
import { Banner } from '../../components/ui/Banner'
import { GaugeRing, DonutChart, AreaLine, Sparkline } from '../../components/ui/Charts'

export function HealthInsightsPage() {
  const { openDrawer } = useShell()
  return (
    <div className="flex min-h-full flex-col">
      <TopBar title="Health Insights" subtitle="Track your health, stay healthier" onMenu={openDrawer} notificationCount={0} />

      <div className="space-y-3 px-4 pt-1">
        {/* Health score */}
        <Card>
          <div className="flex items-center gap-4">
            <GaugeRing percent={82} label="82" sub="Good" color="var(--brand-500)" size={104} />
            <div className="flex-1">
              <h2 className="text-[15px] font-bold text-text">Health Score</h2>
              <p className="mt-0.5 text-[12.5px] text-text-muted">Great job! Keep up your healthy habits.</p>
              <span className="mt-2 inline-block rounded-full bg-green-soft px-2.5 py-1 text-[11.5px] font-semibold text-green-500">
                ↑ 8 points from last month
              </span>
            </div>
          </div>
        </Card>

        {/* Overview */}
        <div className="grid grid-cols-2 gap-2.5">
          <Tile bg="bg-brand-soft" fg="text-brand-500" n="94%" label="Adherence" delta="↑6" />
          <Tile bg="bg-green-soft" fg="text-green-500" n="28" label="Doses Taken" delta="↑5" />
          <Tile bg="bg-amber-soft" fg="text-amber-500" n="3" label="Doses Missed" delta="↓2" />
          <Tile bg="bg-red-soft" fg="text-red-500" n="2" label="Late Doses" delta="↓1" />
        </div>

        <Card>
          <h2 className="mb-1 text-[15px] font-bold text-text">Medication Adherence</h2>
          <p className="mb-2 text-[12px] text-text-muted">This Month · 94% average</p>
          <AreaLine data={[80, 88, 92, 85, 95, 90, 96, 94, 98, 94]} />
        </Card>

        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">Adherence by Time</h2>
          <div className="flex items-center gap-4">
            <DonutChart
              segments={[
                { value: 79, color: 'var(--green-500)' },
                { value: 7, color: 'var(--amber-500)' },
                { value: 11, color: 'var(--red-500)' },
                { value: 3, color: 'var(--border-strong)' },
              ]}
              centerLabel="28"
              centerSub="Doses"
              size={110}
            />
            <div className="flex-1 space-y-1.5">
              <Row color="bg-green-500" label="On Time" value="79%" />
              <Row color="bg-amber-500" label="Late" value="7%" />
              <Row color="bg-red-500" label="Missed" value="11%" />
              <Row color="bg-border-strong" label="Not Scheduled" value="3%" />
            </div>
          </div>
        </Card>

        {/* Health trends */}
        <Card>
          <h2 className="mb-3 text-[15px] font-bold text-text">Health Trends <span className="text-[11px] font-normal text-text-muted">(Last 3 Months)</span></h2>
          <div className="space-y-3">
            <Trend icon={<Heart size={16} />} fg="text-red-500" name="Blood Pressure" value="118/76" unit="mmHg" tag="Stable" data={[118, 120, 116, 119, 118]} color="var(--red-500)" />
            <Trend icon={<Droplet size={16} />} fg="text-blue-500" name="Blood Sugar" value="96" unit="mg/dL" tag="Stable" data={[98, 95, 97, 94, 96]} color="var(--blue-500)" />
            <Trend icon={<Scale size={16} />} fg="text-brand-500" name="Weight" value="72.5" unit="kg" tag="↓1.2kg" data={[74, 73.5, 73, 72.8, 72.5]} color="var(--brand-500)" />
          </div>
        </Card>

        <Banner icon={<Activity size={18} />} title="Consistency is the key!" subtitle="Your steady habits are paying off." showChevron />
      </div>
    </div>
  )
}

function Tile({ bg, fg, n, label, delta }: { bg: string; fg: string; n: string; label: string; delta: string }) {
  return (
    <div className={`rounded-2xl p-3 ${bg}`}>
      <div className="flex items-baseline gap-1.5">
        <span className={`text-[20px] font-extrabold ${fg}`}>{n}</span>
        <span className={`text-[11px] font-semibold ${fg}`}>{delta}</span>
      </div>
      <div className="mt-0.5 text-[12px] font-medium text-text">{label}</div>
    </div>
  )
}
function Row({ color, label, value }: { color: string; label: string; value: string }) {
  return (
    <div className="flex items-center gap-2">
      <span className={`h-2.5 w-2.5 rounded-full ${color}`} />
      <span className="flex-1 text-[12px] text-text">{label}</span>
      <span className="text-[12px] font-bold text-text">{value}</span>
    </div>
  )
}
function Trend({ icon, fg, name, value, unit, tag, data, color }: { icon: React.ReactNode; fg: string; name: string; value: string; unit: string; tag: string; data: number[]; color: string }) {
  return (
    <div className="flex items-center gap-3 rounded-2xl bg-surface-2 p-2.5">
      <span className={`grid h-9 w-9 shrink-0 place-items-center rounded-full bg-surface ${fg}`}>{icon}</span>
      <div className="min-w-0">
        <p className="text-[13px] font-bold text-text">{name}</p>
        <p className="text-[12px] text-text-muted"><span className="font-bold text-text">{value}</span> {unit}</p>
      </div>
      <div className="ml-auto w-20"><Sparkline data={data} color={color} /></div>
      <span className="shrink-0 rounded-full bg-surface px-2 py-0.5 text-[10px] font-semibold text-text-muted">{tag}</span>
    </div>
  )
}
