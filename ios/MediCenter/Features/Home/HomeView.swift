import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var app

    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "Good morning, \(app.userName)",
                subtitle: "Stay on track, stay healthy.",
                greeting: true
            )

            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 16) {
                        if let dose = HomeData.nextDose {
                            NextDoseCard(dose: dose)
                        } else {
                            EmptyState(
                                icon: "pills",
                                title: "No medications yet",
                                message: "Add your medicines to see your next dose and daily schedule.",
                                actionLabel: "Add Medication",
                                action: { app.presentFullScreen(AddMedicationWizardView()) }
                            )
                        }

                        let schedule = HomeData.todaySchedule
                        if !schedule.isEmpty {
                            TodayScheduleCard(items: schedule) {
                                app.selectedTab = .calendar
                            }
                        }
                        ProgressCard()

                        // Tip of the day is always pinned to the bottom, above the nav bar
                        Spacer(minLength: 12)
                        TipOfDayCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, 120) // clear the floating tab bar
                    .frame(minHeight: geo.size.height, alignment: .top)
                }
            }
        }
        .background(Theme.bg)
    }
}
