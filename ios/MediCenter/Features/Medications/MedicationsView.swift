import SwiftUI

struct MedicationsView: View {
    @Environment(AppState.self) private var app
    @State private var tab: Tab = .medications
    @State private var query: String = ""

    enum Tab { case medications, supplements }

    private var source: [Medication] {
        MedicationsData.items(for: tab == .supplements ? .supplement : .medication)
    }

    private var filtered: [Medication] {
        query.isEmpty
            ? source
            : source.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Medications", subtitle: "Manage all your medicines in one place.")

            ScrollView {
                VStack(spacing: 12) {
                    tabs
                    searchRow

                    ForEach(filtered) { med in
                        Button { app.present(MedicationOptionsModal(name: med.name)) } label: {
                            MedicationCard(med: med)
                        }
                        .buttonStyle(.plain)
                    }

                    if filtered.isEmpty {
                        Text("No \(tab == .supplements ? "supplements" : "medications") found.")
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.textMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 32)
                            .background(Theme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(Theme.border, lineWidth: 1))
                    }

                    RefillCarousel()

                    TipOfDayCard(text: "Store medicines in a cool, dry place and away from direct sunlight.")
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 120)
            }
        }
        .background(Theme.bg)
    }

    private var tabs: some View {
        HStack(spacing: 6) {
            tabButton(.medications, icon: "pills", label: "My Medications")
            tabButton(.supplements, icon: "leaf", label: "Supplements")
        }
        .padding(6)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Theme.border, lineWidth: 1))
    }

    private func tabButton(_ t: Tab, icon: String, label: String) -> some View {
        let active = tab == t
        return Button { tab = t } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                Text(label).font(.system(size: 13.5, weight: .bold))
            }
            .foregroundStyle(active ? Theme.brand500 : Theme.textMuted)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(active ? Theme.brandSoft : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private var searchRow: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").font(.system(size: 15)).foregroundStyle(Theme.textFaint)
                TextField("Search medication", text: $query)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.text)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Theme.border, lineWidth: 1))

            Button { app.present(FilterModal()) } label: {
                HStack(spacing: 6) {
                    Image(systemName: "slider.horizontal.3").font(.system(size: 14))
                    Text("Filter").font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(Theme.brand500)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Theme.brand500.opacity(0.4), lineWidth: 1))
            }
        }
    }
}
