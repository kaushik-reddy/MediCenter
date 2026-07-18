import Foundation

// Local demo data for the Home screen. Mirrors the reference design and the web app.

enum DoseStatus {
    case taken, upcoming, pending, late, missed
}

struct ScheduleItem: Identifiable {
    let id = UUID()
    let time: String
    let name: String
    let detail: String
    let status: DoseStatus
}

struct NextDose {
    let inLabel: String
    let atTime: String
    let name: String
    let detail: String
}

struct WeekProgress {
    let percent: Int
    let streakDays: Int
    /// 1 = full, 0.5 = half, 0 = empty. Index 0 = Mon ... 6 = Sun
    let week: [Double]
    let weekLabels: [String]
}

enum HomeData {
    static let nextDose = NextDose(
        inLabel: "01:45",
        atTime: "10:30 AM",
        name: "Paracetamol 650mg",
        detail: "1 Tablet · After Food"
    )

    static let todaySchedule: [ScheduleItem] = [
        ScheduleItem(time: "08:30 AM", name: "Vitamin D3 60K", detail: "1 Capsule · After Food", status: .taken),
        ScheduleItem(time: "10:30 AM", name: "Paracetamol 650mg", detail: "1 Tablet · After Food", status: .upcoming),
        ScheduleItem(time: "08:30 PM", name: "B-Complex", detail: "1 Tablet · After Dinner", status: .pending),
    ]

    static let weekProgress = WeekProgress(
        percent: 85,
        streakDays: 12,
        week: [1, 1, 1, 1, 1, 0.5, 0],
        weekLabels: ["M", "T", "W", "T", "F", "S", "S"]
    )
}
