import SwiftUI

struct TokoGuideView: View {
    let message: String
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: .success) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: "avatar_fox_explorer",
                    fallbackSystemImage: "leaf.fill",
                    mode: .avatar,
                    height: 54,
                    accentColor: AppColors.forest,
                    accessibilityDescription: "Toko"
                )
                .frame(width: 54, height: 54)

                Text(message)
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    TokoGuideView(message: "Pick one place and start with a short mission.")
        .padding()
        .background(AppColors.background)
}
