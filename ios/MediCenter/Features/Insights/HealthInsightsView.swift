import SwiftUI

struct HealthInsightsView: View {
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Health Insights", subtitle: "Track your health, stay healthier")
            ScrollView {
                VStack(spacing: 12) {
                    SectionCard {
                        HStack(spacing: 16) {
                            GaugeRingView(percent: 82, color: Theme.brand500, size: 100, label: "82", sub: "Good")
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Health Score").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                                Text("Great job! Keep up your healthy habits.").font(.system(size: 12.5)).foregroundStyle(Theme.textMuted)
                                Text("↑ 8 points from last month").font(.system(size: 11.5, weight: .semibold)).foregroundStyle(Theme.green)
                                    .padding(.horizontal, 10).padding(.vertical, 4).background(Theme.greenSoft).clipShape(Capsule())
                            }
                        }
                    }
                    HStack(spacing: 10) {
                        tile("94%", "Adherence", "↑6", Theme.brandSoft, Theme.brand500)
                        tile("28", "Doses Taken", "↑5", Theme.greenSoft, Theme.green)
                    }
                    HStack(spacing: 10) {
                        tile("3", "Doses Missed", "↓2", Theme.amberSoft, Theme.amber)
                        tile("2", "Late Doses", "↓1", Theme.redSoft, Theme.red)
                    }
                    SectionCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Medication Adherence").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            AreaLineView(data: [80, 88, 92, 85, 95, 90, 96, 94, 98, 94])
                        }
                    }
                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Health Trends").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            trend("heart.fill", Theme.red, "Blood Pressure", "118/76 mmHg", "Stable", [118, 120, 116, 119, 118], Theme.red)
                            trend("drop.fill", Theme.blue, "Blood Sugar", "96 mg/dL", "Stable", [98, 95, 97, 94, 96], Theme.blue)
                            trend("scalemass.fill", Theme.brand500, "Weight", "72.5 kg", "↓1.2kg", [74, 73.5, 73, 72.8, 72.5], Theme.brand500)
                        }
                    }
                    InfoBanner(icon: "waveform.path.ecg", title: "Consistency is the key!", subtitle: "Your steady habits are paying off.", showChevron: true)
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func tile(_ n: String, _ label: String, _ delta: String, _ bg: Color, _ fg: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(n).font(.system(size: 20, weight: .heavy)).foregroundStyle(fg)
                Text(delta).font(.system(size: 11, weight: .semibold)).foregroundStyle(fg)
            }
            Text(label).font(.system(size: 12, weight: .medium)).foregroundStyle(Theme.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(12).background(bg).clipShape(RoundedRectangle(cornerRadius: 16))
    }
    private func trend(_ icon: String, _ fg: Color, _ name: String, _ value: String, _ tag: String, _ data: [Double], _ color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(fg)
                .frame(width: 36, height: 36).background(Theme.surface).clipShape(Circle())
            VStack(alignment: .leading, spacing: 1) {
                Text(name).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                Text(value).font(.system(size: 12)).foregroundStyle(Theme.textMuted)
            }
            Spacer()
            SparklineView(data: data, color: color).frame(width: 70)
            Text(tag).font(.system(size: 10, weight: .semibold)).foregroundStyle(Theme.textMuted)
                .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.surface).clipShape(Capsule())
        }
        .padding(10).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
