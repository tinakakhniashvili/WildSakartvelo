import XCTest
@testable import WildSakartvelo

final class ExplorerExpansionTests: XCTestCase {
    func testDailyDiscoveryIsDeterministicForSameDay() throws {
        let discoveries = [
            TestFixtures.dailyDiscovery(id: "one"),
            TestFixtures.dailyDiscovery(id: "two"),
            TestFixtures.dailyDiscovery(id: "three")
        ]
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let service = DailyDiscoveryService(calendar: calendar)
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        XCTAssertEqual(
            service.discovery(for: date, discoveries: discoveries),
            service.discovery(for: date.addingTimeInterval(3_600), discoveries: discoveries)
        )
    }

    func testChallengeProgressAndDuplicateRewardPrevention() throws {
        let challenge = TestFixtures.challenge(targetValue: 1, rewardBadgeID: "reward")
        let catalogue = try TestFixtures.catalogue(explorerChallenges: [challenge])
        let service = ExplorerChallengeService()
        let progress = UserProgress(
            completedMissionIDs: ["mountain-habitat-discovery"],
            discoveredAnimalIDs: [],
            discoveredPlantIDs: [],
            unlockedEcosystemIDs: [],
            earnedBadgeIDs: [],
            activeMissionID: nil,
            currentActivityIndexByMission: [:],
            totalAttemptsByMission: [:]
        )

        let rewarded = service.applyingCompletedRewards(in: catalogue, to: progress)
        let rewardedAgain = service.applyingCompletedRewards(in: catalogue, to: rewarded)

        XCTAssertTrue(rewarded.earnedBadgeIDs.contains("reward"))
        XCTAssertEqual(rewardedAgain.earnedBadgeIDs, rewarded.earnedBadgeIDs)
        XCTAssertEqual(rewardedAgain.challengeProgress.filter { $0.challengeID == challenge.id }.count, 1)
    }

    func testEquipmentUnlockRules() throws {
        let catalogue = try TestFixtures.catalogue()
        let service = EquipmentUnlockService()
        let progress = UserProgress(
            completedMissionIDs: ["mountain-habitat-discovery"],
            discoveredAnimalIDs: [],
            discoveredPlantIDs: [],
            unlockedEcosystemIDs: [],
            earnedBadgeIDs: [],
            activeMissionID: nil,
            currentActivityIndexByMission: [:],
            totalAttemptsByMission: [:]
        )

        let notebook = try XCTUnwrap(service.equipment.first { $0.id == "field-notebook" })
        XCTAssertTrue(service.isUnlocked(notebook, catalogue: catalogue, progress: progress))
    }

    func testObservationCompletionPersistsAndRewardsBadge() throws {
        let store = MockProgressStore()
        let service = ProgressService(store: store)
        let observation = TestFixtures.observation()

        let progress = try service.completeObservation(observation, for: TestFixtures.profileA)

        XCTAssertTrue(progress.completedObservationActivityIDs.contains(observation.id))
        XCTAssertTrue(progress.earnedBadgeIDs.contains("first-observation"))
        XCTAssertEqual(store.values[TestFixtures.profileA], progress)
    }

    func testOldSavedProgressDecodesNewFieldsAsEmpty() throws {
        let data = Data(#"{"completedMissionIDs":["mission"]}"#.utf8)
        let progress = try JSONDecoder().decode(UserProgress.self, from: data)

        XCTAssertEqual(progress.completedMissionIDs, ["mission"])
        XCTAssertTrue(progress.challengeProgress.isEmpty)
        XCTAssertTrue(progress.completedObservationActivityIDs.isEmpty)
    }

    func testProgressCalculatorConsistency() throws {
        let catalogue = try TestFixtures.catalogue()
        let progress = UserProgress(
            completedMissionIDs: ["mountain-habitat-discovery"],
            discoveredAnimalIDs: ["caucasian-tur"],
            discoveredPlantIDs: ["caucasus-rhododendron"],
            unlockedEcosystemIDs: [],
            earnedBadgeIDs: [],
            activeMissionID: nil,
            currentActivityIndexByMission: [:],
            totalAttemptsByMission: [:]
        )
        let calculator = ProgressCalculator()

        XCTAssertEqual(calculator.overallMissionCompletion(catalogue: catalogue, progress: progress), 1)
        XCTAssertEqual(calculator.journalDiscoveryPercentage(catalogue: catalogue, progress: progress), 1)
    }
}
