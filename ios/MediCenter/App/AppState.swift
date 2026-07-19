import SwiftUI

/// Global, observable app state. For now everything is local (in-memory / on-device).
@Observable
final class AppState {
    // Theme preference: defaults to light mode (users can switch to dark from the drawer/settings).
    var themeOverride: ColorScheme? = .light

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

    // Presented full-screen flow (multi-step wizard)
    var fullScreenFlow: AnyView? = nil

    func present<V: View>(_ view: V) {
        modal = AnyView(view)
    }

    func dismissModal() {
        modal = nil
    }

    func presentFullScreen<V: View>(_ view: V) {
        fullScreenFlow = AnyView(view)
    }

    func dismissFullScreen() {
        fullScreenFlow = nil
    }

    func open(_ route: AppRoute) {
        isDrawerOpen = false
        navigationPath.append(route)
    }

    /// Pop the current pushed page (used by the top-bar back button).
    func goBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}
