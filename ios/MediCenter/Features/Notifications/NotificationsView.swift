import SwiftUI

struct NotificationsView: View {
    @Environment(AppState.self) private var app
    @State private var chip = "All"

    struct Notif: Identifiable { let id = UUID(); let icon: String; let bg: Color; let fg: Color; let title: String; let sub: String; let time: String; var unread = false; var action: String? = nil }
    struct Group: Identifiable { let id = UUID(); let label: String; let items: [Notif] }

    private var groups: [Group] {
        [
            Group(label: "Today", items: [
                Notif(icon: "bell", bg: Theme.brandSoft, fg: Theme.brand500, title: "Time for Vitamin D3", sub: "1 Capsule · After Breakfast", time: "8:30 AM", unread: true, action: "take"),
                Notif(icon: "checkmark", bg: Theme.greenSoft, fg: Theme.green, title: "Dose taken", sub: "You took Paracetamol on time", time: "10:30 AM", unread: true),
                Notif(icon: "star", bg: Theme.amberSoft, fg: Theme.amber, title: "7 day streak! 🎉", sub: "Consistent for a week", time: "9:00 AM"),
            ]),
            Group(label: "Yesterday", items: [
                Notif(icon: "pills", bg: Theme.redSoft, fg: Theme.red, title: "Low stock alert", sub: "B-Complex has 3 tablets left", time: "6:15 PM"),
                Notif(icon: "megaphone", bg: Theme.brandSoft, fg: Theme.brand500, title: "New feature: Insights", sub: "Track your health trends", time: "2:00 PM"),
            ]),
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Notifications", subtitle: "Stay updated with your health")
            ScrollView {
                VStack(spacing: 12) {
                    ChipsRow(items: [ChipItem(label: "All", count: 24), ChipItem(label: "Reminders", count: 12), ChipItem(label: "Medication", count: 8), ChipItem(label: "System", count: 4)], active: $chip)
                    ForEach(groups) { g in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(g.label).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.textMuted)
                            SettingsCard {
                                ForEach(Array(g.items.enumerated()), id: \.element.id) { idx, n in
                                    rowView(n, last: idx == g.items.count - 1)
                                }
                            }
                        }
                    }
                    InfoBanner(icon: "bell", title: "Never miss important updates", subtitle: "Manage your notification preferences", showChevron: true)
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func rowView(_ n: Notif, last: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: n.icon).font(.system(size: 18)).foregroundStyle(n.fg)
                .frame(width: 40, height: 40).background(n.bg).clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(n.title).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    Spacer()
                    Text(n.time).font(.system(size: 11)).foregroundStyle(Theme.textFaint)
                }
                Text(n.sub).font(.system(size: 12.5)).foregroundStyle(Theme.textMuted)
                if n.action == "take" {
                    Button { app.present(MarkAsTakenModal(name: n.title)) } label: {
                        Text("Mark as Taken").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.brand500)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
                    }
                    .padding(.top, 4)
                }
            }
            if n.unread { Circle().fill(Theme.brand500).frame(width: 8, height: 8).padding(.top, 6) }
        }
        .padding(.horizontal, 14).padding(.vertical, 12)
        .overlay(last ? nil : Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)
    }
}
