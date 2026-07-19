import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        @Bindable var app = app

        ZStack {
            NavigationStack(path: $app.navigationPath) {
                ZStack(alignment: .bottom) {
                    Theme.bg.ignoresSafeArea()

                    // Active tab content (fades/rises in on each tab switch)
                    Group {
                        switch app.selectedTab {
                        case .home: HomeView()
                        case .medications: MedicationsView()
                        case .calendar: CalendarView()
                        case .history: HistoryView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .id(app.selectedTab)
                    .pageEntrance()

                    // Floating bottom nav + center add button
                    CustomTabBar(
                        selected: $app.selectedTab,
                        onAdd: { app.presentFullScreen(AddMedicationWizardView()) }
                    )
                }
                .navigationBarHidden(true)
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
                        case .medicineDetail(let name): MedicineDetailView(name: name)
                        }
                    }
                    .pageEntrance(rise: 0)
                    .toolbar(.hidden, for: .navigationBar)
                }
            }

            // Drawer sits above the whole navigation stack.
            DrawerView()

            // Modal popups sit above EVERYTHING (including pushed pages) so they always
            // appear over the current screen — not just the root tab.
            if let modal = app.modal {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial).ignoresSafeArea()
                    Color.black.opacity(0.18).ignoresSafeArea()
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
        .onAppear { NotificationManager.shared.requestAuthorization() }
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
            .glass(28)
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
