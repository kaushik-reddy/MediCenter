import ActivityKit
import Foundation

/// Shared Live Activity definition used by BOTH the app (to start / update / end activities)
/// and the widget extension (to render the Dynamic Island + Lock Screen).
///
/// When the `MediCenterWidgets` extension target is added in Xcode, add THIS file to that
/// target's membership too (standard ActivityKit sharing pattern).
///
/// A single activity switches between several "box-box F1"-style modes without being
/// recreated, driven by `ContentState.mode`:
///  • "countdown" → live auto-ticking timer to the next dose (started ~1h before).
///  • "due"       → the dose is due now ("Time to take …") with Taken / Snooze affordance.
///  • "progress"  → today's adherence ("3 of 5 doses taken").
struct MedActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// "countdown" | "due" | "progress"
        var mode: String
        var medName: String
        /// e.g. "1 Tablet · After Food"
        var dose: String
        /// Supporting line, e.g. "Take with water" / "Snoozed 10 min".
        var message: String
        /// The dose time being counted down to (countdown mode) — powers the on-device
        /// auto-ticking timer with no server pushes required.
        var targetDate: Date?
        /// Adherence for the "progress" mode.
        var dosesTaken: Int
        var dosesTotal: Int
        /// Accent color hex (matches the pill's tint on the card).
        var accentHex: String

        var isCountdown: Bool { mode == "countdown" }
        var isDue: Bool { mode == "due" }
        var isProgress: Bool { mode == "progress" }
    }

    /// Static metadata for the whole activity.
    var title: String       // e.g. "Medication Reminder"
    var medId: String
    var pillKind: String    // "capsule" | "softgel" | "tablet"
}
