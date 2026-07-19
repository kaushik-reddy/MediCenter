import Foundation
import UserNotifications

/// Schedules on-device local notifications for the Lock Screen / banners.
/// These work without any extra target and are the reliable backbone of the reminder system;
/// the Live Activity (Dynamic Island) is the richer, optional layer on top.
final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    /// Schedules the full reminder chain for a dose:
    ///  • a "get ready" heads-up `leadMinutes` before the dose (default 60 min), and
    ///  • the "time to take it" alert at the dose time.
    /// `hour`/`minute` are parsed from the medication's display time (e.g. "10:30 AM").
    func scheduleDoseReminders(for med: Medication, leadMinutes: Int = 60) {
        guard let (hour, minute) = Self.parseTime(med.time) else { return }

        // At-time alert.
        add(
            id: "dose-\(med.id.uuidString)",
            title: "Time for \(med.name)",
            body: "\(med.dose) · \(med.food)",
            hour: hour, minute: minute
        )

        // Lead-time heads-up (roll back across the hour/day boundary).
        var leadTotal = hour * 60 + minute - leadMinutes
        if leadTotal < 0 { leadTotal += 24 * 60 }
        add(
            id: "lead-\(med.id.uuidString)",
            title: "\(med.name) in \(leadMinutes) min",
            body: "Get ready — \(med.dose) coming up at \(med.time)",
            hour: leadTotal / 60, minute: leadTotal % 60
        )
    }

    /// A one-off "due now" style notification used by the demo actions.
    func fireDoseDue(for med: Medication, after seconds: TimeInterval = 3) {
        let content = UNMutableNotificationContent()
        content.title = "Time to take \(med.name)"
        content.body = "\(med.dose) · \(med.food)"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        center.add(UNNotificationRequest(identifier: "due-\(med.id.uuidString)", content: content, trigger: trigger))
    }

    func cancelReminders(for med: Medication) {
        center.removePendingNotificationRequests(withIdentifiers: [
            "dose-\(med.id.uuidString)", "lead-\(med.id.uuidString)", "due-\(med.id.uuidString)"
        ])
    }

    // MARK: - Helpers

    private func add(id: String, title: String, body: String, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
    }

    /// Parses "10:30 AM" / "09:30 PM" into 24-hour (hour, minute).
    static func parseTime(_ text: String) -> (Int, Int)? {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "hh:mm a"
        guard let date = f.date(from: text) else { return nil }
        let c = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let h = c.hour, let m = c.minute else { return nil }
        return (h, m)
    }

    /// Builds the next `Date` for a medication's daily time (today if still ahead, else tomorrow).
    static func nextDoseDate(for med: Medication) -> Date? {
        guard let (hour, minute) = parseTime(med.time) else { return nil }
        let cal = Calendar.current
        let now = Date()
        var comps = cal.dateComponents([.year, .month, .day], from: now)
        comps.hour = hour
        comps.minute = minute
        guard let candidate = cal.date(from: comps) else { return nil }
        return candidate > now ? candidate : cal.date(byAdding: .day, value: 1, to: candidate)
    }
}
