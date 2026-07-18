import SwiftUI

// Temporary placeholder screens. Each real screen replaces these one-by-one,
// built pixel-for-pixel from the reference designs. The shell stays navigable.

struct HomePlaceholderView: View {
    @Environment(AppState.self) private var app
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "Good morning, \(app.userName)", greeting: true)
            PlaceholderBody(title: "Home")
        }
    }
}

struct TabPlaceholderView: View {
    let title: String
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: title)
            PlaceholderBody(title: title)
        }
    }
}

struct RoutePlaceholderView: View {
    let route: AppRoute
    @Environment(AppState.self) private var app
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: route.title)
            PlaceholderBody(title: route.title)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct PlaceholderBody: View {
    let title: String
    var body: some View {
        VStack(spacing: 14) {
            Spacer()
            Image(systemName: "hammer.fill")
                .font(.system(size: 30))
                .foregroundStyle(Theme.brand500)
                .frame(width: 80, height: 80)
                .background(Theme.brandSoft)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.text)
            Text("This screen is queued. We'll build it pixel-for-pixel from your reference designs.")
                .font(.system(size: 14))
                .foregroundStyle(Theme.textMuted)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 240)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg)
    }
}
