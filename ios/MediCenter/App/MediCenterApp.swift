import SwiftUI

@main
struct MediCenterApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .preferredColorScheme(appState.themeOverride)
                .tint(Theme.brand500)
        }
    }
}
