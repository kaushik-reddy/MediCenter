import SwiftUI

struct MedicationCard: View {
    let med: Medication

    private var accent: Color { med.color == .green ? Theme.green : Theme.brand500 }
    private var stripBg: Color { med.color == .green ? Theme.greenSoft : Theme.brandSoft }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MedThumb(kind: med.kind, tint: med.tint, pillColor: med.pillColor, size: 68)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(med.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.text)
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textFaint)
                }

                HStack(spacing: 5) {
                    Image(systemName: "pills").font(.system(size: 12))
                    Text(med.dose)
                    Text("·").foregroundStyle(Theme.textFaint)
                    Image(systemName: med.foodIcon).font(.system(size: 11))
                    Text(med.food)
                }
                .font(.system(size: 12))
                .foregroundStyle(Theme.textMuted)
                .padding(.top, 4)

                HStack(spacing: 8) {
                    Image(systemName: "clock").font(.system(size: 13, weight: .semibold)).foregroundStyle(accent)
                    Text(med.time).font(.system(size: 12, weight: .bold)).foregroundStyle(accent)
                    Spacer(minLength: 4)
                    WeekdayStrip(days: med.days, color: accent)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(stripBg)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.top, 8)
            }
        }
        .padding(12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Theme.border, lineWidth: 1))
        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
    }
}

private struct WeekdayStrip: View {
    let days: [DayState]
    let color: Color
    private let labels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        HStack(spacing: 5) {
            ForEach(days.indices, id: \.self) { i in
                switch days[i] {
                case .on:
                    Text(labels[i])
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(color)
                        .clipShape(Circle())
                case .ring:
                    Text(labels[i])
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(color)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().strokeBorder(color, lineWidth: 2))
                case .off:
                    Text(labels[i])
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Theme.textFaint)
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}
