import SwiftUI

struct EcosystemCardView: View {
    let ecosystem: Ecosystem
    let isUnlocked: Bool
    let progress: UserProgress?
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: isUnlocked ? .elevated : .locked) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                ecosystemImage

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    HStack(alignment: .top, spacing: AppSpacing.small) {
                        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                            Text(ecosystem.displayName(for: appState.currentLanguage))
                                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                                .foregroundStyle(AppColors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)

                            if !isUnlocked {
                                Label(String.localized("mission.status.locked", for: appState.currentLanguage), systemImage: "lock.fill")
                                    .font(AppTypography.captionFont(using: accessibilitySettings))
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: isUnlocked ? "chevron.right" : "lock.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppColors.secondaryText)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(ecosystem.displaySubtitle(for: appState.currentLanguage))
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(isUnlocked ? ecosystem.theme.accentColor : AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack(spacing: AppSpacing.small) {
                            statPill(
                                symbol: "checkmark.seal.fill",
                                text: "\(completedMissionCount)/\(ecosystem.missionIDs.count) \(text("missions", "მისია"))",
                                color: ecosystem.theme.accentColor
                            )

                            statPill(
                                symbol: "pawprint.fill",
                                text: "\(discoveredAnimalCount)/\(ecosystem.animalIDs.count)",
                                color: AppColors.water
                            )
                        }
                        .opacity(isUnlocked ? 1 : 0.55)

                        if isUnlocked, let progress {
                            EcosystemProgressView(ecosystem: ecosystem, progress: progress)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                    mode: .thumbnail,
                    height: 94,
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
        .frame(width: 104, height: 94)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.largeCard))
        .clipped()
    }

    private var completedMissionCount: Int {
        guard let progress else { return 0 }
        return ecosystem.missionIDs.filter { progress.completedMissionIDs.contains($0) }.count
    }

    private var discoveredAnimalCount: Int {
        guard let progress else { return 0 }
        return ecosystem.animalIDs.filter { progress.discoveredAnimalIDs.contains($0) }.count
    }

    private func statPill(symbol: String, text: String, color: Color) -> some View {
        Label(text, systemImage: symbol)
            .font(AppTypography.captionFont(using: accessibilitySettings))
            .foregroundStyle(color)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(color.opacity(0.10), in: Capsule())
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
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
