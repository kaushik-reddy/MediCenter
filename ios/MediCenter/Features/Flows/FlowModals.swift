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
            Button { app.dismissModal(); LiveActivityManager.shared.end() } label: {
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
    var med: Medication? = nil
    @State private var days = [true, true, true, true, true, false, false]
    private let labels = ["M", "T", "W", "T", "F", "S", "S"]
    var body: some View {
        ModalCard(icon: "alarm", title: "Set Reminder Time", subtitle: name.isEmpty ? "Choose when to be reminded" : name) {
            Text(med?.time ?? "08:30 AM").font(.system(size: 30, weight: .heavy)).foregroundStyle(Theme.brand500)
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
            ModalActions(primaryLabel: "Save Reminder") {
                scheduleReminder()
            }
        }
    }

    /// Schedules the lock-screen reminder chain and starts the Dynamic Island countdown.
    private func scheduleReminder() {
        let target = med ?? MedicationsData.find(name: name)
        guard let target else { return }
        NotificationManager.shared.scheduleDoseReminders(for: target, leadMinutes: 60)
        NotificationManager.shared.fireDoseDue(for: target, after: 5) // visible test alert
        if let next = NotificationManager.nextDoseDate(for: target) {
            LiveActivityManager.shared.startCountdown(med: target, at: next)
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
    var med: Medication? = nil
    var body: some View {
        ModalCard(icon: "pills", title: name, subtitle: "Choose an action") {
            VStack(spacing: 8) {
                optionButton("checkmark", "Mark as Taken", Theme.greenSoft, Theme.green) { app.present(MarkAsTakenModal(name: name)) }
                optionButton("bell.badge", "Set Reminder", Theme.brandSoft, Theme.brand500) { app.present(SetReminderModal(name: name, med: med)) }
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

struct FilterModal: View {
    @State private var food: String? = nil
    @State private var timeOfDay: String? = nil
    @State private var sched: String? = nil
    private let foods = ["Before Food", "After Food", "Before Bed"]
    private let times = ["Morning", "Afternoon", "Evening", "Night"]
    private let scheds = ["Everyday", "Weekdays", "Custom"]

    var body: some View {
        ModalCard(icon: "slider.horizontal.3", title: "Filter", subtitle: "Narrow down your list") {
            filterGroup("Food", options: foods, selection: $food)
            filterGroup("Time of Day", options: times, selection: $timeOfDay)
            filterGroup("Schedule", options: scheds, selection: $sched)
            ModalActions(primaryLabel: "Apply Filters") {
                food = nil; timeOfDay = nil; sched = nil
            }
        }
    }

    private func filterGroup(_ label: String, options: [String], selection: Binding<String?>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
            FlowChips(options: options, selection: selection)
        }
        .padding(.bottom, 14)
    }
}

private struct FlowChips: View {
    let options: [String]
    @Binding var selection: String?

    var body: some View {
        HStack(spacing: 8) {
            ForEach(options, id: \.self) { opt in
                let active = selection == opt
                Button {
                    selection = active ? nil : opt
                } label: {
                    Text(opt)
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundStyle(active ? Color.white : Theme.textMuted)
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(active ? AnyShapeStyle(Theme.brand500) : AnyShapeStyle(Theme.surface2))
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
