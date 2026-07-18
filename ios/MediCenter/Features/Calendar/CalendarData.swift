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
    static let monthLabel = "May 2024"
    static let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    static let days: [DayCell] = {
        let g: [DotColor] = [.green]
        return [
            DayCell(day: 28, inMonth: false), DayCell(day: 29, inMonth: false), DayCell(day: 30, inMonth: false),
            DayCell(day: 1, inMonth: true, dots: g), DayCell(day: 2, inMonth: true, dots: g),
            DayCell(day: 3, inMonth: true, dots: [.amber, .red]), DayCell(day: 4, inMonth: true),
            DayCell(day: 5, inMonth: true, dots: g), DayCell(day: 6, inMonth: true, dots: g),
            DayCell(day: 7, inMonth: true, dots: [.red]), DayCell(day: 8, inMonth: true, dots: g),
            DayCell(day: 9, inMonth: true, dots: [.amber]), DayCell(day: 10, inMonth: true, dots: g),
            DayCell(day: 11, inMonth: true),
            DayCell(day: 12, inMonth: true, dots: g), DayCell(day: 13, inMonth: true, dots: g),
            DayCell(day: 14, inMonth: true, dots: g), DayCell(day: 15, inMonth: true, dots: g),
            DayCell(day: 16, inMonth: true, dots: [.amber]), DayCell(day: 17, inMonth: true, dots: g),
            DayCell(day: 18, inMonth: true, dots: g),
            DayCell(day: 19, inMonth: true, dots: g), DayCell(day: 20, inMonth: true, today: true, dots: g),
            DayCell(day: 21, inMonth: true, dots: g), DayCell(day: 22, inMonth: true, dots: [.red]),
            DayCell(day: 23, inMonth: true, dots: g), DayCell(day: 24, inMonth: true, dots: g),
            DayCell(day: 25, inMonth: true, dots: g),
            DayCell(day: 26, inMonth: true, dots: g), DayCell(day: 27, inMonth: true, dots: [.amber]),
            DayCell(day: 28, inMonth: true, dots: g), DayCell(day: 29, inMonth: true, dots: g),
            DayCell(day: 30, inMonth: true, dots: g), DayCell(day: 31, inMonth: true, dots: g),
            DayCell(day: 1, inMonth: false),
        ]
    }()

    static let selectedDayLabel = "Monday, 20 May 2024"
    static let selectedStats = (taken: 3, late: 1, missed: 0)
    static let selectedMeds: [DayMed] = [
        DayMed(name: "Paracetamol 650mg", detail: "1 Tablet · After Breakfast", time: "08:30 AM", when: .morning, status: .taken),
        DayMed(name: "Vitamin D3 60K", detail: "1 Capsule · After Lunch", time: "02:30 PM", when: .noon, status: .late),
        DayMed(name: "B-Complex", detail: "1 Tablet · After Dinner", time: "08:30 PM", when: .night, status: .taken),
    ]

    static let quick = (month: "May 2024", takenDays: 18, lateDays: 5, missedDays: 2, adherence: 90)
}
