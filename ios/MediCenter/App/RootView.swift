import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        @Bindable var app = app

        NavigationStack(path: $app.navigationPath) {
            ZStack(alignment: .bottom) {
                Theme.bg.ignoresSafeArea()

                // Active tab content
                Group {
                    switch app.selectedTab {
                    case .home: HomeView()
                    case .medications: MedicationsView()
                    case .calendar: CalendarView()
                    case .history: HistoryView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Floating bottom nav + center add button
                CustomTabBar(
                    selected: $app.selectedTab,
                    onAdd: { app.presentFullScreen(AddMedicationWizardView()) }
                )
            }
            .navigationBarHidden(true)
            .overlay(alignment: .leading) {
                DrawerView()
            }
            .overlay {
                if let modal = app.modal {
                    ZStack {
                        Color.black.opacity(0.45).ignoresSafeArea()
                            .onTapGesture { app.dismissModal() }
                        modal
                            .padding(.horizontal, 24)
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.2), value: app.modal != nil)
            .fullScreenCover(isPresented: Binding(
                get: { app.fullScreenFlow != nil },
                set: { if !$0 { app.fullScreenFlow = nil } }
            )) {
                if let flow = app.fullScreenFlow {
                    flow.environment(app)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                Group {
                    switch route {
                    case .profile: ProfileView()
                    case .reminders: RemindersView()
                    case .notifications: NotificationsView()
                    case .inventory: InventoryView()
                    case .analytics: AnalyticsView()
                    case .insights: HealthInsightsView()
                    case .reports: HealthReportsView()
                    case .visits: DoctorVisitsView()
                    case .interactions: InteractionCheckerView()
                    case .caregiver: CaregiverView()
                    case .contacts: EmergencyContactsView()
                    case .travel: TravelModeView()
                    case .settings: SettingsView()
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

// MARK: - Custom floating tab bar

struct CustomTabBar: View {
    @Binding var selected: AppTab
    var onAdd: () -> Void

    var body: some View {
        ZStack {
            HStack {
                tabItem(.home)
                tabItem(.medications)
                Spacer().frame(width: 56) // center gap for FAB
                tabItem(.calendar)
                tabItem(.history)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Theme.surface)
                    .shadow(color: .black.opacity(0.12), radius: 20, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(Theme.border, lineWidth: 1)
            )
            .padding(.horizontal, 16)

            // Center + FAB
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Theme.brandGradient)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(Theme.bg, lineWidth: 4))
                    .shadow(color: Theme.brand600.opacity(0.5), radius: 12, x: 0, y: 8)
            }
            .offset(y: -22)
        }
        .padding(.bottom, 4)
    }

    private func tabItem(_ tab: AppTab) -> some View {
        let isActive = selected == tab
        return Button {
            selected = tab
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 20, weight: isActive ? .semibold : .regular))
                Text(tab.title)
                    .font(.system(size: 10, weight: .semibold))
            }
            .foregroundStyle(isActive ? Theme.brand500 : Theme.textFaint)
            .frame(maxWidth: .infinity)
        }
    }
}
