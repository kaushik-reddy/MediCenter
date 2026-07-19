import SwiftUI

/// Travel Mode Setup — full-screen 4-step wizard with the top step timeline.
/// Mirrors web features/flows/TravelModeWizard.tsx.
struct TravelModeWizardView: View {
    @Environment(AppState.self) private var app

    @State private var step = 0
    @State private var dest = "Dubai, UAE"
    @State private var from = "May 20, 2025"
    @State private var to = "May 27, 2025"
    @State private var zone = "(GMT +4:00) Gulf Standard Time"
    @State private var behavior = "local"
    @State private var notifyBefore = true
    @State private var autoDisable = true

    private let steps = [
        FlowStep(icon: "mappin.and.ellipse", label: "Destination"),
        FlowStep(icon: "globe", label: "Time Zone"),
        FlowStep(icon: "checkmark.seal", label: "Review"),
        FlowStep(icon: "airplane", label: "Confirm"),
    ]
    private let zones: [(z: String, city: String)] = [
        ("(GMT +4:00) Gulf Standard Time", "Dubai, UAE"),
        ("(GMT +3:00) Moscow Standard Time", "Moscow, Russia"),
        ("(GMT +1:00) Central European Time", "Paris, France"),
        ("(GMT -5:00) Eastern Time", "New York, USA"),
    ]
    private var isLast: Bool { step == steps.count - 1 }

    var body: some View {
        WizardScaffold(
            title: "Travel Mode Setup", subtitle: "Configure your travel preferences",
            steps: steps, step: $step, isLast: isLast, finishLabel: "Done"
        ) {
            content
        }
    }

    @ViewBuilder private var content: some View {
        switch step {
        case 0: destinationStep
        case 1: timeZoneStep
        case 2: reviewStep
        default: confirmStep
        }
    }

    private var destinationStep: some View {
        VStack(spacing: 0) {
            WizardPanel {
                WizardStepHead(icon: "mappin.and.ellipse", title: "Where are you going?", sub: "Select your destination to adjust reminders")
                HStack(spacing: 8) {
                    Image(systemName: "mappin.and.ellipse").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(dest.isEmpty ? "Destination" : dest).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                        Text("United Arab Emirates").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12).padding(.vertical, 10)
                .background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
            }
            WizardPanel {
                HStack(spacing: 8) {
                    Image(systemName: "calendar").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                    Text("Travel Dates").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                }
                HStack(spacing: 8) {
                    WizardField(label: "From", placeholder: "", text: $from)
                    WizardField(label: "To", placeholder: "", text: $to)
                }
            }
            WizardPanel {
                HStack(spacing: 8) {
                    Image(systemName: "globe").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                    Text("Time Zone").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                }
                WizardMenu($zone, zones.map { $0.z })
            }
            WizardPanel {
                HStack(spacing: 8) {
                    Image(systemName: "clock").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                    Text("Reminder Behavior").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                }
                radioRow(on: behavior == "local", title: "Adjust to local time", sub: "Reminders shown at your usual times in the new time zone") { behavior = "local" }
                radioRow(on: behavior == "home", title: "Keep home time", sub: "Reminders follow your home time zone (GMT +5:30)") { behavior = "home" }
            }
            WizardPanel {
                Text("Additional Options").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.text)
                optionToggle(icon: "bell", title: "Notify me before travel", sub: "Get a reminder to prepare before you leave", isOn: $notifyBefore)
                optionToggle(icon: "arrow.counterclockwise", title: "Auto disable on return", sub: "Turn off Travel Mode when I return home", isOn: $autoDisable)
            }
        }
    }

    private var timeZoneStep: some View {
        WizardPanel {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").font(.system(size: 14)).foregroundStyle(Theme.textFaint)
                Text("Search time zone or city").font(.system(size: 13)).foregroundStyle(Theme.textFaint)
                Spacer()
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
            ForEach(zones, id: \.z) { z in
                let on = zone == z.z
                Button { zone = z.z } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().strokeBorder(on ? Theme.brand500 : Theme.border, lineWidth: 2).frame(width: 20, height: 20)
                            if on { Circle().fill(Theme.brand500).frame(width: 11, height: 11) }
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            Text(z.z).font(.system(size: 13, weight: .bold)).foregroundStyle(on ? Theme.brand500 : Theme.text)
                            Text(z.city).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 12).padding(.vertical, 10)
                    .background(on ? Theme.brandSoft : Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(on ? Theme.brand500.opacity(0.5) : Theme.border, lineWidth: 1))
                }
            }
        }
    }

    private var reviewStep: some View {
        WizardPanel {
            Text("Review Your Settings").font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
            Text("Please review your travel details").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
            VStack(spacing: 0) {
                reviewRow("mappin.and.ellipse", dest.isEmpty ? "Destination" : dest, "United Arab Emirates")
                reviewRow("calendar", "\(from) - \(to)", "7 days")
                reviewRow("globe", zone, "Time Zone")
                reviewRow("clock", behavior == "local" ? "Adjust to local time" : "Keep home time", "Reminder Behavior")
            }
        }
    }

    private var confirmStep: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                Circle().fill(Theme.brandGradient).frame(width: 80, height: 80)
                    .overlay(Image(systemName: "airplane").font(.system(size: 32)).foregroundStyle(.white))
                Image(systemName: "checkmark").font(.system(size: 15, weight: .bold)).foregroundStyle(.white)
                    .frame(width: 30, height: 30).background(Theme.green).clipShape(Circle())
                    .overlay(Circle().strokeBorder(Theme.bg, lineWidth: 4))
            }
            .padding(.top, 24).padding(.bottom, 16)
            Text("You're all set!").font(.system(size: 19, weight: .heavy)).foregroundStyle(Theme.text)
            Text("Travel Mode is active. We'll adjust your reminders to \(zone).")
                .font(.system(size: 12.5)).foregroundStyle(Theme.textMuted)
                .multilineTextAlignment(.center).frame(maxWidth: 240).padding(.top, 4)
            HStack(spacing: 8) {
                Image(systemName: "clock").font(.system(size: 15)).foregroundStyle(Theme.green)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Active until \(to)").font(.system(size: 12.5, weight: .bold)).foregroundStyle(Theme.green)
                    Text("You'll be notified before your travel ends.").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12).padding(.vertical, 12)
            .background(Theme.greenSoft).clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: Helpers
    private func radioRow(on: Bool, title: String, sub: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().strokeBorder(on ? Theme.brand500 : Theme.border, lineWidth: 2).frame(width: 20, height: 20)
                    if on { Circle().fill(Theme.brand500).frame(width: 11, height: 11) }
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(.system(size: 13, weight: .bold)).foregroundStyle(on ? Theme.brand500 : Theme.text)
                    Text(sub).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(on ? Theme.brandSoft : Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(on ? Theme.brand500.opacity(0.5) : Theme.border, lineWidth: 1))
        }
    }

    private func optionToggle(icon: String, title: String, sub: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(Theme.brand500)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                Text(sub).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 4)
            Toggle("", isOn: isOn).labelsHidden().tint(Theme.brand500)
        }
        .padding(.horizontal, 12).padding(.vertical, 8)
        .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func reviewRow(_ icon: String, _ title: String, _ sub: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Theme.textFaint)
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text).lineLimit(1)
                Text(sub).font(.system(size: 10.5)).foregroundStyle(Theme.textMuted)
            }
            Spacer()
        }
        .padding(.vertical, 9)
        .overlay(Rectangle().fill(Theme.border).frame(height: 1), alignment: .top)
    }
}
