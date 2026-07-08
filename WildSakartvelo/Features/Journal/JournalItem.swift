import Foundation

enum JournalItemType: String, CaseIterable, Identifiable, Hashable {
    case animal
    case plant
    case badge

    var id: String { rawValue }

    var displayTitle: String {
        displayTitle(for: .english)
    }

    func displayTitle(for language: AppLanguage) -> String {
        switch self {
        case .animal:
            return .localized("journal.item.animal", for: language)
        case .plant:
            return .localized("journal.item.plant", for: language)
        case .badge:
            return .localized("journal.item.badge", for: language)
        }
    }

    var fallbackSymbol: String {
        switch self {
        case .animal:
            return "pawprint.fill"
        case .plant:
            return "leaf.fill"
        case .badge:
            return "seal.fill"
        }
    }
}

struct JournalItem: Identifiable, Hashable {
    let sourceID: String
    let type: JournalItemType
    let title: String
    let subtitle: String
    let imageName: String?
    let fallbackSymbol: String

    var id: String {
        "\(type.rawValue):\(sourceID)"
    }

    var accessibilityLabel: String {
        "\(type.displayTitle): \(title). \(subtitle)"
    }

    func accessibilityLabel(for language: AppLanguage) -> String {
        "\(type.displayTitle(for: language)): \(title). \(subtitle)"
    }
}
