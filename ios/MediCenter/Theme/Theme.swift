import SwiftUI

// MARK: - Hex Color helper

extension Color {
    /// Create a Color from a hex string like "#7C5CFC" or "7C5CFC".
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 8: // ARGB
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: // RGB (6)
            (a, r, g, b) = (255, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// A color that adapts to light / dark mode.
    static func dynamic(light: String, dark: String) -> Color {
        Color(uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor(Color(hex: dark))
                : UIColor(Color(hex: light))
        })
    }

    /// Six-digit RGB hex string (no leading #), e.g. "7C5CFC". Used when a color must be
    /// serialized across the app / widget boundary (Live Activity content state).
    var hexString: String {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "%02X%02X%02X",
                      Int((r * 255).rounded()), Int((g * 255).rounded()), Int((b * 255).rounded()))
    }
}

// MARK: - MediCenter Design Tokens
// Derived pixel-for-pixel from the reference designs. Mirrors the web token set.

enum Theme {
    // Brand purple
    static let brand500 = Color(hex: "7C5CFC")
    static let brand600 = Color(hex: "6D4FE0")
    static let brand700 = Color(hex: "5B3FD0")
    static let brandGradient = LinearGradient(
        colors: [Color(hex: "6D4FE0"), Color(hex: "7C5CFC")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // Status
    static let green = Color(hex: "22C55E")
    static let amber = Color(hex: "F59E0B")
    static let red = Color(hex: "EF4444")
    static let rose = Color(hex: "F43F5E")
    static let blue = Color(hex: "3B82F6")

    // Surfaces & text (adaptive)
    static let bg = Color.dynamic(light: "F5F5FB", dark: "0E0B1A")
    static let bgElevated = Color.dynamic(light: "FFFFFF", dark: "17132B")
    static let surface = Color.dynamic(light: "FFFFFF", dark: "1A1730")
    static let surface2 = Color.dynamic(light: "F3F2FB", dark: "211C3C")
    static let text = Color.dynamic(light: "1E1B2E", dark: "FFFFFF")
    static let textMuted = Color.dynamic(light: "8A8699", dark: "9A94B8")
    static let textFaint = Color.dynamic(light: "B4B0C4", dark: "6F6A8C")
    static let border = Color.dynamic(light: "ECE9F6", dark: "2A2544")
    static let borderStrong = Color.dynamic(light: "DDD8EE", dark: "352F52")

    // Tinted status backgrounds
    static let greenSoft = Color.dynamic(light: "E8F8EF", dark: "10261C")
    static let amberSoft = Color.dynamic(light: "FEF3E2", dark: "2A2011")
    static let redSoft = Color.dynamic(light: "FDECEC", dark: "2A1518")
    static let brandSoft = Color.dynamic(light: "EFEAFF", dark: "221A45")
    static let blueSoft = Color.dynamic(light: "E7F0FE", dark: "101F34")

    // Shape
    static let radiusSm: CGFloat = 12
    static let radius: CGFloat = 16
    static let radiusLg: CGFloat = 20
    static let radiusXl: CGFloat = 24
}

// MARK: - Reusable card style

struct CardStyle: ViewModifier {
    var padding: CGFloat = 16
    var radius: CGFloat = Theme.radiusLg
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func card(padding: CGFloat = 16, radius: CGFloat = Theme.radiusLg) -> some View {
        modifier(CardStyle(padding: padding, radius: radius))
    }
}
