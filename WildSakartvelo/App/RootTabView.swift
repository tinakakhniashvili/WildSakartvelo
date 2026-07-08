import SwiftUI

struct RootTabView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoadingContent || (appState.contentCatalogue == nil && appState.contentErrorMessage == nil) {
                loadingView
            } else if let contentErrorMessage = appState.contentErrorMessage {
                errorView(message: contentErrorMessage)
            } else if let catalogue = appState.contentCatalogue {
                if !appState.hasCompletedOnboarding {
                    OnboardingView()
                } else if appState.selectedProfile == nil {
                    ProfileSelectionView()
                } else {
                    tabs(catalogue: catalogue)
                }
            }
        }
        .task {
            appState.loadContent()
        }
    }

    private func tabs(catalogue: ContentCatalogue) -> some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                ExploreView(catalogue: catalogue)
            }
            .tabItem {
                Label(String.localized("tab.explore", for: appState.currentLanguage), systemImage: "map.fill")
            }
            .tag(AppTab.explore)

            NavigationStack {
                JournalView(catalogue: catalogue)
            }
            .tabItem {
                Label(String.localized("tab.journal", for: appState.currentLanguage), systemImage: "book.closed.fill")
            }
            .tag(AppTab.journal)

            NavigationStack {
                ParentView(catalogue: catalogue)
            }
            .tabItem {
                Label(String.localized("tab.parent", for: appState.currentLanguage), systemImage: "person.2.fill")
            }
            .tag(AppTab.parent)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label(String.localized("tab.settings", for: appState.currentLanguage), systemImage: "gearshape.fill")
            }
            .tag(AppTab.settings)
        }
        .tint(AppColors.forest)
    }

    private var loadingView: some View {
        ProgressView(String.localized("loading.content", for: appState.currentLanguage))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
    }

    private func errorView(message: String) -> some View {
        AppErrorView(
            title: String.localized("error.contentLoad.title", for: appState.currentLanguage),
            message: message,
            retryAction: {
                appState.contentCatalogue = nil
                appState.loadContent()
            }
        )
    }
}

private struct RootTabViewPreview: View {
    @StateObject private var appState = AppState()

    var body: some View {
        RootTabView(appState: appState)
            .environmentObject(appState)
    }
}

#Preview {
    RootTabViewPreview()
}
