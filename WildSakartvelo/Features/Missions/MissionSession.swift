import Combine
import Foundation

final class MissionSession: ObservableObject {
    let mission: Mission
    let activities: [MissionActivity]

    @Published var currentActivityIndex = 0
    @Published var selectedAnswerID: String?
    @Published var selectedPairs: [String: String] = [:]
    @Published var selectedCategories: [String: String] = [:]
    @Published var orderedItemIDs: [String] = []
    @Published var habitatSelections: [String: String] = [:]
    @Published var attempts = 0
    @Published var feedbackMessage: String?
    @Published var isAnswerCorrect = false
    @Published var isMissionCompleted = false
    @Published private var currentActivityIncorrectAttempts = 0

    init(
        mission: Mission,
        catalogue: ContentCatalogue,
        startingActivityIndex: Int = 0,
        startingAttempts: Int = 0
    ) {
        self.mission = mission
        self.activities = mission.activityIDs.compactMap { activityID in
            catalogue.activitiesByID[activityID]
        }
        self.currentActivityIndex = min(max(startingActivityIndex, 0), max(activities.count - 1, 0))
        self.attempts = max(startingAttempts, 0)
        self.isMissionCompleted = activities.isEmpty
        prepareActivityState(for: currentActivity)
    }

    var currentActivity: MissionActivity? {
        guard activities.indices.contains(currentActivityIndex) else { return nil }
        return activities[currentActivityIndex]
    }

    var progressText: String {
        guard !activities.isEmpty else { return "No activities" }
        return "Activity \(currentActivityIndex + 1) of \(activities.count)"
    }

    func progressText(for language: AppLanguage) -> String {
        guard !activities.isEmpty else {
            return language == .georgian ? "აქტივობები არ არის" : "No activities"
        }

        return language == .georgian
            ? "აქტივობა \(currentActivityIndex + 1) / \(activities.count)"
            : "Activity \(currentActivityIndex + 1) of \(activities.count)"
    }

    var progressValue: Double {
        guard !activities.isEmpty else { return 1 }
        return Double(currentActivityIndex + 1) / Double(activities.count)
    }

    var canSubmit: Bool {
        guard let currentActivity, !isAnswerCorrect else { return false }

        switch currentActivity.type {
        case .multipleChoice:
            return selectedAnswerID != nil
        case .matching:
            let leftOptionIDs = Set(matchingLeftOptions(for: currentActivity).map(\.id))
            return !leftOptionIDs.isEmpty && Set(selectedPairs.keys) == leftOptionIDs && selectedPairs.count == leftOptionIDs.count
        case .classification:
            let optionIDs = Set(currentActivity.options.map(\.id))
            return !optionIDs.isEmpty && Set(selectedCategories.keys) == optionIDs && selectedCategories.count == optionIDs.count
        case .sequencing:
            guard let sequenceItems = currentActivity.sequenceItems, !sequenceItems.isEmpty else { return false }
            let itemIDs = sequenceItems.map(\.id)
            return orderedItemIDs.count == itemIDs.count && Set(orderedItemIDs) == Set(itemIDs)
        case .habitatPlacement:
            guard let habitatZones = currentActivity.habitatZones, !habitatZones.isEmpty else { return false }
            let itemIDs = Set(currentActivity.options.map(\.id))
            return !itemIDs.isEmpty
                && Set(habitatSelections.keys) == itemIDs
                && habitatSelections.count == itemIDs.count
        }
    }

    func submitAnswer() {
        guard let currentActivity, canSubmit else { return }

        attempts += 1
        isAnswerCorrect = validateAnswer(for: currentActivity)

        if isAnswerCorrect {
            feedbackMessage = currentActivity.successFeedback
            currentActivityIncorrectAttempts = 0
        } else if currentActivityIncorrectAttempts > 0 {
            currentActivityIncorrectAttempts += 1
            feedbackMessage = "\(currentActivity.failureFeedback) Hint: \(currentActivity.hint)"
        } else {
            currentActivityIncorrectAttempts += 1
            feedbackMessage = currentActivity.failureFeedback
        }
    }

    func continueToNextActivity() {
        guard isAnswerCorrect else { return }

        if currentActivityIndex >= activities.count - 1 {
            isMissionCompleted = true
            return
        }

        currentActivityIndex += 1
        resetActivityState()
        prepareActivityState(for: currentActivity)
    }

