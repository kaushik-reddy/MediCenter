import SwiftUI

struct ProgressCard: View {
    private var store = AdherenceStore.shared

    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.brand500)
                    Text("Your Progress")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Theme.text)
                }

                HStack(spacing: 10) {
                    ProgressRing(percent: store.percent)

                    VStack(alignment: .leading, spacing: 8) {
                        (Text("Great job! ").foregroundColor(Theme.green).fontWeight(.bold)
                            + Text("You're staying consistent.").foregroundColor(Theme.text))
                            .font(.system(size: 13))
                            .fixedSize(horizontal: false, vertical: true)

                        WeekDots(week: store.week, labels: store.labels, today: store.todayIndex)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    streakTile
                }
            }
        }
    }

    private var streakTile: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Text("🔥").font(.system(size: 18))
                Text("\(store.streakDays)")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundStyle(Color(hex: "F97316"))
            }
            Text("Day Streak")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Theme.textMuted)
        }
        .frame(width: 68)
        .padding(.vertical, 14)
        .background(Color.dynamic(light: "FFF5F0", dark: "2A1F18"))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct ProgressRing: View {
    let percent: Int

    var body: some View {
        ZStack {
            Circle().stroke(Theme.border, lineWidth: 9)
            Circle()
                .trim(from: 0, to: CGFloat(percent) / 100)
                .stroke(Theme.green, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.4), value: percent)
            VStack(spacing: 1) {
                Text("\(percent)%")
                    .font(.system(size: 19, weight: .heavy))
                    .foregroundStyle(Theme.text)
                Text("This Week")
                    .font(.system(size: 10))
                    .foregroundStyle(Theme.textMuted)
            }
        }
        .frame(width: 84, height: 84)
    }
}

private struct WeekDots: View {
    let week: [Double]
    let labels: [String]
    let today: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(week.indices, id: \.self) { i in
                VStack(spacing: 4) {
                    dot(week[i], isToday: i == today)
                    Text(labels[i])
                        .font(.system(size: 10, weight: i == today ? .bold : .medium))
                        .foregroundStyle(i == today ? Theme.brand500 : Theme.textMuted)
                }
            }
        }
    }

    /// Proportional fill: full = green disc + check, partial = trimmed ring, empty = outline.
    @ViewBuilder
    private func dot(_ v: Double, isToday: Bool) -> some View {
        ZStack {
            Circle().fill(Theme.surface)
                .overlay(Circle().strokeBorder(isToday ? Theme.brand500.opacity(0.5) : Theme.borderStrong, lineWidth: 2))
            if v >= 1 {
                Circle().fill(Theme.green)
                Image(systemName: "checkmark").font(.system(size: 9, weight: .heavy)).foregroundStyle(.white)
            } else if v > 0 {
                Circle()
                    .trim(from: 0, to: v)
                    .stroke(Theme.green, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(1)
            }
        }
        .frame(width: 20, height: 20)
        .animation(.easeOut(duration: 0.35), value: v)
    }
}
