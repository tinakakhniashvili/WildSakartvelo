import SwiftUI

struct ExploreView: View {
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    private let unlockService = UnlockService()
    private let progressCalculator = ProgressCalculator()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                welcomeContent
                continueExploringSection
                ecosystemContent
                geographySection
                recentJournalSection
                overallProgressSection
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

    private var welcomeContent: some View {
        AppCard(variant: .elevated) {
            HStack(alignment: .center, spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: appState.selectedProfile?.avatarID ?? "app_logo",
                    fallbackAssetName: "app_logo",
                    fallbackSystemImage: "person.crop.circle.fill",
                    mode: .avatar,
                    height: 82,
                    accentColor: AppColors.forest,
                    accessibilityDescription: greetingTitle
                )
                .frame(width: 86, height: 82)

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(greetingTitle)
                        .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    if let profile = appState.selectedProfile {
                        Label(profile.learningLevel.displayTitle(for: appState.currentLanguage), systemImage: "star.circle.fill")
                            .font(AppTypography.bodyFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.forest)
                    }

                    Text(text("Choose an ecosystem or continue your current mission.", "აირჩიე ეკოსისტემა ან გააგრძელე მიმდინარე მისია."))
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var geographySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            dashboardSectionTitle(text("Explore Georgia", "აღმოაჩინე საქართველო"))

            NavigationLink {
                GeographyHomeView(catalogue: catalogue)
            } label: {
                AppCard(variant: .elevated) {
                    HStack(alignment: .center, spacing: AppSpacing.medium) {
                        GeorgiaMapThumbnailView(regions: catalogue.regions)
                            .frame(width: 96, height: 78)
                            .accessibilityLabel(text("Map of Georgia", "საქართველოს რუკა"))

                        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                            Text(text("Geography Map", "გეოგრაფიის რუკა"))
                                .font(AppTypography.cardTitle)
                                .foregroundStyle(AppColors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)

                            Text(text("Regions, cities, mountains, rivers and the Black Sea.", "რეგიონები, ქალაქები, მთები, მდინარეები და შავი ზღვა."))
                                .font(AppTypography.body)
                                .foregroundStyle(AppColors.secondaryText)
                                .lineLimit(3)
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
                KidSectionHeader(
                    title: String.localized("explore.chooseEcosystem", for: appState.currentLanguage),
                    symbol: "map.fill",
                    color: AppColors.forest
                )

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

    private var overallProgressSection: some View {
        let missionProgress = progressCalculator.overallMissionCompletion(catalogue: catalogue, progress: appState.userProgress)
        let journalProgress = progressCalculator.journalDiscoveryPercentage(catalogue: catalogue, progress: appState.userProgress)

        return VStack(alignment: .leading, spacing: AppSpacing.medium) {
            dashboardSectionTitle(text("Overall Progress", "საერთო პროგრესი"))

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    compactProgressRow(
                        title: text("Missions", "მისიები"),
                        value: missionProgress,
                        completed: appState.userProgress.completedMissionIDs.count,
                        total: catalogue.missions.count,
                        color: AppColors.forest
                    )

                    compactProgressRow(
                        title: text("Journal", "დღიური"),
                        value: journalProgress,
                        completed: appState.userProgress.discoveredAnimalIDs.count + appState.userProgress.discoveredPlantIDs.count,
                        total: catalogue.animals.count + catalogue.plants.count,
                        color: AppColors.water
                    )
                }
            }
        }
    }

    private func dashboardSectionTitle(_ title: String) -> some View {
        KidSectionHeader(title: title, symbol: "sparkle.magnifyingglass", color: AppColors.water)
    }

    private var greetingTitle: String {
        let fallback = text("Explorer", "მკვლევარო")
        let nickname = appState.selectedProfile?.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = nickname?.isEmpty == false ? nickname! : fallback
        return text("Hi, \(displayName)", "გამარჯობა, \(displayName)")
    }

    private func compactProgressRow(title: String, value: Double, completed: Int, total: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            HStack {
                Text(title)
                    .font(AppTypography.bodyFont(using: accessibilitySettings).weight(.semibold))
                    .foregroundStyle(AppColors.primaryText)

                Spacer()

                Text("\(completed)/\(max(total, 0))")
                    .font(AppTypography.captionFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
            }

            ProgressView(value: min(max(value, 0), 1))
                .tint(color)
        }
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
