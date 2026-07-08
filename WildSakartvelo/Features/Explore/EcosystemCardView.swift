import SwiftUI

struct EcosystemCardView: View {
    let ecosystem: Ecosystem
    let isUnlocked: Bool
    let progress: UserProgress?
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: isUnlocked ? .elevated : .locked) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                ecosystemImage

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(ecosystem.displayName(for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: AppSpacing.small) {
                        Text(ecosystem.displaySubtitle(for: appState.currentLanguage))
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(isUnlocked ? ecosystem.theme.accentColor : AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        if !isUnlocked {
                            Spacer(minLength: AppSpacing.small)
                            Label(String.localized("mission.status.locked", for: appState.currentLanguage), systemImage: "lock.fill")
                                .font(AppTypography.captionFont(using: accessibilitySettings))
                                .foregroundStyle(AppColors.secondaryText)
                        }
                    }

                    Text(ecosystem.displayDescription(for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    if isUnlocked, let progress {
                        EcosystemProgressView(ecosystem: ecosystem, progress: progress)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
    }

    @ViewBuilder
    private var ecosystemImage: some View {
        let accentColor = isUnlocked ? ecosystem.theme.accentColor : AppColors.secondaryText

        ZStack {
            if isUnlocked {
                ContentImageView(
                    imageName: ecosystem.imageName,
                    fallbackSystemImage: ecosystem.theme.fallbackSystemImage,
                    mode: .card,
                    height: AppLayout.ecosystemCardImageHeight,
                    accentColor: accentColor,
                    accessibilityDescription: ecosystem.displayName(for: appState.currentLanguage)
                )
            } else {
                LockedContentArtwork(
                    imageName: ecosystem.imageName,
                    title: String.localized("mission.status.locked", for: appState.currentLanguage),
                    accentColor: accentColor
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: AppLayout.ecosystemCardImageHeight)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.largeCard))
        .clipped()
    }

    private var accessibilityLabel: String {
        ecosystem.displayName(for: appState.currentLanguage)
    }

    private var accessibilityValue: String {
        if isUnlocked {
            return progress == nil
                ? String.localized("explore.accessibility.unlocked", for: appState.currentLanguage)
                : String.localized("explore.accessibility.progress", for: appState.currentLanguage)
        }
        return String.localized("mission.status.locked", for: appState.currentLanguage)
    }
}

private let ecosystemCardPreviewProgress = UserProgress(
    completedMissionIDs: ["mountain-habitat-discovery"],
    discoveredAnimalIDs: [],
    discoveredPlantIDs: [],
    unlockedEcosystemIDs: [],
    earnedBadgeIDs: [],
    activeMissionID: nil,
    currentActivityIndexByMission: [:],
    totalAttemptsByMission: [:]
)

#Preview("Unlocked") {
    EcosystemCardView(ecosystem: .sample, isUnlocked: true, progress: ecosystemCardPreviewProgress)
        .padding()
        .background(AppColors.background)
}

#Preview("Locked") {
    EcosystemCardView(ecosystem: .sample, isUnlocked: false, progress: nil)
        .padding()
        .background(AppColors.background)
}
