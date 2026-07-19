import SwiftUI

@main
struct MediCenterApp: App {
    @State private var appState = AppState()

    /// Global UI scale. < 1 "zooms out" (everything renders smaller and more fits on screen).
    /// The content is laid out on a proportionally larger canvas then scaled down, so it
    /// reflows correctly and still fills the screen edge-to-edge — no clipping or gaps.
    private let uiScale: CGFloat = 0.9

    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                RootView()
                    .frame(width: proxy.size.width / uiScale,
                           height: proxy.size.height / uiScale)
                    .scaleEffect(uiScale, anchor: .topLeading)
            }
            .background(Theme.bg.ignoresSafeArea())
            .environment(appState)
            .preferredColorScheme(appState.themeOverride)
            .tint(Theme.brand500)
        }
    }
}
