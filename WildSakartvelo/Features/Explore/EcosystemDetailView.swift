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
                counts
                animalsSection
                plantsSection
                missionsSection
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
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var counts: some View {
        AppCard {
            HStack(spacing: AppSpacing.medium) {
                countItem(title: String.localized("content.animals", for: appState.currentLanguage), value: viewModel.animals.count)
                countItem(title: String.localized("content.plants", for: appState.currentLanguage), value: viewModel.plants.count)
                countItem(title: String.localized("content.missions", for: appState.currentLanguage), value: viewModel.missionTitles.count)
            }
        }
    }

    private func countItem(title: String, value: Int) -> some View {
        VStack(spacing: AppSpacing.small) {
            Text("\(value)")
                .font(AppTypography.screenTitle)
                .foregroundStyle(ecosystem.theme.accentColor)

            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }

    private var animalsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String.localized("content.animals", for: appState.currentLanguage))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    if viewModel.animals.isEmpty {
                        emptySectionText(for: .animals)
                    } else {
                        ForEach(viewModel.animals) { animal in
                            NavigationLink {
                                AnimalDetailView(animal: animal)
                            } label: {
                                AnimalRowView(animal: animal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var plantsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String.localized("content.plants", for: appState.currentLanguage))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    if viewModel.plants.isEmpty {
                        emptySectionText(for: .plants)
                    } else {
                        ForEach(viewModel.plants) { plant in
                            NavigationLink {
                                PlantDetailView(plant: plant, catalogue: catalogue)
                            } label: {
                                PlantRowView(plant: plant)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }

    private var missionsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String.localized("content.missions", for: appState.currentLanguage))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

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
