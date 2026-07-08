import SwiftUI

struct DailyDiscoveryCard: View {
    let discovery: DailyDiscovery
    let language: AppLanguage
    let destination: AnyView?

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard(variant: .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(alignment: .top, spacing: AppSpacing.medium) {
                    ExploreThumbnail(
                        imageName: discovery.imageName,
                        fallbackSystemImage: iconName,
                        accentColor: AppColors.water,
                        accessibilityDescription: discovery.title.displayText(for: language),
                        width: 96,
                        height: 88
                    )

                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Label(labelText, systemImage: iconName)
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.water)

                        Text(discovery.title.displayText(for: language))
                            .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(discovery.description.displayText(for: language))
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let destination {
                    NavigationLink {
                        destination
                    } label: {
                        Text(language == .georgian ? "გახსნა" : "Open")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
            }
        }
    }

    private var labelText: String {
        language == .georgian ? "დღის აღმოჩენა" : "Today's Discovery"
    }

    private var iconName: String {
        switch discovery.factType {
        case .animalFact:
            return "pawprint.fill"
        case .plantFact:
            return "leaf.fill"
        case .ecosystemFact:
            return "map.fill"
        case .observationTip:
            return "eye.fill"
        case .environmentTip:
            return "hand.raised.fill"
        }
    }
}
