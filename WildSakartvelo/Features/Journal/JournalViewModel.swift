import Foundation

final class JournalViewModel: ObservableObject {
    @Published var selectedFilter: JournalFilter = .all

    private let catalogue: ContentCatalogue
    private var progress: UserProgress
    private var language: AppLanguage

    init(catalogue: ContentCatalogue, progress: UserProgress, language: AppLanguage) {
        self.catalogue = catalogue
        self.progress = progress
        self.language = language
    }

    var discoveredAnimals: [Animal] {
        catalogue.animals.filter { progress.discoveredAnimalIDs.contains($0.id) }
    }

    var discoveredPlants: [Plant] {
        catalogue.plants.filter { progress.discoveredPlantIDs.contains($0.id) }
    }

    var earnedBadges: [JournalItem] {
        progress.earnedBadgeIDs
            .sorted()
            .map { badgeID in
                JournalItem(
                    sourceID: badgeID,
                    type: .badge,
                    title: badgeTitle(for: badgeID),
                    subtitle: .localized("journal.badge.subtitle", for: language),
                    imageName: nil,
                    fallbackSymbol: JournalItemType.badge.fallbackSymbol
                )
            }
    }

    var totalDiscoverableAnimals: Int {
        catalogue.animals.count
    }

    var totalDiscoverablePlants: Int {
        catalogue.plants.count
    }

    var discoveredAnimalCount: Int {
        discoveredAnimals.count
    }

    var discoveredPlantCount: Int {
        discoveredPlants.count
    }

    var remainingAnimalCount: Int {
        max(totalDiscoverableAnimals - discoveredAnimalCount, 0)
    }

    var remainingPlantCount: Int {
        max(totalDiscoverablePlants - discoveredPlantCount, 0)
    }

    var overallProgress: Double {
        let total = totalDiscoverableAnimals + totalDiscoverablePlants
        guard total > 0 else { return 1 }
        return Double(discoveredAnimalCount + discoveredPlantCount) / Double(total)
    }

    var allItems: [JournalItem] {
        discoveredAnimals.map(journalItem(for:)) +
        discoveredPlants.map(journalItem(for:)) +
        earnedBadges
    }

    var filteredJournalItems: [JournalItem] {
        let items = allItems

        switch selectedFilter {
        case .all:
            return items
        case .animals:
            return items.filter { $0.type == .animal }
        case .plants:
            return items.filter { $0.type == .plant }
        case .badges:
            return items.filter { $0.type == .badge }
        }
    }

    func update(progress: UserProgress, language: AppLanguage) {
        guard self.progress != progress || self.language != language else { return }
        self.progress = progress
        self.language = language
        objectWillChange.send()
    }

    private func journalItem(for animal: Animal) -> JournalItem {
        JournalItem(
            sourceID: animal.id,
            type: .animal,
            title: animal.displayName(for: language),
            subtitle: animal.displaySummary(for: language),
            imageName: animal.imageName,
            fallbackSymbol: JournalItemType.animal.fallbackSymbol
        )
    }

    private func journalItem(for plant: Plant) -> JournalItem {
        JournalItem(
            sourceID: plant.id,
            type: .plant,
            title: plant.displayName(for: language),
            subtitle: plant.displayDescription(for: language),
            imageName: plant.imageName,
            fallbackSymbol: JournalItemType.plant.fallbackSymbol
        )
    }

    private func badgeTitle(for badgeID: String) -> String {
        switch badgeID {
        case "first-mission":
            return .localized("badge.title.firstMission", for: language)
        default:
            return .localized("journal.item.badge", for: language)
        }
    }
}
