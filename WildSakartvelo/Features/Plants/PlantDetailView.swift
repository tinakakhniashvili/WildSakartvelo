import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    private var ecosystemNames: [String] {
        plant.ecosystemIDs.compactMap { id in
            catalogue.ecosystemsByID[id]?.displayName(for: appState.currentLanguage)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header
                factSection(title: .localized("plant.section.description", for: appState.currentLanguage), text: plant.displayDescription(for: appState.currentLanguage))
                factSection(title: .localized("plant.section.fact", for: appState.currentLanguage), text: plant.displaySurprisingFact(for: appState.currentLanguage))
                ecosystemsSection
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(plant.displayName(for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            ContentImageView(
                imageName: plant.imageName,
                fallbackSystemImage: "leaf.fill",
                mode: .detail,
                height: 280,
                accentColor: AppColors.forest
            )

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(plant.displayName(for: appState.currentLanguage))
                    .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(String.localized("content.plant", for: appState.currentLanguage))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
            }
        }
    }

    private func factSection(title: String, text: String) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(title)
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                Text(text)
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var ecosystemsSection: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(String.localized("plant.section.ecosystems", for: appState.currentLanguage))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                if ecosystemNames.isEmpty {
                    Text(String.localized("plant.section.ecosystems.empty", for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                } else {
                    ForEach(ecosystemNames, id: \.self) { ecosystemName in
                        Text(ecosystemName)
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.primaryText)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(
            plant: .sample,
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
