import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var app
    @State private var emailNotif = true
    @State private var pushNotif = true

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Profile", subtitle: "Manage your account and preferences.")
            ScrollView {
                VStack(spacing: 16) {
                    profileCard

                    section("Account") {
                        SettingsRow(icon: "person", title: "Personal Information", subtitle: "Update your personal details")
                        SettingsRow(icon: "lock", title: "Login & Security", subtitle: "Change password and security settings")
                        SettingsRow(icon: "envelope", title: "Email Notifications", subtitle: "Manage email reminders and updates", trailing: .toggle($emailNotif))
                        SettingsRow(icon: "iphone", title: "Push Notifications", subtitle: "Manage push notification preferences", trailing: .toggle($pushNotif), last: true)
                    }

                    section("Preferences") {
                        SettingsRow(icon: "clock", title: "Reminder Settings", subtitle: "Default times, snooze and more")
                        SettingsRow(icon: "pills", title: "Medication Preferences", subtitle: "Units, dosage format and other preferences")
                        SettingsRow(icon: "paintpalette", title: "App Appearance", subtitle: "Theme, color and display settings", trailing: .pill(icon: "sun.max", label: "Light"))
                        SettingsRow(icon: "globe", title: "Language", subtitle: "Choose your preferred language", trailing: .pill(icon: nil, label: "English"), last: true)
                    }

                    section("Support & More") {
                        SettingsRow(icon: "questionmark.circle", title: "Help & FAQs", subtitle: "Get help and find answers")
                        SettingsRow(icon: "headphones", title: "Contact Support", subtitle: "We're here to help you")
                        SettingsRow(icon: "star", title: "Rate Us", subtitle: "If you enjoy using the app, please rate us")
                        SettingsRow(icon: "info.circle", title: "About App", subtitle: "Version 1.2.0", last: true)
                    }

                    Button {} label: {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out").font(.system(size: 15, weight: .bold))
                        }
                        .foregroundStyle(Theme.red)
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Theme.redSoft).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }

                    privacyBanner
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 120)
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

    private var profileCard: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    Circle().fill(Theme.brandGradient).frame(width: 64, height: 64)
                        .overlay(Text("K").font(.system(size: 26, weight: .bold)).foregroundStyle(.white))
                        .overlay(Circle().strokeBorder(.white, lineWidth: 3))
                    Image(systemName: "camera.fill").font(.system(size: 10)).foregroundStyle(.white)
                        .frame(width: 22, height: 22).background(Theme.brand500).clipShape(Circle())
                        .overlay(Circle().strokeBorder(Theme.brandSoft, lineWidth: 2))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Kaushik Reddy").font(.system(size: 18, weight: .bold)).foregroundStyle(Theme.text)
                    Text("kaushik.reddy@email.com").font(.system(size: 12.5)).foregroundStyle(Theme.textMuted)
                    HStack(spacing: 4) {
                        Image(systemName: "phone").font(.system(size: 11))
                        Text("+91 98765 43210").font(.system(size: 12.5))
                    }.foregroundStyle(Theme.textMuted)
                }
                Spacer(minLength: 0)
                Button { app.present(EditProfileModal()) } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "pencil").font(.system(size: 12))
                        Text("Edit Profile").font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Theme.brand500)
                    .padding(.horizontal, 10).padding(.vertical, 8)
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
                }
            }

            HStack(spacing: 0) {
                stat("calendar", Theme.brand500, "28", "Days Streak"); statDivider
                stat("checkmark.seal.fill", Theme.green, "98%", "On Time"); statDivider
                stat("star.fill", Theme.amber, "156", "Doses Taken"); statDivider
                stat("heart.fill", Theme.red, "12", "Medicines")
            }
            .overlay(Rectangle().frame(height: 1).foregroundStyle(.white.opacity(0.5)), alignment: .top)
            .padding(.top, 4)
        }
        .padding(16)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func stat(_ icon: String, _ fg: Color, _ value: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 3) {
                Image(systemName: icon).font(.system(size: 13)).foregroundStyle(fg)
                Text(value).font(.system(size: 17, weight: .heavy)).foregroundStyle(fg)
            }
            Text(label).font(.system(size: 10.5)).foregroundStyle(Theme.textMuted).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    private var statDivider: some View { Rectangle().fill(.white.opacity(0.5)).frame(width: 1, height: 30) }

    private var privacyBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.shield.fill").font(.system(size: 30)).foregroundStyle(Theme.brand500)
            VStack(alignment: .leading, spacing: 1) {
                Text("Your health, our priority").font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.brand500)
                Text("Your data is private and secure with us.").font(.system(size: 12)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 4)
            HStack(spacing: 5) {
                Image(systemName: "checkmark.shield").font(.system(size: 12))
                Text("Privacy Policy").font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(Theme.brand500)
            .padding(.horizontal, 10).padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
        }
        .padding(14)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct EditProfileModal: View {
    @State private var name = "Kaushik Reddy"
    @State private var email = "kaushik.reddy@email.com"
    @State private var phone = "+91 98765 43210"
    var body: some View {
        ModalCard(icon: "pencil", title: "Edit Profile", subtitle: "Update your personal information") {
            ModalField(label: "Full Name", text: $name)
            ModalField(label: "Email", text: $email)
            ModalField(label: "Phone Number", text: $phone)
            ModalActions(primaryLabel: "Save Changes")
        }
    }
}
