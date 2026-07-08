import SwiftUI

struct ProgressOverviewView: View {
    let completedMissionCount: Int
    let totalMissionCount: Int
    let discoveredAnimalCount: Int
    let totalAnimalCount: Int
    let discoveredPlantCount: Int
    let totalPlantCount: Int
    let language: AppLanguage

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    private var overallProgress: Double {
        let completed = completedMissionCount + discoveredAnimalCount + discoveredPlantCount
        let total = totalMissionCount + totalAnimalCount + totalPlantCount
        guard total > 0 else { return 1 }
        return Double(completed) / Double(total)
    }

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text(String.localized("parent.progress.title", for: language))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                progressRow(
                    title: String.localized("parent.progress.missions", for: language),
                    completed: completedMissionCount,
                    total: totalMissionCount
                )
                progressRow(
                    title: String.localized("parent.progress.animals", for: language),
                    completed: discoveredAnimalCount,
                    total: totalAnimalCount
                )
                progressRow(
                    title: String.localized("parent.progress.plants", for: language),
                    completed: discoveredPlantCount,
                    total: totalPlantCount
                )

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(String.localizedFormat("parent.progress.overall", for: language, Int(overallProgress * 100)))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    ProgressView(value: overallProgress)
                        .tint(AppColors.forest)
                        .accessibilityLabel(String.localized("parent.progress.overall.label", for: language))
                        .accessibilityValue(String.localizedFormat("parent.gate.progress.value", for: language, Int(overallProgress * 100)))
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private func progressRow(title: String, completed: Int, total: Int) -> some View {
        let value = total > 0 ? Double(completed) / Double(total) : 1

        return VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            HStack {
                Text(title)
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                Spacer()

                Text(String.localizedFormat("parent.progress.count", for: language, completed, total))
                    .font(AppTypography.captionFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
            }

            ProgressView(value: value)
                .tint(AppColors.forest)
                .accessibilityLabel(title)
                .accessibilityValue(String.localizedFormat("parent.progress.count", for: language, completed, total))
        }
    }
}

#Preview("Empty Progress") {
    ProgressOverviewView(
        completedMissionCount: 0,
        totalMissionCount: 3,
        discoveredAnimalCount: 0,
        totalAnimalCount: 4,
        discoveredPlantCount: 0,
        totalPlantCount: 2,
        language: .english
    )
    .padding()
    .background(AppColors.background)
}

#Preview("Partial Progress") {
    ProgressOverviewView(
        completedMissionCount: 1,
        totalMissionCount: 3,
        discoveredAnimalCount: 2,
        totalAnimalCount: 4,
        discoveredPlantCount: 1,
        totalPlantCount: 2,
        language: .english
    )
    .padding()
    .background(AppColors.background)
}

#Preview("Completed Progress") {
    ProgressOverviewView(
        completedMissionCount: 3,
        totalMissionCount: 3,
        discoveredAnimalCount: 4,
        totalAnimalCount: 4,
        discoveredPlantCount: 2,
        totalPlantCount: 2,
        language: .georgian
    )
    .padding()
    .background(AppColors.background)
}
