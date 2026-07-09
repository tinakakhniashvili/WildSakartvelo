import SwiftUI

struct OfflineContentView: View {
    let catalogue: ContentCatalogue

    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @State private var packPendingDeletion: ContentPack?

    var body: some View {
        List {
            Section {
                Text(String.localized("downloads.description", for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
            }

            Section(String.localized("downloads.section.packs", for: appState.currentLanguage)) {
                ForEach(catalogue.contentPacks) { pack in
                    ContentPackRowView(
                        pack: pack,
                        ecosystemName: ecosystemName(for: pack),
                        ecosystemImageName: ecosystem(for: pack)?.imageName,
                        state: appState.contentPackState(for: pack),
                        hasUpdate: hasUpdate(for: pack),
                        language: appState.currentLanguage,
                        onDownload: { download(pack) },
                        onCancel: { appState.cancelContentPackDownload(pack) },
                        onDelete: { packPendingDeletion = pack }
                    )
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
        .navigationTitle(String.localized("downloads.title", for: appState.currentLanguage))
        .alert(
            String.localized("downloads.delete.title", for: appState.currentLanguage),
            isPresented: Binding(
                get: { packPendingDeletion != nil },
                set: { if !$0 { packPendingDeletion = nil } }
            ),
            presenting: packPendingDeletion
        ) { pack in
            Button(String.localized("downloads.action.delete", for: appState.currentLanguage), role: .destructive) {
                appState.deleteContentPack(pack)
                packPendingDeletion = nil
            }
            Button(String.localized("downloads.action.cancel", for: appState.currentLanguage), role: .cancel) {
                packPendingDeletion = nil
            }
        } message: { _ in
            Text(String.localized("downloads.delete.message", for: appState.currentLanguage))
        }
    }

    private func ecosystemName(for pack: ContentPack) -> String {
        ecosystem(for: pack)?.localizedName?.displayText(
            for: appState.currentLanguage
        ) ?? pack.ecosystemID
    }

    private func ecosystem(for pack: ContentPack) -> Ecosystem? {
        catalogue.ecosystemsByID[pack.ecosystemID]
    }

    private func hasUpdate(for pack: ContentPack) -> Bool {
        guard let installedVersion = appState.contentPackState(for: pack).installedVersion else {
            return false
        }
        return pack.version > installedVersion
    }

    private func download(_ pack: ContentPack) {
        Task {
            await appState.downloadContentPack(pack)
        }
    }
}

#Preview("Offline Content") {
    NavigationStack {
        OfflineContentView(
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [],
                plants: [],
                missions: [],
                activities: [],
                contentPacks: [.sample]
            )
        )
        .environmentObject(AppState())
    }
}
