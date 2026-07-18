import SwiftUI

struct RefillCarousel: View {
    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(systemImage: "shippingbox", title: "Refill & Low Stock", actionLabel: "View all")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MedicationsData.refills) { item in
                            RefillCard(item: item)
                        }
                    }
                }
            }
        }
    }
}

private struct RefillCard: View {
    let item: RefillItem
    private var accent: Color { item.isLow ? Theme.red : Theme.amber }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                MedThumb(kind: item.kind, tint: .white, pillColor: item.pillColor, size: 52)
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(item.name).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text).lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold)).foregroundStyle(Theme.textFaint)
                    }
                    Text(item.statusLabel).font(.system(size: 12, weight: .semibold)).foregroundStyle(accent)
                    Text(item.detail).font(.system(size: 11)).foregroundStyle(Theme.textMuted).lineLimit(1)
                }
            }

            Button {} label: {
                HStack(spacing: 6) {
                    Image(systemName: item.isLow ? "cart" : "bell.badge").font(.system(size: 13))
                    Text(item.isLow ? "Reorder" : "Set Reminder").font(.system(size: 12.5, weight: .bold))
                }
                .foregroundStyle(accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(accent, lineWidth: 1))
            }
        }
        .padding(12)
        .frame(width: 240)
        .background(item.tint)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
