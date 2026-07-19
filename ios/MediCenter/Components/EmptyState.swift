import SwiftUI

/// Reusable empty-state card shown when a screen/section has no user data yet.
struct EmptyState: View {
    var icon: String = "tray"
    let title: String
    let message: String
    var actionLabel: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundStyle(Theme.brand500)
                .frame(width: 64, height: 64)
                .background(Theme.brandSoft)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

            Text(title).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
            Text(message)
                .font(.system(size: 12.5))
                .foregroundStyle(Theme.textMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 260)

            if let actionLabel, let action {
                Button(action: action) {
                    Text(actionLabel)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18).padding(.vertical, 10)
                        .background(Theme.brandGradient)
                        .clipShape(Capsule())
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .padding(.horizontal, 20)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Theme.border, lineWidth: 1))
    }
}
