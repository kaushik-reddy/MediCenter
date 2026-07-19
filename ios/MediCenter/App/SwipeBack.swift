import UIKit

// Re-enables the interactive edge-swipe "back" gesture on every pushed page.
//
// SwiftUI's `NavigationStack` normally provides swipe-to-go-back, but hiding the
// navigation bar (`.navigationBarHidden` / `.toolbar(.hidden, ...)`) disables the
// gesture because UIKit ties it to the presence of the bar's back button. Taking
// over the gesture recognizer's delegate restores the swipe while keeping the bar
// hidden. The gesture is only allowed when there is a page to pop back to.
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
