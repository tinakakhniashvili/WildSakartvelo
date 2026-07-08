import SwiftUI

struct ParentDashboardView: View {
    let catalogue: ContentCatalogue

    @EnvironmentObject var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @State private var isShowingEditProfile = false
    @State private var confirmation: ParentConfirmation?

    private var profile: ChildProfile? {
        appState.selectedProfile
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                if let profile {
                    profileSummary(profile)
                    currentMissionSection

                    ProgressOverviewView(
                        completedMissionCount: appState.userProgress.completedMissionIDs.count,
                        totalMissionCount: catalogue.missions.count,
                        discoveredAnimalCount: appState.userProgress.discoveredAnimalIDs.count,
                        totalAnimalCount: catalogue.animals.count,
                        discoveredPlantCount: appState.userProgress.discoveredPlantIDs.count,
                        totalPlantCount: catalogue.plants.count,
                        language: appState.currentLanguage
                    )

                    CompletedMissionsView(
                        catalogue: catalogue,
                        completedMissionIDs: appState.userProgress.completedMissionIDs,
                        language: appState.currentLanguage
                    )

                    LearningTopicsView(
                        catalogue: catalogue,
                        completedMissionIDs: appState.userProgress.completedMissionIDs,
                        language: appState.currentLanguage
                    )

                    profileManagementSection(profile)
                } else {
                    EmptyStateView(
                        systemImage: "person.crop.circle.badge.questionmark",
                        title: String.localized("parent.noProfile.title", for: appState.currentLanguage),
                        description: String.localized("parent.noProfile.description", for: appState.currentLanguage)
                    )
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(String.localized("parent.dashboard.title", for: appState.currentLanguage))
        .sheet(isPresented: $isShowingEditProfile) {
            if let profile {
                EditProfileView(profile: profile) { updatedProfile in
                    appState.updateProfile(updatedProfile)
                }
                .environmentObject(appState)
                .environment(\.appAccessibilitySettings, accessibilitySettings)
            }
        }
        .alert(item: $confirmation) { confirmation in
            switch confirmation {
            case .deleteProfile:
                return Alert(
                    title: Text(String.localized("parent.deleteProfile.title", for: appState.currentLanguage)),
                    message: Text(String.localized("parent.deleteProfile.message", for: appState.currentLanguage)),
                    primaryButton: .destructive(Text(String.localized("parent.deleteProfile.confirm", for: appState.currentLanguage))) {
                        if let profile {
                            appState.deleteProfile(profile)
                        }
                    },
                    secondaryButton: .cancel(Text(String.localized("action.cancel", for: appState.currentLanguage)))
                )
            case .resetProgress:
                return Alert(
                    title: Text(String.localized("parent.resetProgress.title", for: appState.currentLanguage)),
                    message: Text(String.localized("parent.resetProgress.message", for: appState.currentLanguage)),
                    primaryButton: .destructive(Text(String.localized("parent.resetProgress.confirm", for: appState.currentLanguage))) {
                        appState.resetProgress()
                    },
                    secondaryButton: .cancel(Text(String.localized("action.cancel", for: appState.currentLanguage)))
                )
            }
        }
    }

    private func profileSummary(_ profile: ChildProfile) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(alignment: .center, spacing: AppSpacing.medium) {
                    ContentImageView(
                        imageName: AvatarSelectionView.assetName(for: profile.avatarID),
                        fallbackSystemImage: AvatarSelectionView.systemImage(for: profile.avatarID),
                        mode: .avatar,
                        height: 64,
                        accentColor: AppColors.forest,
                        accessibilityDescription: profile.nickname
                    )
                    .frame(width: 64, height: 64)

                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(profile.nickname)
                            .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(profile.learningLevel.displayTitle(for: appState.currentLanguage))
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                    }
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: AppSpacing.small)], spacing: AppSpacing.small) {
                    statItem(
                        title: String.localized("parent.stat.completedMissions", for: appState.currentLanguage),
                        value: appState.userProgress.completedMissionIDs.count,
                        symbol: "checkmark.seal.fill"
                    )
                    statItem(
                        title: String.localized("parent.stat.animals", for: appState.currentLanguage),
                        value: appState.userProgress.discoveredAnimalIDs.count,
                        symbol: "pawprint.fill"
                    )
                    statItem(
                        title: String.localized("parent.stat.plants", for: appState.currentLanguage),
                        value: appState.userProgress.discoveredPlantIDs.count,
                        symbol: "leaf.fill"
                    )
                    statItem(
                        title: String.localized("parent.stat.badges", for: appState.currentLanguage),
                        value: appState.userProgress.earnedBadgeIDs.count,
                        symbol: "seal.fill"
                    )
                }

                if let equipment = EquipmentUnlockService().featuredEquipment(catalogue: catalogue, progress: appState.userProgress) {
                    HStack(spacing: AppSpacing.medium) {
                        ContentImageView(
                            imageName: equipment.imageName,
                            fallbackSystemImage: "bag.fill",
                            mode: .thumbnail,
                            height: 54,
                            accentColor: AppColors.forest,
                            accessibilityDescription: equipment.title.displayText(for: appState.currentLanguage)
                        )
                        .frame(width: 60, height: 54)

                        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                            Text(appState.currentLanguage == .georgian ? "აღჭურვილობა" : "Equipment")
                                .font(AppTypography.captionFont(using: accessibilitySettings))
                                .foregroundStyle(AppColors.secondaryText)

                            Text(equipment.title.displayText(for: appState.currentLanguage))
                                .font(AppTypography.bodyFont(using: accessibilitySettings))
                                .foregroundStyle(AppColors.primaryText)
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
    }

    private func statItem(title: String, value: Int, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            Image(systemName: symbol)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.forest)
                .accessibilityHidden(true)

            Text("\(value)")
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            Text(title)
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .leading)
        .padding(AppSpacing.small)
        .background(AppColors.background, in: RoundedRectangle(cornerRadius: AppSpacing.small))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var currentMissionSection: some View {
        if let activeMissionID = appState.userProgress.activeMissionID,
           !appState.userProgress.completedMissionIDs.contains(activeMissionID),
           let mission = catalogue.missionsByID[activeMissionID] {
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Label(String.localized("parent.currentMission.status", for: appState.currentLanguage), systemImage: "hourglass")
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.forest)

                    Text(mission.displayTitle(for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(
                        String.localizedFormat(
                            "parent.currentMission.activity",
                            for: appState.currentLanguage,
                            currentActivityNumber(for: mission),
                            max(mission.activityIDs.count, 1)
                        )
                    )
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)

                    Text(String.localizedFormat("parent.currentMission.attempts", for: appState.currentLanguage, appState.userProgress.totalAttemptsByMission[mission.id, default: 0]))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
            .accessibilityElement(children: .combine)
        }
    }

    private func profileManagementSection(_ profile: ChildProfile) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text(String.localized("parent.management.title", for: appState.currentLanguage))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                Button {
                    appState.clearSelectedProfile()
                } label: {
                    Label(String.localized("parent.management.switchProfile", for: appState.currentLanguage), systemImage: "person.2.fill")
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }

                Button {
                    isShowingEditProfile = true
                } label: {
                    Label(String.localized("parent.management.editProfile", for: appState.currentLanguage), systemImage: "pencil")
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }

                Button(role: .destructive) {
                    confirmation = .resetProgress
                } label: {
                    Label(String.localized("parent.management.resetProgress", for: appState.currentLanguage), systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }

                Button(role: .destructive) {
                    confirmation = .deleteProfile
                } label: {
                    Label(String.localized("parent.management.deleteProfile", for: appState.currentLanguage), systemImage: "trash.fill")
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
            }
            .buttonStyle(.borderless)
        }
    }

    private func currentActivityNumber(for mission: Mission) -> Int {
        let savedIndex = appState.userProgress.currentActivityIndexByMission[mission.id, default: 0]
        return min(max(savedIndex + 1, 1), max(mission.activityIDs.count, 1))
    }
}

