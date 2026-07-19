import SwiftUI

// Local demo data for the Calendar screen (May 2024). Mirrors the web app.

enum DotColor { case green, amber, red }

struct DayCell: Identifiable {
    let id = UUID()
    let day: Int
    let inMonth: Bool
    var today: Bool = false
    var dots: [DotColor] = []
}

enum TimeOfDay { case morning, noon, night }

struct DayMed: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
    let time: String
    let when: TimeOfDay
    let status: DoseStatus
}

enum CalendarData {
    static let monthLabel: String = {
        let f = DateFormatter(); f.dateFormat = "MMMM yyyy"; return f.string(from: Date())
    }()
    static let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    /// Real month grid for the current month, with today marked and no fake status dots.
    static let days: [DayCell] = {
        let cal = Calendar.current
        let now = Date()
        let comps = cal.dateComponents([.year, .month], from: now)
        guard let first = cal.date(from: comps),
              let range = cal.range(of: .day, in: .month, for: now) else { return [] }
        let leading = (cal.component(.weekday, from: first) - 1) // Sun-based
        let todayDay = cal.component(.day, from: now)
        var cells: [DayCell] = []
        // leading days from previous month (greyed)
        if leading > 0 {
            for i in stride(from: leading, to: 0, by: -1) {
                if let d = cal.date(byAdding: .day, value: -i, to: first) {
                    cells.append(DayCell(day: cal.component(.day, from: d), inMonth: false))
                }
            }
        }
        for day in range {
            cells.append(DayCell(day: day, inMonth: true, today: day == todayDay))
        }
        // trailing to fill the last week
        var trailing = 1
        while cells.count % 7 != 0 { cells.append(DayCell(day: trailing, inMonth: false)); trailing += 1 }
        return cells
    }()

    static var selectedDayLabel: String {
        let f = DateFormatter(); f.dateFormat = "EEEE, d MMM yyyy"; return f.string(from: Date())
    }

    static var selectedStats: (taken: Int, late: Int, missed: Int) { (0, 0, 0) }

    /// Today's medicines, synced from the user's store.
    static var selectedMeds: [DayMed] {
        MedStore.shared.medications
            .sorted { HomeData.minutes($0.time) < HomeData.minutes($1.time) }
            .map { med in
                let hour = HomeData.minutes(med.time) / 60
                let when: TimeOfDay = hour < 12 ? .morning : (hour < 17 ? .noon : .night)
                return DayMed(name: med.name, detail: "\(med.dose) · \(med.food)", time: med.time, when: when, status: .upcoming)
            }
    }

    static var quick: (month: String, takenDays: Int, lateDays: Int, missedDays: Int, adherence: Int) {
        (monthLabel, 0, 0, 0, 0)
    }
}
