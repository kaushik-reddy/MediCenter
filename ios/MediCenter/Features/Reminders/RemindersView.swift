import SwiftUI

struct RemindersView: View {
    @Environment(AppState.self) private var app
    @State private var chip = "All"

    struct Reminder: Identifiable { let id = UUID(); let time: String; let ampm: String; let color: Color; let bg: Color; let name: String; let detail: String; var status: String? = nil; var statusGreen = true; var today = false }

    private let today: [Reminder] = [
        Reminder(time: "08:30", ampm: "AM", color: Theme.brand500, bg: Theme.brandSoft, name: "Vitamin D3 60K", detail: "1 Capsule · After Breakfast", status: "Due in 15 min", statusGreen: true),
        Reminder(time: "02:30", ampm: "PM", color: Theme.amber, bg: Theme.amberSoft, name: "Paracetamol 650mg", detail: "1 Tablet · After Lunch", status: "Due in 5h 45m", statusGreen: false),
        Reminder(time: "08:30", ampm: "PM", color: Theme.green, bg: Theme.greenSoft, name: "B-Complex", detail: "1 Tablet · After Dinner"),
    ]
    private let upcoming: [Reminder] = [
        Reminder(time: "09:30", ampm: "PM", color: Theme.brand500, bg: Theme.brandSoft, name: "Calcium", detail: "1 Tablet · Before Bed", today: true),
        Reminder(time: "10:30", ampm: "PM", color: Theme.red, bg: Theme.redSoft, name: "Omega 3", detail: "1 Capsule · After Dinner", today: true),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Medication Reminders", subtitle: "Never miss your medicines")
            ScrollView {
                VStack(spacing: 12) {
                    InfoBanner(icon: "bell", title: "Stay on track!", subtitle: "You have 3 reminders today", showChevron: true)
                    ChipsRow(items: [ChipItem(label: "All", count: 8), ChipItem(label: "Today", count: 3), ChipItem(label: "Tomorrow", count: 2), ChipItem(label: "Custom", count: 3)], active: $chip)

                    header("Today's Reminders")
                    ForEach(today) { r in row(r) }
                    header("Upcoming Reminders")
                    ForEach(upcoming) { r in row(r) }
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
            Image(systemName: "ellipsis").font(.system(size: 16)).foregroundStyle(Theme.textFaint)
        }
        .padding(10).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }
}
