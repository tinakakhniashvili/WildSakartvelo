import SwiftUI

struct BadgeDetailView: View {
    let badge: JournalItem
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        Image(systemName: badge.fallbackSymbol)
                            .font(.system(size: 56, weight: .semibold))
                            .foregroundStyle(AppColors.water)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(badge.title)
                            .font(AppTypography.largeTitle)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(
                            String(
                                format: .localized("badge.detail.id", for: appState.currentLanguage),
                                badge.sourceID
                            )
                        )
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)

                        Text(String.localized("badge.detail.description", for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(badge.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        BadgeDetailView(
            badge: JournalItem(
                sourceID: "first-mission",
                type: .badge,
                title: "First Mission",
                subtitle: "Earned through exploration",
                imageName: nil,
                fallbackSymbol: "seal.fill"
            )
        )
    }
}
