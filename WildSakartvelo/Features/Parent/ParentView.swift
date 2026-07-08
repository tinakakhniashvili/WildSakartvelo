import SwiftUI

struct ParentView: View {
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @State private var isUnlocked = false

    var body: some View {
        Group {
            if isUnlocked {
                ParentDashboardView(catalogue: catalogue)
            } else {
                ParentGateView {
                    isUnlocked = true
                }
            }
        }
        .navigationTitle(String.localized("parent.title", for: appState.currentLanguage))
    }
}

#Preview {
    NavigationStack {
        ParentView(
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [.sample]
            )
        )
        .environmentObject(AppState())
    }
}
