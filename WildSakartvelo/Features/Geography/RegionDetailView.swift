import SwiftUI

struct RegionDetailView: View {
    let region: GeorgiaRegion
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                ContentImageView(
                    imageName: region.imageName,
                    fallbackAssetName: nil,
                    fallbackSystemImage: "map.fill",
                    mode: .hero,
                    accentColor: AppColors.water,
                    accessibilityDescription: region.name.displayText(for: appState.currentLanguage)
                )

                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text(region.name.displayText(for: appState.currentLanguage))
                            .font(AppTypography.screenTitle)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Label(centerTitle, systemImage: "building.2.fill")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.forest)

                        Text(region.description.displayText(for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                mapLocationSection

                infoSection(
                    title: text("Important Cities", "მნიშვნელოვანი ქალაქები"),
                    symbol: "building.columns.fill",
                    items: region.cityIDs.compactMap { catalogue.citiesByID[$0] }.map { city in
                        cityLabel(city)
                    }
                )

                infoSection(
                    title: text("Landmarks", "ღირსშესანიშნაობები"),
                    symbol: "mountain.2.fill",
                    items: region.landmarkIDs.compactMap { catalogue.geographyLandmarksByID[$0] }.map {
                        $0.name.displayText(for: appState.currentLanguage)
                    }
                )

                infoSection(
                    title: text("Neighboring Regions", "მეზობელი რეგიონები"),
                    symbol: "arrow.left.and.right",
                    items: region.neighboringRegionIDs.compactMap { catalogue.regionsByID[$0]?.name.displayText(for: appState.currentLanguage) }
                )

                infoSection(
                    title: text("Explore Nature Here", "გამოიკვლიე ბუნება აქ"),
                    symbol: "leaf.fill",
                    items: region.ecosystemIDs.compactMap { catalogue.ecosystemsByID[$0]?.displayName(for: appState.currentLanguage) }
                )

                AppCard(variant: .warning) {
                    Label(region.fact.displayText(for: appState.currentLanguage), systemImage: "sparkles")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let mission = catalogue.geographyMissions.first(where: { $0.regionIDs.contains(region.id) }) {
                    NavigationLink {
                        GeographyMissionView(mission: mission, catalogue: catalogue)
                    } label: {
                        geographyMissionCard(mission)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("region.startGeographyMission")
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(region.name.displayText(for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var centerTitle: String {
        if region.id == "tbilisi" {
            return text("National capital: Tbilisi", "დედაქალაქი: თბილისი")
        }
        return "\(text("Administrative center", "ადმინისტრაციული ცენტრი")): \(region.administrativeCenter.displayText(for: appState.currentLanguage))"
    }

    private func infoSection(title: String, symbol: String, items: [String]) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Label(title, systemImage: symbol)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)

                if items.isEmpty {
                    Text(text("No linked items yet.", "ჯერ დაკავშირებული ჩანაწერები არ არის."))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                } else {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }

    private var mapLocationSection: some View {
        AppCard {
            HStack(spacing: AppSpacing.medium) {
                GeorgiaMapThumbnailView(regions: [region])
                    .frame(width: 132, height: 92)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Label(text("Map location", "მდებარეობა რუკაზე"), systemImage: "mappin.and.ellipse")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.primaryText)

                    Text(region.fact.displayText(for: appState.currentLanguage))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func geographyMissionCard(_ mission: GeographyMission) -> some View {
        let isCompleted = appState.userProgress.geographyProgress.completedGeographyMissionIDs.contains(mission.id)

        return AppCard(variant: isCompleted ? .success : .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(alignment: .top, spacing: AppSpacing.medium) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.thumbnail)
                            .fill((isCompleted ? AppColors.success : AppColors.forest).opacity(0.14))

                        Image(systemName: isCompleted ? "checkmark.seal.fill" : "map.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(isCompleted ? AppColors.success : AppColors.forest)
                    }
                    .frame(width: 62, height: 62)
                    .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(isCompleted ? text("Geography Mission Complete", "გეოგრაფიის მისია დასრულებულია") : text("Geography Mission", "გეოგრაფიის მისია"))
                            .font(AppTypography.caption)
                            .foregroundStyle(isCompleted ? AppColors.success : AppColors.forest)

                        Text(mission.title.displayText(for: appState.currentLanguage))
                            .font(AppTypography.cardTitle)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(mission.introduction.displayText(for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: AppSpacing.small) {
                    Label(
                        text("\(mission.activityIDs.count) map tasks", "\(mission.activityIDs.count) რუკის დავალება"),
                        systemImage: "list.bullet.clipboard.fill"
                    )
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)

                    Spacer(minLength: AppSpacing.small)

                    Label(
                        isCompleted ? text("Review", "გადახედვა") : text("Start", "დაწყება"),
                        systemImage: isCompleted ? "arrow.clockwise.circle.fill" : "play.circle.fill"
                    )
                    .font(AppTypography.button)
                    .foregroundStyle(.white)
                    .padding(.horizontal, AppSpacing.medium)
                    .frame(minHeight: 44)
                    .background(
                        isCompleted ? AppColors.success : AppColors.forest,
                        in: RoundedRectangle(cornerRadius: AppRadius.button)
                    )
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            isCompleted
                ? text("Review geography mission", "გეოგრაფიის მისიის გადახედვა")
                : text("Start geography mission", "გეოგრაფიის მისიის დაწყება")
        )
        .accessibilityValue(mission.title.displayText(for: appState.currentLanguage))
    }

    private func cityLabel(_ city: GeorgianCity) -> String {
        if city.id == "tbilisi" {
            return "\(city.name.displayText(for: appState.currentLanguage)) - \(text("national capital", "დედაქალაქი"))"
        }
        if city.isAdministrativeCenter {
            return "\(city.name.displayText(for: appState.currentLanguage)) - \(text("administrative center", "ადმინისტრაციული ცენტრი"))"
        }
        return city.name.displayText(for: appState.currentLanguage)
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}
