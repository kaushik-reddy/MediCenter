import SwiftUI

// SwiftUI illustrations approximating the reference 3D renders. Mirrors the web SVGs.

struct PillGlassIllustration: View {
    var body: some View {
        ZStack {
            // Glass of water
            GlassShape()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.white.opacity(0.12)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .overlay(GlassShape().stroke(Color.white.opacity(0.5), lineWidth: 1.5))
                .overlay(
                    GlassShape()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "BFE9FF").opacity(0.85), Color(hex: "7FC7F5").opacity(0.7)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .mask(Rectangle().padding(.top, 34))
                )
                .frame(width: 70, height: 96)
                .offset(x: 44, y: -4)

            // Round white pill
            ZStack {
                Ellipse().fill(Color.white).frame(width: 52, height: 40)
                Rectangle().fill(Color(hex: "D7D7E6")).frame(width: 40, height: 2)
            }
            .offset(x: -2, y: 26)

            // Green/white capsule
            ZStack {
                Capsule().fill(Color.white)
                Capsule()
                    .fill(
                        LinearGradient(colors: [Color(hex: "4ADE80"), Color(hex: "22C55E")],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .mask(HStack(spacing: 0) { Rectangle(); Color.clear })
            }
            .frame(width: 86, height: 34)
            .rotationEffect(.degrees(-28))
            .offset(x: -34, y: 6)
        }
    }
}

private struct GlassShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width, h = rect.height
        p.move(to: CGPoint(x: w * 0.08, y: 0))
        p.addLine(to: CGPoint(x: w * 0.92, y: 0))
        p.addLine(to: CGPoint(x: w * 0.78, y: h))
        p.addLine(to: CGPoint(x: w * 0.22, y: h))
        p.closeSubpath()
        return p
    }
}

struct TipGlassIllustration: View {
    var body: some View {
        ZStack {
            GlassShape()
                .fill(Color.white.opacity(0.65))
                .overlay(GlassShape().stroke(Color(hex: "C9D6EA"), lineWidth: 1.2))
                .overlay(
                    GlassShape()
                        .fill(Color(hex: "8FCFF3").opacity(0.85))
                        .mask(Rectangle().padding(.top, 18))
                )
                .frame(width: 34, height: 48)
                .offset(y: -6)
            HStack(spacing: 3) {
                Circle().fill(Color(hex: "F59E0B")).frame(width: 13, height: 13)
                Circle().fill(Color(hex: "8B5CF6")).frame(width: 12, height: 12)
                Circle().fill(Color(hex: "22C55E")).frame(width: 11, height: 11)
                Circle().fill(Color(hex: "EF4444")).frame(width: 10, height: 10)
            }
            .offset(y: 22)
        }
        .frame(width: 56, height: 56)
    }
}

struct ShieldCrossIllustration: View {
    var body: some View {
        ZStack {
            Image(systemName: "sparkle")
                .font(.system(size: 10))
                .foregroundStyle(Color(hex: "A78BFA"))
                .offset(x: -26, y: -18)
            Image(systemName: "heart.fill")
                .font(.system(size: 9))
                .foregroundStyle(Color(hex: "C4B5FD"))
                .offset(x: -20, y: 2)
            ZStack {
                Image(systemName: "shield.fill")
                    .font(.system(size: 58))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "8B5CF6"), Color(hex: "6D4FE0")],
                                       startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                Image(systemName: "cross.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
            }
            .offset(x: 12)
        }
        .frame(width: 80, height: 80)
    }
}
