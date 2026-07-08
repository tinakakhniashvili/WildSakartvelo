import SwiftUI

struct JournalCardView: View {
    let item: JournalItem
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                image
                    .layoutPriority(1)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    typeTag

                    Text(item.title)
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .lineLimit(3)
                        .minimumScaleFactor(0.82)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(item.subtitle)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(3)
                        .minimumScaleFactor(0.82)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.accessibilityLabel(for: appState.currentLanguage))
        .accessibilityValue(item.type.displayTitle(for: appState.currentLanguage))
    }

    private var image: some View {
        ContentImageView(
            imageName: item.imageName,
            fallbackSystemImage: item.fallbackSymbol,
            mode: .journal,
            height: 72,
            accentColor: backgroundColor,
            accessibilityDescription: item.title
        )
        .frame(width: 72, height: 72)
        .background(backgroundColor.opacity(0.12), in: RoundedRectangle(cornerRadius: AppRadius.thumbnail))
        .clipped()
    }

    private var typeTag: some View {
        Text(item.type.displayTitle(for: appState.currentLanguage))
            .font(AppTypography.captionFont(using: accessibilitySettings))
            .foregroundStyle(backgroundColor)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    private var backgroundColor: Color {
        switch item.type {
        case .animal:
            return AppColors.mountain
        case .plant:
            return AppColors.forest
        case .badge:
            return AppColors.water
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.medium) {
        JournalCardView(
            item: JournalItem(
                sourceID: "caucasian-tur",
                type: .animal,
                title: "Caucasian Tur",
                subtitle: "ჯიხვი",
                imageName: "caucasian_tur",
                fallbackSymbol: "pawprint.fill"
            )
        )

        JournalCardView(
            item: JournalItem(
                sourceID: "caucasus-rhododendron",
                type: .plant,
                title: "Caucasus Rhododendron",
                subtitle: "დეკა",
                imageName: "caucasus_rhododendron",
                fallbackSymbol: "leaf.fill"
            )
        )
    }
    .padding()
    .background(AppColors.background)
}
