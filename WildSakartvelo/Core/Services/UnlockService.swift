struct UnlockService {
    func isEcosystemUnlocked(_ ecosystem: Ecosystem, progress: UserProgress) -> Bool {
        ecosystem.isInitiallyUnlocked || progress.unlockedEcosystemIDs.contains(ecosystem.id)
    }

    func isMissionUnlocked(_ mission: Mission, catalogue: ContentCatalogue, progress: UserProgress) -> Bool {
        guard let ecosystem = catalogue.ecosystemsByID[mission.ecosystemID],
              isEcosystemUnlocked(ecosystem, progress: progress) else {
            return false
        }

        return mission.prerequisiteMissionIDs.allSatisfy { progress.completedMissionIDs.contains($0) }
    }

    func missionLockReason(
        _ mission: Mission,
        catalogue: ContentCatalogue,
        progress: UserProgress,
        language: AppLanguage
    ) -> String? {
        guard let ecosystem = catalogue.ecosystemsByID[mission.ecosystemID] else {
            return .localized("mission.locked.unavailableEcosystem", for: language)
        }

        if !isEcosystemUnlocked(ecosystem, progress: progress) {
            return .localizedFormat(
                "mission.locked.unlockEcosystem",
                for: language,
                ecosystem.displayName(for: language)
            )
        }

        let missingPrerequisites = mission.prerequisiteMissionIDs.filter {
            !progress.completedMissionIDs.contains($0)
        }

        guard let firstMissingID = missingPrerequisites.first else {
            return nil
        }

        if let prerequisite = catalogue.missionsByID[firstMissingID] {
            return .localizedFormat(
                "mission.locked.completeMission",
                for: language,
                prerequisite.displayTitle(for: language)
            )
        }

        return .localized("mission.locked.completeRequired", for: language)
    }
}
