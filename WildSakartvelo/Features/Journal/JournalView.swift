import SwiftUI

struct JournalView: View {
    let catalogue: ContentCatalogue

    @EnvironmentObject var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @StateObject private var viewModel: JournalViewModel

    init(catalogue: ContentCatalogue) {
        self.catalogue = catalogue
        _viewModel = StateObject(
            wrappedValue: JournalViewModel(catalogue: catalogue, progress: .empty, language: .english)
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                header
                filterControl

                if viewModel.filteredJournalItems.isEmpty {
                    emptyState
                } else {
                    JournalGridView(items: viewModel.filteredJournalItems)
                }

                lockedProgressSection
                observationsSection
            }
            .padding(AppSpacing.medium)
            .padding(.bottom, AppSpacing.large)
        }
        .background(AppColors.background)
        .navigationTitle(String.localized("tab.journal", for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: JournalItem.self) { item in
            destination(for: item)
        }
        .onAppear {
            viewModel.update(progress: appState.userProgress, language: appState.currentLanguage)
        }
        .onChange(of: appState.userProgress) { _, progress in
            viewModel.update(progress: progress, language: appState.currentLanguage)
        }
        .onChange(of: appState.currentLanguage) { _, language in
            viewModel.update(progress: appState.userProgress, language: language)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                Text(String.localized("journal.description", for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    discoveryStats
                    progressBar
                }
            }
        }
    }

    private var discoveryStats: some View {
        HStack(spacing: AppSpacing.small) {
            summaryStat(
                title: .localized("journal.item.animal", for: appState.currentLanguage),
                value: "\(viewModel.discoveredAnimalCount)/\(viewModel.totalDiscoverableAnimals)",
                symbol: "pawprint.fill",
                color: AppColors.mountain
            )

            summaryStat(
                title: .localized("journal.item.plant", for: appState.currentLanguage),
                value: "\(viewModel.discoveredPlantCount)/\(viewModel.totalDiscoverablePlants)",
                symbol: "leaf.fill",
                color: AppColors.forest
            )

            summaryStat(
                title: .localized("journal.item.badge", for: appState.currentLanguage),
                value: "\(viewModel.earnedBadges.count)",
                symbol: "seal.fill",
                color: AppColors.water
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            String.localizedFormat(
                "journal.summary.accessibility",
                for: appState.currentLanguage,
                viewModel.discoveredAnimalCount,
                viewModel.totalDiscoverableAnimals,
                viewModel.discoveredPlantCount,
                viewModel.totalDiscoverablePlants,
                viewModel.earnedBadges.count
            )
        )
    }

    private func summaryStat(title: String, value: String, symbol: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(color)
                .accessibilityHidden(true)

            Text(value)
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(AppColors.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(title)
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .padding(AppSpacing.small)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: AppSpacing.small))
    }

    private var progressBar: some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            ProgressView(value: viewModel.overallProgress)
                .tint(AppColors.forest)

