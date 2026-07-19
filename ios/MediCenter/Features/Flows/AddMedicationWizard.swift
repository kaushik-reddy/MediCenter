import SwiftUI

/// Add Medication — full-screen 5-step wizard (mirrors web AddMedicationWizard.tsx).
struct AddMedicationWizardView: View {
    @Environment(AppState.self) private var app

    @State private var step = 0
    @State private var name = ""
    @State private var purpose = ""
    @State private var form = "Tablet"
    @State private var strength = ""
    @State private var unit = "mg"
    @State private var how = "After Food"
    @State private var instructions = ""
    @State private var freq = "Every Day"
    @State private var times = ["08:30 AM", "02:30 PM", "08:30 PM"]
    @State private var stock = 20
    @State private var refill = true

    private let steps = ["Medicine Details", "Dosage & Form", "Frequency", "Reminder Times", "Stock & Refill", "Review & Save"]
    private let popular = ["Paracetamol", "Vitamin D3", "Calcium", "Ibuprofen", "B-Complex"]
    private let forms = ["Tablet", "Capsule", "Syrup", "Injection", "Other"]
    private let hows = ["Before Food", "After Food", "With Food"]
    private let freqs = ["Every Day", "Alternate Days", "Weekly", "Custom Days", "Custom Schedule"]

    private var isLast: Bool { step == 4 }

    private let wizardSteps = [
        FlowStep(icon: "magnifyingglass", label: "Details"),
        FlowStep(icon: "pills", label: "Dosage"),
        FlowStep(icon: "calendar", label: "Frequency"),
        FlowStep(icon: "bell", label: "Reminders"),
        FlowStep(icon: "shippingbox", label: "Stock"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            StepTimeline(steps: wizardSteps, current: step)
                .padding(.horizontal, 16).padding(.bottom, 12)
            ScrollView {
                stepContent.padding(.horizontal, 16).padding(.top, 2).padding(.bottom, 16)
            }
            footer
        }
        .background(Theme.bg.ignoresSafeArea())
    }

