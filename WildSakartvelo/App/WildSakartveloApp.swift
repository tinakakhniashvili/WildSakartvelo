import SwiftUI

@main
struct WildSakartveloApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootTabView(appState: appState)
                .environmentObject(appState)
                .environment(\.appAccessibilitySettings, appState.appAccessibilitySettings)
                .environment(\.locale, Locale(identifier: appState.currentLanguage.localeIdentifier))
        }
    }
}
