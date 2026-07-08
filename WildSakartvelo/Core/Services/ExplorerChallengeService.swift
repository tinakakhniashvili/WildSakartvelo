struct ExplorerChallengeService {
    private let calculator = ProgressCalculator()

    func progress(for challenge: ExplorerChallenge, catalogue: ContentCatalogue, progress: UserProgress) -> ExplorerChallengeProgress {
        let currentValue = min(calculator.challengeValue(for: challenge, catalogue: catalogue, progress: progress), challenge.targetValue)
        let stored = progress.challengeProgress.first { $0.challengeID == challenge.id }
        let isCompleted = currentValue >= challenge.targetValue || stored?.isCompleted == true
        return ExplorerChallengeProgress(
            challengeID: challenge.id,
            currentValue: currentValue,
            isCompleted: isCompleted,
            rewardClaimed: stored?.rewardClaimed == true
        )
    }

    func activeChallenges(in catalogue: ContentCatalogue, progress: UserProgress) -> [ExplorerChallenge] {
        catalogue.explorerChallenges.filter {
            !self.progress(for: $0, catalogue: catalogue, progress: progress).isCompleted
        }
    }

    func completedChallenges(in catalogue: ContentCatalogue, progress: UserProgress) -> [ExplorerChallenge] {
        catalogue.explorerChallenges.filter {
            self.progress(for: $0, catalogue: catalogue, progress: progress).isCompleted
        }
    }

    func applyingCompletedRewards(in catalogue: ContentCatalogue, to progress: UserProgress) -> UserProgress {
        var updated = progress

        for challenge in catalogue.explorerChallenges {
            var challengeProgress = self.progress(for: challenge, catalogue: catalogue, progress: updated)
            guard challengeProgress.isCompleted else { continue }

            if let index = updated.challengeProgress.firstIndex(where: { $0.challengeID == challenge.id }) {
                updated.challengeProgress[index].currentValue = challengeProgress.currentValue
                updated.challengeProgress[index].isCompleted = true
            } else {
                updated.challengeProgress.append(challengeProgress)
            }

            guard !challengeProgress.rewardClaimed else { continue }
            if let rewardBadgeID = challenge.rewardBadgeID {
                updated.earnedBadgeIDs.insert(rewardBadgeID)
            }
            challengeProgress.rewardClaimed = true
            if let index = updated.challengeProgress.firstIndex(where: { $0.challengeID == challenge.id }) {
                updated.challengeProgress[index] = challengeProgress
            }
        }

        return updated
    }
}
