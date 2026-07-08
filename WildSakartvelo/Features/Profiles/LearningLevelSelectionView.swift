import SwiftUI

struct LearningLevelSelectionView: View {
    @Binding var selectedLevel: LearningLevel
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            ForEach(LearningLevel.allCases, id: \.self) { level in
                Button {
                    selectedLevel = level
                } label: {
                    HStack(alignment: .top, spacing: AppSpacing.medium) {
                        Image(systemName: selectedLevel == level ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(selectedLevel == level ? AppColors.forest : AppColors.secondaryText)

                        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                            Text(level.displayTitle(for: appState.currentLanguage))
                                .font(AppTypography.cardTitle)
                                .foregroundStyle(AppColors.primaryText)

                            Text(level.shortDescription(for: appState.currentLanguage))
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(AppSpacing.medium)
                    .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppSpacing.medium))
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.medium)
                            .stroke(selectedLevel == level ? AppColors.forest : AppColors.secondaryText.opacity(0.14), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedLevel = LearningLevel.explorerOne

    return LearningLevelSelectionView(selectedLevel: $selectedLevel)
        .padding()
        .background(AppColors.background)
        .environmentObject(AppState())
}
