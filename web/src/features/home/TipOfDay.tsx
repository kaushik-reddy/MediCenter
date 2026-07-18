import {
  TipGlassIllustration,
  ShieldCrossIllustration,
} from '../../components/illustrations/Illustrations'

export function TipOfDay({
  text = 'Take your medicines with water and follow the prescribed dosage.',
}: {
  text?: string
}) {
  return (
    <div className="relative overflow-hidden rounded-[18px] bg-brand-soft px-3.5 py-3.5">
      <div className="flex items-center gap-3">
        <TipGlassIllustration className="h-12 w-12 shrink-0" />
        <div className="min-w-0 flex-1 pr-14">
          <h3 className="text-[14px] font-bold text-brand-500">Tip of the day</h3>
          <p className="mt-0.5 text-[12px] leading-snug text-text-muted">{text}</p>
        </div>
      </div>
      <ShieldCrossIllustration className="pointer-events-none absolute -bottom-1 right-2 h-[68px] w-[68px]" />
    </div>
  )
}
