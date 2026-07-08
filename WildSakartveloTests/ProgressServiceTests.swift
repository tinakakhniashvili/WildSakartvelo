import XCTest
@testable import WildSakartvelo

final class ProgressServiceTests: XCTestCase {
    private var store: MockProgressStore!
    private var service: ProgressService!
    private var mission: Mission!

    override func setUp() {
        super.setUp()
        store = MockProgressStore()
        service = ProgressService(store: store)
        mission = TestFixtures.mission(
            reward: MissionReward(type: .badge, referenceID: "mountain-observer", title: "Observer", localizedTitle: nil)
        )
    }

    func testStartingMission() throws {
        let progress = try service.startMission(mission, for: TestFixtures.profileA)
        XCTAssertEqual(progress.activeMissionID, mission.id)
        XCTAssertEqual(progress.currentActivityIndexByMission[mission.id], 0)
        XCTAssertEqual(progress.totalAttemptsByMission[mission.id], 0)
    }

    func testSavingCurrentActivityAndAttempts() throws {
        _ = try service.updateMission(mission, activityIndex: 2, attempts: 4, for: TestFixtures.profileA)
        let progress = try service.loadProgress(for: TestFixtures.profileA)
        XCTAssertEqual(progress.currentActivityIndexByMission[mission.id], 2)
        XCTAssertEqual(progress.totalAttemptsByMission[mission.id], 4)
    }

    func testCompletingMissionUnlocksRewardWithoutDuplicates() throws {
        _ = try service.completeMission(mission, for: TestFixtures.profileA)
        _ = try service.completeMission(mission, for: TestFixtures.profileA)
        let progress = try service.loadProgress(for: TestFixtures.profileA)
        XCTAssertEqual(progress.completedMissionIDs, [mission.id])
        XCTAssertEqual(progress.earnedBadgeIDs, ["mountain-observer"])
        XCTAssertNil(progress.activeMissionID)
    }

    func testSeparateProgressForTwoProfilesAndResetOne() throws {
        _ = try service.completeMission(mission, for: TestFixtures.profileA)
        let otherMission = TestFixtures.mission(id: "other", reward: MissionReward(type: .animalCard, referenceID: "animal", title: "Animal", localizedTitle: nil))
        _ = try service.completeMission(otherMission, for: TestFixtures.profileB)

        _ = try service.resetProgress(for: TestFixtures.profileA)

        XCTAssertTrue(try service.loadProgress(for: TestFixtures.profileA).completedMissionIDs.isEmpty)
        XCTAssertEqual(try service.loadProgress(for: TestFixtures.profileB).completedMissionIDs, ["other"])
    }
}
