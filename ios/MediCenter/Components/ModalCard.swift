import SwiftUI

/// Centered card popup matching the reference pop-up sheets.
struct ModalCard<Content: View>: View {
    @Environment(AppState.self) private var app
    var icon: String? = nil
    var iconBg: Color = Theme.brandSoft
    var iconFg: Color = Theme.brand500
    var title: String? = nil
    var subtitle: String? = nil
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 4) {
                    if let icon {
                        Image(systemName: icon).font(.system(size: 22)).foregroundStyle(iconFg)
                            .frame(width: 56, height: 56).background(iconBg)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.bottom, 8)
                    }
                    if let title {
                        Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                    }
                    if let subtitle {
                        Text(subtitle).font(.system(size: 12)).foregroundStyle(Theme.textMuted)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)

                Button { app.dismissModal() } label: {
                    Image(systemName: "xmark").font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)
                        .frame(width: 30, height: 30).background(Theme.surface2).clipShape(Circle())
                }
            }
            .padding(.bottom, (icon != nil || title != nil) ? 16 : 0)

            content
        }
        .padding(20)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: 24, y: 12)
    }
}

/// Text field used inside modals.
struct ModalField: View {
    let label: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.textMuted)
            TextField("", text: $text)
                .font(.system(size: 14)).foregroundStyle(Theme.text)
                .padding(.horizontal, 14).padding(.vertical, 12)
                .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
        }
        .padding(.bottom, 12)
    }
}

/// Cancel + primary action row.
struct ModalActions: View {
    @Environment(AppState.self) private var app
    var primaryLabel: String
    var secondaryLabel: String = "Cancel"
    var primaryColor: AnyShapeStyle = AnyShapeStyle(Theme.brandGradient)
    var onPrimary: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Button { app.dismissModal() } label: {
                Text(secondaryLabel).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
            }
            Button { onPrimary(); app.dismissModal() } label: {
                Text(primaryLabel).font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(primaryColor).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, 4)
    }
}
