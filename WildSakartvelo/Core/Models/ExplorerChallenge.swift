struct ExplorerChallenge: Identifiable, Codable, Hashable {
    let id: String
    let title: LocalizedContentText
    let description: LocalizedContentText
    let type: ExplorerChallengeType
    let rewardBadgeID: String?
    let targetValue: Int
    let relatedEcosystemID: String?
    let safetyMessage: LocalizedContentText?
}

enum ExplorerChallengeType: String, Codable, Hashable {
    case completeMissions
    case discoverAnimals
    case discoverPlants
    case exploreEcosystem
    case completeObservation
    case retryMission
    case listenToNarration
}

struct ExplorerChallengeProgress: Codable, Hashable {
    let challengeID: String
    var currentValue: Int
    var isCompleted: Bool
    var rewardClaimed: Bool
}
