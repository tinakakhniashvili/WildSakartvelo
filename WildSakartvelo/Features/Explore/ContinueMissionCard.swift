import SwiftUI

struct ContinueMissionCard: View {
    let mission: Mission
    let ecosystem: Ecosystem?
    let currentActivityIndex: Int
    let language: AppLanguage

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: .elevated) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                ExploreThumbnail(
                    imageName: ecosystem?.imageName ?? "mission_adventure",
                    fallbackSystemImage: "play.circle.fill",
                    accentColor: ecosystem?.theme.accentColor ?? AppColors.forest,
                    accessibilityDescription: mission.displayTitle(for: language),
                    width: 96,
                    height: 82
                )

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Label(text("Continue Exploring", "გააგრძელე კვლევა"), systemImage: "play.fill")
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.forest)

                    Text(mission.displayTitle(for: language))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    ProgressView(value: progress)
                        .tint(AppColors.forest)

                    Text(text("Activity \(min(currentActivityIndex + 1, mission.activityIDs.count)) of \(max(mission.activityIDs.count, 1))", "აქტივობა \(min(currentActivityIndex + 1, mission.activityIDs.count)) / \(max(mission.activityIDs.count, 1))"))
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var progress: Double {
        guard !mission.activityIDs.isEmpty else { return 0 }
        return Double(currentActivityIndex) / Double(mission.activityIDs.count)
    }

    private func text(_ english: String, _ georgian: String) -> String {
        language == .georgian ? georgian : english
    }
}
