struct ContentCatalogue: Hashable {
    let ecosystems: [Ecosystem]
    let animals: [Animal]
    let plants: [Plant]
    let missions: [Mission]
    let activities: [MissionActivity]
    let contentPacks: [ContentPack]
    let dailyDiscoveries: [DailyDiscovery]
    let explorerChallenges: [ExplorerChallenge]
    let observationActivities: [ObservationActivity]
    let ecosystemsByID: [String: Ecosystem]
    let animalsByID: [String: Animal]
    let plantsByID: [String: Plant]
    let missionsByID: [String: Mission]
    let activitiesByID: [String: MissionActivity]
    let dailyDiscoveriesByID: [String: DailyDiscovery]
    let explorerChallengesByID: [String: ExplorerChallenge]
    let observationActivitiesByID: [String: ObservationActivity]

    init(
        ecosystems: [Ecosystem],
        animals: [Animal],
        plants: [Plant],
        missions: [Mission],
        activities: [MissionActivity],
        contentPacks: [ContentPack] = [],
        dailyDiscoveries: [DailyDiscovery] = [],
        explorerChallenges: [ExplorerChallenge] = [],
        observationActivities: [ObservationActivity] = []
    ) throws {
        self.ecosystems = ecosystems
        self.animals = animals
        self.plants = plants
        self.missions = missions
        self.activities = activities
        self.contentPacks = contentPacks
        self.dailyDiscoveries = dailyDiscoveries
        self.explorerChallenges = explorerChallenges
        self.observationActivities = observationActivities
        self.ecosystemsByID = Dictionary(ecosystems.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.animalsByID = Dictionary(animals.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.plantsByID = Dictionary(plants.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.missionsByID = Dictionary(missions.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.activitiesByID = Dictionary(activities.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.dailyDiscoveriesByID = Dictionary(dailyDiscoveries.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.explorerChallengesByID = Dictionary(explorerChallenges.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        self.observationActivitiesByID = Dictionary(observationActivities.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })

        try validate()
    }

    init(provider: ContentProviding) throws {
        try self.init(
            ecosystems: provider.loadEcosystems(),
            animals: provider.loadAnimals(),
            plants: provider.loadPlants(),
            missions: provider.loadMissions(),
            activities: provider.loadActivities(),
            contentPacks: provider.loadContentPacks(),
            dailyDiscoveries: provider.loadDailyDiscoveries(),
            explorerChallenges: provider.loadExplorerChallenges(),
            observationActivities: provider.loadObservationActivities()
        )
    }

    static func load(using provider: ContentProviding = ContentService()) throws -> ContentCatalogue {
        try ContentCatalogue(provider: provider)
    }

    private func validate() throws {
        let ecosystemIDs = try uniqueIDs(ecosystems, named: "ecosystem")
        let animalIDs = try uniqueIDs(animals, named: "animal")
        let plantIDs = try uniqueIDs(plants, named: "plant")
        let missionIDs = try uniqueIDs(missions, named: "mission")
        let activityIDs = try uniqueIDs(activities, named: "activity")
        _ = try uniqueIDs(contentPacks, named: "content pack")
        _ = try uniqueIDs(dailyDiscoveries, named: "daily discovery")
        _ = try uniqueIDs(explorerChallenges, named: "explorer challenge")
        _ = try uniqueIDs(observationActivities, named: "observation activity")

        for ecosystem in ecosystems {
            try requireAll(
                ecosystem.animalIDs,
                in: animalIDs,
                message: "ecosystem \(ecosystem.id) references missing animal"
            )
            try requireAll(
                ecosystem.plantIDs,
                in: plantIDs,
                message: "ecosystem \(ecosystem.id) references missing plant"
            )
            try requireAll(
                ecosystem.missionIDs,
                in: missionIDs,
                message: "ecosystem \(ecosystem.id) references missing mission"
            )
        }

        for mission in missions {
            guard ecosystemIDs.contains(mission.ecosystemID) else {
                throw ContentError.missingReference(
                    "mission \(mission.id) references missing ecosystem \(mission.ecosystemID)"
                )
            }

            try requireAll(
                mission.activityIDs,
                in: activityIDs,
                message: "mission \(mission.id) references missing activity"
            )
        }

        for pack in contentPacks where !ecosystemIDs.contains(pack.ecosystemID) {
            throw ContentError.missingReference(
                "content pack \(pack.id) references missing ecosystem \(pack.ecosystemID)"
            )
        }

        for discovery in dailyDiscoveries {
            try requireOptional(discovery.relatedAnimalID, in: animalIDs, message: "daily discovery \(discovery.id) references missing animal")
            try requireOptional(discovery.relatedPlantID, in: plantIDs, message: "daily discovery \(discovery.id) references missing plant")
            try requireOptional(discovery.relatedEcosystemID, in: ecosystemIDs, message: "daily discovery \(discovery.id) references missing ecosystem")
        }

        for challenge in explorerChallenges {
            if let ecosystemID = challenge.relatedEcosystemID, !ecosystemIDs.contains(ecosystemID) {
                throw ContentError.missingReference(
                    "explorer challenge \(challenge.id) references missing ecosystem \(ecosystemID)"
                )
            }
        }

        for observation in observationActivities {
            if let ecosystemID = observation.ecosystemID, !ecosystemIDs.contains(ecosystemID) {
                throw ContentError.missingReference(
                    "observation activity \(observation.id) references missing ecosystem \(ecosystemID)"
                )
            }
        }
    }

    private func uniqueIDs<T: Identifiable>(_ items: [T], named contentType: String) throws -> Set<String>
    where T.ID == String {
        var ids = Set<String>()

        for item in items {
            guard ids.insert(item.id).inserted else {
                throw ContentError.duplicateIdentifier("\(contentType) \(item.id)")
            }
        }

        return ids
    }

    private func requireAll(_ references: [String], in validIDs: Set<String>, message: String) throws {
        for reference in references where !validIDs.contains(reference) {
            throw ContentError.missingReference("\(message) \(reference)")
        }
    }

    private func requireOptional(_ reference: String?, in validIDs: Set<String>, message: String) throws {
        guard let reference, !validIDs.contains(reference) else { return }
        throw ContentError.missingReference("\(message) \(reference)")
    }
}
