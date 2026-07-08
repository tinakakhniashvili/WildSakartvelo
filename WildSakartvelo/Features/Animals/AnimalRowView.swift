import SwiftUI

struct AnimalRowView: View {
    let animal: Animal
    @EnvironmentObject private var appState: AppState

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            ContentImageView(
                imageName: animal.imageName,
                fallbackSystemImage: "pawprint.fill",
                mode: .thumbnail,
                height: 72,
                accentColor: animal.conservationStatus.color
            )
            .frame(width: 88)

            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                Text(animal.displayName(for: appState.currentLanguage))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(2)

                Text(animal.displayHabitat(for: appState.currentLanguage))
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(2)
            }

            Spacer(minLength: AppSpacing.small)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.secondaryText)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    AnimalRowView(animal: .sample)
        .padding()
        .background(AppColors.background)
}
