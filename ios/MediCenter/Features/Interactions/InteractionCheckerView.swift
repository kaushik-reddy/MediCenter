import SwiftUI

struct InteractionCheckerView: View {
    @Environment(AppState.self) private var app
    struct Recent: Identifiable { let id = UUID(); let pair: String; let ago: String; let risk: String; let tone: Color }
    private let recent: [Recent] = []

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Interaction Checker", subtitle: "Check interactions between medicines")
            ScrollView {
                VStack(spacing: 12) {
                    SectionCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.shield").foregroundStyle(Theme.brand500)
                                Text("Check for interactions").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                            }
                            Button { app.present(InfoModal(icon: "plus", title: "Add Medicine", message: "Search and add another medicine to check for interactions.")) } label: {
                                HStack(spacing: 6) { Image(systemName: "plus"); Text("Add Another Medicine").font(.system(size: 13, weight: .semibold)) }
                                    .foregroundStyle(Theme.textMuted).frame(maxWidth: .infinity).padding(.vertical, 10)
                                    .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5])).foregroundStyle(Theme.border))
                            }
                            Button { app.present(InteractionResultModal()) } label: {
                                HStack(spacing: 8) { Image(systemName: "magnifyingglass"); Text("Check Interactions").font(.system(size: 14, weight: .bold)) }
                                    .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 12)
                                    .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    HStack {
                        Text("Recent Checks").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                        Spacer()
                        Text("View All").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.brand500)
                    }
                    if recent.isEmpty {
                        EmptyState(icon: "exclamationmark.shield", title: "No checks yet",
                                   message: "Run an interaction check to see your results here.")
                    } else {
                        SettingsCard {
                            ForEach(Array(recent.enumerated()), id: \.element.id) { idx, r in
                                HStack(spacing: 12) {
                                    HStack(spacing: -6) {
                                        Circle().fill(Theme.green).frame(width: 28, height: 28).overlay(Circle().strokeBorder(Theme.surface, lineWidth: 2))
                                        Circle().fill(Theme.blue).frame(width: 28, height: 28).overlay(Circle().strokeBorder(Theme.surface, lineWidth: 2))
                                    }
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(r.pair).font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                                        Text("Checked \(r.ago)").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                                    }
                                    Spacer()
                                    Text(r.risk).font(.system(size: 10.5, weight: .semibold)).foregroundStyle(r.tone)
                                        .padding(.horizontal, 8).padding(.vertical, 2).background(r.tone.opacity(0.14)).clipShape(Capsule())
                                }
                                .padding(.horizontal, 14).padding(.vertical, 12)
                                .overlay(idx == recent.count - 1 ? nil : Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)
                            }
                        }
                    }
                    InfoBanner(icon: "exclamationmark.shield", title: "Why check interactions?", subtitle: "Some medicines can affect each other.")
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }
    private func medRow(_ name: String, _ form: String) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8).fill(Theme.brandSoft).frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 1) {
                Text(name).font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                Text(form).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
            }
            Spacer()
            Image(systemName: "xmark").font(.system(size: 15)).foregroundStyle(Theme.textFaint)
        }
        .padding(8).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
