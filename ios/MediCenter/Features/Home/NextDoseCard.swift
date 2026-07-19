import SwiftUI

struct NextDoseCard: View {
    @Environment(AppState.self) private var app
    let dose: NextDose

    private let teal = Color(hex: "5EEAD4")

    /// Next occurrence of the dose time, used to drive the live countdown.
    private var targetDate: Date {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "hh:mm a"
        let cal = Calendar.current
        let now = Date()
        guard let parsed = f.date(from: dose.atTime) else { return now.addingTimeInterval(3600) }
        let t = cal.dateComponents([.hour, .minute], from: parsed)
        var dc = cal.dateComponents([.year, .month, .day], from: now)
        dc.hour = t.hour; dc.minute = t.minute; dc.second = 0
        let candidate = cal.date(from: dc) ?? now
        return candidate > now ? candidate : (cal.date(byAdding: .day, value: 1, to: candidate) ?? candidate)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient (navy -> purple with a bottom-right glow)
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "191A2E"), Color(hex: "241F45"), Color(hex: "3A2A6B")],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                RadialGradient(
                    colors: [Color(hex: "7C5CFC").opacity(0.55), Color.clear],
                    center: .bottomTrailing, startRadius: 0, endRadius: 260
                )
            }

            // Illustration — hugged to the top-right corner
            PillGlassIllustration()
                .frame(width: 138, height: 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 8)
                .padding(.trailing, 6)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 0) {
                Text("NEXT DOSE")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(2)
                    .foregroundStyle(teal)

                // Live countdown with seconds
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("In")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                    TimelineView(.periodic(from: .now, by: 1)) { context in
                        Text(countdown(to: targetDate, now: context.date))
                            .font(.system(size: 33, weight: .heavy))
                            .monospacedDigit()
                            .foregroundStyle(teal)
                    }
                }
                .padding(.top, 2)

                HStack(spacing: 6) {
                    Image(systemName: "clock").font(.system(size: 12, weight: .semibold))
                    Text(dose.atTime).font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.12))
                .clipShape(Capsule())
                .padding(.top, 10)

                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 1)
                    .padding(.vertical, 12)

                VStack(alignment: .leading, spacing: 2) {
                    Text(dose.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(dose.detail)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.65))
                }

                // Actions available right here: Taken / Snooze / Reschedule / Skip
                HStack(spacing: 8) {
                    Button {
                        AdherenceStore.shared.markTakenToday()
                        app.present(MarkAsTakenModal(name: dose.name))
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "checkmark").font(.system(size: 13, weight: .heavy))
                            Text("Taken").font(.system(size: 12.5, weight: .bold))
                        }
                        .foregroundStyle(Color(hex: "0B3B2E"))
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .background(LinearGradient(colors: [Color(hex: "8BF0C0"), Color(hex: "5FD6A0")],
                                                   startPoint: .top, endPoint: .bottom))
                        .clipShape(Capsule())
                    }
                    Spacer(minLength: 4)
                    actionIcon("moon.fill") { app.present(SnoozeModal(name: dose.name)) }
                    actionIcon("calendar.badge.clock") { app.present(RescheduleDoseModal(name: dose.name, current: dose.atTime)) }
                    actionIcon("forward.end.fill") {
                        AdherenceStore.shared.skipToday()
                        app.present(ConfirmSkipModal())
                    }
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color(hex: "321E6E").opacity(0.5), radius: 18, x: 0, y: 14)
        .contentShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onTapGesture { app.open(.medicineDetail(dose.name)) }
    }

    private func actionIcon(_ icon: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(Color.white.opacity(0.14))
                .clipShape(Circle())
        }
    }

    private func countdown(to target: Date, now: Date) -> String {
        let s = max(0, Int(target.timeIntervalSince(now)))
        return String(format: "%02d:%02d:%02d", s / 3600, (s % 3600) / 60, s % 60)
    }
}
