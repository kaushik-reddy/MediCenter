import SwiftUI

struct RemindersView: View {
    @Environment(AppState.self) private var app
    @State private var chip = "All"

    struct Reminder: Identifiable { let id = UUID(); let time: String; let ampm: String; let color: Color; let bg: Color; let name: String; let detail: String; var status: String? = nil; var statusGreen = true; var today = false }

    private let today: [Reminder] = []
    private let upcoming: [Reminder] = []

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Medication Reminders", subtitle: "Never miss your medicines")
            ScrollView {
                VStack(spacing: 12) {
                    InfoBanner(icon: "bell", title: "Stay on track!", subtitle: "No reminders yet", showChevron: true)
                    ChipsRow(items: [ChipItem(label: "All", count: 0), ChipItem(label: "Today", count: 0), ChipItem(label: "Tomorrow", count: 0), ChipItem(label: "Custom", count: 0)], active: $chip)

                    if today.isEmpty && upcoming.isEmpty {
                        EmptyState(icon: "bell", title: "No reminders yet",
                                   message: "Add your medicines to start getting reminders here.")
                    } else {
                        if !today.isEmpty {
                            header("Today's Reminders")
                            ForEach(today) { r in row(r) }
                        }
                        if !upcoming.isEmpty {
                            header("Upcoming Reminders")
                            ForEach(upcoming) { r in row(r) }
                        }
                    }
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func header(_ t: String) -> some View {
        Text(t).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func row(_ r: Reminder) -> some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Text(r.time).font(.system(size: 13, weight: .heavy)).foregroundStyle(r.color)
                Text(r.ampm).font(.system(size: 10, weight: .bold)).foregroundStyle(r.color)
            }
            .frame(width: 60).padding(.vertical, 12).background(r.bg).clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 2) {
                Text(r.name).font(.system(size: 14.5, weight: .bold)).foregroundStyle(Theme.text)
                Text(r.detail).font(.system(size: 12)).foregroundStyle(Theme.textMuted)
                if let s = r.status {
                    Text(s).font(.system(size: 10.5, weight: .semibold)).foregroundStyle(r.statusGreen ? Theme.green : Theme.amber)
                        .padding(.horizontal, 8).padding(.vertical, 2)
                        .background(r.statusGreen ? Theme.greenSoft : Theme.amberSoft).clipShape(Capsule())
                }
                if r.today {
                    Text("Today").font(.system(size: 10.5, weight: .semibold)).foregroundStyle(Theme.brand500)
                        .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.brandSoft).clipShape(Capsule())
                }
            }
            Spacer(minLength: 4)
            Button { app.present(SetReminderModal(name: r.name)) } label: {
                Image(systemName: "bell").font(.system(size: 16)).foregroundStyle(Theme.brand500)
                    .frame(width: 36, height: 36).background(Theme.brandSoft).clipShape(Circle())
            }
            Button { app.present(ReminderOptionsModal(name: r.name)) } label: {
                Image(systemName: "ellipsis").font(.system(size: 16)).foregroundStyle(Theme.textFaint)
                    .frame(width: 32, height: 36)
            }
        }
        .padding(10).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }
}
