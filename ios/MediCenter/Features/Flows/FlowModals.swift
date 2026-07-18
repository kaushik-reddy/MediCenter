import SwiftUI

// Flow popups (mirrors web features/flows/FlowModals.tsx). Presented via app.present(...).

struct MarkAsTakenModal: View {
    @Environment(AppState.self) private var app
    var name: String = ""
    @State private var mood = 3
    @State private var note = ""
    private let moods = ["😖", "😕", "😐", "🙂", "😄"]

    var body: some View {
        ModalCard(icon: "checkmark", iconBg: Theme.greenSoft, iconFg: Theme.green,
                  title: "Great! Medicine Taken", subtitle: name.isEmpty ? "Your dose has been recorded" : "\(name) marked as taken") {
            Text("How did you feel?").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.text)
                .frame(maxWidth: .infinity)
            HStack {
                ForEach(0..<5, id: \.self) { i in
                    Button { mood = i } label: {
                        Text(moods[i]).font(.system(size: 22))
                            .frame(width: 44, height: 44)
                            .background(mood == i ? Theme.brandSoft : Color.clear)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(mood == i ? Theme.brand500 : .clear, lineWidth: 2))
                    }
                    if i < 4 { Spacer() }
                }
            }
            .padding(.vertical, 8)
            Button { app.dismissModal() } label: {
                Text("Done").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct AddMedicationModal: View {
    @State private var name = ""
    @State private var dosage = ""
    @State private var schedule = true
    var body: some View {
        ModalCard(icon: "pills", title: "Add New Medication", subtitle: "Enter your medicine details") {
            ModalField(label: "Medication Name", text: $name)
            ModalField(label: "Dosage", text: $dosage)
            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Add to Schedule").font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                    Text("Get reminders for this medicine").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                }
                Spacer()
                Toggle("", isOn: $schedule).labelsHidden().tint(Theme.brand500)
            }
            .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 12)
            ModalActions(primaryLabel: "Save Medication")
        }
    }
}

struct SetReminderModal: View {
    var name: String = ""
    @State private var days = [true, true, true, true, true, false, false]
    private let labels = ["M", "T", "W", "T", "F", "S", "S"]
    var body: some View {
        ModalCard(icon: "alarm", title: "Set Reminder Time", subtitle: name.isEmpty ? "Choose when to be reminded" : name) {
            Text("08:30 AM").font(.system(size: 30, weight: .heavy)).foregroundStyle(Theme.brand500)
                .frame(maxWidth: .infinity).padding(.vertical, 8)
            Text("Repeat").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                ForEach(0..<7, id: \.self) { i in
                    Button { days[i].toggle() } label: {
                        Text(labels[i]).font(.system(size: 13, weight: .bold))
                            .foregroundStyle(days[i] ? .white : Theme.textMuted)
                            .frame(width: 36, height: 36)
                            .background(days[i] ? Theme.brand500 : Theme.surface2).clipShape(Circle())
                    }
                    if i < 6 { Spacer() }
                }
            }
            .padding(.vertical, 8)
            ModalActions(primaryLabel: "Save Reminder")
        }
    }
}

struct DeleteModal: View {
    var name: String = ""
    var body: some View {
        ModalCard(icon: "trash", iconBg: Theme.redSoft, iconFg: Theme.red,
                  title: "Delete", subtitle: name.isEmpty ? "This action cannot be undone" : "Remove \(name)?") {
            Text("This will permanently remove the medicine and all its reminders.")
                .font(.system(size: 12.5)).foregroundStyle(Theme.red)
                .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.redSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 12)
            ModalActions(primaryLabel: "Delete", primaryColor: AnyShapeStyle(Theme.red))
        }
    }
}

struct MedicationOptionsModal: View {
    @Environment(AppState.self) private var app
    let name: String
    var body: some View {
        ModalCard(icon: "pills", title: name, subtitle: "Choose an action") {
            VStack(spacing: 8) {
                optionButton("checkmark", "Mark as Taken", Theme.greenSoft, Theme.green) { app.present(MarkAsTakenModal(name: name)) }
                optionButton("bell.badge", "Set Reminder", Theme.brandSoft, Theme.brand500) { app.present(SetReminderModal(name: name)) }
                optionButton("pencil", "Edit Medication", Theme.surface2, Theme.text) { app.present(AddMedicationModal()) }
                optionButton("trash", "Delete", Theme.redSoft, Theme.red) { app.present(DeleteModal(name: name)) }
            }
        }
    }
    private func optionButton(_ icon: String, _ title: String, _ bg: Color, _ fg: Color, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.system(size: 17))
                Text(title).font(.system(size: 14, weight: .semibold))
                Spacer()
            }
            .foregroundStyle(fg).padding(.horizontal, 14).padding(.vertical, 12)
            .background(bg).clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct ReorderModal: View {
    let name: String
    @State private var qty = 30
    var body: some View {
        ModalCard(icon: "cart", title: "Reorder Medicine", subtitle: name) {
            HStack {
                Text("Quantity").font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                Spacer()
                Button { qty = max(1, qty - 1) } label: { Image(systemName: "minus").frame(width: 32, height: 32).background(Theme.surface).clipShape(Circle()) }
                Text("\(qty)").font(.system(size: 16, weight: .bold)).frame(width: 32)
                Button { qty += 1 } label: { Image(systemName: "plus").foregroundStyle(.white).frame(width: 32, height: 32).background(Theme.brand500).clipShape(Circle()) }
            }
            .foregroundStyle(Theme.brand500)
            .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.bottom, 12)
            ModalActions(primaryLabel: "Place Order")
        }
    }
}
