import SwiftUI

/// Smooth content-entrance animation for a screen: fades in (and optionally rises) when the
/// view appears, so navigating to a page reveals its content gracefully instead of snapping in.
struct PageEntrance: ViewModifier {
    var rise: CGFloat = 14
    var duration: Double = 0.35
    @State private var shown = false

    func body(content: Content) -> some View {
        content
            .opacity(shown ? 1 : 0)
            .offset(y: shown ? 0 : rise)
            .onAppear {
                shown = false
                withAnimation(.easeOut(duration: duration)) { shown = true }
            }
    }
}

extension View {
    /// Fade + gentle rise when the screen appears.
    func pageEntrance(rise: CGFloat = 14, duration: Double = 0.35) -> some View {
        modifier(PageEntrance(rise: rise, duration: duration))
    }
}
