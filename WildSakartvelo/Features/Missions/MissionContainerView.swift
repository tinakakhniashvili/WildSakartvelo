import SwiftUI

struct MissionContainerView: View {
    let mission: Mission
    let catalogue: ContentCatalogue

    @StateObject private var session: MissionSession
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @State private var hasStartedMission = false
    @State private var hasSavedCompletion = false

    init(
        mission: Mission,
        catalogue: ContentCatalogue,
        startingActivityIndex: Int = 0,
        startingAttempts: Int = 0
    ) {
        self.mission = mission
        self.catalogue = catalogue
        _session = StateObject(
            wrappedValue: MissionSession(
                mission: mission,
                catalogue: catalogue,
                startingActivityIndex: startingActivityIndex,
                startingAttempts: startingAttempts
            )
        )
    }

    var body: some View {
        Group {
            if session.isMissionCompleted {
                MissionResultView(
                    mission: mission,
                    attempts: session.attempts,
                    unlockedEcosystemName: unlockedEcosystemName
                ) {
                    dismiss()
                }
            } else {
                missionContent
            }
        }
        .navigationTitle(mission.displayTitle(for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard !hasStartedMission else { return }
            hasStartedMission = true
            appState.startMission(mission)
            appState.saveMissionProgress(
                mission,
                activityIndex: session.currentActivityIndex,
                attempts: session.attempts
            )
        }
        .onChange(of: session.isMissionCompleted) { _, isCompleted in
            guard isCompleted, !hasSavedCompletion else { return }
            hasSavedCompletion = true
            appState.stopAudio()
            appState.completeMission(mission)
        }
        .onDisappear {
            appState.stopAudio()
        }
    }

    private var reducedMotionEnabled: Bool {
        appState.appSettings.reducedMotionEnabled || systemReduceMotion
    }

    private var missionContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header
                if let narrationFileName = session.currentActivity?.narrationFileName(for: appState.currentLanguage),
                   appState.narrationEnabled {
                    AudioControlButton(
                        fileName: narrationFileName,
                        label: String.localized("audio.playNarration", for: appState.currentLanguage),
                        audioService: appState.audioService,
                        actionLabel: "narration",
                        accessibilityIdentifier: "mission.narrationButton"
                    )
                    subtitleText
                }
                activityContent
                feedback
                actionButton
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .transaction { transaction in
            if reducedMotionEnabled {
                transaction.animation = nil
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(mission.displayTitle(for: appState.currentLanguage))
                .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(session.progressText)
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)

            ProgressView(value: session.progressValue)
                .tint(AppColors.progressTint(using: accessibilitySettings))
        }
    }

