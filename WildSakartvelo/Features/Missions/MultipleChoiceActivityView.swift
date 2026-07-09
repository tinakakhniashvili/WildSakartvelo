import SwiftUI

struct MultipleChoiceActivityView: View {
    let activity: MissionActivity
    @Binding var selectedAnswerID: String?
    var hasSubmitted = false
    var isAnswerCorrect = false
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.large) {
            Text(activity.displayInstruction(for: appState.currentLanguage))
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            if activity.imageName != nil {
                ContentImageView(
                    imageName: activity.imageName,
                    fallbackSystemImage: "questionmark.circle.fill",
                    height: 160,
                    accentColor: AppColors.mountain
                )
            }

            Text(activity.displayQuestion(for: appState.currentLanguage))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: AppSpacing.medium) {
                ForEach(activity.options) { option in
                    Button {
                        selectedAnswerID = option.id
                    } label: {
                        optionCard(option)
                    }
                    .buttonStyle(.plain)
                    .disabled(isAnswerCorrect)
                }
            }
        }
    }

    private func optionCard(_ option: ActivityOption) -> some View {
        let isSelected = selectedAnswerID == option.id
        let isCorrectOption = activity.correctAnswerIDs.contains(option.id)
        let state = optionState(isSelected: isSelected, isCorrectOption: isCorrectOption)

        return AppCard {
            HStack(spacing: AppSpacing.medium) {
                if option.imageName != nil {
                    ContentImageView(
                        imageName: option.imageName,
                        fallbackSystemImage: "photo.fill",
                        height: 64,
                        accentColor: AppColors.water
                    )
                    .frame(width: 76)
                }

                Text(option.displayText(for: appState.currentLanguage))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: state.iconName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(state.color)
                    .accessibilityHidden(true)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppSpacing.medium)
                .stroke(state.borderColor, lineWidth: state.borderWidth)
        }
        .opacity(isAnswerCorrect && !isCorrectOption ? 0.58 : 1)
        .accessibilityValue(state.accessibilityValue)
    }

    private func optionState(isSelected: Bool, isCorrectOption: Bool) -> AnswerCardState {
        guard hasSubmitted else {
            return isSelected ? .selected : .normal
        }

        if isCorrectOption {
            return .correct
        }

        if isSelected {
            return .incorrect
        }

        return isAnswerCorrect ? .disabled : .normal
    }
}

private enum AnswerCardState {
    case normal
    case selected
    case correct
    case incorrect
    case disabled

    var iconName: String {
        switch self {
        case .normal:
            return "circle"
        case .selected:
            return "checkmark.circle.fill"
        case .correct:
            return "checkmark.seal.fill"
        case .incorrect:
            return "xmark.circle.fill"
        case .disabled:
            return "minus.circle"
        }
    }

    var color: Color {
        switch self {
        case .normal, .disabled:
            return AppColors.secondaryText
        case .selected:
            return AppColors.forest
        case .correct:
            return AppColors.success
        case .incorrect:
            return AppColors.warning
        }
    }

    var borderColor: Color {
        switch self {
        case .normal, .disabled:
            return .clear
        case .selected:
            return AppColors.forest
        case .correct:
            return AppColors.success
        case .incorrect:
            return AppColors.warning
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .normal, .disabled:
            return 0
        case .selected, .correct, .incorrect:
            return 2
        }
    }

    var accessibilityValue: String {
        switch self {
        case .normal:
            return "Not selected"
        case .selected:
            return "Selected"
        case .correct:
            return "Correct answer"
        case .incorrect:
            return "Try again"
        case .disabled:
            return "Disabled"
        }
    }
}

#Preview {
    MultipleChoiceActivityView(
        activity: .sample,
        selectedAnswerID: .constant("rocky-mountain-slope")
    )
    .padding()
    .background(AppColors.background)
}
