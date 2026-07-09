import SwiftUI

struct ProfileCardView: View {
    let profile: ChildProfile
    var language: AppLanguage = .english
    var showsLastUsed = true
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard {
            HStack(spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: AvatarSelectionView.assetName(for: profile.avatarID),
                    fallbackSystemImage: AvatarSelectionView.systemImage(for: profile.avatarID),
                    mode: .avatar,
                    height: 64,
                    accentColor: AppColors.forest,
                    accessibilityDescription: profile.nickname
                )
                .frame(width: 64, height: 64)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(profile.nickname)
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .lineLimit(1)

                    Text(profile.learningLevel.displayTitle(for: language))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)

                    if showsLastUsed {
                        Text(lastUsedText)
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                    }
                }

                Spacer(minLength: AppSpacing.small)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(profile.nickname)
        .accessibilityValue(profile.learningLevel.displayTitle(for: language))
    }

    private var lastUsedText: String {
        let formattedDate = profile.lastOpenedAt.formatted(
            .dateTime
                .locale(language.locale)
                .month(.abbreviated)
                .day()
                .year()
        )
        return String.localizedFormat("profile.lastUsed", for: language, formattedDate)
    }
}

#Preview {
    ProfileCardView(profile: .sample)
        .padding()
        .background(AppColors.background)
}
