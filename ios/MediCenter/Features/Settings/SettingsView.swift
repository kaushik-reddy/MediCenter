import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var app
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Settings", subtitle: "Customize your experience")
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: "gearshape.fill").font(.system(size: 24)).foregroundStyle(.white)
                            .frame(width: 48, height: 48).background(.white.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 16))
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Make it yours").font(.system(size: 16, weight: .bold)).foregroundStyle(.white)
                            Text("Personalize MediCenter").font(.system(size: 12.5)).foregroundStyle(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding(16).background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 20))

                    section("Preferences") {
                        SettingsRow(icon: "bell", title: "Reminder & Notification", subtitle: "Timing, channels, quiet hours") { app.present(NotificationChannelsModal()) }
                        SettingsRow(icon: "pills", title: "Medications", subtitle: "Default dose, refill alerts") { app.present(InfoModal(icon: "pills", title: "Medication Preferences", message: "Choose your units, dosage format and display preferences.")) }
                        SettingsRow(icon: "waveform.path.ecg", title: "Health Insights", subtitle: "Metrics and tracking") { app.open(.insights) }
                        SettingsRow(icon: "phone", title: "Emergency Contacts", subtitle: "Manage contacts", last: true) { app.open(.contacts) }
                    }
                    section("App Settings") {
                        SettingsRow(icon: "paintpalette", title: "Appearance", subtitle: "Theme, color and display",
                                    trailing: .pill(icon: "sun.max", label: colorScheme == .dark ? "Dark" : "Light")) {
                            app.themeOverride = (app.themeOverride == .dark || colorScheme == .dark) ? .light : .dark
                        }
                        SettingsRow(icon: "globe", title: "Language", subtitle: "Choose your language", trailing: .pill(icon: nil, label: "English")) { app.present(LanguageModal()) }
                        SettingsRow(icon: "ruler", title: "Units", subtitle: "Weight, height, temperature", last: true) { app.present(UnitsModal()) }
                    }
                    section("Account & Data") {
                        SettingsRow(icon: "icloud.and.arrow.up", title: "Backup & Restore", subtitle: "Keep your data safe") { app.present(InfoModal(icon: "icloud.and.arrow.up", title: "Backup & Restore", message: "Back up your data locally or restore from a previous backup.")) }
                        SettingsRow(icon: "checkmark.shield", title: "Privacy & Security", subtitle: "App lock, encryption", last: true) { app.present(InfoModal(icon: "checkmark.shield", title: "Privacy & Security", message: "Enable app lock and encryption to protect your health data.")) }
                    }
                    section("Support") {
                        SettingsRow(icon: "questionmark.circle", title: "Help & FAQs", subtitle: "Find answers") { app.present(InfoModal(icon: "questionmark.circle", title: "Help & FAQs", message: "Find answers to common questions and learn how to use MediCenter.")) }
                        SettingsRow(icon: "headphones", title: "Contact Support", subtitle: "We're here to help") { app.present(InfoModal(icon: "headphones", title: "Contact Support", message: "Reach our support team at support@medicenter.app anytime.")) }
                        SettingsRow(icon: "info.circle", title: "About MediCenter", subtitle: "Version 1.2.0", last: true) { app.present(InfoModal(icon: "info.circle", title: "About MediCenter", message: "MediCenter v1.2.0 — your personal medication companion.")) }
                    }
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func section<C: View>(_ label: String, @ViewBuilder _ content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SettingsSectionLabel(text: label)
            SettingsCard { content() }
        }
    }
}
