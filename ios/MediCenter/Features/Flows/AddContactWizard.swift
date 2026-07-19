import SwiftUI

/// Add Emergency Contact — full-screen multi-step wizard with the top step timeline.
/// Mirrors web features/flows/AddContactWizard.tsx.
struct AddContactWizardView: View {
    @Environment(AppState.self) private var app

    @State private var step = 0
    @State private var name = ""
    @State private var rel = "Family"
    @State private var priority = "Primary"
    @State private var phone = ""
    @State private var altPhone = ""
    @State private var email = ""
    @State private var address = ""
    @State private var prefs: [String: Bool] = ["notify": true, "medical": true, "location": true]
    @State private var notes = ""

    private let steps = [
        FlowStep(icon: "person", label: "Personal"),
        FlowStep(icon: "phone", label: "Contact"),
        FlowStep(icon: "slider.horizontal.3", label: "Preferences"),
        FlowStep(icon: "checkmark.seal", label: "Review"),
    ]
    private let prefList: [(key: String, title: String, sub: String, icon: String)] = [
        ("notify", "Notify in Emergencies", "Send alerts and notifications", "bell"),
        ("medical", "Share Medical Information", "Share allergies, conditions & meds", "heart.text.square"),
        ("location", "Share Live Location", "Share your location during emergencies", "location"),
    ]
    private var isLast: Bool { step == steps.count - 1 }
    private var canProceed: Bool { step == 0 ? !name.trimmingCharacters(in: .whitespaces).isEmpty : true }

    var body: some View {
        VStack(spacing: 0) {
            header
            StepTimeline(steps: steps, current: step)
                .padding(.horizontal, 16).padding(.bottom, 12)
            ScrollView {
                content.padding(.horizontal, 16).padding(.top, 2).padding(.bottom, 16)
            }
            footer
        }
        .background(Theme.bg.ignoresSafeArea())
    }

