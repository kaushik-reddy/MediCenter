import SwiftUI

/// Medicine / Refill Details screen (mirrors web MedicineDetailPage.tsx).
/// Shown when tapping a medication card. Demo stock values are local for testing.
struct MedicineDetailView: View {
    @Environment(AppState.self) private var app
    let name: String

    @State private var note = ""

    private var med: Medication? { MedicationsData.find(name: name) }
    private let stock = 12
    private let total = 20
    private var pct: Int { total > 0 ? Int(Double(stock) / Double(total) * 100) : 0 }

    var body: some View {
        Group {
            if let med {
                content(med)
            } else {
                VStack(spacing: 12) {
                    TopBar(title: "Medicine Details", subtitle: "View and manage your medicine")
                    Spacer()
                    Text("Medicine not found").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                    Spacer()
                }
            }
        }
        .background(Theme.bg)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func content(_ med: Medication) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 10) {
                Button { app.goBack() } label: {
                    Image(systemName: "arrow.left").font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Theme.text).frame(width: 36, height: 36)
                        .background(Theme.surface).clipShape(Circle()).shadow(color: .black.opacity(0.06), radius: 8, y: 3)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text("Medicine Details").font(.system(size: 15.5, weight: .bold)).foregroundStyle(Theme.text)
                    Text("View and manage your medicine").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16).padding(.vertical, 8)

