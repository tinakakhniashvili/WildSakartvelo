extension DifficultyLevel {
    var displayTitle: String {
        displayTitle(for: .english)
    }

    func displayTitle(for language: AppLanguage) -> String {
        switch self {
        case .beginner:
            return String.localized("difficulty.beginner", for: language)
        case .intermediate:
            return String.localized("difficulty.intermediate", for: language)
        case .advanced:
            return String.localized("difficulty.advanced", for: language)
        }
    }

    var systemImage: String {
        switch self {
        case .beginner:
            return "1.circle.fill"
        case .intermediate:
            return "2.circle.fill"
        case .advanced:
            return "3.circle.fill"
        }
    }
}
