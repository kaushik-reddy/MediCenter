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
    static let summary = (period: "This Week", percent: 85, taken: 17, late: 2, missed: 1, doses: "17 of 20 doses taken")

    static let groups: [HistoryGroup] = [
        HistoryGroup(label: "Today", date: "May 17, 2025", rows: [
            HistoryRow(time: "08:30 AM", name: "Vitamin D3 60K", detail: "1 Capsule · After Food", status: .onTime, badge: "On Time"),
            HistoryRow(time: "10:30 AM", name: "Paracetamol 650mg", detail: "1 Tablet · After Food", status: .onTime, badge: "On Time"),
            HistoryRow(time: "08:30 PM", name: "B-Complex", detail: "1 Tablet · After Dinner", status: .onTime, badge: "On Time"),
        ]),
        HistoryGroup(label: "Yesterday", date: "May 16, 2025", rows: [
            HistoryRow(time: "08:30 AM", name: "Vitamin D3 60K", detail: "1 Capsule · After Food", status: .onTime, badge: "On Time"),
            HistoryRow(time: "10:45 AM", name: "Paracetamol 650mg", detail: "1 Tablet · After Food", status: .late, badge: "15m Late"),
            HistoryRow(time: "08:30 PM", name: "B-Complex", detail: "1 Tablet · After Dinner", status: .onTime, badge: "On Time"),
        ]),
        HistoryGroup(label: "Thu", date: "May 15, 2025", rows: [
            HistoryRow(time: "08:30 AM", name: "Vitamin D3 60K", detail: "1 Capsule · After Food", status: .onTime, badge: "On Time"),
            HistoryRow(time: "10:30 AM", name: "Paracetamol 650mg", detail: "1 Tablet · After Food", status: .missed, badge: "Missed"),
            HistoryRow(time: "08:30 PM", name: "B-Complex", detail: "1 Tablet · After Dinner", status: .onTime, badge: "On Time"),
        ]),
    ]
}
