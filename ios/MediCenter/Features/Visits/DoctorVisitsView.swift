import SwiftUI

struct DoctorVisitsView: View {
    @Environment(AppState.self) private var app
    struct Appt: Identifiable { let id = UUID(); let mon: String; let day: String; let dow: String; let name: String; let spec: String; let time: String; let confirmed: Bool }
    private let upcoming: [Appt] = []
    private let past: [Appt] = []

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Doctor Visits", subtitle: "Manage your appointments")
            ScrollView {
                VStack(spacing: 12) {
                    if upcoming.isEmpty && past.isEmpty {
                        EmptyState(icon: "stethoscope", title: "No appointments yet",
                                   message: "Book a doctor visit to keep track of it here.")
                    } else {
                        if !upcoming.isEmpty {
                            header("Upcoming Appointments", "View Calendar")
                            ForEach(upcoming) { a in
                                VStack(spacing: 12) {
                                    apptRow(a)
                                    HStack(spacing: 8) {
                                        Image(systemName: "bell").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                                        Text("Appointment in 2 days").font(.system(size: 12, weight: .medium)).foregroundStyle(Theme.brand500)
                                        Spacer()
                                        Text("View Details").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.brand500)
                                    }
                                    .padding(.horizontal, 12).padding(.vertical, 10).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .padding(12).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
                            }
                        }
                        if !past.isEmpty {
                            header("Past Appointments", "View All")
                            SettingsCard {
                                ForEach(Array(past.enumerated()), id: \.element.id) { idx, a in
                                    apptRow(a).padding(12)
                                        .overlay(idx == past.count - 1 ? nil : Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)
                                }
                            }
                        }
                    }
                    HStack(spacing: 10) {
                        tile("calendar", "0", "Total Visits", Theme.brandSoft, Theme.brand500)
                        tile("checkmark.circle.fill", "0", "Completed", Theme.greenSoft, Theme.green)
                    }
                    HStack(spacing: 10) {
                        tile("clock", "0", "Upcoming", Theme.amberSoft, Theme.amber)
                        tile("stethoscope", "0", "Doctors", Theme.blueSoft, Theme.blue)
                    }

                    Button { app.presentFullScreen(AddAppointmentWizardView()) } label: {
                        HStack(spacing: 6) { Image(systemName: "plus"); Text("Book New Appointment").font(.system(size: 13.5, weight: .bold)) }
                            .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func header(_ t: String, _ a: String) -> some View {
        HStack {
            Text(t).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
            Spacer()
            Text(a).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.brand500)
        }
    }
    private func apptRow(_ a: Appt) -> some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Text(a.mon).font(.system(size: 10, weight: .bold))
                Text(a.day).font(.system(size: 18, weight: .heavy))
                Text(a.dow).font(.system(size: 9))
            }
            .foregroundStyle(.white).frame(width: 52).padding(.vertical, 8).background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment: .leading, spacing: 2) {
                Text(a.name).font(.system(size: 14.5, weight: .bold)).foregroundStyle(Theme.text)
                Text(a.spec).font(.system(size: 12)).foregroundStyle(Theme.textMuted)
                HStack(spacing: 4) { Image(systemName: "clock").font(.system(size: 10)); Text(a.time).font(.system(size: 11.5)) }.foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 4)
            if a.confirmed {
                Text("Confirmed").font(.system(size: 10.5, weight: .semibold)).foregroundStyle(Theme.green)
                    .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.greenSoft).clipShape(Capsule())
            } else {
                HStack(spacing: 4) { Image(systemName: "checkmark.circle.fill").font(.system(size: 12)); Text("Completed").font(.system(size: 11, weight: .semibold)) }.foregroundStyle(Theme.green)
            }
        }
    }
    private func tile(_ icon: String, _ n: String, _ label: String, _ bg: Color, _ fg: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(fg)
                .frame(width: 36, height: 36).background(Theme.surface.opacity(0.7)).clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 1) {
                Text(n).font(.system(size: 17, weight: .heavy)).foregroundStyle(fg)
                Text(label).font(.system(size: 11)).foregroundStyle(Theme.textMuted)
            }
            Spacer()
        }
        .padding(12).background(bg).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