    // MARK: Header
    private var header: some View {
        HStack(spacing: 10) {
            Button { step > 0 ? (step -= 1) : app.dismissFullScreen() } label: {
                Image(systemName: "arrow.left").font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.text).frame(width: 36, height: 36)
                    .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Add New Medication").font(.system(size: 16, weight: .heavy)).foregroundStyle(Theme.text)
                Text("Step by step to set up your medicine").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 0)
            Button { app.dismissFullScreen() } label: {
                Image(systemName: "xmark").font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Theme.text).frame(width: 36, height: 36)
                    .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 10)
    }

    // MARK: Step content
    @ViewBuilder private var stepContent: some View {
        switch step {
        case 0: step1
        case 1: step2
        case 2: step3
        case 3: step4
        default: step5
        }
    }

    private var step1: some View {
        VStack(alignment: .leading, spacing: 12) {
            panel {
                stepHead("magnifyingglass", "Medicine Details", "Search or enter your medicine name")
                fieldBox { TextField("Search medicine", text: $name).font(.system(size: 13.5)) }
                Text("Popular Medicines").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.text)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(popular, id: \.self) { p in
                            Button { name = p } label: {
                                Text(p).font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(name == p ? Theme.brand500 : Theme.textMuted)
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(name == p ? Theme.brandSoft : Theme.surface2)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            panel {
                Text("Medicine Name").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
                fieldBox { TextField("e.g. Paracetamol 650mg", text: $name).font(.system(size: 13.5)) }
                Text("Purpose (Optional)").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
                fieldBox { TextField("Relieves pain and reduces fever.", text: $purpose, axis: .vertical).lineLimit(2...3).font(.system(size: 13.5)) }
            }
        }
    }

    private var step2: some View {
        VStack(alignment: .leading, spacing: 12) {
            panel {
                stepHead("pills", "Dosage & Form", "Enter how much and what form")
                Text("Form").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
                HStack(spacing: 6) {
                    ForEach(forms, id: \.self) { f in
                        Button { form = f } label: {
                            Text(f).font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(form == f ? Theme.brand500 : Theme.textMuted)
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                                .background(form == f ? Theme.brandSoft : Theme.surface2)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                Text("Strength").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
                HStack(spacing: 8) {
                    fieldBox { TextField("650", text: $strength).font(.system(size: 13.5)) }
                    fieldBox { TextField("mg", text: $unit).font(.system(size: 13.5)) }.frame(width: 90)
                }
                Text("How to take").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
                HStack(spacing: 6) {
                    ForEach(hows, id: \.self) { h in
                        Button { how = h } label: {
                            Text(h).font(.system(size: 10.5, weight: .semibold))
                                .foregroundStyle(how == h ? Theme.brand500 : Theme.textMuted)
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                                .background(how == h ? Theme.brandSoft : Theme.surface2)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
        }
    }

    private var step3: some View {
        panel {
            stepHead("calendar", "Frequency", "How often do you take this medicine?")
            ForEach(freqs, id: \.self) { f in
                Button { freq = f } label: {
                    HStack {
                        Text(f).font(.system(size: 13.5, weight: .bold)).foregroundStyle(freq == f ? Theme.brand500 : Theme.text)
                        Spacer()
                        ZStack {
                            Circle().strokeBorder(freq == f ? Theme.brand500 : Theme.border, lineWidth: 2).frame(width: 20, height: 20)
                            if freq == f { Circle().fill(Theme.brand500).frame(width: 11, height: 11) }
                        }
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(freq == f ? Theme.brandSoft : Theme.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private var step4: some View {
        panel {
            stepHead("bell", "Reminder Times", "When do you want to be reminded?")
            ForEach(Array(times.enumerated()), id: \.offset) { i, t in
                HStack {
                    Image(systemName: i == 2 ? "moon.fill" : "sun.max.fill").foregroundStyle(i == 2 ? Theme.brand500 : Theme.amber)
                    Text(["Morning", "Afternoon", "Evening"][min(i, 2)]).font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                    Spacer()
                    Text(t).font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                    Button { times.remove(at: i) } label: { Image(systemName: "xmark").font(.system(size: 13)).foregroundStyle(Theme.textFaint) }
                }
                .padding(.horizontal, 12).padding(.vertical, 10).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var step5: some View {
        VStack(alignment: .leading, spacing: 12) {
            panel {
                stepHead("calendar.badge.checkmark", "Stock & Refill", "Manage your current stock")
                Text("Current Stock").font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
                HStack {
                    Button { stock = max(0, stock - 1) } label: { Image(systemName: "minus").frame(width: 32, height: 32).background(Theme.surface).clipShape(Circle()) }
                    Spacer()
                    Text("\(stock) Tablets").font(.system(size: 16, weight: .heavy)).foregroundStyle(Theme.text)
                    Spacer()
                    Button { stock += 1 } label: { Image(systemName: "plus").foregroundStyle(.white).frame(width: 32, height: 32).background(Theme.brand500).clipShape(Circle()) }
                }
                .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Refill Reminder").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.text)
                        Text("Remind me when stock is low").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                    Toggle("", isOn: $refill).labelsHidden().tint(Theme.brand500)
                }
                .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            panel {
                Text("Preview Summary").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                summaryRow("Medicine", name.isEmpty ? "—" : name)
                summaryRow("Form", form)
                summaryRow("Strength", strength.isEmpty ? "—" : "\(strength) \(unit)")
                summaryRow("How to take", how)
                summaryRow("Frequency", freq)
                summaryRow("Stock", "\(stock) Tablets")
            }
        }
    }

    // MARK: Footer
    private var footer: some View {
        HStack(spacing: 12) {
            Button { step > 0 ? (step -= 1) : app.dismissFullScreen() } label: {
                Text(step > 0 ? "Back" : "Cancel").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
            }
            Button {
                if isLast { app.dismissFullScreen() } else { step += 1 }
            } label: {
                HStack(spacing: 6) {
                    if isLast { Image(systemName: "checkmark") }
                    Text(isLast ? "Save Medication" : "Next")
                    if !isLast { Image(systemName: "arrow.right") }
                }
                .font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(step == 0 && name.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(step == 0 && name.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
        }
        .padding(16).overlay(Rectangle().fill(Theme.border).frame(height: 1), alignment: .top)
    }

    // MARK: Helpers
    @ViewBuilder private func panel<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) { content() }
            .padding(14).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }

    private func stepHead(_ icon: String, _ title: String, _ sub: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 16)).foregroundStyle(Theme.brand500)
                .frame(width: 40, height: 40).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                Text(sub).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 0)
        }
    }

    @ViewBuilder private func fieldBox<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content()
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 12.5)).foregroundStyle(Theme.textMuted)
            Spacer()
            Text(value).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
        }
        .padding(.vertical, 6)
    }
}
