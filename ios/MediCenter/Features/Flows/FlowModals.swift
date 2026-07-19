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
    @State private var step = 0
    @State private var name = ""
    @State private var dosage = ""
    @State private var schedule = true
    private let steps = [FlowStep(icon: "pills", label: "Details"),
                         FlowStep(icon: "bell.badge", label: "Schedule")]
    var body: some View {
        StepFlow(title: "Add Medication", steps: steps, step: $step,
                 finishLabel: "Save Medication", canProceed: step == 0 ? !name.isEmpty : true) { i in
            if i == 0 {
                VStack(spacing: 0) {
                    ModalField(label: "Medication Name", text: $name)
                    ModalField(label: "Dosage", text: $dosage)
                }
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Add to Schedule").font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                        Text("Get reminders for this medicine").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                    Toggle("", isOn: $schedule).labelsHidden().tint(Theme.brand500)
                }
                .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct SetReminderModal: View {
    var name: String = ""
    var med: Medication? = nil
    @State private var step = 0
    @State private var days = [true, true, true, true, true, false, false]
    private let labels = ["M", "T", "W", "T", "F", "S", "S"]
    private let steps = [FlowStep(icon: "clock", label: "Time"),
                         FlowStep(icon: "calendar", label: "Repeat")]
    var body: some View {
        StepFlow(title: name.isEmpty ? "Set Reminder" : name, steps: steps, step: $step,
                 finishLabel: "Save Reminder", onFinish: { scheduleReminder() }) { i in
            if i == 0 {
                VStack(spacing: 4) {
                    Text(med?.time ?? "08:30 AM").font(.system(size: 30, weight: .heavy)).foregroundStyle(Theme.brand500)
                    Text("Tap Next to choose repeat days").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 8)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Repeat on").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.textMuted)
                    HStack {
                        ForEach(0..<7, id: \.self) { d in
                            Button { days[d].toggle() } label: {
                                Text(labels[d]).font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(days[d] ? .white : Theme.textMuted)
                                    .frame(width: 36, height: 36)
                                    .background(days[d] ? Theme.brand500 : Theme.surface2).clipShape(Circle())
                            }
                            if d < 6 { Spacer() }
                        }
                    }
                }
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
            ModalActions(primaryLabel: "Delete", primaryColor: AnyShapeStyle(Theme.red)) {
                if !name.isEmpty {
                    if let med = MedStore.shared.find(name: name) {
                        NotificationManager.shared.cancelReminders(for: med)
                    }
                    MedStore.shared.remove(name: name)
                }
            }
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
    @State private var active = "All"
    private let chips = ["All", "Tablet", "Capsule", "Syrup", "Before Food", "After Food", "Morning", "Night"]

    var body: some View {
        ModalCard(icon: "slider.horizontal.3", title: "Filter", subtitle: "Refine your medicine list") {
            FlowWrapChips(options: chips, selection: $active)
                .padding(.bottom, 16)
            ModalActions(primaryLabel: "Apply Filters", secondaryLabel: "Reset")
        }
    }
}

/// Single-select wrapping chip row used across the filter/period popups.
struct FlowWrapChips: View {
    let options: [String]
    @Binding var selection: String

    var body: some View {
        FlowLayout(spacing: 8, lineSpacing: 8) {
            ForEach(options, id: \.self) { opt in
                let on = selection == opt
                Button { selection = opt } label: {
                    Text(opt)
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundStyle(on ? Color.white : Theme.textMuted)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(on ? AnyShapeStyle(Theme.brand500) : AnyShapeStyle(Theme.surface2))
                        .clipShape(Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Skip / Snooze / Reschedule / Dose actions

struct ConfirmSkipModal: View {
    var body: some View {
        ModalCard(icon: "exclamationmark.triangle.fill", iconBg: Theme.amberSoft, iconFg: Theme.amber,
                  title: "Are you sure?", subtitle: "Do you want to skip this dose?") {
            Text("Skipping doses may affect your treatment. This will be recorded in your history.")
                .font(.system(size: 12.5)).foregroundStyle(Theme.amber)
                .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.amberSoft).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.bottom, 12)
            ModalActions(primaryLabel: "Skip Dose", secondaryLabel: "Go Back", primaryColor: AnyShapeStyle(Theme.amber))
        }
    }
}

struct SnoozeModal: View {
    var name: String = ""
    @State private var choice = "15 minutes"
    private let opts = ["5 minutes", "15 minutes", "30 minutes", "1 hour", "Custom"]
    var body: some View {
        ModalCard(icon: "moon.fill", title: "Snooze Reminder",
                  subtitle: name.isEmpty ? "Remind me again in" : "Remind me about \(name) in") {
            ModalChoiceList(options: opts, choice: $choice)
            ModalActions(primaryLabel: "Snooze")
        }
    }
}

struct RescheduleDoseModal: View {
    var name: String = ""
    var current: String = ""
    @State private var hh = "09"
    @State private var mm = "00"
    @State private var ap = "AM"
    private let hours = (1...12).map { String(format: "%02d", $0) }
    private let mins = stride(from: 0, through: 55, by: 5).map { String(format: "%02d", $0) }

    var body: some View {
        ModalCard(icon: "calendar.badge.clock", title: "Reschedule Dose",
                  subtitle: name.isEmpty ? "Pick a new time for today" : name) {
            HStack(spacing: 8) {
                TimeBox(value: $hh, options: hours)
                Text(":").font(.system(size: 24, weight: .bold)).foregroundStyle(Theme.text)
                TimeBox(value: $mm, options: mins)
                TimeBox(value: $ap, options: ["AM", "PM"])
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
            .onAppear { applyCurrent() }
            ModalActions(primaryLabel: "Reschedule")
        }
    }

    private func applyCurrent() {
        // Parse "09:30 PM"
        let parts = current.uppercased().split(whereSeparator: { $0 == ":" || $0 == " " })
        if parts.count >= 3 {
            hh = String(parts[0]).count == 1 ? "0" + parts[0] : String(parts[0])
            mm = String(parts[1])
            ap = String(parts[2])
        }
    }
}

private struct TimeBox: View {
    @Binding var value: String
    let options: [String]
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { o in
                Button(o) { value = o }
            }
        } label: {
            Text(value)
                .font(.system(size: 22, weight: .bold)).foregroundStyle(Theme.text)
                .frame(width: 64, height: 56)
                .background(Theme.surface2)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}

struct DoseActionsModal: View {
    @Environment(AppState.self) private var app
    let name: String
    var time: String = ""
    var med: Medication? = nil
    var body: some View {
        ModalCard(icon: "pills", title: name, subtitle: time.isEmpty ? "Choose an action" : "Scheduled for \(time)") {
            VStack(spacing: 8) {
                optionRow("checkmark", "Mark as Taken", Theme.greenSoft, Theme.green) { app.present(MarkAsTakenModal(name: name)) }
                optionRow("moon.fill", "Snooze", Theme.brandSoft, Theme.brand500) { app.present(SnoozeModal(name: name)) }
                optionRow("calendar.badge.clock", "Reschedule", Theme.amberSoft, Theme.amber) { app.present(RescheduleDoseModal(name: name, current: time)) }
                optionRow("forward.end.fill", "Skip Dose", Theme.amberSoft, Color(hex: "F97316")) { app.present(ConfirmSkipModal()) }
            }
        }
    }
    private func optionRow(_ icon: String, _ title: String, _ bg: Color, _ fg: Color, _ action: @escaping () -> Void) -> some View {
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

// MARK: - Reminders / notifications

struct NotificationChannelsModal: View {
    @State private var ch: [String: Bool] = ["Push": true, "Email": true, "WhatsApp": true, "SMS": false, "Phone Call": false]
    private let order = ["Push", "Email", "WhatsApp", "SMS", "Phone Call"]
    var body: some View {
        ModalCard(icon: "bell.badge", title: "Notification Channels", subtitle: "How should we reach you?") {
            VStack(spacing: 8) {
                ForEach(order, id: \.self) { k in
                    HStack {
                        Text(k).font(.system(size: 14, weight: .semibold)).foregroundStyle(Theme.text)
                        Spacer()
                        Toggle("", isOn: Binding(get: { ch[k] ?? false }, set: { ch[k] = $0 })).labelsHidden().tint(Theme.brand500)
                    }
                    .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            Text("You'll always receive critical alerts even if channels are turned off.")
                .font(.system(size: 11.5)).foregroundStyle(Theme.brand500)
                .padding(.horizontal, 12).padding(.vertical, 10).frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.vertical, 12)
            ModalActions(primaryLabel: "Save Preferences")
        }
    }
}

struct ReminderOptionsModal: View {
    @Environment(AppState.self) private var app
    let name: String
    var body: some View {
        ModalCard(icon: "alarm", title: name, subtitle: "Reminder options") {
            VStack(spacing: 8) {
                optionRow("clock", "Edit Time", Theme.brandSoft, Theme.brand500) { app.present(SetReminderModal(name: name)) }
                optionRow("moon.fill", "Snooze", Theme.surface2, Theme.text) { app.present(SnoozeModal()) }
                optionRow("bell.badge", "Notification Channels", Theme.surface2, Theme.text) { app.present(NotificationChannelsModal()) }
                optionRow("trash", "Delete Reminder", Theme.redSoft, Theme.red) { app.present(DeleteModal(name: name)) }
            }
        }
    }
    private func optionRow(_ icon: String, _ title: String, _ bg: Color, _ fg: Color, _ action: @escaping () -> Void) -> some View {
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

// MARK: - Generic info / period / date-range / logout

struct InfoModal: View {
    @Environment(AppState.self) private var app
    var icon: String = "bell.badge"
    let title: String
    let message: String
    var body: some View {
        ModalCard(icon: icon, title: title, subtitle: message) {
            Button { app.dismissModal() } label: {
                Text("Got it").font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.top, 2)
        }
    }
}

struct PeriodModal: View {
    var onSelect: ((String) -> Void)? = nil
    @State private var choice = "This Week"
    private let opts = ["Today", "This Week", "This Month", "Last 3 Months", "This Year"]
    var body: some View {
        ModalCard(icon: "clock", title: "Select Period", subtitle: "Choose a time range") {
            ModalChoiceList(options: opts, choice: $choice)
            ModalActions(primaryLabel: "Apply") { onSelect?(choice) }
        }
    }
}

struct DateRangeModal: View {
    @State private var from = ""
    @State private var to = ""
    var body: some View {
        ModalCard(icon: "clock", title: "Select Date Range", subtitle: "Filter by custom dates") {
            HStack(spacing: 12) {
                ModalField(label: "From", text: $from)
                ModalField(label: "To", text: $to)
            }
            ModalActions(primaryLabel: "Apply Range")
        }
    }
}

struct LogoutModal: View {
    var body: some View {
        ModalCard(icon: "rectangle.portrait.and.arrow.right", iconBg: Theme.redSoft, iconFg: Theme.red,
                  title: "Log Out", subtitle: "Are you sure you want to log out?") {
            ModalActions(primaryLabel: "Log Out", primaryColor: AnyShapeStyle(Theme.red))
        }
    }
}

struct SendReminderModal: View {
    var name: String = ""
    @State private var message = "Time for your medicine! Please don't forget to take it."
    var body: some View {
        ModalCard(icon: "paperplane", title: "Send Reminder", subtitle: name.isEmpty ? "Send a gentle nudge" : "Remind \(name)") {
            VStack(alignment: .leading, spacing: 6) {
                Text("Message").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.textMuted)
                TextField("", text: $message, axis: .vertical).lineLimit(2...4).font(.system(size: 13.5))
                    .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.bottom, 12)
            ModalActions(primaryLabel: "Send Reminder")
        }
    }
}

struct InteractionResultModal: View {
    var body: some View {
        ModalCard(icon: "exclamationmark.triangle.fill", iconBg: Theme.redSoft, iconFg: Theme.red,
                  title: "High Risk Interaction", subtitle: "Paracetamol + Ibuprofen") {
            VStack(alignment: .leading, spacing: 10) {
                Text("Taking these together may increase the risk of stomach irritation and bleeding. Consult your doctor before combining.")
                    .font(.system(size: 12.5)).foregroundStyle(Theme.text)
                    .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.redSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                resultRow("clock", "Space doses at least 6 hours apart")
                resultRow("fork.knife", "Always take with food")
                resultRow("stethoscope", "Consult your physician")
            }
            .padding(.bottom, 12)
            ModalActions(primaryLabel: "Got it", secondaryLabel: "Close")
        }
    }
    private func resultRow(_ icon: String, _ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Theme.brand500)
            Text(text).font(.system(size: 12.5)).foregroundStyle(Theme.text)
            Spacer(minLength: 0)
        }
    }
}

struct ExportReportModal: View {
    @State private var format = "PDF"
    private let formats = ["PDF", "CSV", "Image"]
    var body: some View {
        ModalCard(icon: "arrow.down.circle", title: "Export Report", subtitle: "Choose a format to download") {
            FlowWrapChips(options: formats, selection: $format).padding(.bottom, 14)
            ModalActions(primaryLabel: "Export \(format)")
        }
    }
}

struct ShareReportModal: View {
    private let targets: [(String, String)] = [("envelope", "Email"), ("message", "Message"), ("doc.on.doc", "Copy Link"), ("square.and.arrow.up", "More")]
    var body: some View {
        ModalCard(icon: "square.and.arrow.up", title: "Share Report", subtitle: "Send your health report") {
            HStack(spacing: 10) {
                ForEach(targets, id: \.1) { t in
                    VStack(spacing: 6) {
                        Image(systemName: t.0).font(.system(size: 18)).foregroundStyle(Theme.brand500)
                            .frame(width: 48, height: 48).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 14))
                        Text(t.1).font(.system(size: 10.5, weight: .medium)).foregroundStyle(Theme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 12)
            ModalActions(primaryLabel: "Done", secondaryLabel: "Cancel")
        }
    }
}

struct AddCaregiverModal: View {
    @State private var name = ""
    @State private var relation = ""
    var body: some View {
        ModalCard(icon: "person.badge.plus", title: "Add Person", subtitle: "Connect with a loved one") {
            ModalField(label: "Name", text: $name)
            ModalField(label: "Relationship", text: $relation)
            ModalActions(primaryLabel: "Send Invite")
        }
    }
}

struct LanguageModal: View {
    @State private var choice = "English"
    private let langs = ["English", "हिन्दी", "Español", "Français", "العربية", "中文"]
    var body: some View {
        ModalCard(icon: "globe", title: "Language", subtitle: "Choose your language") {
            VStack(spacing: 6) {
                ForEach(langs, id: \.self) { l in
                    let on = choice == l
                    Button { choice = l } label: {
                        HStack {
                            Text(l).font(.system(size: 14, weight: .semibold))
                            Spacer()
                            if on { Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)) }
                        }
                        .foregroundStyle(on ? Theme.brand500 : Theme.text)
                        .padding(.horizontal, 14).padding(.vertical, 12)
                        .background(on ? Theme.brandSoft : Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.bottom, 8)
            ModalActions(primaryLabel: "Apply")
        }
    }
}

struct UnitsModal: View {
    @State private var weight = "kg"
    @State private var temp = "°C"
    var body: some View {
        ModalCard(icon: "ruler", title: "Units", subtitle: "Measurement preferences") {
            unitRow("Weight", ["kg", "lb"], $weight)
            unitRow("Temperature", ["°C", "°F"], $temp)
            ModalActions(primaryLabel: "Save")
        }
    }
    private func unitRow(_ label: String, _ options: [String], _ value: Binding<String>) -> some View {
        HStack {
            Text(label).font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
            Spacer()
            HStack(spacing: 4) {
                ForEach(options, id: \.self) { o in
                    let on = value.wrappedValue == o
                    Button { value.wrappedValue = o } label: {
                        Text(o).font(.system(size: 12.5, weight: .bold))
                            .foregroundStyle(on ? .white : Theme.textMuted)
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(on ? AnyShapeStyle(Theme.brand500) : AnyShapeStyle(Theme.surface2)).clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.vertical, 6).padding(.bottom, 6)
    }
}

// MARK: - Inventory: Add Stock / Scan pack

struct AddStockModal: View {
    var name: String = ""
    @State private var qty = 30
    @State private var purchaseDate = ""
    @State private var note = ""
    var body: some View {
        ModalCard(icon: "plus.circle", title: "Add Stock", subtitle: name.isEmpty ? "Update your inventory" : name) {
            HStack {
                Text("Quantity").font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                Spacer()
                Button { qty = max(1, qty - 1) } label: { Image(systemName: "minus").foregroundStyle(Theme.brand500).frame(width: 32, height: 32).background(Theme.surface).clipShape(Circle()) }
                Text("\(qty)").font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text).frame(width: 40)
                Button { qty += 1 } label: { Image(systemName: "plus").foregroundStyle(.white).frame(width: 32, height: 32).background(Theme.brand500).clipShape(Circle()) }
            }
            .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.bottom, 10)
            ModalField(label: "Purchase Date", text: $purchaseDate)
            ModalField(label: "Note (Optional)", text: $note)
            ModalActions(primaryLabel: "Add to Inventory")
        }
    }
}

struct ScanMedicineModal: View {
    @State private var scanned = false
    var body: some View {
        ModalCard(icon: "camera.viewfinder", title: "Scan Medicine Pack", subtitle: scanned ? "We found a match" : "Point your camera at the pack") {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Theme.surface2)
                    .frame(height: 150)
                RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.brand500, style: StrokeStyle(lineWidth: 2, dash: [8]))
                    .frame(width: 170, height: 110)
                Image(systemName: scanned ? "checkmark.circle.fill" : "viewfinder")
                    .font(.system(size: 40)).foregroundStyle(scanned ? Theme.green : Theme.brand500)
            }
            .padding(.bottom, 10)

            if scanned {
                HStack(spacing: 12) {
                    Image(systemName: "pills").font(.system(size: 20)).foregroundStyle(Theme.brand500)
                        .frame(width: 44, height: 44).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Paracetamol 650mg").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        Text("Tablet · 20 in pack · Exp 08/2027").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                    }
                    Spacer(minLength: 0)
                }
                .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.bottom, 10)
                ModalActions(primaryLabel: "Add to Inventory")
            } else {
                Button { withAnimation { scanned = true } } label: {
                    HStack(spacing: 8) { Image(systemName: "camera"); Text("Scan Now").font(.system(size: 14, weight: .bold)) }
                        .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 2)
            }
        }
    }
}

/// Vertical single-select list (checkmark on the chosen row) used by Snooze / Period.
private struct ModalChoiceList: View {
    let options: [String]
    @Binding var choice: String
    var body: some View {
        VStack(spacing: 6) {
            ForEach(options, id: \.self) { o in
                let on = choice == o
                Button { choice = o } label: {
                    HStack {
                        Text(o).font(.system(size: 14, weight: .semibold))
                        Spacer()
                        if on { Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)) }
                    }
                    .foregroundStyle(on ? Theme.brand500 : Theme.text)
                    .padding(.horizontal, 14).padding(.vertical, 12)
                    .background(on ? Theme.brandSoft : Theme.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.bottom, 8)
    }
}