            ScrollView {
                VStack(spacing: 12) {
                    hero(med)
                    infoRow(med)
                    scheduleSection(med)
                    stockSection
                    statsRow
                    informationSection
                    notesSection
                    footer(med)
                }
                .padding(.horizontal, 16).padding(.top, 4).padding(.bottom, 120)
            }
        }
    }

    // MARK: Hero
    private func hero(_ med: Medication) -> some View {
        SectionCard {
            HStack(alignment: .top, spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    MedThumb(kind: med.kind, tint: med.tint, pillColor: med.pillColor, size: 104)
                    Image(systemName: "camera.fill").font(.system(size: 11)).foregroundStyle(.white)
                        .frame(width: 26, height: 26).background(Theme.brand500).clipShape(Circle())
                        .overlay(Circle().strokeBorder(Theme.surface, lineWidth: 2)).offset(x: -4, y: -4)
                }
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        Text(med.name).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                        Spacer()
                        HStack(spacing: 3) { Image(systemName: "pencil").font(.system(size: 11)); Text("Edit").font(.system(size: 12, weight: .semibold)) }
                            .foregroundStyle(Theme.brand500)
                    }
                    Text(med.category == .supplement ? "Supplement" : "Pain Reliever")
                        .font(.system(size: 10.5, weight: .semibold)).foregroundStyle(Theme.green)
                        .padding(.horizontal, 8).padding(.vertical, 2).background(Theme.greenSoft).clipShape(Capsule())
                    Text("Used to relieve mild to moderate pain such as headache, body ache, and fever.")
                        .font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                    HStack(spacing: 6) {
                        chip("pills", med.kind == .tablet ? "Tablet" : med.kind == .capsule ? "Capsule" : "Syrup")
                        chip("doc.text", "Prescription")
                    }
                }
            }
        }
    }

    // MARK: Info row (4 tiles)
    private func infoRow(_ med: Medication) -> some View {
        SectionCard(padding: 12) {
            HStack(spacing: 6) {
                infoTile("calendar", Theme.green, Theme.greenSoft, "Start Date", "10 May 2024")
                infoTile("calendar.badge.clock", Theme.brand500, Theme.brandSoft, "End Date", "10 Jun 2024")
                infoTile(med.foodIcon, Theme.amber, Theme.amberSoft, "Take", med.food)
                infoTile("stethoscope", Theme.blue, Theme.blueSoft, "By", "Dr. Sharma")
            }
        }
    }

    // MARK: Schedule
    private func scheduleSection(_ med: Medication) -> some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("Schedule", "View All") { app.open(.reminders) }
                HStack(spacing: 12) {
                    Image(systemName: "sunrise.fill").font(.system(size: 16)).foregroundStyle(Theme.amber)
                        .frame(width: 40, height: 40).background(Theme.amberSoft).clipShape(RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 1) {
                        Text(med.time).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        Text("\(med.dose) · \(med.food)").font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                    }
                    Spacer()
                }
                .padding(12).background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: Stock & Refill
    private var stockSection: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("Stock & Refill", nil, nil)
                HStack(spacing: 12) {
                    Image(systemName: "calendar").font(.system(size: 20)).foregroundStyle(Theme.brand500)
                        .frame(width: 48, height: 48).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 14))
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 4) {
                            Text("\(stock)").font(.system(size: 15, weight: .heavy)).foregroundStyle(Theme.brand500)
                            Text("Tablets Left").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.text)
                        }
                        Text("Out of \(total) Tablets").font(.system(size: 11)).foregroundStyle(Theme.textMuted)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Theme.surface2)
                                Capsule().fill(Theme.brand500).frame(width: geo.size.width * CGFloat(pct) / 100)
                            }
                        }
                        .frame(height: 6)
                        Text("\(pct)% Remaining").font(.system(size: 10.5, weight: .semibold)).foregroundStyle(Theme.brand500)
                    }
                    Button { app.present(SetReminderModal(name: name, med: med)) } label: {
                        Image(systemName: "bell").font(.system(size: 15)).foregroundStyle(Theme.brand500)
                            .frame(width: 36, height: 36).background(Theme.brandSoft).clipShape(Circle())
                    }
                }

                HStack(spacing: 8) {
                    refillOption("plus.circle", "Add Stock", Theme.brand500, Theme.brandSoft) { app.present(AddStockModal(name: name)) }
                    refillOption("bell.badge", "Reminder", Theme.amber, Theme.amberSoft) { app.present(SetReminderModal(name: name, med: med)) }
                    refillOption("cart", "Buy Online", Theme.green, Theme.greenSoft) { app.present(ReorderModal(name: name)) }
                }
            }
        }
    }

    private func refillOption(_ icon: String, _ label: String, _ fg: Color, _ bg: Color, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(fg)
                Text(label).font(.system(size: 10.5, weight: .semibold)).foregroundStyle(fg)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(bg).clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Stats
    private var statsRow: some View {
        SectionCard(padding: 12) {
            HStack(spacing: 6) {
                statTile("checkmark", Theme.green, Theme.greenSoft, "0", "Taken")
                statTile("clock", Theme.amber, Theme.amberSoft, "0", "Late")
                statTile("xmark", Theme.red, Theme.redSoft, "0", "Missed")
                statTile("chart.line.uptrend.xyaxis", Theme.brand500, Theme.brandSoft, "—", "Adherence")
            }
        }
    }

    // MARK: Information
    private var informationSection: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("Information", nil, nil)
                infoDetail("exclamationmark.triangle", "Side Effects", "Nausea, Rash, Stomach upset (rare)")
                infoDetail("info.circle", "Important Notes", "Do not exceed the recommended dose.")
                infoDetail("shield.lefthalf.filled", "Interactions", "Avoid alcohol while taking this medicine.")
            }
        }
    }

    // MARK: Notes
    private var notesSection: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("My Notes", "+ Add Note", nil)
                TextField("Add a note about this medicine…", text: $note, axis: .vertical)
                    .lineLimit(2...4).font(.system(size: 12.5))
                    .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: Footer
    private func footer(_ med: Medication) -> some View {
        HStack(spacing: 12) {
            Button { app.present(DeleteModal(name: med.name)) } label: {
                HStack(spacing: 6) { Image(systemName: "trash"); Text("Delete Medicine").font(.system(size: 14, weight: .bold)) }
                    .foregroundStyle(Theme.red).frame(maxWidth: .infinity).padding(.vertical, 12)
                    .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.red.opacity(0.5), lineWidth: 1))
            }
            Button {} label: {
                HStack(spacing: 6) { Image(systemName: "pause"); Text("Pause Medicine").font(.system(size: 14, weight: .bold)) }
                    .foregroundStyle(.white).frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(.top, 4)
    }

    // MARK: Helpers
    private func chip(_ icon: String, _ label: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 10))
            Text(label).font(.system(size: 10.5, weight: .semibold))
        }
        .foregroundStyle(Theme.textMuted)
        .padding(.horizontal, 8).padding(.vertical, 5)
        .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Theme.border, lineWidth: 1))
    }

    private func infoTile(_ icon: String, _ fg: Color, _ bg: Color, _ label: String, _ value: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(fg)
                .frame(width: 32, height: 32).background(bg).clipShape(Circle())
            Text(label).font(.system(size: 9)).foregroundStyle(Theme.textMuted)
            Text(value).font(.system(size: 10, weight: .bold)).foregroundStyle(Theme.text).lineLimit(1).minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
    }

    private func statTile(_ icon: String, _ fg: Color, _ bg: Color, _ n: String, _ label: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(fg)
                .frame(width: 32, height: 32).background(bg).clipShape(Circle())
            Text(n).font(.system(size: 15, weight: .heavy)).foregroundStyle(fg)
            Text(label).font(.system(size: 9.5)).foregroundStyle(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private func infoDetail(_ icon: String, _ title: String, _ sub: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).font(.system(size: 15)).foregroundStyle(Theme.brand500)
                .frame(width: 34, height: 34).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 13, weight: .bold)).foregroundStyle(Theme.text)
                Text(sub).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 0)
        }
    }

    private func sectionHeader(_ title: String, _ action: String?, _ onAction: (() -> Void)?) -> some View {
        HStack {
            Text(title).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
            Spacer()
            if let action {
                Button { onAction?() } label: {
                    Text(action).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.brand500)
                }
            }
        }
    }
}
