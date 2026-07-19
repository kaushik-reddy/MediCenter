import WidgetKit
import SwiftUI

// Widget extension entry point. Add these files to a new "Widget Extension" target named
// `MediCenterWidgets` in Xcode, and also add the app's
// `ios/MediCenter/LiveActivity/MedActivityAttributes.swift` to that target's membership.
@main
struct MediCenterWidgetBundle: WidgetBundle {
    var body: some Widget {
        DoseLiveActivity()
    }
}

// Self-contained hex color for the widget target (the app's Theme is not a member here).
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}
