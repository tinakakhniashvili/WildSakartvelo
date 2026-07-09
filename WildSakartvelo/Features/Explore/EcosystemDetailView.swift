import SwiftUI

struct EcosystemDetailView: View {
    let ecosystem: Ecosystem
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    private let unlockService = UnlockService()

    private var viewModel: EcosystemDetailViewModel {
        EcosystemDetailViewModel(ecosystem: ecosystem, catalogue: catalogue)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header
                continueMissionSection
                missionsSection
                animalsSection
                plantsSection
                geographySection
                environmentalFactSection
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(ecosystem.displayName(for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            ecosystemImage

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(ecosystem.displayName(for: appState.currentLanguage))
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(ecosystem.displaySubtitle(for: appState.currentLanguage))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(ecosystem.theme.accentColor)
                    .fixedSize(horizontal: false, vertical: true)

                Text(ecosystem.displayDescription(for: appState.currentLanguage))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    @ViewBuilder
    private var continueMissionSection: some View {
        if let mission = viewModel.missions.first(where: { mission in
            appState.userProgress.activeMissionID == mission.id ||
                appState.userProgress.currentActivityIndexByMission[mission.id] != nil
        }) {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                sectionTitle(text("Continue Mission", "მისიის გაგრძელება"), symbol: "play.circle.fill")

                NavigationLink {
                    MissionIntroView(mission: mission, catalogue: catalogue)
                } label: {
                    ContinueMissionCard(
                        mission: mission,
                        ecosystem: ecosystem,
                        currentActivityIndex: appState.userProgress.currentActivityIndexByMission[mission.id] ?? 0,
                        language: appState.currentLanguage
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    private var geographySection: some View {
        let linkedRegions = catalogue.regions.filter { $0.ecosystemIDs.contains(ecosystem.id) }
        if !linkedRegions.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                sectionTitle(text("Geography Connection", "კავშირი რუკასთან"), symbol: "map.fill")

                AppCard {
                    VStack(spacing: AppSpacing.small) {
                        ForEach(linkedRegions) { region in
                            NavigationLink {
                                RegionDetailView(region: region, catalogue: catalogue)
                            } label: {
                                HStack(spacing: AppSpacing.medium) {
                                    Image(systemName: "map.fill")
                                        .foregroundStyle(AppColors.water)
                                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                                        Text(region.name.displayText(for: appState.currentLanguage))
                                            .font(AppTypography.body)
                                            .foregroundStyle(AppColors.primaryText)
                                        Text(region.administrativeCenter.displayText(for: appState.currentLanguage))
                                            .font(AppTypography.caption)
                                            .foregroundStyle(AppColors.secondaryText)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(AppColors.secondaryText)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var animalsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            sectionTitle(String.localized("content.animals", for: appState.currentLanguage), symbol: "pawprint.fill")

            if viewModel.animals.isEmpty {
                AppCard {
                    emptySectionText(for: .animals)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.small) {
                        ForEach(viewModel.animals) { animal in
                            NavigationLink {
                                AnimalDetailView(animal: animal)
                            } label: {
                                EcosystemContentTile(
                                    title: animal.displayName(for: appState.currentLanguage),
                                    subtitle: animal.scientificName,
                                    imageName: animal.imageName,
                                    symbol: "pawprint.fill",
                                    accentColor: ecosystem.theme.accentColor
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    private var plantsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            sectionTitle(String.localized("content.plants", for: appState.currentLanguage), symbol: "leaf.fill")

            if viewModel.plants.isEmpty {
                AppCard {
                    emptySectionText(for: .plants)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: AppSpacing.small) {
                        ForEach(viewModel.plants) { plant in
                            NavigationLink {
                                PlantDetailView(plant: plant, catalogue: catalogue)
                            } label: {
                                EcosystemContentTile(
                                    title: plant.displayName(for: appState.currentLanguage),
                                    subtitle: text("Plant", "მცენარე"),
                                    imageName: plant.imageName,
                                    symbol: "leaf.fill",
                                    accentColor: AppColors.forest
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    private var missionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            sectionTitle(String.localized("content.missions", for: appState.currentLanguage), symbol: "flag.checkered")

            if viewModel.missions.isEmpty {
                AppCard {
                    emptySectionText(for: .missions)
                }
            } else {
                VStack(spacing: AppSpacing.medium) {
                    ForEach(viewModel.missions) { mission in
                        let status = missionStatus(for: mission)
                        let lockReason = unlockService.missionLockReason(
                            mission,
                            catalogue: catalogue,
                            progress: appState.userProgress,
                            language: appState.currentLanguage
                        )

                        if status == .locked {
                            MissionRowView(
                                mission: mission,
                                status: status,
                                lockReason: lockReason
                            )
                        } else {
                            NavigationLink {
                                MissionIntroView(mission: mission, catalogue: catalogue)
                            } label: {
                                MissionRowView(
                                    mission: mission,
                                    status: status,
                                    lockReason: nil
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var environmentalFactSection: some View {
        AppCard(variant: .warning) {
            Label(ecosystem.displayDescription(for: appState.currentLanguage), systemImage: "leaf.fill")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func contentSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(title)
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    if items.isEmpty {
                        Text(String(localized: "common.emptyState"))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                    } else {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
    }

    private enum EmptySectionKind {
        case animals
        case plants
        case missions
    }

    private func emptySectionText(for kind: EmptySectionKind) -> some View {
        let text: String
        switch kind {
        case .animals:
            text = String.localized("explore.empty.animals", for: appState.currentLanguage)
        case .plants:
            text = String.localized("explore.empty.plants", for: appState.currentLanguage)
        case .missions:
            text = String.localized("explore.empty.missions", for: appState.currentLanguage)
        }

        return Text(text)
            .font(AppTypography.body)
            .foregroundStyle(AppColors.secondaryText)
    }

    private func missionStatus(for mission: Mission) -> MissionStatus {
        guard unlockService.isMissionUnlocked(mission, catalogue: catalogue, progress: appState.userProgress) else {
            return .locked
        }

        if appState.userProgress.completedMissionIDs.contains(mission.id) {
            return .completed
        }

        if appState.userProgress.activeMissionID == mission.id ||
            appState.userProgress.currentActivityIndexByMission[mission.id] != nil {
            return .inProgress
        }

        return .available
    }

    private func sectionTitle(_ title: String, symbol: String) -> some View {
        KidSectionHeader(title: title, symbol: symbol, color: ecosystem.theme.accentColor)
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }

    @ViewBuilder
    private var ecosystemImage: some View {
        ContentImageView(
            imageName: ecosystem.imageName,
            fallbackSystemImage: ecosystem.theme.fallbackSystemImage,
            mode: .hero,
            height: AppLayout.heroImageHeight,
            accentColor: ecosystem.theme.accentColor,
            accessibilityDescription: ecosystem.displayName(for: appState.currentLanguage)
        )
    }
}

private struct EcosystemContentTile: View {
    let title: String
    let subtitle: String
    let imageName: String
    let symbol: String
    let accentColor: Color

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                ExploreThumbnail(
                    imageName: imageName,
                    fallbackSystemImage: symbol,
                    accentColor: accentColor,
                    accessibilityDescription: title,
                    width: 132,
                    height: 96
                )

                Text(title)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(2)
                    .frame(width: 132, alignment: .leading)

                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(1)
                    .frame(width: 132, alignment: .leading)
            }
        }
        .frame(width: 164)
    }
}

private struct EcosystemDetailViewModel {
    let ecosystem: Ecosystem
    let catalogue: ContentCatalogue

    var animals: [Animal] {
        ecosystem.animalIDs.compactMap { id in
            catalogue.animalsByID[id]
        }
    }

    var plants: [Plant] {
        ecosystem.plantIDs.compactMap { id in
            catalogue.plantsByID[id]
        }
    }

    var missionTitles: [String] {
        missions.map(\.title)
    }

    var missions: [Mission] {
        ecosystem.missionIDs.compactMap { id in
            catalogue.missionsByID[id]
        }
    }
}

#Preview {
    NavigationStack {
        EcosystemDetailView(
            ecosystem: .sample,
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [.sample]
            )
        )
        .environmentObject(AppState())
    }
}
