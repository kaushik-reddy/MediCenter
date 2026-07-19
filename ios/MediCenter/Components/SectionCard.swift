import SwiftUI

/// White rounded card container matching the design system.
struct SectionCard<Content: View>: View {
    var padding: CGFloat = 14
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(Theme.border, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

/// "icon  Title ............ Action >" header row.
struct SectionHeader: View {
    var systemImage: String?
    var title: String
    var actionLabel: String?
    var action: (() -> Void)?

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Theme.brand500)
                }
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.text)
            }
            Spacer()
            if let actionLabel {
                Button {
                    action?()
                } label: {
                    HStack(spacing: 2) {
                        Text(actionLabel)
                            .font(.system(size: 12.5, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Theme.brand500)
                }
            }
        }
    }
}
