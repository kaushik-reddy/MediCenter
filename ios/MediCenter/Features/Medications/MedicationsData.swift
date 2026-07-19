import SwiftUI

// Medication model + on-device store. No seeded demo data — the store starts empty and the
// user's own medications are persisted via `MedStore`.

enum PillKind: String, Codable { case capsule, softgel, tablet }
enum ScheduleColor: String, Codable { case green, purple }
enum DayState: String, Codable { case on, ring, off }
enum MedCategory: String, Codable { case medication, supplement }

struct Medication: Identifiable, Codable {
    var id = UUID()
    var name: String
    var dose: String
    var food: String
    var foodIcon: String // SF Symbol
    var time: String
    var color: ScheduleColor
    var kind: PillKind
    var tintHex: String
    var pillHex: String
    var days: [DayState]
    var category: MedCategory = .medication

    var tint: Color { Color(hex: tintHex) }
    var pillColor: Color { Color(hex: pillHex) }
}

struct RefillItem: Identifiable {
    let id = UUID()
    let name: String
    let isLow: Bool
    let statusLabel: String
    let detail: String
    let tint: Color
    let kind: PillKind
    let pillColor: Color
}

/// Persisted, reactive store of the user's medications & supplements. Empty by default.
@Observable
final class MedStore {
    static let shared = MedStore()
    private let key = "medstore.items.v1"

    var meds: [Medication] {
        didSet { Persisted.save(meds, key) }
    }

    private init() {
        meds = Persisted.load([Medication].self, key) ?? []
    }

    var medications: [Medication] { meds.filter { $0.category == .medication } }
    var supplements: [Medication] { meds.filter { $0.category == .supplement } }

    func items(for category: MedCategory) -> [Medication] {
        meds.filter { $0.category == category }
    }

    func find(name: String) -> Medication? {
        meds.first { $0.name == name }
    }

    func add(_ medication: Medication) {
        meds.append(medication)
    }

    func remove(name: String) {
        meds.removeAll { $0.name == name }
    }
}

/// Thin reactive facade kept for existing call-sites. Reads flow through `MedStore.shared`,
/// so views that read these during `body` stay reactive to changes.
enum MedicationsData {
    /// Default weekday template applied to a newly added medication (Mon–Fri on, Sat optional, Sun off).
    static let week: [DayState] = [.on, .on, .on, .on, .on, .ring, .off]

    static var medications: [Medication] { MedStore.shared.medications }
    static var supplements: [Medication] { MedStore.shared.supplements }
    static func items(for category: MedCategory) -> [Medication] { MedStore.shared.items(for: category) }
    static func find(name: String) -> Medication? { MedStore.shared.find(name: name) }

    /// No fake refill data — refills are derived once real stock tracking is added.
    static let refills: [RefillItem] = []
}
