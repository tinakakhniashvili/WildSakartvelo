import SwiftUI

struct MissionResultView: View {
    let mission: Mission
    let attempts: Int
    var unlockedEcosystemName: String? = nil
    let closeAction: () -> Void
    @EnvironmentObject private var appState: AppState
    private var language: AppLanguage { appState.currentLanguage }

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 72, weight: .semibold))
                .foregroundStyle(AppColors.success)

            VStack(spacing: AppSpacing.small) {
                Text(String.localized("mission.result.title", for: language))
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)

                Text(mission.displayTitle(for: appState.currentLanguage))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    if let unlockedEcosystemName {
                        HStack(alignment: .top, spacing: AppSpacing.medium) {
                            Image(systemName: "map.fill")
                                .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(AppColors.forest)
                            .frame(width: 30)

                            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                                Text(String.localized("mission.result.newEcosystem", for: language))
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.secondaryText)

                                Text(unlockedEcosystemName)
                                    .font(AppTypography.body)
                                    .foregroundStyle(AppColors.primaryText)
                            }
                        }
                    } else {
                        resultRow(title: String.localized("mission.detail.reward", for: language), value: mission.reward.displayTitle(for: language))
                    }
                    resultRow(
                        title: String.localized("mission.result.totalAttempts", for: language),
                        value: String(attempts)
                    )
                }
            }

            PrimaryButton(title: String.localized("action.close", for: language), action: closeAction)
        }
        .padding(AppSpacing.medium)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }

    private func resultRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)

            Text(value)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.primaryText)
        }
    }
}

#Preview {
    VStack {
        MissionResultView(mission: .sample, attempts: 2) {}
        MissionResultView(mission: .sample, attempts: 2, unlockedEcosystemName: "Kolkheti Wetlands") {}
    }
}
