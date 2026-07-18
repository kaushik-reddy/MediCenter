import SwiftUI

struct TipOfDayCard: View {
    var text: String = "Take your medicines with water and follow the prescribed dosage."

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack(spacing: 12) {
                TipGlassIllustration()
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tip of the day")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Theme.brand500)
                    Text(text)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.trailing, 52)
                Spacer(minLength: 0)
            }
            .padding(14)

            ShieldCrossIllustration()
                .frame(width: 68, height: 68)
                .offset(x: 4, y: 6)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
