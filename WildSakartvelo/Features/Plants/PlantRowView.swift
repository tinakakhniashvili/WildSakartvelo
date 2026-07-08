import SwiftUI

struct PlantRowView: View {
    let plant: Plant
    @EnvironmentObject private var appState: AppState

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            ContentImageView(
                imageName: plant.imageName,
                fallbackSystemImage: "leaf.fill",
                mode: .thumbnail,
                height: 72,
                accentColor: AppColors.forest
            )
            .frame(width: 88)

            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                Text(plant.displayName(for: appState.currentLanguage))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(2)

                Text(plant.displayDescription(for: appState.currentLanguage))
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
    PlantRowView(plant: .sample)
        .padding()
        .background(AppColors.background)
}
