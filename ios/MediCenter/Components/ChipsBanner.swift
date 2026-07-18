import SwiftUI

struct ChipItem: Identifiable {
    let id = UUID()
    let label: String
    var count: Int? = nil
}

struct ChipsRow: View {
    let items: [ChipItem]
    @Binding var active: String
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items) { c in
                    Button { active = c.label } label: {
                        HStack(spacing: 6) {
                            Text(c.label).font(.system(size: 12.5, weight: .semibold))
                            if let n = c.count {
                                Text("\(n)").font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 5).padding(.vertical, 1)
                                    .background(active == c.label ? Color.white.opacity(0.25) : Theme.surface2)
                                    .clipShape(Capsule())
                            }
                        }
                        .foregroundStyle(active == c.label ? .white : Theme.textMuted)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(active == c.label ? AnyShapeStyle(Theme.brand500) : AnyShapeStyle(Theme.surface))
                        .clipShape(Capsule())
                        .overlay(active == c.label ? nil : Capsule().strokeBorder(Theme.border, lineWidth: 1))
                    }
                }
            }
        }
    }
}

struct InfoBanner: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var showChevron: Bool = false
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 18)).foregroundStyle(Theme.brand500)
                .frame(width: 40, height: 40).background(Theme.surface.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 13.5, weight: .bold)).foregroundStyle(Theme.brand500)
                if let subtitle { Text(subtitle).font(.system(size: 12)).foregroundStyle(Theme.textMuted) }
            }
            Spacer(minLength: 0)
            if showChevron { Image(systemName: "chevron.right").font(.system(size: 15)).foregroundStyle(Theme.brand500) }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.brandSoft)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
