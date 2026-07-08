import SwiftUI

struct ExploreView: View {
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    private let unlockService = UnlockService()
    private let dailyDiscoveryService = DailyDiscoveryService()
    private let challengeService = ExplorerChallengeService()
    private let equipmentService = EquipmentUnlockService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                welcomeContent
                TokoGuideView(message: TokoMessageService().message(for: nextTokoSituation, language: appState.currentLanguage))
                continueExploringSection
                todaysDiscoverySection
                ecosystemContent
                recentJournalSection
                equipmentSection
                challengeSection
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(String.localized("tab.explore", for: appState.currentLanguage))
    }

    @ViewBuilder
    private var continueExploringSection: some View {
        if let activeMissionID = appState.userProgress.activeMissionID,
           let mission = catalogue.missionsByID[activeMissionID] {
            dashboardSectionTitle(text("Continue Exploring", "გააგრძელე კვლევა"))
            NavigationLink {
                MissionIntroView(mission: mission, catalogue: catalogue)
            } label: {
                ContinueMissionCard(
                    mission: mission,
                    ecosystem: catalogue.ecosystemsByID[mission.ecosystemID],
                    currentActivityIndex: appState.userProgress.currentActivityIndexByMission[mission.id] ?? 0,
                    language: appState.currentLanguage
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var todaysDiscoverySection: some View {
        if let discovery = dailyDiscoveryService.discovery(discoveries: catalogue.dailyDiscoveries) {
            dashboardSectionTitle(text("Today's Discovery", "დღის აღმოჩენა"))
            DailyDiscoveryCard(
                discovery: discovery,
                language: appState.currentLanguage,
                destination: destination(for: discovery)
            )
        }
    }

    private var welcomeContent: some View {
        AppCard(variant: .elevated) {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                ExploreThumbnail(
                    imageName: "app_logo",
                    fallbackSystemImage: "leaf.fill",
                    accentColor: AppColors.forest,
                    accessibilityDescription: String.localized("app.title", for: appState.currentLanguage),
                    width: 78,
                    height: 78
                )

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(String.localized("explore.welcome", for: appState.currentLanguage))
                        .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(String.localized("explore.description", for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    @ViewBuilder
    private var ecosystemContent: some View {
        if catalogue.ecosystems.isEmpty {
            EmptyStateView(
                systemImage: "map.fill",
                title: String.localized("explore.empty.title", for: appState.currentLanguage),
                description: String.localized("explore.empty.description", for: appState.currentLanguage)
            )
        } else {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text(String.localized("explore.chooseEcosystem", for: appState.currentLanguage))
                    .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                ForEach(catalogue.ecosystems) { ecosystem in
                    let isUnlocked = unlockService.isEcosystemUnlocked(ecosystem, progress: appState.userProgress)

                    if isUnlocked {
                        NavigationLink {
                            EcosystemDetailView(ecosystem: ecosystem, catalogue: catalogue)
                        } label: {
                            EcosystemCardView(
                                ecosystem: ecosystem,
                                isUnlocked: true,
                                progress: appState.userProgress
                            )
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("explore.ecosystemCard.\(ecosystem.id)")
                    } else {
                        EcosystemCardView(
                            ecosystem: ecosystem,
                            isUnlocked: false,
                            progress: nil
                        )
                        .accessibilityIdentifier("explore.ecosystemCard.\(ecosystem.id)")
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var recentJournalSection: some View {
        if let animalID = appState.userProgress.discoveredAnimalIDs.sorted().last,
           let animal = catalogue.animalsByID[animalID] {
            dashboardSectionTitle(text("Recent Journal Discovery", "ბოლო აღმოჩენა დღიურში"))
            NavigationLink {
                AnimalDetailView(animal: animal)
            } label: {
                JournalTeaserCard(
                    title: animal.displayName(for: appState.currentLanguage),
                    subtitle: animal.scientificName,
                    imageName: animal.imageName,
                    symbol: "pawprint.fill"
                )
            }
            .buttonStyle(.plain)
        } else if let plantID = appState.userProgress.discoveredPlantIDs.sorted().last,
                  let plant = catalogue.plantsByID[plantID] {
            dashboardSectionTitle(text("Recent Journal Discovery", "ბოლო აღმოჩენა დღიურში"))
            NavigationLink {
                PlantDetailView(plant: plant, catalogue: catalogue)
            } label: {
                JournalTeaserCard(
                    title: plant.displayName(for: appState.currentLanguage),
                    subtitle: text("Plant discovery", "მცენარის აღმოჩენა"),
                    imageName: plant.imageName,
                    symbol: "leaf.fill"
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var equipmentSection: some View {
        if let equipment = equipmentService.featuredEquipment(catalogue: catalogue, progress: appState.userProgress) {
            dashboardSectionTitle(text("Explorer Equipment", "მკვლევრის აღჭურვილობა"))
            NavigationLink {
                ExplorerEquipmentView(catalogue: catalogue)
            } label: {
                JournalTeaserCard(
                    title: equipment.title.displayText(for: appState.currentLanguage),
                    subtitle: equipment.description.displayText(for: appState.currentLanguage),
                    imageName: equipment.imageName,
                    symbol: "bag.fill"
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var challengeSection: some View {
        if let challenge = challengeService.activeChallenges(in: catalogue, progress: appState.userProgress).first {
            dashboardSectionTitle(text("Optional Nature Challenge", "არჩევითი ბუნების გამოწვევა"))
            ExplorerChallengeCard(
                challenge: challenge,
                progress: challengeService.progress(for: challenge, catalogue: catalogue, progress: appState.userProgress),
                ecosystemName: challenge.relatedEcosystemID.flatMap { catalogue.ecosystemsByID[$0]?.displayName(for: appState.currentLanguage) },
                language: appState.currentLanguage,
                destination: challenge.relatedEcosystemID.flatMap { ecosystemID in
                    catalogue.ecosystemsByID[ecosystemID].map { AnyView(EcosystemDetailView(ecosystem: $0, catalogue: catalogue)) }
                }
            )

            NavigationLink {
                ExplorerChallengesView(catalogue: catalogue)
            } label: {
                Text(text("See All Challenges", "ყველა გამოწვევის ნახვა"))
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }

    private func dashboardSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(AppTypography.screenTitleFont(using: accessibilitySettings))
            .foregroundStyle(AppColors.primaryText)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func destination(for discovery: DailyDiscovery) -> AnyView? {
        if let animalID = discovery.relatedAnimalID,
           let animal = catalogue.animalsByID[animalID] {
            return AnyView(AnimalDetailView(animal: animal))
        }
        if let plantID = discovery.relatedPlantID,
           let plant = catalogue.plantsByID[plantID] {
            return AnyView(PlantDetailView(plant: plant, catalogue: catalogue))
        }
        if let ecosystemID = discovery.relatedEcosystemID,
           let ecosystem = catalogue.ecosystemsByID[ecosystemID] {
            return AnyView(EcosystemDetailView(ecosystem: ecosystem, catalogue: catalogue))
        }
        return nil
    }

    private var nextTokoSituation: TokoMessageService.Situation {
        if appState.userProgress.completedMissionIDs.isEmpty {
            return .firstMission
        }
        if appState.userProgress.discoveredAnimalIDs.isEmpty && appState.userProgress.discoveredPlantIDs.isEmpty {
            return .emptyJournal
        }
        return .missionComplete
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}

private struct JournalTeaserCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let symbol: String

    var body: some View {
        AppCard {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                ExploreThumbnail(
                    imageName: imageName,
                    fallbackSystemImage: symbol,
                    accentColor: AppColors.forest,
                    accessibilityDescription: title,
                    width: 82,
                    height: 72
                )

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(title)
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(subtitle)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
    }
}


#Preview {
    NavigationStack {
        ExploreView(
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [.sample]
            )
        )
    }
    .environmentObject(AppState())
}
