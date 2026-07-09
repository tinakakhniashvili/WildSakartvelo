import SwiftUI

struct RegionCardView: View {
    let region: GeorgiaRegion
    let language: AppLanguage
    var isDiscovered = false

    var body: some View {
        AppCard(variant: isDiscovered ? .selected : .standard) {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                ExploreThumbnail(
                    imageName: region.imageName,
                    fallbackSystemImage: "map.fill",
                    accentColor: AppColors.water,
                    accessibilityDescription: region.name.displayText(for: language),
                    width: 82,
                    height: 70
                )

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(region.name.displayText(for: language))
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Label(region.administrativeCenter.displayText(for: language), systemImage: "mappin.and.ellipse")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
    }
}
