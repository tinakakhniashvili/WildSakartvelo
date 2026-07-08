import SwiftUI

struct IllustratedHeaderView: View {
    let title: String
    let subtitle: String
    let imageName: String
    var accentColor: Color = AppColors.forest

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: .elevated) {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: imageName,
                    fallbackSystemImage: "leaf.fill",
                    mode: .avatar,
                    height: 86,
                    accentColor: accentColor,
                    accessibilityDescription: title
                )
                .frame(width: 92, height: 86)
                .background(accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: AppRadius.largeCard))
                .clipped()

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(title)
                        .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(subtitle)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct KidSectionHeader: View {
    let title: String
    var symbol: String = "sparkle"
    var color: Color = AppColors.forest

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(color, in: Circle())
                .accessibilityHidden(true)

            Text(title)
                .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.large) {
        IllustratedHeaderView(
            title: "Wild Sakartvelo",
            subtitle: "Choose a place and start exploring.",
            imageName: "app_logo"
        )

        KidSectionHeader(title: "Ecosystems", symbol: "map.fill")
    }
    .padding()
    .background(AppColors.background)
}
