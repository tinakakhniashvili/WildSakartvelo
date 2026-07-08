import XCTest
@testable import WildSakartvelo

final class UnlockServiceTests: XCTestCase {
    private let service = UnlockService()

    func testEcosystemUnlocking() {
        let unlocked = TestFixtures.ecosystem(initiallyUnlocked: true)
        let locked = TestFixtures.ecosystem(id: "locked", initiallyUnlocked: false)
        var progress = UserProgress.empty

        XCTAssertTrue(service.isEcosystemUnlocked(unlocked, progress: progress))
        XCTAssertFalse(service.isEcosystemUnlocked(locked, progress: progress))

        progress.unlockedEcosystemIDs.insert("locked")
        XCTAssertTrue(service.isEcosystemUnlocked(locked, progress: progress))
    }

    func testMissionWithoutPrerequisitesIsUnlocked() throws {
        let catalogue = try TestFixtures.catalogue()
        XCTAssertTrue(service.isMissionUnlocked(catalogue.missions[0], catalogue: catalogue, progress: .empty))
    }

    func testMissionPrerequisites() throws {
        let first = TestFixtures.mission(id: "first")
        let second = TestFixtures.mission(id: "second", prerequisiteMissionIDs: ["first"])
        let ecosystem = TestFixtures.ecosystem(missionIDs: ["first", "second"])
        let catalogue = try TestFixtures.catalogue(ecosystems: [ecosystem], missions: [first, second])

        XCTAssertFalse(service.isMissionUnlocked(second, catalogue: catalogue, progress: .empty))

        var progress = UserProgress.empty
        progress.completedMissionIDs.insert("first")
        XCTAssertTrue(service.isMissionUnlocked(second, catalogue: catalogue, progress: progress))

        progress.completedMissionIDs.insert("second")
        XCTAssertTrue(service.isMissionUnlocked(second, catalogue: catalogue, progress: progress))
    }
}
