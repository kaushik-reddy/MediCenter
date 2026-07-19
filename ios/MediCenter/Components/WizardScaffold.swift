import SwiftUI

/// Reusable full-screen wizard chrome: back/close header, top `StepTimeline`, scrollable
/// content and a Back / Next / Finish footer. Shared by the Add Appointment / Travel Mode flows.
struct WizardScaffold<Content: View>: View {
    @Environment(AppState.self) private var app

    let title: String
    let subtitle: String
    let steps: [FlowStep]
    @Binding var step: Int
    let isLast: Bool
    var canProceed: Bool = true
    var finishLabel: String = "Save"
    var onFinish: () -> Void = {}
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Button { step > 0 ? (step -= 1) : app.dismissFullScreen() } label: {
                    Image(systemName: "arrow.left").font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Theme.text).frame(width: 36, height: 36)
                        .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(.system(size: 16, weight: .heavy)).foregroundStyle(Theme.text)
                    Text(subtitle).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
                }
                Spacer(minLength: 0)
                Button { app.dismissFullScreen() } label: {
                    Image(systemName: "xmark").font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.text).frame(width: 36, height: 36)
                        .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 10)

            StepTimeline(steps: steps, current: step)
                .padding(.horizontal, 16).padding(.bottom, 12)

            ScrollView {
                content().padding(.horizontal, 16).padding(.top, 2).padding(.bottom, 16)
            }

            HStack(spacing: 12) {
                Button { step > 0 ? (step -= 1) : app.dismissFullScreen() } label: {
                    Text(step > 0 ? "Back" : "Cancel").font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
                }
                Button { isLast ? finish() : (step += 1) } label: {
                    HStack(spacing: 6) {
                        if isLast { Image(systemName: "checkmark") }
                        Text(isLast ? finishLabel : "Next")
                        if !isLast { Image(systemName: "arrow.right") }
                    }
                    .font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Theme.brandGradient).clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(canProceed ? 1 : 0.5)
                }
                .disabled(!canProceed)
            }
            .padding(16).overlay(Rectangle().fill(Theme.border).frame(height: 1), alignment: .top)
        }
        .background(Theme.bg.ignoresSafeArea())
    }

    private func finish() { onFinish(); app.dismissFullScreen() }
}

// MARK: - Shared wizard primitives

struct WizardPanel<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 10) { content() }
            .padding(14).frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface).clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.border, lineWidth: 1))
            .padding(.bottom, 12)
    }
}

struct WizardStepHead: View {
    var icon: String?
    let title: String
    let sub: String
    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon).font(.system(size: 16)).foregroundStyle(Theme.brand500)
                    .frame(width: 40, height: 40).background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(.system(size: 14, weight: .bold)).foregroundStyle(Theme.text)
                Text(sub).font(.system(size: 11.5)).foregroundStyle(Theme.textMuted)
            }
            Spacer(minLength: 0)
        }
    }
}

struct WizardLabel: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WizardField: View {
    let label: String
    var icon: String?
    let placeholder: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            WizardLabel(label)
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon).font(.system(size: 14)).foregroundStyle(Theme.textFaint)
                }
                TextField(placeholder, text: $text).font(.system(size: 13.5))
            }
            .padding(.horizontal, 12).padding(.vertical, 10)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
        }
    }
}

struct WizardTextArea: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .lineLimit(3...5).font(.system(size: 13.5))
            .padding(.horizontal, 12).padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
    }
}

struct WizardMenu: View {
    @Binding var value: String
    let options: [String]
    init(_ value: Binding<String>, _ options: [String]) { self._value = value; self.options = options }
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { o in Button(o) { value = o } }
        } label: {
            HStack {
                Text(value).font(.system(size: 13.5, weight: .semibold)).foregroundStyle(Theme.text)
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.textMuted)
            }
            .padding(.horizontal, 12).padding(.vertical, 11)
            .background(Theme.surface2).clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.border, lineWidth: 1))
        }
    }
}

struct WizardReviewRow: View {
    let icon: String
    let value: String
    init(_ icon: String, _ value: String) { self.icon = icon; self.value = value }
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 13)).foregroundStyle(Theme.textFaint)
            Text(value).font(.system(size: 12.5, weight: .semibold)).foregroundStyle(Theme.text).lineLimit(1)
            Spacer()
        }
        .padding(.vertical, 9)
        .overlay(Rectangle().fill(Theme.border).frame(height: 1), alignment: .top)
    }
}

struct WizardNote: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle").font(.system(size: 13)).foregroundStyle(Theme.brand500)
            Text(text).font(.system(size: 11.5)).foregroundStyle(Theme.brand500)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Theme.brandSoft).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
