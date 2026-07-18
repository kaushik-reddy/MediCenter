import SwiftUI

/// Rounded tinted tile with a small pill illustration (capsule / softgel / tablet).
struct MedThumb: View {
    let kind: PillKind
    let tint: Color
    let pillColor: Color
    var size: CGFloat = 68

    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(tint)
            .frame(width: size, height: size)
            .overlay(pill.frame(width: size * 0.66, height: size * 0.66))
    }

    @ViewBuilder
    private var pill: some View {
        switch kind {
        case .capsule:
            ZStack {
                Capsule().fill(.white)
                Capsule()
                    .fill(pillColor)
                    .mask(HStack(spacing: 0) { Rectangle(); Color.clear })
            }
            .frame(height: 20)
            .rotationEffect(.degrees(-35))
        case .softgel:
            Ellipse()
                .fill(
                    LinearGradient(colors: [pillColor.opacity(0.85), pillColor],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .frame(height: 26)
                .rotationEffect(.degrees(-30))
                .overlay(
                    Ellipse().fill(.white.opacity(0.5)).frame(width: 14, height: 6)
                        .rotationEffect(.degrees(-30)).offset(x: -4, y: -6)
                )
        case .tablet:
            ZStack {
                Circle().fill(pillColor)
                Rectangle().fill(.black.opacity(0.08)).frame(height: 2)
            }
        }
    }
}
