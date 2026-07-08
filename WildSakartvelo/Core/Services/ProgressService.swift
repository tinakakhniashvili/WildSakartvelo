import Foundation

final class ProgressService {
    private let store: ProgressStoring

    init(store: ProgressStoring = UserDefaultsProgressStore()) {
        self.store = store
    }

    func loadProgress(for profileID: UUID) throws -> UserProgress {
        try store.loadProgress(for: profileID)
    }

    func startMission(_ mission: Mission, for profileID: UUID) throws -> UserProgress {
        var progress = try store.loadProgress(for: profileID)
        progress.activeMissionID = mission.id
        if progress.currentActivityIndexByMission[mission.id] == nil {
            progress.currentActivityIndexByMission[mission.id] = 0
        }
        if progress.totalAttemptsByMission[mission.id] == nil {
            progress.totalAttemptsByMission[mission.id] = 0
        }
        try store.saveProgress(progress, for: profileID)
        return progress
    }

    func updateMission(_ mission: Mission, activityIndex: Int, attempts: Int, for profileID: UUID) throws -> UserProgress {
        var progress = try store.loadProgress(for: profileID)
        progress.activeMissionID = mission.id
        progress.currentActivityIndexByMission[mission.id] = activityIndex
        progress.totalAttemptsByMission[mission.id] = attempts
        try store.saveProgress(progress, for: profileID)
        return progress
    }

    func completeMission(_ mission: Mission, for profileID: UUID) throws -> UserProgress {
        var progress = try store.loadProgress(for: profileID)
        progress.completedMissionIDs.insert(mission.id)
        progress.activeMissionID = nil
        progress.currentActivityIndexByMission.removeValue(forKey: mission.id)
        unlockReward(mission.reward, in: &progress)
        try store.saveProgress(progress, for: profileID)
        return progress
    }

    func completeObservation(_ observation: ObservationActivity, for profileID: UUID) throws -> UserProgress {
        var progress = try store.loadProgress(for: profileID)
        progress.completedObservationActivityIDs.insert(observation.id)
        if let rewardBadgeID = observation.rewardBadgeID {
            progress.earnedBadgeIDs.insert(rewardBadgeID)
        }
        try store.saveProgress(progress, for: profileID)
        return progress
    }

    func saveProgress(_ progress: UserProgress, for profileID: UUID) throws -> UserProgress {
        try store.saveProgress(progress, for: profileID)
        return progress
    }

    func resetProgress(for profileID: UUID) throws -> UserProgress {
        try store.resetProgress(for: profileID)
        return .empty
    }

    func deleteProgress(for profileID: UUID) throws {
        try store.deleteProgress(for: profileID)
    }

    private func unlockReward(_ reward: MissionReward, in progress: inout UserProgress) {
        switch reward.type {
        case .animalCard:
            progress.discoveredAnimalIDs.insert(reward.referenceID)
        case .plantCard:
            progress.discoveredPlantIDs.insert(reward.referenceID)
        case .badge:
            progress.earnedBadgeIDs.insert(reward.referenceID)
        case .journalPage:
            break
        case .ecosystemUnlock:
            progress.unlockedEcosystemIDs.insert(reward.referenceID)
        }
    }
}
