struct UserProgress: Codable, Hashable {
    var completedMissionIDs: Set<String>
    var discoveredAnimalIDs: Set<String>
    var discoveredPlantIDs: Set<String>
    var unlockedEcosystemIDs: Set<String>
    var earnedBadgeIDs: Set<String>
    var activeMissionID: String?
    var currentActivityIndexByMission: [String: Int]
    var totalAttemptsByMission: [String: Int]
    var challengeProgress: [ExplorerChallengeProgress]
    var completedObservationActivityIDs: Set<String>
    var geographyProgress: GeographyProgress

    enum CodingKeys: String, CodingKey {
        case completedMissionIDs
        case discoveredAnimalIDs
        case discoveredPlantIDs
        case unlockedEcosystemIDs
        case earnedBadgeIDs
        case activeMissionID
        case currentActivityIndexByMission
        case totalAttemptsByMission
        case challengeProgress
        case completedObservationActivityIDs
        case geographyProgress
    }

    init(
        completedMissionIDs: Set<String>,
        discoveredAnimalIDs: Set<String>,
        discoveredPlantIDs: Set<String>,
        unlockedEcosystemIDs: Set<String>,
        earnedBadgeIDs: Set<String>,
        activeMissionID: String?,
        currentActivityIndexByMission: [String: Int],
        totalAttemptsByMission: [String: Int],
        challengeProgress: [ExplorerChallengeProgress] = [],
        completedObservationActivityIDs: Set<String> = [],
        geographyProgress: GeographyProgress = .empty
    ) {
        self.completedMissionIDs = completedMissionIDs
        self.discoveredAnimalIDs = discoveredAnimalIDs
        self.discoveredPlantIDs = discoveredPlantIDs
        self.unlockedEcosystemIDs = unlockedEcosystemIDs
        self.earnedBadgeIDs = earnedBadgeIDs
        self.activeMissionID = activeMissionID
        self.currentActivityIndexByMission = currentActivityIndexByMission
        self.totalAttemptsByMission = totalAttemptsByMission
        self.challengeProgress = challengeProgress
        self.completedObservationActivityIDs = completedObservationActivityIDs
        self.geographyProgress = geographyProgress
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        completedMissionIDs = try container.decodeIfPresent(Set<String>.self, forKey: .completedMissionIDs) ?? []
        discoveredAnimalIDs = try container.decodeIfPresent(Set<String>.self, forKey: .discoveredAnimalIDs) ?? []
        discoveredPlantIDs = try container.decodeIfPresent(Set<String>.self, forKey: .discoveredPlantIDs) ?? []
        unlockedEcosystemIDs = try container.decodeIfPresent(Set<String>.self, forKey: .unlockedEcosystemIDs) ?? []
        earnedBadgeIDs = try container.decodeIfPresent(Set<String>.self, forKey: .earnedBadgeIDs) ?? []
        activeMissionID = try container.decodeIfPresent(String.self, forKey: .activeMissionID)
        currentActivityIndexByMission = try container.decodeIfPresent([String: Int].self, forKey: .currentActivityIndexByMission) ?? [:]
        totalAttemptsByMission = try container.decodeIfPresent([String: Int].self, forKey: .totalAttemptsByMission) ?? [:]
        challengeProgress = try container.decodeIfPresent([ExplorerChallengeProgress].self, forKey: .challengeProgress) ?? []
        completedObservationActivityIDs = try container.decodeIfPresent(Set<String>.self, forKey: .completedObservationActivityIDs) ?? []
        geographyProgress = try container.decodeIfPresent(GeographyProgress.self, forKey: .geographyProgress) ?? .empty
    }

    static let empty = UserProgress(
        completedMissionIDs: [],
        discoveredAnimalIDs: [],
        discoveredPlantIDs: [],
        unlockedEcosystemIDs: [],
        earnedBadgeIDs: [],
        activeMissionID: nil,
        currentActivityIndexByMission: [:],
        totalAttemptsByMission: [:],
        challengeProgress: [],
        completedObservationActivityIDs: [],
        geographyProgress: .empty
    )
}
