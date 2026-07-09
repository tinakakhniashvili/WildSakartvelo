import SwiftUI

struct GeographyHomeView: View {
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @State private var selectedRegionID: String?
    private let progressCalculator = ProgressCalculator()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                geographyHeader

                progressSummary

                GeorgiaMapView(
                    regions: catalogue.regions,
                    selectedRegionID: $selectedRegionID,
                    language: appState.currentLanguage
                )

                regionSelector

                if let selectedRegion {
                    NavigationLink {
                        RegionDetailView(region: selectedRegion, catalogue: catalogue)
                    } label: {
                        Label(text("Open Region", "რეგიონის გახსნა"), systemImage: "arrow.right.circle.fill")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }

                sectionTitle(text("Learn the Regions", "ისწავლე რეგიონები"), symbol: "map.fill")
                regionList

                sectionTitle(text("Map Challenges", "რუკის გამოწვევები"), symbol: "flag.checkered")
                missionList
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(text("Geography", "გეოგრაფია"))
        .onAppear {
            selectedRegionID = selectedRegionID ?? catalogue.regions.first?.id
        }
    }

    private var regionSelector: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Label(text("Select a region", "აირჩიე რეგიონი"), systemImage: "list.bullet")
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.small) {
                        ForEach(catalogue.regions) { region in
                            Button {
                                selectedRegionID = region.id
                            } label: {
                                Label(
                                    region.name.displayText(for: appState.currentLanguage),
                                    systemImage: selectedRegionID == region.id ? "checkmark.circle.fill" : "circle"
                                )
                                .font(AppTypography.caption)
                                .lineLimit(1)
                            }
                            .buttonStyle(ChoiceButtonStyle(isSelected: selectedRegionID == region.id))
                            .accessibilityAddTraits(selectedRegionID == region.id ? [.isSelected] : [])
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    private var progressSummary: some View {
        let completion = progressCalculator.geographyCompletion(catalogue: catalogue, progress: appState.userProgress)
        return AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                HStack {
                    Label(text("Geography progress", "გეოგრაფიის პროგრესი"), systemImage: "map.circle.fill")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.primaryText)

                    Spacer()

                    Text("\(Int(completion * 100))%")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.forest)
                }

                ProgressView(value: completion)
                    .tint(AppColors.forest)
            }
        }
    }

    private var geographyHeader: some View {
        AppCard(variant: .elevated) {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                GeorgiaMapThumbnailView(regions: catalogue.regions)
                    .frame(width: 126, height: 88)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(text("Explore Georgia", "აღმოაჩინე საქართველო"))
                        .font(AppTypography.screenTitle)
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(text(
                        "Explore the regions, cities, mountains, rivers and coast of Sakartvelo.",
                        "გამოიკვლიე საქართველოს რეგიონები, ქალაქები, მთები, მდინარეები და სანაპირო."
                    ))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var regionList: some View {
        VStack(spacing: AppSpacing.small) {
            ForEach(catalogue.regions) { region in
                NavigationLink {
                    RegionDetailView(region: region, catalogue: catalogue)
                } label: {
                    RegionCardView(
                        region: region,
                        language: appState.currentLanguage,
                        isDiscovered: appState.userProgress.geographyProgress.discoveredRegionIDs.contains(region.id)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var missionList: some View {
        VStack(spacing: AppSpacing.small) {
            ForEach(catalogue.geographyMissions) { mission in
                NavigationLink {
                    GeographyMissionView(mission: mission, catalogue: catalogue)
                } label: {
                    AppCard(variant: appState.userProgress.geographyProgress.completedGeographyMissionIDs.contains(mission.id) ? .success : .standard) {
                        HStack(spacing: AppSpacing.medium) {
                            Image(systemName: "map.fill")
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(AppColors.water)
                                .frame(width: AppIconSize.medium, height: AppIconSize.medium)

                            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                                Text(mission.title.displayText(for: appState.currentLanguage))
                                    .font(AppTypography.cardTitle)
                                    .foregroundStyle(AppColors.primaryText)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text(mission.introduction.displayText(for: appState.currentLanguage))
                                    .font(AppTypography.caption)
                                    .foregroundStyle(AppColors.secondaryText)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Image(systemName: "chevron.right")
                                .foregroundStyle(AppColors.secondaryText)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var selectedRegion: GeorgiaRegion? {
        guard let selectedRegionID else { return nil }
        return catalogue.regionsByID[selectedRegionID]
    }

    private func sectionTitle(_ title: String, symbol: String) -> some View {
        KidSectionHeader(title: title, symbol: symbol, color: AppColors.water)
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}
