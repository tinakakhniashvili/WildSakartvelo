import SwiftUI

struct CompletedMissionsView: View {
    let catalogue: ContentCatalogue
    let completedMissionIDs: Set<String>
    let language: AppLanguage

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    private var completedMissions: [Mission] {
        catalogue.missions.filter { completedMissionIDs.contains($0.id) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(String.localized("parent.completedMissions.title", for: language))
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            if completedMissions.isEmpty {
                EmptyStateView(
                    systemImage: "checkmark.seal.fill",
                    title: String.localized("parent.completedMissions.empty.title", for: language),
                    description: String.localized("parent.completedMissions.empty.description", for: language)
                )
            } else {
                VStack(spacing: AppSpacing.small) {
                    ForEach(completedMissions) { mission in
                        missionRow(mission)
                    }
                }
            }
        }
    }

    private func missionRow(_ mission: Mission) -> some View {
        let ecosystem = catalogue.ecosystems.first { $0.id == mission.ecosystemID }

        return AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(mission.displayTitle(for: language))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(ecosystem?.displayName(for: language) ?? String.localized("common.itemUnavailable", for: language))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)

                HStack(spacing: AppSpacing.small) {
                    Label(mission.difficulty.displayTitle(for: language), systemImage: "speedometer")
                    Label(String.localized("parent.completedMissions.status.completed", for: language), systemImage: "checkmark.circle.fill")
                }
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.forest)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Empty Completed Missions") {
    CompletedMissionsView(
        catalogue: try! ContentCatalogue(
            ecosystems: [.sample],
            animals: [.sample],
            plants: [.sample],
            missions: [.sample],
            activities: [.sample]
        ),
        completedMissionIDs: [],
        language: .english
    )
    .padding()
    .background(AppColors.background)
}

#Preview("Completed Missions") {
    CompletedMissionsView(
        catalogue: try! ContentCatalogue(
            ecosystems: [.sample],
            animals: [.sample],
            plants: [.sample],
            missions: [.sample],
            activities: [.sample]
        ),
        completedMissionIDs: ["mountain-habitat-discovery"],
        language: .english
    )
    .padding()
    .background(AppColors.background)
}
