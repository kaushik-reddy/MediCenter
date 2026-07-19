import SwiftUI

// Local demo data for the Medications screen. Mirrors the web app.

enum PillKind { case capsule, softgel, tablet }
enum ScheduleColor { case green, purple }
enum DayState { case on, ring, off }
enum MedCategory { case medication, supplement }

struct Medication: Identifiable {
    let id = UUID()
    let name: String
    let dose: String
    let food: String
    let foodIcon: String // SF Symbol
    let time: String
    let color: ScheduleColor
    let kind: PillKind
    let tint: Color
    let pillColor: Color
    let days: [DayState]
    var category: MedCategory = .medication
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

enum MedicationsData {
    static let week: [DayState] = [.on, .on, .on, .on, .on, .ring, .off]

    static let medications: [Medication] = [
        Medication(name: "Paracetamol 650mg", dose: "1 Tablet", food: "After Food", foodIcon: "fork.knife",
                   time: "10:30 AM", color: .green, kind: .capsule,
                   tint: Color(hex: "E7F6EE"), pillColor: Color(hex: "22C55E"), days: week),
        Medication(name: "Vitamin D3 60K", dose: "1 Capsule", food: "After Food", foodIcon: "fork.knife",
                   time: "08:30 AM", color: .green, kind: .softgel,
                   tint: Color(hex: "FDF3D8"), pillColor: Color(hex: "F59E0B"), days: week),
        Medication(name: "B-Complex", dose: "1 Tablet", food: "After Dinner", foodIcon: "fork.knife",
                   time: "08:30 PM", color: .purple, kind: .tablet,
                   tint: Color(hex: "FDE7F0"), pillColor: Color(hex: "EC4899"), days: week),
        Medication(name: "Omega 3", dose: "1 Capsule", food: "After Food", foodIcon: "fork.knife",
                   time: "09:00 AM", color: .green, kind: .capsule,
                   tint: Color(hex: "E6F0FD"), pillColor: Color(hex: "3B82F6"), days: week),
        Medication(name: "Cetirizine 10mg", dose: "1 Tablet", food: "Before Bed", foodIcon: "moon.fill",
                   time: "09:30 PM", color: .purple, kind: .tablet,
                   tint: Color(hex: "EEF0F3"), pillColor: Color(hex: "E5E7EB"), days: week),
    ]

    static let supplements: [Medication] = [
        Medication(name: "Vitamin C 500mg", dose: "1 Tablet", food: "After Food", foodIcon: "fork.knife",
                   time: "11:00 AM", color: .green, kind: .tablet,
                   tint: Color(hex: "FDECE0"), pillColor: Color(hex: "F97316"), days: week,
                   category: .supplement),
        Medication(name: "Fish Oil", dose: "1 Capsule", food: "After Food", foodIcon: "fork.knife",
                   time: "09:00 AM", color: .green, kind: .softgel,
                   tint: Color(hex: "E6F0FD"), pillColor: Color(hex: "3B82F6"), days: week,
                   category: .supplement),
        Medication(name: "Magnesium", dose: "1 Tablet", food: "Before Bed", foodIcon: "moon.fill",
                   time: "10:00 PM", color: .purple, kind: .tablet,
                   tint: Color(hex: "E7F6EE"), pillColor: Color(hex: "10B981"), days: week,
                   category: .supplement),
        Medication(name: "Probiotic", dose: "1 Capsule", food: "Before Food", foodIcon: "fork.knife",
                   time: "07:30 AM", color: .green, kind: .capsule,
                   tint: Color(hex: "FDE7F0"), pillColor: Color(hex: "EC4899"), days: week,
                   category: .supplement),
    ]

    static func items(for category: MedCategory) -> [Medication] {
        category == .supplement ? supplements : medications
    }

    static let refills: [RefillItem] = [
        RefillItem(name: "B-Complex", isLow: true, statusLabel: "Low Stock (3 left)",
                   detail: "1 Tablet · After Dinner", tint: Color(hex: "FDECEF"),
                   kind: .tablet, pillColor: Color(hex: "EC4899")),
        RefillItem(name: "Vitamin D3 60K", isLow: false, statusLabel: "Refill in 5 days",
                   detail: "1 Capsule · After Food", tint: Color(hex: "FDF3D8"),
                   kind: .softgel, pillColor: Color(hex: "F59E0B")),
    ]
}
