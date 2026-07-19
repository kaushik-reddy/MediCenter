import SwiftUI

/// Frosted "liquid glass" surface. Uses a translucent `Material` so content behind shows
/// through with a live blur, plus a soft top-down highlight stroke and a drop shadow — the
/// glassmorphism look. Works on iOS 15+ (no iOS 26 `glassEffect` dependency), so it compiles
/// everywhere. Best used on floating chrome that sits over scrolling content.
struct GlassBackground<S: Shape>: ViewModifier {
    let shape: S
    var material: Material = .ultraThinMaterial
    var highlight: Double = 0.55
    var shadowRadius: CGFloat = 20
    var shadowY: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .background(shape.fill(material))
            .overlay(
                shape.stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(highlight), Color.white.opacity(highlight * 0.2)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 1
                )
            )
            .clipShape(shape)
            .shadow(color: .black.opacity(0.14), radius: shadowRadius, x: 0, y: shadowY)
    }
}

extension View {
    /// Frosted glass rounded-rect surface.
    func glass(_ cornerRadius: CGFloat,
               material: Material = .ultraThinMaterial,
               shadowRadius: CGFloat = 20,
               shadowY: CGFloat = 8) -> some View {
        modifier(GlassBackground(
            shape: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            material: material, shadowRadius: shadowRadius, shadowY: shadowY
        ))
    }

    /// Frosted glass circular surface (icon buttons, badges).
    func glassCircle(material: Material = .ultraThinMaterial,
                     shadowRadius: CGFloat = 8,
                     shadowY: CGFloat = 3) -> some View {
        modifier(GlassBackground(shape: Circle(), material: material,
                                 shadowRadius: shadowRadius, shadowY: shadowY))
    }
}
