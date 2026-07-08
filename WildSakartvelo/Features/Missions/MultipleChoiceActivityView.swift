import SwiftUI

struct MultipleChoiceActivityView: View {
    let activity: MissionActivity
    @Binding var selectedAnswerID: String?
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
                }
            }
        }
    }

    private func optionCard(_ option: ActivityOption) -> some View {
        let isSelected = selectedAnswerID == option.id

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

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isSelected ? AppColors.forest : AppColors.secondaryText)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppSpacing.medium)
                .stroke(isSelected ? AppColors.forest : .clear, lineWidth: 2)
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
