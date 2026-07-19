import SwiftUI

/// Reusable top bar with hamburger, title/greeting, bell and avatar — matches the reference header.
struct TopBar: View {
    @Environment(AppState.self) private var app

    var title: String
    var subtitle: String? = nil
    var greeting: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            // On a pushed page show a back button; on a root tab show the hamburger.
            Button {
                if app.navigationPath.isEmpty {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        app.isDrawerOpen = true
                    }
                } else {
                    app.goBack()
                }
            } label: {
                Image(systemName: app.navigationPath.isEmpty ? "line.3.horizontal" : "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.text)
                    .frame(width: 36, height: 36)
                    .background(Theme.surface)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
            }

            VStack(alignment: .leading, spacing: 1) {
                if greeting {
                    Text(title)
                        .font(.system(size: 15.5, weight: .heavy))
                        .foregroundStyle(Theme.text)
                        .lineLimit(1)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11.5))
                            .foregroundStyle(Theme.textMuted)
                            .lineLimit(1)
                    }
                } else {
                    Text(title)
                        .font(.system(size: 15.5, weight: .bold))
                        .foregroundStyle(Theme.text)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11.5))
                            .foregroundStyle(Theme.textMuted)
                    }
                }
            }

            Spacer(minLength: 0)

            Button {
                app.open(.notifications)
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bell")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Theme.text)
                        .frame(width: 36, height: 36)
                        .background(Theme.surface)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
                    if app.notificationCount > 0 {
                        Text("\(app.notificationCount)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(minWidth: 16, minHeight: 16)
                            .background(Theme.red)
                            .clipShape(Circle())
                            .offset(x: 2, y: -2)
                    }
                }
            }

            Button {
                app.open(.profile)
            } label: {
                Circle()
                    .fill(Theme.brandGradient)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(String(app.userName.prefix(1)))
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .overlay(Circle().strokeBorder(Theme.surface, lineWidth: 2))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
