import ActivityKit
import WidgetKit
import SwiftUI

/// MediCenter Live Activity — Lock Screen banner + all Dynamic Island presentations.
/// Styled after rich "box-box F1"-type activities: bold accent, big live countdown, and a
/// compact ticker in the pill. Modes come from `MedActivityAttributes.ContentState.mode`.
struct DoseLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MedActivityAttributes.self) { context in
            LockScreenView(context: context)
                .activityBackgroundTint(Color.black.opacity(0.92))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            let accent = Color(hex: context.state.accentHex)
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: icon(for: context.state))
                        .font(.title3)
                        .foregroundStyle(accent)
                        .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    trailing(context: context, accent: accent)
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 2) {
                        Text(context.state.medName)
                            .font(.subheadline).bold().lineLimit(1)
                        Text(context.state.dose)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        if context.state.isCountdown, let target = context.state.targetDate {
                            ProgressView(timerInterval: range(to: target), countsDown: true) {
                                EmptyView()
                            } currentValueLabel: { EmptyView() }
                            .tint(accent)
                        } else if context.state.isProgress {
                            ProgressView(value: fraction(context.state))
                                .tint(accent)
                        }
                        Text(context.state.message)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .padding(.top, 2)
                }
            } compactLeading: {
                Image(systemName: icon(for: context.state))
                    .foregroundStyle(Color(hex: context.state.accentHex))
            } compactTrailing: {
                compactTrailing(context: context, accent: Color(hex: context.state.accentHex))
            } minimal: {
                Image(systemName: icon(for: context.state))
                    .foregroundStyle(Color(hex: context.state.accentHex))
            }
            .keylineTint(accent)
        }
    }

    private func icon(for state: MedActivityAttributes.ContentState) -> String {
        if state.isDue { return "bell.fill" }
        if state.isProgress { return "checklist" }
        return "clock.fill"
    }

    @ViewBuilder
    private func trailing(context: ActivityViewContext<MedActivityAttributes>, accent: Color) -> some View {
        if context.state.isCountdown, let target = context.state.targetDate {
            Text(timerInterval: range(to: target), countsDown: true)
                .font(.headline).monospacedDigit()
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 74)
                .foregroundStyle(accent)
                .padding(.trailing, 4)
        } else if context.state.isProgress {
            Text("\(context.state.dosesTaken)/\(context.state.dosesTotal)")
                .font(.headline).monospacedDigit()
                .foregroundStyle(accent)
                .padding(.trailing, 4)
        } else {
            Text("NOW")
                .font(.caption).bold()
                .foregroundStyle(accent)
                .padding(.trailing, 4)
        }
    }

    @ViewBuilder
    private func compactTrailing(context: ActivityViewContext<MedActivityAttributes>, accent: Color) -> some View {
        if context.state.isCountdown, let target = context.state.targetDate {
            Text(timerInterval: range(to: target), countsDown: true)
                .font(.caption2).monospacedDigit()
                .frame(maxWidth: 54)
                .foregroundStyle(accent)
        } else if context.state.isProgress {
            Text("\(context.state.dosesTaken)/\(context.state.dosesTotal)")
                .font(.caption2).monospacedDigit()
                .foregroundStyle(accent)
        } else {
            Text("NOW").font(.caption2).bold().foregroundStyle(accent)
        }
    }

    private func fraction(_ s: MedActivityAttributes.ContentState) -> Double {
        s.dosesTotal > 0 ? Double(s.dosesTaken) / Double(s.dosesTotal) : 0
    }

    private func range(to target: Date) -> ClosedRange<Date> {
        let start = min(Date(), target)
        let end = max(target, start.addingTimeInterval(1))
        return start...end
    }
}

/// Lock Screen / banner layout, mode-aware.
private struct LockScreenView: View {
    let context: ActivityViewContext<MedActivityAttributes>

    var body: some View {
        let state = context.state
        let accent = Color(hex: state.accentHex)
        HStack(spacing: 12) {
            Image(systemName: state.isDue ? "bell.fill" : (state.isProgress ? "checklist" : "clock.fill"))
                .font(.title2)
                .foregroundStyle(accent)
                .frame(width: 44, height: 44)
                .background(accent.opacity(0.16), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(state.medName)
                        .font(.headline).foregroundStyle(.white).lineLimit(1)
                    Spacer()
                    if state.isCountdown, let target = state.targetDate {
                        Text(timerInterval: WidgetRange.range(to: target), countsDown: true)
                            .font(.subheadline).bold().monospacedDigit()
                            .frame(maxWidth: 84)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(accent)
                    } else if state.isProgress {
                        Text("\(state.dosesTaken)/\(state.dosesTotal)")
                            .font(.subheadline).bold().monospacedDigit()
                            .foregroundStyle(accent)
                    } else {
                        Text("NOW").font(.caption).bold().foregroundStyle(accent)
                    }
                }
                if state.isCountdown, let target = state.targetDate {
                    ProgressView(timerInterval: WidgetRange.range(to: target), countsDown: true) {
                        EmptyView()
                    } currentValueLabel: { EmptyView() }
                    .tint(accent)
                } else if state.isProgress {
                    ProgressView(value: state.dosesTotal > 0 ? Double(state.dosesTaken) / Double(state.dosesTotal) : 0)
                        .tint(accent)
                }
                Text(state.message)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }
        }
        .padding(16)
    }
}

private enum WidgetRange {
    static func range(to target: Date) -> ClosedRange<Date> {
        let start = min(Date(), target)
        let end = max(target, start.addingTimeInterval(1))
        return start...end
    }
}
