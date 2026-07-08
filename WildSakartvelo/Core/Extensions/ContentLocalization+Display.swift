import Foundation

extension Ecosystem {
    func displayName(for language: AppLanguage) -> String {
        localizedName.displayText(for: language, fallback: name)
    }

    func displaySubtitle(for language: AppLanguage) -> String {
        localizedSubtitle.displayText(for: language, fallback: subtitle)
    }

    func displayDescription(for language: AppLanguage) -> String {
        localizedDescription.displayText(for: language, fallback: description)
    }
}

extension Mission {
    func displayTitle(for language: AppLanguage) -> String {
        localizedTitle.displayText(for: language, fallback: title)
    }

    func displaySubtitle(for language: AppLanguage) -> String {
        localizedSubtitle.displayText(for: language, fallback: subtitle)
    }

    func displayIntroduction(for language: AppLanguage) -> String {
        localizedIntroduction.displayText(for: language, fallback: introduction)
    }
}

extension MissionReward {
    func displayTitle(for language: AppLanguage) -> String {
        localizedTitle.displayText(for: language, fallback: title)
    }
}

extension MissionActivity {
    func displayInstruction(for language: AppLanguage) -> String {
        localizedInstruction.displayText(for: language, fallback: instruction)
    }

    func displayQuestion(for language: AppLanguage) -> String {
        localizedQuestion.displayText(for: language, fallback: question)
    }

    func displayHint(for language: AppLanguage) -> String {
        localizedHint.displayText(for: language, fallback: hint)
    }

    func displaySuccessFeedback(for language: AppLanguage) -> String {
        localizedSuccessFeedback.displayText(for: language, fallback: successFeedback)
    }

    func displayFailureFeedback(for language: AppLanguage) -> String {
        localizedFailureFeedback.displayText(for: language, fallback: failureFeedback)
    }
}

extension OnboardingPage {
    func displayTitle(for language: AppLanguage) -> String {
        localizedTitle.displayText(for: language, fallback: title)
    }

    func displayDescription(for language: AppLanguage) -> String {
        localizedDescription.displayText(for: language, fallback: description)
    }
}

extension Animal {
    func displayName(for language: AppLanguage) -> String {
        switch language {
        case .english:
            return englishName.isEmpty ? georgianName : englishName
        case .georgian:
            return georgianName.isEmpty ? englishName : georgianName
        }
    }

    func displaySummary(for language: AppLanguage) -> String {
        localizedSummary.displayText(for: language, fallback: summary)
    }

    func displayHabitat(for language: AppLanguage) -> String {
        localizedHabitat.displayText(for: language, fallback: habitat)
    }

    func displayDiet(for language: AppLanguage) -> String {
        localizedDiet.displayText(for: language, fallback: diet)
    }

    func displaySizeDescription(for language: AppLanguage) -> String {
        localizedSizeDescription.displayText(for: language, fallback: sizeDescription)
    }

    func displaySurprisingFact(for language: AppLanguage) -> String {
        localizedSurprisingFact.displayText(for: language, fallback: surprisingFact)
    }
}

extension Plant {
    func displayName(for language: AppLanguage) -> String {
        switch language {
        case .english:
            return englishName.isEmpty ? georgianName : englishName
        case .georgian:
            return georgianName.isEmpty ? englishName : georgianName
        }
    }

    func displayDescription(for language: AppLanguage) -> String {
        localizedDescription.displayText(for: language, fallback: description)
    }

    func displaySurprisingFact(for language: AppLanguage) -> String {
        localizedSurprisingFact.displayText(for: language, fallback: surprisingFact)
    }
}

extension ActivityOption {
    func displayText(for language: AppLanguage) -> String {
        localizedText.displayText(for: language, fallback: text)
    }
}

extension ActivityCategory {
    func displayTitle(for language: AppLanguage) -> String {
        localizedTitle.displayText(for: language, fallback: title)
    }
}

extension SequenceItem {
    func displayText(for language: AppLanguage) -> String {
        localizedText.displayText(for: language, fallback: text)
    }
}

extension HabitatZone {
    func displayTitle(for language: AppLanguage) -> String {
        localizedTitle.displayText(for: language, fallback: title)
    }
}
