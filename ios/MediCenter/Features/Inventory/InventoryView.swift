import SwiftUI

struct InventoryView: View {
    @Environment(AppState.self) private var app
    @State private var chip = "All"

    struct Item: Identifiable { let id = UUID(); let name: String; let detail: String; let kind: PillKind; let tint: Color; let pill: Color; let statusLabel: String; let badge: Color; let bar: Color; let left: Int; let total: Int; let refill: String }
    private let items: [Item] = [
        Item(name: "Paracetamol 650mg", detail: "1 Tablet · 3 times daily", kind: .capsule, tint: Color(hex: "E7F6EE"), pill: Color(hex: "22C55E"), statusLabel: "Healthy", badge: Theme.green, bar: Theme.green, left: 18, total: 20, refill: "Refill in 12 days"),
        Item(name: "B-Complex", detail: "1 Tablet · Once daily", kind: .tablet, tint: Color(hex: "FDE7F0"), pill: Color(hex: "EC4899"), statusLabel: "Low Stock", badge: Theme.amber, bar: Theme.amber, left: 3, total: 30, refill: "Refill in 3 days"),
        Item(name: "Cetirizine 10mg", detail: "1 Tablet · At night", kind: .tablet, tint: Color(hex: "EEF0F3"), pill: Color(hex: "E5E7EB"), statusLabel: "Critical", badge: Theme.red, bar: Theme.red, left: 0, total: 10, refill: "Out of stock"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Inventory & Refill", subtitle: "Keep your medicines stocked")
            ScrollView {
                VStack(spacing: 12) {
                    InfoBanner(icon: "shippingbox", title: "Never run out", subtitle: "Track stock and set refill reminders")
                    ChipsRow(items: [ChipItem(label: "All", count: 8), ChipItem(label: "Low Stock", count: 3), ChipItem(label: "Refill Due", count: 2), ChipItem(label: "Out of Stock", count: 1)], active: $chip)
                    ForEach(items) { it in card(it) }
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 24)
            }
        }
        .background(Theme.bg)
    }

    private func card(_ it: Item) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                MedThumb(kind: it.kind, tint: it.tint, pillColor: it.pill, size: 60)
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(it.name).font(.system(size: 15, weight: .bold)).foregroundStyle(Theme.text)
                        Spacer()
                        Text(it.statusLabel).font(.system(size: 10.5, weight: .semibold)).foregroundStyle(it.badge)
                            .padding(.horizontal, 8).padding(.vertical, 2).background(it.badge.opacity(0.14)).clipShape(Capsule())
                    }
                    Text(it.detail).font(.system(size: 12)).foregroundStyle(Theme.textMuted)
                }
            }
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    Text("\(it.left)").font(.system(size: 15, weight: .heavy)).foregroundStyle(it.badge)
                    Text("tablets left").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                    Spacer()
                    Text("out of \(it.total)").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Theme.surface2)
                        Capsule().fill(it.bar).frame(width: geo.size.width * CGFloat(it.left) / CGFloat(it.total))
                    }
                }.frame(height: 8)
                HStack {
                    Text(it.refill).font(.system(size: 12, weight: .semibold)).foregroundStyle(it.badge)
                    Spacer()
                    Button { app.present(ReorderModal(name: it.name)) } label: {
                        HStack(spacing: 6) { Image(systemName: "cart").font(.system(size: 12)); Text("Reorder").font(.system(size: 12, weight: .bold)) }
                            .foregroundStyle(.white).padding(.horizontal, 12).padding(.vertical, 6)
                            .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .padding(12).background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
    }
}
