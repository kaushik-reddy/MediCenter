import SwiftUI

// Local demo data for the History screen. Mirrors the web app.

enum HistoryStatus { case onTime, late, missed }

struct HistoryRow: Identifiable {
    let id = UUID()
    let time: String
    let name: String
    let detail: String
    let status: HistoryStatus
    let badge: String
}

struct HistoryGroup: Identifiable {
    let id = UUID()
    let label: String
    let date: String
    let rows: [HistoryRow]
}

enum HistoryData {
    static let summary = (period: "This Week", percent: 0, taken: 0, late: 0, missed: 0, doses: "0 of 0 doses taken")

    static let groups: [HistoryGroup] = []
}
