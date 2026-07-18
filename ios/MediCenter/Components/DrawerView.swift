import SwiftUI

/// Hamburger drawer overlay: collapsible, slides from the left, contains all secondary navigation.
struct DrawerView: View {
    @Environment(AppState.self) private var app
    @Environment(\.colorScheme) private var colorScheme

    private let width: CGFloat = 320

    var body: some View {
        ZStack(alignment: .leading) {
            if app.isDrawerOpen {
                // Scrim
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture { close() }

                panel
                    .frame(width: width)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: app.isDrawerOpen)
    }

    private var panel: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(Navigation.drawerGroups) { group in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(group.title.uppercased())
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(Theme.textFaint)
                                .padding(.horizontal, 12)
                                .padding(.bottom, 4)
                            ForEach(group.routes, id: \.self) { route in
                                rowButton(route)
                            }
                        }
                    }
                }
                .padding(12)
            }
            footer
        }
        .frame(maxHeight: .infinity)
        .background(Theme.bgElevated)
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    Text("MediCenter")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                }
                Spacer()
                Button { close() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 34, height: 34)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Circle())
                }
            }

            Button { app.open(.profile) } label: {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Text(String(app.userName.prefix(1)))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.white)
                        )
                    VStack(alignment: .leading, spacing: 2) {
                        Text(app.userName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(app.userEmail)
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .padding(20)
        .padding(.top, 44)
        .background(Theme.brandGradient)
    }

    private func rowButton(_ route: AppRoute) -> some View {
        Button { app.open(route) } label: {
            HStack(spacing: 12) {
                Image(systemName: route.systemImage)
                    .font(.system(size: 17))
                    .frame(width: 22)
                Text(route.title)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            .foregroundStyle(Theme.text)
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(Theme.surface2.opacity(0.001)) // keep tap area
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }

    private var footer: some View {
        VStack(spacing: 4) {
            Button {
                app.themeOverride = (effectiveScheme == .dark) ? .light : .dark
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: effectiveScheme == .dark ? "sun.max" : "moon")
                        .frame(width: 22)
                    Text(effectiveScheme == .dark ? "Light Mode" : "Dark Mode")
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                }
                .foregroundStyle(Theme.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 11)
            }
            Button {} label: {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .frame(width: 22)
                    Text("Log Out")
                        .font(.system(size: 14, weight: .medium))
                    Spacer()
                }
                .foregroundStyle(Theme.red)
                .padding(.horizontal, 12)
                .padding(.vertical, 11)
            }
        }
        .padding(12)
        .background(Theme.bgElevated)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Theme.border), alignment: .top)
    }

    private var effectiveScheme: ColorScheme {
        app.themeOverride ?? colorScheme
    }

    private func close() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            app.isDrawerOpen = false
        }
    }
}
