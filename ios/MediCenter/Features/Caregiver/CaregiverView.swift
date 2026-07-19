import SwiftUI

struct CaregiverView: View {
    @Environment(AppState.self) private var app
    @State private var chip = "All"
    struct Person: Identifiable { let id = UUID(); let name: String; let attention: Bool; let meds: Int; let updated: String; let missed: Int; let late: Int; let taken: Int }
    private let people = [
        Person(name: "Mom", attention: true, meds: 5, updated: "10 min ago", missed: 1, late: 1, taken: 3),
        Person(name: "Dad", attention: true, meds: 4, updated: "25 min ago", missed: 0, late: 2, taken: 2),
        Person(name: "Grandma", attention: false, meds: 6, updated: "5 min ago", missed: 0, late: 0, taken: 6),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Caregiver Mode", subtitle: "Stay updated with your loved ones")
            ScrollView {
                VStack(spacing: 12) {
                    InfoBanner(icon: "person.2", title: "Connected with 3 people", subtitle: "You're helping them stay on track")
                    ChipsRow(items: [ChipItem(label: "All", count: 3), ChipItem(label: "Needs Attention", count: 2), ChipItem(label: "All Good", count: 1)], active: $chip)
                    ForEach(people) { p in card(p) }
                    InfoBanner(icon: "checkmark.shield", title: "Care with confidence", subtitle: "Their data is private and secure.")
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func card(_ p: Person) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Circle().fill(Theme.brandGradient).frame(width: 44, height: 44)
                    .overlay(Text(String(p.name.prefix(1))).font(.system(size: 18, weight: .bold)).foregroundStyle(.white))
                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 8) {
                        Text(p.name).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                        Text(p.attention ? "Needs Attention" : "All Good").font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(p.attention ? Theme.amber : Theme.green)
                            .padding(.horizontal, 8).padding(.vertical, 2)
                            .background(p.attention ? Theme.amberSoft : Theme.greenSoft).clipShape(Capsule())
                    }
                    Text("\(p.meds) medications · Updated \(p.updated)").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                }
                Spacer()
            }
            HStack(spacing: 8) {
                mini("xmark", p.missed, "Missed", Theme.redSoft, Theme.red)
                mini("clock", p.late, "Late", Theme.amberSoft, Theme.amber)
                mini("checkmark", p.taken, "Taken", Theme.greenSoft, Theme.green)
            }
            HStack(spacing: 8) {
                Button { app.present(SendReminderModal(name: p.name)) } label: {
                    Text("Send Reminder").font(.system(size: 12.5, weight: .bold)).foregroundStyle(.white)
                        .frame(maxWidth: .infinity).padding(.vertical, 10).background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Button { app.present(InfoModal(title: p.name, message: "\(p.meds) medications · \(p.taken) taken, \(p.late) late, \(p.missed) missed today.")) } label: {
                    HStack(spacing: 4) { Text("View Details").font(.system(size: 12.5, weight: .semibold)); Image(systemName: "chevron.right").font(.system(size: 12)) }
                        .foregroundStyle(Theme.text).padding(.horizontal, 12).padding(.vertical, 10)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
                }
            }
        }
        .padding(12).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }
    private func mini(_ icon: String, _ n: Int, _ label: String, _ bg: Color, _ fg: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(fg)
            Text("\(n)").font(.system(size: 15, weight: .heavy)).foregroundStyle(fg)
            Text(label).font(.system(size: 10)).foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 8).background(bg).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
