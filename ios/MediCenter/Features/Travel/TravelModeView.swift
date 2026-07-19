import SwiftUI

struct TravelModeView: View {
    @Environment(AppState.self) private var app
    @State private var on = true
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Travel Mode", subtitle: "Stay on track, wherever you go")
            ScrollView {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "airplane").font(.system(size: 18)).foregroundStyle(Theme.brand500)
                            .frame(width: 40, height: 40).background(Theme.surface.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 12))
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Never miss your medicines").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.brand500)
                            Text("Adjusts reminders to your time zone").font(.system(size: 12)).foregroundStyle(Theme.textMuted)
                        }
                        Spacer()
                        Toggle("", isOn: $on).labelsHidden().tint(Theme.brand500)
                    }
                    .padding(14).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 18))

                    if on {
                        SectionCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 10) {
                                    Image(systemName: "airplane").font(.system(size: 18)).foregroundStyle(Theme.brand500)
                                        .frame(width: 40, height: 40).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(alignment: .leading, spacing: 1) {
                                        HStack(spacing: 6) {
                                            Text("Active").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.green)
                                            Text("● Live").font(.system(size: 10, weight: .semibold)).foregroundStyle(Theme.green)
                                                .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.greenSoft).clipShape(Capsule())
                                        }
                                        Text("Adjusted to current time zone").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                                    }
                                    Spacer()
                                }
                                HStack(spacing: 8) {
                                    info("clock", "10:30 AM", "Local Time")
                                    info("mappin", "GMT+5:30", "Time Zone")
                                    info("bell", "1:00 PM", "Next Dose")
                                }
                            }
                        }
                    }

                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What Travel Mode does").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            ForEach(["Adjusts to local time zone", "Keeps your schedule intact", "Smart notifications", "Works offline"], id: \.self) { t in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark").font(.system(size: 14, weight: .heavy)).foregroundStyle(Theme.green)
                                        .frame(width: 24, height: 24).background(Theme.greenSoft).clipShape(Circle())
                                    Text(t).font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                                    Spacer()
                                }
                            }
                        }
                    }

                    Button { app.presentFullScreen(TravelModeWizardView()) } label: {
                        HStack(spacing: 8) { Image(systemName: "airplane"); Text("Configure Travel Mode").font(.system(size: 14, weight: .bold)) }
                            .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func info(_ icon: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Theme.brand500)
                .frame(width: 28, height: 28).background(Theme.surface).clipShape(Circle())
            Text(value).font(.system(size: 12.5, weight: .bold)).foregroundStyle(Theme.text)
            Text(label).font(.system(size: 10)).foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 8).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
