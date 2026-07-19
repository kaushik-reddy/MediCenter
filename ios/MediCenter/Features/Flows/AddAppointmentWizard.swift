import SwiftUI

/// Add Appointment — full-screen 4-step wizard with the top step timeline.
/// Mirrors web features/flows/AddAppointmentWizard.tsx.
struct AddAppointmentWizardView: View {
    @Environment(AppState.self) private var app

    @State private var step = 0
    @State private var doctor = ""
    @State private var spec = "General Physician"
    @State private var hospital = ""
    @State private var date = "24 May 2024"
    @State private var time = "11:30 AM"
    @State private var duration = "20 min"
    @State private var purpose = ""
    @State private var notes = ""

    private let steps = [
        FlowStep(icon: "stethoscope", label: "Doctor"),
        FlowStep(icon: "calendar", label: "Appointment"),
        FlowStep(icon: "doc.text", label: "Info"),
        FlowStep(icon: "checkmark.seal", label: "Review"),
    ]
    private var isLast: Bool { step == steps.count - 1 }
    private var canProceed: Bool { step == 0 ? !doctor.trimmingCharacters(in: .whitespaces).isEmpty : true }

    var body: some View {
        WizardScaffold(
            title: "Add Appointment", subtitle: "Book a doctor visit",
            steps: steps, step: $step, isLast: isLast, canProceed: canProceed,
            finishLabel: "Confirm Appointment"
        ) {
            content
        }
    }

    @ViewBuilder private var content: some View {
        switch step {
        case 0:
            WizardPanel {
                WizardStepHead(icon: "stethoscope", title: "Doctor Details", sub: "Who are you visiting?")
                WizardField(label: "Doctor Name", icon: "person", placeholder: "Search doctor name", text: $doctor)
                WizardLabel("Specialization")
                WizardMenu($spec, ["General Physician", "Cardiologist", "Dermatologist", "Orthopedic", "Dentist", "ENT", "Neurologist"])
                WizardField(label: "Hospital / Clinic", icon: "mappin.and.ellipse", placeholder: "Search hospital or clinic", text: $hospital)
            }
        case 1:
            WizardPanel {
                WizardStepHead(icon: "calendar", title: "Appointment Details", sub: "When is your visit?")
                WizardField(label: "Date", icon: "calendar", placeholder: "", text: $date)
                WizardField(label: "Time", icon: "clock", placeholder: "", text: $time)
                WizardLabel("Duration")
                WizardMenu($duration, ["15 min", "20 min", "30 min", "45 min", "1 hour"])
            }
        case 2:
            WizardPanel {
                WizardStepHead(icon: "doc.text", title: "Additional Information", sub: "Optional details for this visit")
                WizardField(label: "Purpose (Optional)", icon: nil, placeholder: "e.g. Follow-up, Consultation", text: $purpose)
                WizardLabel("Notes (Optional)")
                WizardTextArea(placeholder: "Add any notes for this visit", text: $notes)
            }
        default:
            WizardPanel {
                WizardStepHead(icon: nil, title: "Review & Confirm", sub: "Review your appointment details")
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 14).fill(Theme.brand500).frame(width: 44, height: 44)
                        .overlay(Image(systemName: "stethoscope").font(.system(size: 18)).foregroundStyle(.white))
                    VStack(alignment: .leading, spacing: 1) {
                        Text(doctor.isEmpty ? "Doctor" : doctor).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        Text(spec).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                }
                .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 14))
                VStack(spacing: 0) {
                    WizardReviewRow("clock", "\(date) · \(time)")
                    WizardReviewRow("timer", duration)
                    WizardReviewRow("mappin.and.ellipse", hospital.isEmpty ? "Not set" : hospital)
                    WizardReviewRow("bell", "Reminder 1 day before")
                    if !purpose.isEmpty { WizardReviewRow("doc.text", purpose) }
                }
                WizardNote("You'll receive a reminder before your appointment.")
            }
        }
    }
}
