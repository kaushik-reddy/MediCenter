import SwiftUI

/// White rounded card grouping settings rows.
struct SettingsCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 0) { content }
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
            .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
    }
}

struct SettingsSectionLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold))
            .foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
            .padding(.bottom, 6)
    }
}

enum RowTrailing {
    case chevron
    case toggle(Binding<Bool>)
    case pill(icon: String?, label: String)
    case none
}

struct SettingsRow: View {
    let icon: String
    var iconBg: Color = Theme.brandSoft
    var iconFg: Color = Theme.brand500
    let title: String
    var subtitle: String? = nil
    var trailing: RowTrailing = .chevron
    var last: Bool = false
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon).font(.system(size: 18)).foregroundStyle(iconFg)
                    .frame(width: 40, height: 40).background(iconBg)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(.system(size: 14.5, weight: .semibold)).foregroundStyle(Theme.text)
                    if let subtitle {
                        Text(subtitle).font(.system(size: 12)).foregroundStyle(Theme.textMuted).lineLimit(1)
                    }
                }
                Spacer(minLength: 4)
                trailingView
            }
            .padding(.horizontal, 14).padding(.vertical, 11)
            .overlay(last ? nil : Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .bottom)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder private var trailingView: some View {
        switch trailing {
        case .chevron:
            Image(systemName: "chevron.right").font(.system(size: 15, weight: .semibold)).foregroundStyle(Theme.textFaint)
        case .toggle(let binding):
            Toggle("", isOn: binding).labelsHidden().tint(Theme.brand500)
        case .pill(let icon, let label):
            HStack(spacing: 4) {
                if let icon { Image(systemName: icon).font(.system(size: 12)) }
                Text(label).font(.system(size: 12, weight: .semibold))
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .semibold))
            }
            .foregroundStyle(Theme.brand500)
            .padding(.horizontal, 10).padding(.vertical, 6)
            .background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 8))
        case .none:
            EmptyView()
        }
    }
}
