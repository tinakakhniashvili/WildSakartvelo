import SwiftUI

enum MissionFeedbackKind {
    case success
    case retry
    case hint
    case unavailable
    case completion

    var iconName: String {
        switch self {
        case .success, .completion:
            return "checkmark.circle.fill"
        case .retry:
            return "arrow.counterclockwise.circle.fill"
        case .hint:
            return "lightbulb.fill"
        case .unavailable:
            return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success, .completion:
            return AppColors.success
        case .retry, .hint:
            return AppColors.warning
        case .unavailable:
            return AppColors.secondaryText
        }
    }
}

struct ActivityContainerView<AudioService: AudioPlaying, ActivityContent: View, ActionContent: View>: View where AudioService: ObservableObject {
    let title: String
    let progressText: String
    let progressValue: Double
    let instruction: String?
    let narrationFileName: String?
    let showsSubtitles: Bool
    let audioService: AudioService
    let feedbackKind: MissionFeedbackKind?
    let feedbackMessage: String?
    let activityContent: ActivityContent
    let actionContent: ActionContent

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    init(
        title: String,
        progressText: String,
        progressValue: Double,
        instruction: String?,
        narrationFileName: String?,
        showsSubtitles: Bool,
        audioService: AudioService,
        feedbackKind: MissionFeedbackKind?,
        feedbackMessage: String?,
        @ViewBuilder activityContent: () -> ActivityContent,
        @ViewBuilder actionContent: () -> ActionContent
    ) {
        self.title = title
        self.progressText = progressText
        self.progressValue = progressValue
        self.instruction = instruction
        self.narrationFileName = narrationFileName
        self.showsSubtitles = showsSubtitles
        self.audioService = audioService
        self.feedbackKind = feedbackKind
        self.feedbackMessage = feedbackMessage
        self.activityContent = activityContent()
        self.actionContent = actionContent()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.large) {
            header
            instructionPanel
            activityContent
            feedbackPanel
            actionContent
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(title)
                .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(progressText)
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)

            ProgressView(value: min(max(progressValue, 0), 1))
                .tint(AppColors.progressTint(using: accessibilitySettings))
        }
    }

    @ViewBuilder
    private var instructionPanel: some View {
        if instruction != nil || narrationFileName != nil {
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    if let instruction {
                        Label(instruction, systemImage: "sparkles")
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if let narrationFileName {
                        AudioControlButton(
                            fileName: narrationFileName,
                            label: "Play narration",
                            audioService: audioService,
                            actionLabel: "narration",
                            accessibilityIdentifier: "mission.narrationButton"
                        )
                    }

                    if showsSubtitles, let instruction {
                        Text(instruction)
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityHidden(true)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var feedbackPanel: some View {
        if let feedbackMessage, let feedbackKind {
            MissionFeedbackView(kind: feedbackKind, message: feedbackMessage)
        }
    }
}

struct MissionFeedbackView: View {
    let kind: MissionFeedbackKind
    let message: String
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: kind == .success || kind == .completion ? .success : .warning) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                Image(systemName: kind.iconName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(kind.color)
                    .accessibilityHidden(true)

                Text(message)
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
