import SwiftUI

struct NextDoseCard: View {
    let dose: NextDose
    var onTaken: () -> Void = {}

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient (navy -> purple with a bottom-right glow)
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "191A2E"), Color(hex: "241F45"), Color(hex: "3A2A6B")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                RadialGradient(
                    colors: [Color(hex: "7C5CFC").opacity(0.55), Color.clear],
                    center: .bottomTrailing, startRadius: 0, endRadius: 260
                )
            }

            // Illustration — pinned to the top-right of the hero card
            PillGlassIllustration()
                .frame(width: 150, height: 108)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 10)
                .padding(.trailing, 12)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 0) {
                Text("NEXT DOSE")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(Color(hex: "5EEAD4"))

                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text("In")
                        .font(.system(size: 26, weight: .semibold))
                    Text(dose.inLabel)
                        .font(.system(size: 44, weight: .heavy))
                        .foregroundStyle(Color(hex: "5EEAD4"))
                    Text("hrs")
                        .font(.system(size: 22, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.top, 2)

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12, weight: .semibold))
                    Text(dose.atTime)
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.12))
                .clipShape(Capsule())
                .padding(.top, 10)

                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 1)
                    .padding(.vertical, 12)

                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(dose.name)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Text(dose.detail)
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    Spacer(minLength: 8)
                    Button(action: onTaken) {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .heavy))
                            Text("Mark as Taken")
                                .font(.system(size: 12.5, weight: .bold))
                        }
                        .foregroundStyle(Color(hex: "0B3B2E"))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(
                            LinearGradient(colors: [Color(hex: "8BF0C0"), Color(hex: "5FD6A0")],
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color(hex: "321E6E").opacity(0.5), radius: 18, x: 0, y: 14)
    }
}