    @ViewBuilder
    private var activityContent: some View {
        if let activity = session.currentActivity {
            switch activity.type {
            case .multipleChoice:
                MultipleChoiceActivityView(
                    activity: activity,
                    selectedAnswerID: $session.selectedAnswerID
                )
            case .matching:
                MatchingActivityView(
                    activity: activity,
                    selectedPairs: $session.selectedPairs
                )
            case .classification:
                ClassificationActivityView(
                    activity: activity,
                    selectedCategories: $session.selectedCategories
                )
            case .sequencing:
                if activity.sequenceItems == nil {
                    malformedActivity(activity)
                } else {
                    SequencingActivityView(
                        activity: activity,
                        orderedItemIDs: $session.orderedItemIDs
                    )
                }
            case .habitatPlacement:
                if activity.habitatZones == nil {
                    malformedActivity(activity)
                } else {
                    HabitatPlacementActivityView(
                        activity: activity,
                        habitatSelections: $session.habitatSelections
                    )
                }
            }
        } else {
            AppCard {
                Text(String.localized("mission.emptyActivities", for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
    }

    private func malformedActivity(_ activity: MissionActivity) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(String.localized("mission.malformedActivity", for: appState.currentLanguage))
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                Text(
                    String.localizedFormat(
                        "mission.malformedActivity.description",
                        for: appState.currentLanguage,
                        activity.id,
                        activity.type.rawValue
                    )
                )
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    @ViewBuilder
    private var feedback: some View {
        if let feedbackMessage = session.feedbackMessage {
            AppCard {
                HStack(alignment: .top, spacing: AppSpacing.medium) {
                    Image(systemName: session.isAnswerCorrect ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(session.isAnswerCorrect ? AppColors.success : AppColors.warning)

                    Text(feedbackMessage)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        if session.isAnswerCorrect {
            PrimaryButton(title: String.localized("action.continue", for: appState.currentLanguage)) {
                session.continueToNextActivity()
                appState.stopAudio()
                if session.isMissionCompleted {
                    saveCompletionIfNeeded()
                } else {
                    appState.saveMissionProgress(
                        mission,
                        activityIndex: session.currentActivityIndex,
                        attempts: session.attempts
                    )
                }
            }
            .accessibilityIdentifier("mission.continueButton")
        } else {
            PrimaryButton(title: String.localized("action.submit", for: appState.currentLanguage)) {
                session.submitAnswer()
                appState.saveMissionProgress(
                    mission,
                    activityIndex: session.currentActivityIndex,
                    attempts: session.attempts
                )
            }
            .disabled(!session.canSubmit)
            .accessibilityIdentifier("mission.submitButton")
        }
    }

    @ViewBuilder
    private var subtitleText: some View {
        if appState.appSettings.subtitlesEnabled,
           let activity = session.currentActivity {
            Text(activity.displayInstruction(for: appState.currentLanguage))
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityHidden(true)
        }
    }

    private func saveCompletionIfNeeded() {
        guard !hasSavedCompletion else { return }
        hasSavedCompletion = true
        appState.completeMission(mission)
    }

    private var unlockedEcosystemName: String? {
        guard mission.reward.type == .ecosystemUnlock else { return nil }
        return catalogue.ecosystemsByID[mission.reward.referenceID]?.displayName(for: appState.currentLanguage)
    }
}

#Preview {
    NavigationStack {
        MissionContainerView(
            mission: Mission(
                id: "preview-mission",
                title: "Preview Mission",
                localizedTitle: nil,
                subtitle: "Preview supported activities",
                localizedSubtitle: nil,
                introduction: "Try the supported activity types.",
                localizedIntroduction: nil,
                ecosystemID: "caucasus-mountains",
                difficulty: .beginner,
                estimatedMinutes: 8,
                activityIDs: [
                    MissionActivity.sample.id,
                    MissionActivity.sampleMatching.id,
                    MissionActivity.sampleClassification.id,
                    MissionActivity.sampleSequencing.id,
                    MissionActivity.sampleHabitatPlacement.id
                ],
                learningTopics: ["habitats", "animalIdentification", "foodChains", "observation"],
                reward: MissionReward(
                    type: .animalCard,
                    referenceID: "caucasian-tur",
                    title: "Caucasian Tur Card",
                    localizedTitle: LocalizedContentText(
                        english: "Caucasian Tur Card",
                        georgian: "ჯიხვის ბარათი"
                    )
                ),
                prerequisiteMissionIDs: []
            ),
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [
                    .sample,
                    .sampleMatching,
                    .sampleClassification,
                    .sampleSequencing,
                    .sampleHabitatPlacement
                ]
            )
        )
        .environmentObject(AppState())
    }
}

#Preview("Matching Activity") {
    NavigationStack {
        MissionContainerView(
            mission: Mission(
                id: "preview-matching-mission",
                title: "Matching Preview",
                localizedTitle: nil,
                subtitle: "Preview matching",
                localizedSubtitle: nil,
                introduction: "Try matching.",
                localizedIntroduction: nil,
                ecosystemID: "caucasus-mountains",
                difficulty: .beginner,
                estimatedMinutes: 3,
                activityIDs: [MissionActivity.sampleMatching.id],
                learningTopics: ["animalIdentification", "observation"],
                reward: MissionReward(
                    type: .animalCard,
                    referenceID: "caucasian-tur",
                    title: "Caucasian Tur Card",
                    localizedTitle: LocalizedContentText(
                        english: "Caucasian Tur Card",
                        georgian: "ჯიხვის ბარათი"
                    )
                ),
                prerequisiteMissionIDs: []
            ),
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [.sampleMatching]
            )
        )
        .environmentObject(AppState())
    }
}

#Preview("Classification Activity") {
    NavigationStack {
        MissionContainerView(
            mission: Mission(
                id: "preview-classification-mission",
                title: "Classification Preview",
                localizedTitle: nil,
                subtitle: "Preview classification",
                localizedSubtitle: nil,
                introduction: "Try classification.",
                localizedIntroduction: nil,
                ecosystemID: "caucasus-mountains",
                difficulty: .beginner,
                estimatedMinutes: 3,
                activityIDs: [MissionActivity.sampleClassification.id],
                learningTopics: ["habitats", "animalIdentification"],
                reward: MissionReward(
                    type: .animalCard,
                    referenceID: "caucasian-tur",
                    title: "Caucasian Tur Card",
                    localizedTitle: LocalizedContentText(
                        english: "Caucasian Tur Card",
                        georgian: "ჯიხვის ბარათი"
                    )
                ),
                prerequisiteMissionIDs: []
            ),
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [.sampleClassification]
            )
        )
        .environmentObject(AppState())
    }
}
