import SwiftUI

struct ExplorerChallengeCard: View {
    let challenge: ExplorerChallenge
    let progress: ExplorerChallengeProgress
    let ecosystemName: String?
    let language: AppLanguage
    let destination: AnyView?

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: progress.isCompleted ? .success : .standard) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(alignment: .top, spacing: AppSpacing.small) {
                    Image(systemName: progress.isCompleted ? "checkmark.seal.fill" : "sparkle.magnifyingglass")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(progress.isCompleted ? AppColors.success : AppColors.forest)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(challenge.title.displayText(for: language))
                            .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(challenge.description.displayText(for: language))
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                ProgressView(value: Double(progress.currentValue), total: Double(max(challenge.targetValue, 1)))
                    .tint(progress.isCompleted ? AppColors.success : AppColors.forest)

                HStack {
                    Text("\(progress.currentValue)/\(challenge.targetValue)")
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)

                    if let ecosystemName {
                        Text(ecosystemName)
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.water)
                    }
                }

                if let safetyMessage = challenge.safetyMessage {
                    Label(safetyMessage.displayText(for: language), systemImage: "hand.raised.fill")
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let rewardBadgeID = challenge.rewardBadgeID {
                    Label(rewardText(rewardBadgeID), systemImage: "seal.fill")
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.sunshine)
                }

                if let destination {
                    NavigationLink {
                        destination
                    } label: {
                        Text(language == .georgian ? "დაკავშირებული გვერდი" : "View Related Content")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func rewardText(_ badgeID: String) -> String {
        language == .georgian ? "ჯილდო: \(badgeID)" : "Reward: \(badgeID)"
    }
}
