import SwiftUI

struct AnalyticsView: View {
    @State private var range = "30 Days"
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Analytics", subtitle: "Understand your medication habits")
            ScrollView {
                VStack(spacing: 12) {
                    ChipsRow(items: [ChipItem(label: "7 Days"), ChipItem(label: "30 Days"), ChipItem(label: "3 Months"), ChipItem(label: "6 Months"), ChipItem(label: "1 Year")], active: $range)

                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overall Adherence").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            HStack(spacing: 16) {
                                GaugeRingView(percent: 92, color: Theme.green, size: 100, label: "92%", sub: "Adherence")
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Great job! 🎉").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.green)
                                    miniBox("↑ 12%", "vs last period", Theme.greenSoft, Theme.green)
                                    miniBox("85%", "Your Goal", Theme.brandSoft, Theme.brand500)
                                }
                            }
                        }
                    }

                    HStack(spacing: 10) {
                        statTile("28", "Doses Taken", "On Time 24", Theme.greenSoft, Theme.green)
                        statTile("5", "Late", "Avg 22 mins", Theme.amberSoft, Theme.amber)
                    }
                    HStack(spacing: 10) {
                        statTile("2", "Missed", nil, Theme.redSoft, Theme.red)
                        statTile("18", "Days Tracked", nil, Theme.brandSoft, Theme.brand500)
                    }

                    SectionCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Adherence Over Time").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            AreaLineView(data: [70, 82, 78, 90, 85, 95, 88, 92, 100, 90])
                        }
                    }
                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Doses by Time of Day").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            HStack(spacing: 16) {
                                DonutView(segments: [DonutSegment(value: 12, color: Theme.brand500), DonutSegment(value: 8, color: Theme.amber), DonutSegment(value: 8, color: Theme.green)], centerLabel: "28", centerSub: "Total")
                                VStack(spacing: 8) {
                                    legend(Theme.brand500, "Morning", "12")
                                    legend(Theme.amber, "Afternoon", "8")
                                    legend(Theme.green, "Evening", "8")
                                }
                            }
                        }
                    }
                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Weekly Adherence").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            BarsView(data: [100, 90, 100, 80, 95, 70, 100], labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                                     colors: [Theme.green, Theme.green, Theme.green, Theme.amber, Theme.green, Theme.red, Theme.green])
                        }
                    }
                    InfoBanner(icon: "lightbulb", title: "You're most consistent on weekdays", subtitle: "Try a weekend reminder", showChevron: true)
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func miniBox(_ n: String, _ label: String, _ bg: Color, _ fg: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(n).font(.system(size: 15, weight: .heavy)).foregroundStyle(fg)
            Text(label).font(.system(size: 10.5)).foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 12).padding(.vertical, 8)
        .background(bg).clipShape(RoundedRectangle(cornerRadius: 12))
    }
    private func statTile(_ n: String, _ label: String, _ sub: String?, _ bg: Color, _ fg: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(n).font(.system(size: 20, weight: .heavy)).foregroundStyle(fg)
            Text(label).font(.system(size: 12, weight: .medium)).foregroundStyle(Theme.text)
            if let sub { Text(sub).font(.system(size: 10.5)).foregroundStyle(Theme.textMuted) }
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(12).background(bg).clipShape(RoundedRectangle(cornerRadius: 16))
    }
    private func legend(_ c: Color, _ label: String, _ value: String) -> some View {
        HStack(spacing: 8) {
            Circle().fill(c).frame(width: 10, height: 10)
            Text(label).font(.system(size: 12.5)).foregroundStyle(Theme.text)
            Spacer()
            Text(value).font(.system(size: 12.5, weight: .bold)).foregroundStyle(Theme.text)
        }
    }
}
