import SwiftUI

struct MissionIntroView: View {
    let mission: Mission
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    private let unlockService = UnlockService()

    private var activityCount: Int {
        mission.activityIDs.count
    }

    private var language: AppLanguage {
        appState.currentLanguage
    }

    private var missionState: MissionProgressState {
        if appState.userProgress.completedMissionIDs.contains(mission.id) {
            return .completed
        }

        if appState.userProgress.activeMissionID == mission.id ||
            appState.userProgress.currentActivityIndexByMission[mission.id] != nil {
            return .inProgress
        }

        return .notStarted
    }

    private var startButtonTitle: String {
        switch missionState {
        case .notStarted:
            return .localized("action.startMission", for: language)
        case .inProgress:
            return .localized("action.continueMission", for: language)
        case .completed:
            return .localized("action.playAgain", for: language)
        }
    }

    private var startingActivityIndex: Int {
        if missionState == .completed {
            return 0
        }

        return appState.userProgress.currentActivityIndexByMission[mission.id] ?? 0
    }

    private var startingAttempts: Int {
        if missionState == .completed {
            return 0
        }

        return appState.userProgress.totalAttemptsByMission[mission.id] ?? 0
    }

    private var lockReason: String? {
        unlockService.missionLockReason(
            mission,
            catalogue: catalogue,
            progress: appState.userProgress,
            language: language
        )
    }

    private var isUnlocked: Bool {
        unlockService.isMissionUnlocked(mission, catalogue: catalogue, progress: appState.userProgress)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header
                TokoGuideView(message: TokoMessageService().message(for: .firstMission, language: language))
                details
                reward
                if isUnlocked {
                    startLink
                } else {
                    lockedState
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(String.localized("mission.title", for: language))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            ContentImageView(
                imageName: "mission_adventure",
                fallbackSystemImage: "map.fill",
                mode: .hero,
                height: 190,
                accentColor: AppColors.forest,
                accessibilityDescription: mission.displayTitle(for: language)
            )

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(mission.displayTitle(for: language))
                    .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(mission.displaySubtitle(for: language))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.forest)
                    .fixedSize(horizontal: false, vertical: true)

                Text(mission.displayIntroduction(for: language))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var details: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                KidSectionHeader(
                    title: language == .georgian ? "მისიის ჩანთა" : "Mission Pack",
                    symbol: "backpack.fill",
                    color: AppColors.forest
                )

                detailRow(
                    icon: mission.difficulty.systemImage,
                    title: String.localized("mission.detail.difficulty", for: language),
                    value: mission.difficulty.displayTitle(for: language)
                )
                detailRow(
                    icon: "clock.fill",
                    title: String.localized("mission.detail.estimatedTime", for: language),
                    value: String.localizedFormat("mission.detail.minutes", for: language, mission.estimatedMinutes)
                )
                detailRow(
                    icon: "list.bullet.clipboard.fill",
                    title: String.localized("mission.detail.activities", for: language),
                    value: String(activityCount)
                )
            }
        }
    }

    private var reward: some View {
        AppCard(variant: .warning) {
            HStack(spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: "badge_discovery",
                    fallbackSystemImage: "gift.fill",
                    mode: .avatar,
                    height: 56,
                    accentColor: AppColors.sunshine,
                    accessibilityDescription: mission.reward.displayTitle(for: language)
                )
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(String.localized("mission.detail.reward", for: language))
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)

                    Text(mission.reward.displayTitle(for: language))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: AppSpacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AppColors.forest)
                .frame(width: 28)

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

    private var startLink: some View {
        NavigationLink {
            MissionContainerView(
                mission: mission,
                catalogue: catalogue,
                startingActivityIndex: startingActivityIndex,
                startingAttempts: startingAttempts
            )
        } label: {
            Text(startButtonTitle)
                .font(AppTypography.buttonFont(using: accessibilitySettings))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(AppColors.forest, in: RoundedRectangle(cornerRadius: AppSpacing.medium))
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("mission.startButton")
    }

    private var lockedState: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(AppColors.secondaryText)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(String.localized("mission.locked", for: language))
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.primaryText)

                    Text(lockReason ?? String.localized("mission.locked.description", for: language))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

private enum MissionProgressState {
    case notStarted
    case inProgress
    case completed
}

#Preview {
    NavigationStack {
        MissionIntroView(
            mission: .sample,
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
