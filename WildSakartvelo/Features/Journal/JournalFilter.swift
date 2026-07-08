import Foundation

enum JournalFilter: String, CaseIterable, Identifiable, Hashable {
    case all
    case animals
    case plants
    case badges

    var id: String { rawValue }

    var displayTitle: String {
        displayTitle(for: .english)
    }

    func displayTitle(for language: AppLanguage) -> String {
        switch self {
        case .all:
            return .localized("journal.filter.all", for: language)
        case .animals:
            return .localized("journal.filter.animals", for: language)
        case .plants:
            return .localized("journal.filter.plants", for: language)
        case .badges:
            return .localized("journal.filter.badges", for: language)
        }
    }

    var symbolName: String {
        switch self {
        case .all:
            return "books.vertical.fill"
        case .animals:
            return "pawprint.fill"
        case .plants:
            return "leaf.fill"
        case .badges:
            return "seal.fill"
        }
    }
}
