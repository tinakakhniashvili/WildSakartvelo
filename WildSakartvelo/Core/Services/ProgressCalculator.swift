struct ProgressCalculator {
    func ecosystemCompletion(ecosystem: Ecosystem, progress: UserProgress) -> Double {
        let missionTotal = ecosystem.missionIDs.count
        guard missionTotal > 0 else { return 0 }
        let completed = ecosystem.missionIDs.filter { progress.completedMissionIDs.contains($0) }.count
        return Double(completed) / Double(missionTotal)
    }

    func overallMissionCompletion(catalogue: ContentCatalogue, progress: UserProgress) -> Double {
        guard !catalogue.missions.isEmpty else { return 0 }
        return Double(progress.completedMissionIDs.count) / Double(catalogue.missions.count)
    }

    func journalDiscoveryPercentage(catalogue: ContentCatalogue, progress: UserProgress) -> Double {
        let total = catalogue.animals.count + catalogue.plants.count
        guard total > 0 else { return 0 }
        return Double(progress.discoveredAnimalIDs.count + progress.discoveredPlantIDs.count) / Double(total)
    }

    func geographyCompletion(catalogue: ContentCatalogue, progress: UserProgress) -> Double {
        let total = catalogue.regions.count + catalogue.geographyLandmarks.count + catalogue.geographyMissions.count
        guard total > 0 else { return 0 }
        let completed = progress.geographyProgress.discoveredRegionIDs.count
            + progress.geographyProgress.discoveredLandmarkIDs.count
            + progress.geographyProgress.completedGeographyMissionIDs.count
        return Double(completed) / Double(total)
    }

    func completedActivityCount(catalogue: ContentCatalogue, progress: UserProgress) -> Int {
        catalogue.missions.reduce(0) { count, mission in
            guard progress.completedMissionIDs.contains(mission.id) else { return count }
            return count + mission.activityIDs.count
        }
    }

    func challengeValue(for challenge: ExplorerChallenge, catalogue: ContentCatalogue, progress: UserProgress) -> Int {
        switch challenge.type {
        case .completeMissions:
            if let ecosystemID = challenge.relatedEcosystemID {
                let missionIDs = catalogue.ecosystemsByID[ecosystemID]?.missionIDs ?? []
                return missionIDs.filter { progress.completedMissionIDs.contains($0) }.count
            }
            return progress.completedMissionIDs.count
        case .discoverAnimals:
            if let ecosystemID = challenge.relatedEcosystemID {
                let animalIDs = Set(catalogue.ecosystemsByID[ecosystemID]?.animalIDs ?? [])
                return progress.discoveredAnimalIDs.intersection(animalIDs).count
            }
            return progress.discoveredAnimalIDs.count
        case .discoverPlants:
            if let ecosystemID = challenge.relatedEcosystemID {
                let plantIDs = Set(catalogue.ecosystemsByID[ecosystemID]?.plantIDs ?? [])
                return progress.discoveredPlantIDs.intersection(plantIDs).count
            }
            return progress.discoveredPlantIDs.count
        case .exploreEcosystem:
            guard let ecosystemID = challenge.relatedEcosystemID,
                  let ecosystem = catalogue.ecosystemsByID[ecosystemID] else {
                return 0
            }
            return ecosystemCompletion(ecosystem: ecosystem, progress: progress) >= 1 ? challenge.targetValue : 0
        case .completeObservation:
            return progress.completedObservationActivityIDs.count
        case .retryMission:
            return progress.totalAttemptsByMission.values.filter { $0 > 1 }.count
        case .listenToNarration:
            return min(progress.completedMissionIDs.count, challenge.targetValue)
        }
    }

    func equipmentProgress(for requirement: EquipmentUnlockRequirement, catalogue: ContentCatalogue, progress: UserProgress) -> (current: Int, target: Int) {
        switch requirement {
        case .completedMissionCount(let target):
            return (progress.completedMissionIDs.count, target)
        case .discoveredAnimalCount(let target):
            return (progress.discoveredAnimalIDs.count, target)
        case .discoveredPlantCount(let target):
            return (progress.discoveredPlantIDs.count, target)
        case .completedEcosystem(let ecosystemID):
            guard let ecosystem = catalogue.ecosystemsByID[ecosystemID] else { return (0, 1) }
            return (ecosystemCompletion(ecosystem: ecosystem, progress: progress) >= 1 ? 1 : 0, 1)
        case .earnedBadge(let badgeID):
            return (progress.earnedBadgeIDs.contains(badgeID) ? 1 : 0, 1)
        }
    }
}
