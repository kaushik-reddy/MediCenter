import SwiftUI

struct HealthReportsView: View {
    @Environment(AppState.self) private var app
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Health Reports", subtitle: "Your health, in detail")
            ScrollView {
                VStack(spacing: 12) {
                    InfoBanner(icon: "doc.text", title: "Comprehensive Health Reports", subtitle: "Everything about your health in one place")
                    HStack(spacing: 10) {
                        tile("82", "Health Score", "↑8 pts", Theme.brandSoft, Theme.brand500)
                        tile("94%", "Adherence", "↑6%", Theme.greenSoft, Theme.green)
                    }
                    HStack(spacing: 10) {
                        tile("3", "Late Doses", "↓2", Theme.amberSoft, Theme.amber)
                        tile("2", "Missed Doses", "↓1", Theme.redSoft, Theme.red)
                    }
                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Health Overview").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            vital("heart.fill", Theme.red, "Blood Pressure", "118/76 mmHg", "Normal")
                            vital("drop.fill", Theme.blue, "Blood Sugar", "96 mg/dL", "Normal")
                            vital("scalemass.fill", Theme.brand500, "Weight", "72.5 kg", "↓1.2kg")
                            vital("waveform.path.ecg", Theme.green, "BMI", "24.1", "Normal")
                        }
                    }
                    SectionCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trend Overview").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            AreaLineView(data: [60, 70, 65, 80, 88, 94])
                        }
                    }
                    HStack(spacing: 12) {
                        Button { app.present(ExportReportModal()) } label: {
                            HStack(spacing: 8) { Image(systemName: "arrow.down.circle"); Text("Export").font(.system(size: 14, weight: .bold)) }
                                .foregroundStyle(Theme.text).frame(maxWidth: .infinity).padding(.vertical, 12)
                                .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.border, lineWidth: 1))
                        }
                        Button { app.present(ShareReportModal()) } label: {
                            HStack(spacing: 8) { Image(systemName: "square.and.arrow.up"); Text("Share Report").font(.system(size: 14, weight: .bold)) }
                                .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
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
    private func vital(_ icon: String, _ fg: Color, _ name: String, _ value: String, _ tag: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(fg)
                .frame(width: 36, height: 36).background(Theme.surface).clipShape(Circle())
            VStack(alignment: .leading, spacing: 1) {
                Text(name).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                Text(value).font(.system(size: 12)).foregroundStyle(Theme.textMuted)
            }
            Spacer()
            Text(tag).font(.system(size: 10.5, weight: .semibold)).foregroundStyle(Theme.green)
                .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.greenSoft).clipShape(Capsule())
        }
        .padding(10).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
