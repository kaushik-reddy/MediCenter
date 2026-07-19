import SwiftUI

// MARK: - Navigation model (mirrors the web navigation config)

/// Destinations reachable from the hamburger drawer or via push navigation.
enum AppRoute: Hashable {
    case profile
    case reminders
    case notifications
    case inventory
    case analytics
    case insights
    case reports
    case visits
    case interactions
    case caregiver
    case contacts
    case travel
    case settings
    case medicineDetail(String)

    var title: String {
        switch self {
        case .profile: return "Profile"
        case .reminders: return "Medication Reminders"
        case .notifications: return "Notifications"
        case .inventory: return "Inventory & Refill"
        case .analytics: return "Analytics"
        case .insights: return "Health Insights"
        case .reports: return "Health Reports"
        case .visits: return "Doctor Visits"
        case .interactions: return "Interaction Checker"
        case .caregiver: return "Caregiver Mode"
        case .contacts: return "Emergency Contacts"
        case .travel: return "Travel Mode"
        case .settings: return "Settings"
        case .medicineDetail: return "Medicine Details"
        }
    }

    var systemImage: String {
        switch self {
        case .profile: return "person.circle"
        case .reminders: return "bell.badge"
        case .notifications: return "bell"
        case .inventory: return "shippingbox"
        case .analytics: return "chart.bar"
        case .insights: return "waveform.path.ecg"
        case .reports: return "doc.text"
        case .visits: return "stethoscope"
        case .interactions: return "exclamationmark.shield"
        case .caregiver: return "person.2"
        case .contacts: return "phone"
        case .travel: return "airplane"
        case .settings: return "gearshape"
        case .medicineDetail: return "pills"
        }
    }
}

/// The four fixed bottom-tab destinations (the center + is a floating action).
enum AppTab: Int, CaseIterable, Hashable {
    case home, medications, calendar, history

    var title: String {
        switch self {
        case .home: return "Home"
        case .medications: return "Medications"
        case .calendar: return "Calendar"
        case .history: return "History"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house"
        case .medications: return "pills"
        case .calendar: return "calendar"
        case .history: return "clock.arrow.circlepath"
        }
    }
}

struct DrawerGroup: Identifiable {
    let id = UUID()
    let title: String
    let routes: [AppRoute]
}

enum Navigation {
    static let drawerGroups: [DrawerGroup] = [
        DrawerGroup(title: "Overview", routes: [.profile, .reminders, .notifications, .inventory]),
        DrawerGroup(title: "Health", routes: [.analytics, .insights, .reports, .visits, .interactions]),
        DrawerGroup(title: "Care & Safety", routes: [.caregiver, .contacts, .travel]),
        DrawerGroup(title: "System", routes: [.settings]),
    ]
}
