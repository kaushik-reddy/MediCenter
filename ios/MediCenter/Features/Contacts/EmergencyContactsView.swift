import SwiftUI

struct EmergencyContactsView: View {
    @Environment(AppState.self) private var app
    @State private var chip = "All"
    struct Contact: Identifiable { let id = UUID(); let name: String; let rel: String; let phone: String; let primary: Bool; var order: Int? = nil }
    private let primaryC: [Contact] = []
    private let secondaryC: [Contact] = []

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Emergency Contacts", subtitle: "Your safety, our priority")
            ScrollView {
                VStack(spacing: 12) {
                    InfoBanner(icon: "checkmark.shield", title: "Stay prepared", subtitle: "No emergency contacts yet")
                    ChipsRow(items: [ChipItem(label: "All", count: 0), ChipItem(label: "Family", count: 0), ChipItem(label: "Friends", count: 0), ChipItem(label: "Others", count: 0)], active: $chip)
                    if primaryC.isEmpty && secondaryC.isEmpty {
                        EmptyState(icon: "phone", title: "No contacts yet",
                                   message: "Add emergency contacts so they can be reached quickly.")
                    } else {
                        if !primaryC.isEmpty {
                            Text("Primary Contacts").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text).frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(primaryC) { c in row(c) }
                        }
                        if !secondaryC.isEmpty {
                            Text("Secondary Contacts").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text).frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(secondaryC) { c in row(c) }
                        }
                    }
                    Button { app.presentFullScreen(AddContactWizardView()) } label: {
                        HStack(spacing: 6) { Image(systemName: "plus"); Text("Add Emergency Contact").font(.system(size: 13.5, weight: .bold)) }
                            .foregroundStyle(Theme.brand500).frame(maxWidth: .infinity).padding(.vertical, 14)
                            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5])).foregroundStyle(Theme.brand500.opacity(0.4)))
                    }
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }
    private func row(_ c: Contact) -> some View {
        HStack(spacing: 12) {
            if let o = c.order {
                Text("\(o)").font(.system(size: 11, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 24, height: 24).background(Theme.brand500).clipShape(Circle())
            }
            Circle().fill(Theme.brandGradient).frame(width: 44, height: 44)
                .overlay(Text(String(c.name.prefix(1))).font(.system(size: 17, weight: .bold)).foregroundStyle(.white))
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 6) {
                    Text(c.name).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    Text(c.primary ? "Primary" : "Secondary").font(.system(size: 9.5, weight: .semibold))
                        .foregroundStyle(c.primary ? Theme.green : Theme.amber)
                        .padding(.horizontal, 6).padding(.vertical, 1)
                        .background(c.primary ? Theme.greenSoft : Theme.amberSoft).clipShape(Capsule())
                }
                Text("\(c.rel) · \(c.phone)").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 4)
            Image(systemName: "phone.fill").font(.system(size: 15)).foregroundStyle(Theme.green)
                .frame(width: 36, height: 36).background(Theme.greenSoft).clipShape(Circle())
            Image(systemName: "message.fill").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                .frame(width: 36, height: 36).background(Theme.brandSoft).clipShape(Circle())
        }
        .padding(12).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }
}
