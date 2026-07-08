import SwiftUI

struct ExplorerEquipmentView: View {
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    private let service = EquipmentUnlockService()
    private let calculator = ProgressCalculator()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: AppSpacing.medium) {
                ForEach(service.equipment) { item in
                    equipmentCard(item)
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(text("Explorer Equipment", "მკვლევრის აღჭურვილობა"))
    }

    private func equipmentCard(_ item: ExplorerEquipment) -> some View {
        let unlocked = service.isUnlocked(item, catalogue: catalogue, progress: appState.userProgress)
        let values = calculator.equipmentProgress(for: item.unlockRequirement, catalogue: catalogue, progress: appState.userProgress)

        return AppCard(variant: unlocked ? .success : .locked) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: item.imageName,
                    fallbackSystemImage: unlocked ? "bag.fill" : "lock.fill",
                    mode: .thumbnail,
                    height: 76,
                    accentColor: AppColors.forest,
                    accessibilityDescription: item.title.displayText(for: appState.currentLanguage)
                )
                .frame(width: 86, height: 76)
                .opacity(unlocked ? 1 : 0.55)

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Label(
                        unlocked ? text("Unlocked", "გახსნილია") : text("Locked", "ჩაკეტილია"),
                        systemImage: unlocked ? "checkmark.seal.fill" : "lock.fill"
                    )
                    .font(AppTypography.caption)
                    .foregroundStyle(unlocked ? AppColors.success : AppColors.secondaryText)

                    Text(item.title.displayText(for: appState.currentLanguage))
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.primaryText)

                    Text(item.description.displayText(for: appState.currentLanguage))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)

                    ProgressView(value: Double(min(values.current, values.target)), total: Double(max(values.target, 1)))
                        .tint(AppColors.forest)

                    Text(service.requirementText(for: item.unlockRequirement, language: appState.currentLanguage))
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}
