enum EcosystemTheme: String, Codable, Hashable {
    case forest
    case mountain
    case wetland
    case coast
}

enum ConservationStatus: String, Codable, Hashable {
    case common
    case protected
    case endangered
    case unknown
}

enum DifficultyLevel: String, Codable, Hashable {
    case beginner
    case intermediate
    case advanced
}

enum ActivityType: String, Codable, Hashable {
    case multipleChoice
    case matching
    case classification
    case sequencing
    case habitatPlacement
}

enum RewardType: String, Codable, Hashable {
    case animalCard
    case plantCard
    case badge
    case journalPage
    case ecosystemUnlock
}

enum AppLanguage: String, Codable, Hashable, CaseIterable {
    case english
    case georgian

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .georgian:
            return "ქართული"
        }
    }

    var localeIdentifier: String {
        switch self {
        case .english:
            return "en"
        case .georgian:
            return "ka"
        }
    }
}

enum MissionStatus: String, Codable, Hashable {
    case locked
    case available
    case inProgress
    case completed
}

enum LearningLevel: String, Codable, Hashable, CaseIterable {
    case explorerOne
    case explorerTwo
    case explorerThree

    var displayTitle: String {
        displayTitle(for: .english)
    }

    func displayTitle(for language: AppLanguage) -> String {
        switch self {
        case .explorerOne:
            return String.localized("learningLevel.explorerOne", for: language)
        case .explorerTwo:
            return String.localized("learningLevel.explorerTwo", for: language)
        case .explorerThree:
            return String.localized("learningLevel.explorerThree", for: language)
        }
    }

    var shortDescription: String {
        shortDescription(for: .english)
    }

    func shortDescription(for language: AppLanguage) -> String {
        switch self {
        case .explorerOne:
            return String.localized("learningLevel.explorerOne.description", for: language)
        case .explorerTwo:
            return String.localized("learningLevel.explorerTwo.description", for: language)
        case .explorerThree:
            return String.localized("learningLevel.explorerThree.description", for: language)
        }
    }
}
