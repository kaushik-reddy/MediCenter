import { useShell } from '../../components/shell/shellContext'
import { TopBar } from '../../components/shell/TopBar'
import { NextDoseCard } from './NextDoseCard'
import { TodaySchedule } from './TodaySchedule'
import { ProgressCard } from './ProgressCard'
import { TipOfDay } from './TipOfDay'
import { weekProgress } from '../../data/homeData'
import { useMeds } from '../../store/medStore'
import { MarkAsTakenModal, DoseActionsModal } from '../flows/FlowModals'

export function HomePage() {
  const { openDrawer, openModal } = useShell()
  const { nextDose, todaySchedule } = useMeds()

  return (
    <div className="flex min-h-full flex-col">
      <TopBar
        variant="greeting"
        title="Good morning, Kaushik"
        subtitle="Stay on track, stay healthy."
        onMenu={openDrawer}
        notificationCount={0}
      />

      <div className="flex flex-1 flex-col px-4 pt-1">
        <div className="space-y-3">
          {nextDose && (
            <NextDoseCard
              dose={nextDose}
              onTaken={() => openModal(<MarkAsTakenModal name={nextDose.name} medId={nextDose.id} />)}
            />
          )}
          <TodaySchedule
            items={todaySchedule}
            onOptions={(item) => openModal(<DoseActionsModal name={item.name} medId={item.id} time={item.time} />)}
          />
          <ProgressCard progress={weekProgress} />
        </div>

        {/* Tip of the day is always pinned to the bottom of the screen */}
        <div className="mt-auto pt-3">
          <TipOfDay />
        </div>
      </div>
    </div>
  )
}
