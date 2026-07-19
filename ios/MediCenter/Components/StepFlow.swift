import SwiftUI

/// One node in a step flow.
struct FlowStep {
    let icon: String
    let label: String
}

/// Compact horizontal step timeline shown at the top of multi-step popups.
/// The CURRENT step expands into a pill (icon + full label); completed steps show a check;
/// upcoming steps show only their icon. Nodes are joined by a connector that fills as you progress.
struct StepTimeline: View {
    let steps: [FlowStep]
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(steps.indices, id: \.self) { i in
                node(i)
                if i < steps.count - 1 {
                    Capsule()
                        .fill(i < current ? Theme.brand500 : Theme.border)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.85), value: current)
    }

    @ViewBuilder
    private func node(_ i: Int) -> some View {
        let done = i < current
        let active = i == current
        if active {
            HStack(spacing: 6) {
                Image(systemName: steps[i].icon).font(.system(size: 12, weight: .bold))
                Text(steps[i].label).font(.system(size: 11.5, weight: .bold)).lineLimit(1)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12).frame(height: 30)
            .background(Theme.brand500)
            .clipShape(Capsule())
        } else {
            ZStack {
                Circle()
                    .fill(done ? Theme.green : Theme.surface2)
                    .frame(width: 30, height: 30)
                    .overlay(Circle().strokeBorder(done ? Color.clear : Theme.border, lineWidth: 1))
                Image(systemName: done ? "checkmark" : steps[i].icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(done ? .white : Theme.textMuted)
            }
        }
    }
}

/// Reusable multi-step popup shell: title + close, top `StepTimeline`, per-step content, and a
/// Back / Next / Finish footer. Drives its own step index via the `step` binding.
struct StepFlow<Content: View>: View {
    @Environment(AppState.self) private var app

    let title: String
    let steps: [FlowStep]
    @Binding var step: Int
    var finishLabel: String = "Save"
    var canProceed: Bool = true
    var onFinish: () -> Void = {}
    @ViewBuilder var content: (Int) -> Content

    private var isLast: Bool { step >= steps.count - 1 }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 16, weight: .bold)).foregroundStyle(Theme.text)
                    Text(steps[safe: step]?.label ?? "")
                        .font(.system(size: 12)).foregroundStyle(Theme.textMuted)
                }
                Spacer()
                Button { app.dismissModal() } label: {
                    Image(systemName: "xmark").font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Theme.textMuted)
                        .frame(width: 30, height: 30).background(Theme.surface2).clipShape(Circle())
                }
            }

            StepTimeline(steps: steps, current: step)

            content(step)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Footer
            HStack(spacing: 12) {
                Button {
                    if step > 0 { withAnimation { step -= 1 } } else { app.dismissModal() }
                } label: {
                    Text(step > 0 ? "Back" : "Cancel")
                        .font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
                }
                Button {
                    if isLast { onFinish(); app.dismissModal() }
                    else { withAnimation { step += 1 } }
                } label: {
                    HStack(spacing: 6) {
                        Text(isLast ? finishLabel : "Next").font(.system(size: 14, weight: .bold))
                        Image(systemName: isLast ? "checkmark" : "arrow.right").font(.system(size: 13, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(canProceed ? 1 : 0.5)
                }
                .disabled(!canProceed)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: 24, y: 12)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
