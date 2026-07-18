import { Clock, Check } from 'lucide-react'
import { PillGlassIllustration } from '../../components/illustrations/Illustrations'
import type { NextDose } from '../../data/homeData'

export function NextDoseCard({ dose, onTaken }: { dose: NextDose; onTaken?: () => void }) {
  return (
    <div
      className="next-dose-hero relative overflow-hidden rounded-[22px] px-5 py-4 text-white shadow-[0_16px_36px_-14px_rgba(50,30,110,0.6)]"
      style={{
        backgroundImage:
          'radial-gradient(120% 120% at 100% 100%, rgba(124,92,252,0.55) 0%, rgba(91,58,166,0.0) 55%), linear-gradient(120deg, #191a2e 0%, #241f45 50%, #3a2a6b 100%)',
      }}
    >
      {/* Illustration */}
      <PillGlassIllustration className="pointer-events-none absolute -right-2 top-3 h-[112px] w-[156px]" />

      <p className="text-[11px] font-bold uppercase tracking-[0.14em] text-[#5eead4]">Next Dose</p>

      <div className="mt-1 flex items-baseline gap-1.5">
        <span className="text-[26px] font-semibold leading-none">In</span>
        <span className="text-[44px] font-extrabold leading-none text-[#5eead4]">
          {dose.inLabel}
        </span>
        <span className="text-[22px] font-semibold leading-none">hrs</span>
      </div>

      <div className="mt-2.5 inline-flex items-center gap-1.5 rounded-full bg-white/12 px-2.5 py-1 backdrop-blur-sm">
        <Clock size={13} />
        <span className="text-[12px] font-semibold">{dose.atTime}</span>
      </div>

      <div className="my-3 h-px w-full bg-white/12" />

      <div className="flex items-end justify-between gap-3">
        <div className="min-w-0">
          <h3 className="truncate text-[17px] font-bold leading-tight">{dose.name}</h3>
          <p className="mt-0.5 text-[12px] text-white/65">{dose.detail}</p>
        </div>

        <button
          type="button"
          onClick={onTaken}
          className="flex shrink-0 items-center gap-1.5 rounded-full bg-gradient-to-b from-[#8bf0c0] to-[#5fd6a0] px-3.5 py-2 text-[12.5px] font-bold text-[#0b3b2e] shadow-lg active:scale-95"
        >
          <Check size={15} strokeWidth={3} />
          Mark as Taken
        </button>
      </div>
    </div>
  )
}