private enum ParentConfirmation: Identifiable {
    case deleteProfile
    case resetProgress

    var id: String {
        switch self {
        case .deleteProfile:
            return "deleteProfile"
        case .resetProgress:
            return "resetProgress"
        }
    }
}

#Preview("Parent Dashboard Empty") {
    ParentDashboardPreview(progress: .empty)
}

#Preview("Parent Dashboard Partial") {
    ParentDashboardPreview(
        progress: UserProgress(
            completedMissionIDs: ["mountain-habitat-discovery"],
            discoveredAnimalIDs: ["caucasian-tur"],
            discoveredPlantIDs: [],
            unlockedEcosystemIDs: [],
            earnedBadgeIDs: ["first-mission"],
            activeMissionID: "mountain-habitat-discovery",
            currentActivityIndexByMission: ["mountain-habitat-discovery": 1],
            totalAttemptsByMission: ["mountain-habitat-discovery": 2]
        )
    )
}

#Preview("Parent Dashboard Completed") {
    ParentDashboardPreview(
        progress: UserProgress(
            completedMissionIDs: ["mountain-habitat-discovery"],
            discoveredAnimalIDs: ["caucasian-tur"],
            discoveredPlantIDs: ["caucasian-rhododendron"],
            unlockedEcosystemIDs: ["caucasus-mountains"],
            earnedBadgeIDs: ["first-mission"],
            activeMissionID: nil,
            currentActivityIndexByMission: [:],
            totalAttemptsByMission: ["mountain-habitat-discovery": 3]
        )
    )
}

private struct ParentDashboardPreview: View {
    @StateObject private var appState = AppState()
    let progress: UserProgress

    var body: some View {
        NavigationStack {
            ParentDashboardView(
                catalogue: try! ContentCatalogue(
                    ecosystems: [.sample],
                    animals: [.sample],
                    plants: [.sample],
                    missions: [.sample],
                    activities: [.sample]
                )
            )
        }
        .environmentObject(appState)
        .environment(\.appAccessibilitySettings, AppAccessibilitySettings.defaultValue)
        .onAppear {
            appState.selectedProfile = .sample
            appState.userProgress = progress
        }
    }
}
