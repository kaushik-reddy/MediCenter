import Foundation
import ActivityKit

/// App-side controller that starts / updates / ends the medication Live Activity.
///
/// NOTE: the Dynamic Island + Lock Screen presentation is rendered by the
/// `MediCenterWidgets` widget-extension target (see `ios/MediCenterWidgets/`). Until that
/// target is added in Xcode the calls below are safe no-ops on device (they simply do
/// nothing to display), so the rest of the app is unaffected.
@MainActor
final class LiveActivityManager {
    static let shared = LiveActivityManager()
    private init() {}

    private var current: Activity<MedActivityAttributes>?

    var isSupported: Bool {
        if #available(iOS 16.2, *) {
            return ActivityAuthorizationInfo().areActivitiesEnabled
        }
        return false
    }

    /// Start (or replace) a live countdown to the next dose — the "starts in 45:00" ticker.
    func startCountdown(med: Medication, at target: Date) {
        guard #available(iOS 16.2, *), isSupported else { return }
        end() // one activity at a time for the demo

        let attributes = MedActivityAttributes(
            title: "Next Dose",
            medId: med.id.uuidString,
            pillKind: pillKindString(med.kind)
        )
        let state = MedActivityAttributes.ContentState(
            mode: "countdown",
            medName: med.name,
            dose: "\(med.dose) · \(med.food)",
            message: "Get ready — \(med.name) coming up",
            targetDate: target,
            dosesTaken: 0,
            dosesTotal: 0,
            accentHex: med.pillColor.hexString
        )
        do {
            current = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: target.addingTimeInterval(30 * 60))
            )
        } catch {
            current = nil
        }
    }

    /// Flip the running activity to the "due now" state (or start one).
    func markDue(med: Medication) {
        guard #available(iOS 16.2, *) else { return }
        let state = MedActivityAttributes.ContentState(
            mode: "due",
            medName: med.name,
            dose: "\(med.dose) · \(med.food)",
            message: "Time to take \(med.name)",
            targetDate: nil,
            dosesTaken: 0,
            dosesTotal: 0,
            accentHex: med.pillColor.hexString
        )
        Task { await update(state) }
    }

    /// Show today's adherence progress.
    func showProgress(taken: Int, total: Int) {
        guard #available(iOS 16.2, *) else { return }
        let state = MedActivityAttributes.ContentState(
            mode: "progress",
            medName: "Today's Doses",
            dose: "\(taken) of \(total) taken",
            message: total > 0 && taken >= total ? "All done for today 🎉" : "Keep it up",
            targetDate: nil,
            dosesTaken: taken,
            dosesTotal: total,
            accentHex: "7C5CFC"
        )
        Task { await update(state) }
    }

    @available(iOS 16.2, *)
    private func update(_ state: MedActivityAttributes.ContentState) async {
        guard let current else { return }
        await current.update(.init(state: state, staleDate: nil))
    }

    func end() {
        guard #available(iOS 16.2, *), let current else { return }
        Task { await current.end(nil, dismissalPolicy: .immediate) }
        self.current = nil
    }

    private func pillKindString(_ kind: PillKind) -> String {
        switch kind {
        case .capsule: return "capsule"
        case .softgel: return "softgel"
        case .tablet: return "tablet"
        }
    }
}
