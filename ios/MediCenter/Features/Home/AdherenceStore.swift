import SwiftUI

/// Tracks per-day dose adherence so the "Your Progress" week ring/dots fill dynamically as
/// you mark doses taken/skipped. In-memory for now (seeded to match the demo); swap the seed
/// for real per-date persistence when wiring live user data.
@Observable
final class AdherenceStore {
    static let shared = AdherenceStore()
    private init() {}

    let labels = ["M", "T", "W", "T", "F", "S", "S"]
    /// Index 0 = Monday … 6 = Sunday.
    var taken: [Int] = [3, 3, 3, 3, 3, 1, 0]
    var total: [Int] = [3, 3, 3, 3, 3, 3, 3]
    var streakDays = 12

    /// Monday-based index of today.
    var todayIndex: Int {
        let wd = Calendar.current.component(.weekday, from: Date()) // 1 = Sun … 7 = Sat
        return (wd + 5) % 7
    }

    func fraction(_ i: Int) -> Double {
        total[i] == 0 ? 0 : min(1, Double(taken[i]) / Double(total[i]))
    }

    var week: [Double] { (0..<7).map { fraction($0) } }

    var percent: Int {
        let t = taken.reduce(0, +), tot = total.reduce(0, +)
        return tot == 0 ? 0 : Int((Double(t) / Double(tot)) * 100)
    }

    /// Mark one of today's doses as taken (fills today's circle further).
    func markTakenToday() {
        let i = todayIndex
        if taken[i] < total[i] { taken[i] += 1 }
    }

    /// Skipping a dose removes it from today's required total (counts as handled).
    func skipToday() {
        let i = todayIndex
        if total[i] > taken[i] { total[i] -= 1 }
    }
}