    func matchingLeftOptions(for activity: MissionActivity) -> [ActivityOption] {
        var seenPairIDs: Set<String> = []

        return activity.options.filter { option in
            guard let pairID = option.pairID else { return false }
            let isFirstOptionForPair = !seenPairIDs.contains(pairID)
            seenPairIDs.insert(pairID)
            return isFirstOptionForPair
        }
    }

    func matchingRightOptions(for activity: MissionActivity) -> [ActivityOption] {
        let leftOptionIDs = Set(matchingLeftOptions(for: activity).map(\.id))
        return activity.options.filter { option in
            option.pairID != nil && !leftOptionIDs.contains(option.id)
        }
    }

    private func validateAnswer(for activity: MissionActivity) -> Bool {
        switch activity.type {
        case .multipleChoice:
            guard let selectedAnswerID else { return false }
            return activity.correctAnswerIDs.contains(selectedAnswerID)
        case .matching:
            return validateMatchingAnswer(for: activity)
        case .classification:
            return validateClassificationAnswer(for: activity)
        case .sequencing:
            return validateSequencingAnswer(for: activity)
        case .habitatPlacement:
            return validateHabitatPlacementAnswer(for: activity)
        }
    }

    private func validateMatchingAnswer(for activity: MissionActivity) -> Bool {
        let leftOptions = matchingLeftOptions(for: activity)
        let leftOptionIDs = Set(leftOptions.map(\.id))
        guard selectedPairs.count == leftOptions.count else { return false }
        guard Set(selectedPairs.keys) == leftOptionIDs else { return false }

        let optionsByID = Dictionary(uniqueKeysWithValues: activity.options.map { ($0.id, $0) })

        return leftOptions.allSatisfy { leftOption in
            guard
                let selectedRightID = selectedPairs[leftOption.id],
                let rightOption = optionsByID[selectedRightID],
                selectedRightID != leftOption.id
            else {
                return false
            }

            return leftOption.pairID == rightOption.pairID
        }
    }

    private func validateClassificationAnswer(for activity: MissionActivity) -> Bool {
        guard selectedCategories.count == activity.options.count else { return false }

        return activity.options.allSatisfy { option in
            guard let selectedCategoryID = selectedCategories[option.id] else { return false }
            return selectedCategoryID == option.categoryID
        }
    }

    private func validateSequencingAnswer(for activity: MissionActivity) -> Bool {
        guard let sequenceItems = activity.sequenceItems, !sequenceItems.isEmpty else { return false }
        guard orderedItemIDs.count == sequenceItems.count else { return false }
        guard Set(orderedItemIDs) == Set(sequenceItems.map(\.id)) else { return false }

        let itemsByID = Dictionary(uniqueKeysWithValues: sequenceItems.map { ($0.id, $0) })

        return orderedItemIDs.enumerated().allSatisfy { index, itemID in
            guard let item = itemsByID[itemID] else { return false }
            return item.correctPosition == index + 1
        }
    }

    private func validateHabitatPlacementAnswer(for activity: MissionActivity) -> Bool {
        guard let habitatZones = activity.habitatZones, !habitatZones.isEmpty else { return false }

        let requiredItemIDs = Set(activity.options.map(\.id))
        guard habitatSelections.count == requiredItemIDs.count else { return false }
        guard Set(habitatSelections.keys) == requiredItemIDs else { return false }

        let zonesByID = Dictionary(uniqueKeysWithValues: habitatZones.map { ($0.id, $0) })

        return activity.options.allSatisfy { option in
            guard
                let selectedZoneID = habitatSelections[option.id],
                let zone = zonesByID[selectedZoneID]
            else {
                return false
            }

            return zone.acceptedItemIDs.contains(option.id)
        }
    }

    private func resetActivityState() {
        selectedAnswerID = nil
        selectedPairs = [:]
        selectedCategories = [:]
        orderedItemIDs = []
        habitatSelections = [:]
        feedbackMessage = nil
        isAnswerCorrect = false
        currentActivityIncorrectAttempts = 0
    }

    private func prepareActivityState(for activity: MissionActivity?) {
        guard let activity else { return }

        switch activity.type {
        case .sequencing:
            orderedItemIDs = activity.sequenceItems?.map(\.id) ?? []
        case .habitatPlacement:
            habitatSelections = [:]
        case .multipleChoice, .matching, .classification:
            break
        }
    }
}
