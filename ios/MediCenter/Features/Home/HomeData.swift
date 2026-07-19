import Foundation

// Home screen models. No seeded data — the Home screen derives everything from the user's
// own medications in `MedStore`.

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

enum HomeData {
    /// Sort key: minutes-since-midnight from a "hh:mm a" time string.
    static func minutes(_ time: String) -> Int {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "hh:mm a"
        guard let d = f.date(from: time) else { return 0 }
        let c = Calendar.current.dateComponents([.hour, .minute], from: d)
        return (c.hour ?? 0) * 60 + (c.minute ?? 0)
    }

    /// Today's schedule from the user's medications, ordered by time.
    static var todaySchedule: [ScheduleItem] {
        MedStore.shared.medications
            .sorted { minutes($0.time) < minutes($1.time) }
            .map { ScheduleItem(time: $0.time, name: $0.name, detail: "\($0.dose) · \($0.food)", status: .upcoming) }
    }

    /// The next upcoming dose (soonest after now, else the earliest of the day). Nil if none.
    static var nextDose: NextDose? {
        let meds = MedStore.shared.medications.sorted { minutes($0.time) < minutes($1.time) }
        guard !meds.isEmpty else { return nil }
        let now = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let nowMin = (now.hour ?? 0) * 60 + (now.minute ?? 0)
        let m = meds.first { minutes($0.time) >= nowMin } ?? meds[0]
        return NextDose(inLabel: "", atTime: m.time, name: m.name, detail: "\(m.dose) · \(m.food)")
    }
}
