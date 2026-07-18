import SwiftUI

struct ProgressCard: View {
    let progress: WeekProgress

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
                    ProgressRing(percent: progress.percent)

                    VStack(alignment: .leading, spacing: 8) {
                        (Text("Great job! ").foregroundColor(Theme.green).fontWeight(.bold)
                            + Text("You're staying consistent.").foregroundColor(Theme.text))
                            .font(.system(size: 13))
                            .fixedSize(horizontal: false, vertical: true)

                        WeekDots(week: progress.week, labels: progress.weekLabels)
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
                Text("\(progress.streakDays)")
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

    var body: some View {
        HStack(spacing: 3) {
            ForEach(week.indices, id: \.self) { i in
                VStack(spacing: 4) {
                    dot(week[i])
                    Text(labels[i])
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Theme.textMuted)
                }
            }
        }
    }

    @ViewBuilder
    private func dot(_ v: Double) -> some View {
        if v == 1 {
            ZStack {
                Circle().fill(Theme.green)
                Image(systemName: "checkmark").font(.system(size: 9, weight: .heavy)).foregroundStyle(.white)
            }
            .frame(width: 20, height: 20)
        } else if v == 0.5 {
            ZStack {
                Circle().fill(Theme.surface)
                HStack(spacing: 0) { Theme.green; Color.clear }.clipShape(Circle())
            }
            .frame(width: 20, height: 20)
            .overlay(Circle().strokeBorder(Theme.green, lineWidth: 2))
        } else {
            Circle().fill(Theme.surface)
                .frame(width: 20, height: 20)
                .overlay(Circle().strokeBorder(Theme.borderStrong, lineWidth: 2))
        }
    }
}