    private var header: some View {
        HStack(spacing: 10) {
            Button { step > 0 ? (step -= 1) : app.dismissFullScreen() } label: {
                Image(systemName: "arrow.left").font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.text).frame(width: 36, height: 36)
                    .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(alignment: .leading, spacing: 1) {
                Text("Add Contact").font(.system(size: 16, weight: .heavy)).foregroundStyle(Theme.text)
                Text("Add an emergency contact").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
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

    @ViewBuilder private var content: some View {
        switch step {
        case 0: personalStep
        case 1: contactStep
        case 2: preferencesStep
        default: reviewStep
        }
    }

    private var personalStep: some View {
        panel {
            Text("Personal Information").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
            HStack {
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    Circle().fill(Theme.surface2).frame(width: 80, height: 80)
                        .overlay(Image(systemName: "person.fill").font(.system(size: 30)).foregroundStyle(Theme.textFaint))
                        .overlay(Circle().strokeBorder(Theme.surface, lineWidth: 4))
                    Image(systemName: "camera.fill").font(.system(size: 12)).foregroundStyle(.white)
                        .frame(width: 28, height: 28).background(Theme.brand500).clipShape(Circle())
                        .overlay(Circle().strokeBorder(Theme.surface, lineWidth: 2))
                }
                Spacer()
            }
            .padding(.vertical, 4)
            label("Full Name")
            fieldBox { TextField("Enter full name", text: $name).font(.system(size: 13.5)) }
            label("Relationship")
            menuBox($rel, ["Family", "Spouse", "Parent", "Sibling", "Friend", "Doctor", "Other"])
            label("Priority")
            menuBox($priority, ["Primary", "Secondary"])
            Text("Primary contacts are notified first").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
        }
    }

    private var contactStep: some View {
        panel {
            Text("Contact Information").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
            iconField("Phone Number", "phone", "+91 Enter phone number", $phone)
            iconField("Alternate Phone (Optional)", "phone", "Enter alternate number", $altPhone)
            iconField("Email (Optional)", "envelope", "Enter email address", $email)
            iconField("Address (Optional)", "mappin.and.ellipse", "Enter address", $address)
        }
    }

    private var preferencesStep: some View {
        panel {
            Text("Emergency Preferences").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
            ForEach(prefList, id: \.key) { p in
                let on = prefs[p.key] ?? false
                Button { prefs[p.key] = !on } label: {
                    HStack(spacing: 12) {
                        Image(systemName: p.icon).font(.system(size: 17)).foregroundStyle(on ? Theme.brand500 : Theme.textMuted)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(p.title).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                            Text(p.sub).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                        }
                        Spacer(minLength: 4)
                        ZStack {
                            RoundedRectangle(cornerRadius: 6).strokeBorder(on ? Theme.brand500 : Theme.border, lineWidth: 2).frame(width: 20, height: 20)
                            if on { RoundedRectangle(cornerRadius: 6).fill(Theme.brand500).frame(width: 20, height: 20)
                                Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundStyle(.white) }
                        }
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(on ? Theme.brandSoft : Theme.surface2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(on ? Theme.brand500.opacity(0.5) : Theme.border, lineWidth: 1))
                }
            }
            label("Additional Notes (Optional)")
            fieldBox { TextField("Add any additional notes about this contact", text: $notes, axis: .vertical).lineLimit(2...4).font(.system(size: 13.5)) }
        }
    }

    private var reviewStep: some View {
        panel {
            Text("Review & Save").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
            HStack(spacing: 12) {
                Circle().fill(Theme.brand500).frame(width: 48, height: 48)
                    .overlay(Text(name.isEmpty ? "C" : String(name.prefix(1))).font(.system(size: 20, weight: .bold)).foregroundStyle(.white))
                VStack(alignment: .leading, spacing: 1) {
                    Text(name.isEmpty ? "Contact" : name).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    Text(rel).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                }
                Spacer()
                Text(priority).font(.system(size: 10, weight: .semibold)).foregroundStyle(Theme.green)
                    .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.greenSoft).clipShape(Capsule())
            }
            .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(spacing: 0) {
                if !phone.isEmpty { reviewRow("phone", phone) }
                if !email.isEmpty { reviewRow("envelope", email) }
                if !address.isEmpty { reviewRow("mappin.and.ellipse", address) }
            }
            ForEach(prefList.filter { prefs[$0.key] ?? false }, id: \.key) { p in
                HStack(spacing: 6) {
                    Image(systemName: "checkmark").font(.system(size: 12, weight: .bold))
                    Text(p.title).font(.system(size: 12, weight: .medium))
                }
                .foregroundStyle(Theme.green)
            }
        }
    }

    private var footer: some View {
        HStack(spacing: 12) {
            Button { step > 0 ? (step -= 1) : app.dismissFullScreen() } label: {
                Text(step > 0 ? "Back" : "Cancel").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
            }
            Button { isLast ? app.dismissFullScreen() : (step += 1) } label: {
                HStack(spacing: 6) {
                    if isLast { Image(systemName: "checkmark") }
                    Text(isLast ? "Save Contact" : "Next")
                    if !isLast { Image(systemName: "arrow.right") }
                }
                .font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
                .opacity(canProceed ? 1 : 0.5)
            }
            .disabled(!canProceed)
        }
        .padding(16).overlay(Rectangle().fill(Theme.border).frame(height: 1), alignment: .top)
    }

    // MARK: Helpers
    @ViewBuilder private func panel<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) { content() }
            .padding(14).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }
    private func label(_ t: String) -> some View {
        Text(t).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder private func fieldBox<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        content().padding(.horizontal, 12).padding(.vertical, 10)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
    }
    private func iconField(_ lbl: String, _ icon: String, _ placeholder: String, _ text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            label(lbl)
            HStack(spacing: 8) {
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Theme.textFaint)
                TextField(placeholder, text: text).font(.system(size: 13.5))
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
        }
    }
    private func menuBox(_ value: Binding<String>, _ options: [String]) -> some View {
        Menu {
            ForEach(options, id: \.self) { o in Button(o) { value.wrappedValue = o } }
        } label: {
            HStack {
                Text(value.wrappedValue).font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.textMuted)
            }
            .padding(.horizontal, 12).padding(.vertical, 11)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
        }
    }
    private func reviewRow(_ icon: String, _ value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(Theme.textFaint)
            Text(value).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text).lineLimit(1)
            Spacer()
        }
        .padding(.vertical, 8)
        .overlay(Rectangle().fill(Theme.border).frame(height: 1), alignment: .top)
    }
}