            Text(String.localizedFormat("journal.progress", for: appState.currentLanguage, Int(viewModel.overallProgress * 100)))
                .font(AppTypography.captionFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
        }
    }

    private var filterControl: some View {
        JournalFilterView(selectedFilter: $viewModel.selectedFilter)
    }

    private var emptyState: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: "empty_journal",
                    fallbackSystemImage: "book.closed.fill",
                    mode: .avatar,
                    height: 58,
                    accentColor: AppColors.forest,
                    accessibilityDescription: emptyTitle
                )
                .frame(width: 64, height: 58)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(emptyTitle)
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(emptyDescription)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .accessibilityLabel(emptyTitle)
    }

    private var emptyTitle: String {
        switch viewModel.selectedFilter {
        case .all:
            return .localized("journal.empty.all", for: appState.currentLanguage)
        case .animals:
            return .localized("journal.empty.animals", for: appState.currentLanguage)
        case .plants:
            return .localized("journal.empty.plants", for: appState.currentLanguage)
        case .badges:
            return .localized("journal.empty.badges", for: appState.currentLanguage)
        }
    }

    private var emptyDescription: String {
        switch viewModel.selectedFilter {
        case .all:
            return .localized("journal.empty.all.description", for: appState.currentLanguage)
        case .animals:
            return .localized("journal.empty.animals.description", for: appState.currentLanguage)
        case .plants:
            return .localized("journal.empty.plants.description", for: appState.currentLanguage)
        case .badges:
            return .localized("journal.empty.badges.description", for: appState.currentLanguage)
        }
    }

    private var lockedProgressSection: some View {
        let remaining = viewModel.remainingAnimalCount + viewModel.remainingPlantCount

        return Group {
            if remaining > 0 {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(String.localizedFormat("journal.remaining.title", for: appState.currentLanguage, remaining))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    VStack(spacing: AppSpacing.small) {
                        if viewModel.remainingAnimalCount > 0 {
                            lockedRow(
                                title: .localized("journal.remaining.animals", for: appState.currentLanguage),
                                subtitle: .localizedFormat("journal.remaining.animals.subtitle", for: appState.currentLanguage, viewModel.remainingAnimalCount),
                                symbol: "pawprint.fill"
                            )
                        }

                        if viewModel.remainingPlantCount > 0 {
                            lockedRow(
                                title: .localized("journal.remaining.plants", for: appState.currentLanguage),
                                subtitle: .localizedFormat("journal.remaining.plants.subtitle", for: appState.currentLanguage, viewModel.remainingPlantCount),
                                symbol: "leaf.fill"
                            )
                        }
                    }
                }
            }
        }
    }

    private var observationsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(appState.currentLanguage == .georgian ? "დაკვირვებები" : "Observations")
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            if catalogue.observationActivities.isEmpty {
                AppCard {
                    Text(appState.currentLanguage == .georgian ? "დაკვირვებები ჯერ არ არის." : "No observations yet.")
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                }
            } else {
                VStack(spacing: AppSpacing.small) {
                    ForEach(catalogue.observationActivities.prefix(4)) { activity in
                        NavigationLink {
                            ObservationActivityView(activity: activity, catalogue: catalogue)
                        } label: {
                            observationRow(activity)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func observationRow(_ activity: ObservationActivity) -> some View {
        let completed = appState.userProgress.completedObservationActivityIDs.contains(activity.id)

        return AppCard(variant: completed ? .success : .standard) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                Image(systemName: completed ? "checkmark.seal.fill" : "eye.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(completed ? AppColors.success : AppColors.forest)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(activity.title.displayText(for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    Text(activity.safetyMessage.displayText(for: appState.currentLanguage))
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(2)
                }
            }
        }
    }

    private func lockedRow(title: String, subtitle: String, symbol: String) -> some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                Image(systemName: symbol)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColors.secondaryText)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(title)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    Text(subtitle)
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(title). \(subtitle)")
        }
    }

    @ViewBuilder
    private func destination(for item: JournalItem) -> some View {
        switch item.type {
        case .animal:
            if let animal = catalogue.animalsByID[item.sourceID] {
                AnimalDetailView(animal: animal)
            } else {
                Text(String.localized("common.itemUnavailable", for: appState.currentLanguage))
            }
        case .plant:
            if let plant = catalogue.plantsByID[item.sourceID] {
                PlantDetailView(plant: plant, catalogue: catalogue)
            } else {
                Text(String.localized("common.itemUnavailable", for: appState.currentLanguage))
            }
        case .badge:
            BadgeDetailView(badge: item)
        }
    }
}

#Preview("Empty Journal") {
    NavigationStack {
        JournalView(
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

#Preview("Partially Completed") {
    NavigationStack {
        JournalView(
            catalogue: try! ContentCatalogue(
                ecosystems: [.sample],
                animals: [.sample],
                plants: [.sample],
                missions: [.sample],
                activities: [.sample]
            )
        )
        .environmentObject({
            let state = AppState()
            state.userProgress = UserProgress(
                completedMissionIDs: ["mountain-habitat-discovery"],
                discoveredAnimalIDs: ["caucasian-tur"],
                discoveredPlantIDs: [],
                unlockedEcosystemIDs: [],
                earnedBadgeIDs: ["first-mission"],
                activeMissionID: nil,
                currentActivityIndexByMission: [:],
                totalAttemptsByMission: [:]
            )
            return state
        }())
    }
}
