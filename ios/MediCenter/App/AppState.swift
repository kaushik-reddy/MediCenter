import SwiftUI

/// Global, observable app state. For now everything is local (in-memory / on-device).
@Observable
final class AppState {
    // Theme preference: nil follows the system.
    var themeOverride: ColorScheme? = nil

    // Shell state
    var selectedTab: AppTab = .home
    var isDrawerOpen: Bool = false
    var navigationPath = NavigationPath()

    // Demo user
    var userName: String = "Kaushik"
    var userEmail: String = "kaushik@example.com"
    var notificationCount: Int = 2

    // Presented modal (centered-card popup)
    var modal: AnyView? = nil

    func present<V: View>(_ view: V) {
        modal = AnyView(view)
    }

    func dismissModal() {
        modal = nil
    }

    func open(_ route: AppRoute) {
        isDrawerOpen = false
        navigationPath.append(route)
    }
}
