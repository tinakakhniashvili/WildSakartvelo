import SwiftUI

struct GeorgiaMapView: View {
    let regions: [GeorgiaRegion]
    @Binding var selectedRegionID: String?
    let language: AppLanguage

    var body: some View {
        AppCard(variant: .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                RegionMapOverlay(
                    regions: regions,
                    selectedRegionID: selectedRegionID,
                    language: language
                ) { region in
                    selectedRegionID = region.id
                }

                MapLegendView(language: language)

                if let selectedRegion {
                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(selectedRegion.name.displayText(for: language))
                            .font(AppTypography.cardTitle)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Label(selectedRegion.administrativeCenter.displayText(for: language), systemImage: "building.2.fill")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)

                        Text(selectedRegion.fact.displayText(for: language))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private var selectedRegion: GeorgiaRegion? {
        regions.first { $0.id == selectedRegionID }
    }
}
