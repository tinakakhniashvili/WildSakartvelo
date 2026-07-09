import XCTest
@testable import WildSakartvelo

final class GeographyFeatureTests: XCTestCase {
    func testBundledGeographyContentDecodes() throws {
        let catalogue = try ContentCatalogue.load()

        XCTAssertGreaterThanOrEqual(catalogue.regions.count, 10)
        XCTAssertEqual(catalogue.citiesByID["tbilisi"]?.name.english, "Tbilisi")
        XCTAssertEqual(catalogue.regionsByID["kakheti"]?.administrativeCenter.english, "Telavi")
        XCTAssertGreaterThanOrEqual(catalogue.geographyMissions.count, 8)
    }

    func testCityMustReferenceValidRegion() {
        let city = TestFixtures.city(regionID: "missing-region")
        XCTAssertThrowsError(try TestFixtures.catalogue(cities: [city]))
    }

    func testNeighborMustReferenceValidRegion() {
        let region = TestFixtures.region(neighboringRegionIDs: ["missing-region"])
        XCTAssertThrowsError(try TestFixtures.catalogue(regions: [region]))
    }

    func testMapCoordinatesMustStayNormalized() {
        let region = TestFixtures.region(mapPosition: MapPosition(x: 1.3, y: 0.4))
        XCTAssertThrowsError(try TestFixtures.catalogue(regions: [region]))
    }

    func testGeographyMissionCompletionIsStoredPerProfile() throws {
        let store = MockProgressStore()
        let service = ProgressService(store: store)
        let mission = TestFixtures.geographyMission()

        _ = try service.completeGeographyMission(mission, score: 1, for: TestFixtures.profileA)

        XCTAssertTrue(store.values[TestFixtures.profileA]?.geographyProgress.completedGeographyMissionIDs.contains(mission.id) == true)
        XCTAssertFalse(store.values[TestFixtures.profileB]?.geographyProgress.completedGeographyMissionIDs.contains(mission.id) == true)
    }

    func testGeographyRewardIsNotDuplicated() throws {
        let store = MockProgressStore()
        let service = ProgressService(store: store)
        let mission = TestFixtures.geographyMission()

        _ = try service.completeGeographyMission(mission, score: 1, for: TestFixtures.profileA)
        _ = try service.completeGeographyMission(mission, score: 1, for: TestFixtures.profileA)

        XCTAssertEqual(store.values[TestFixtures.profileA]?.earnedBadgeIDs, ["geo-badge"])
    }

    func testOldProgressDecodesWithEmptyGeographyProgress() throws {
        let json = """
        {
          "completedMissionIDs": ["mission-1"],
          "discoveredAnimalIDs": [],
          "discoveredPlantIDs": [],
          "unlockedEcosystemIDs": [],
          "earnedBadgeIDs": [],
          "activeMissionID": null,
          "currentActivityIndexByMission": {},
          "totalAttemptsByMission": {}
        }
        """.data(using: .utf8)!

        let progress = try JSONDecoder().decode(UserProgress.self, from: json)

        XCTAssertEqual(progress.completedMissionIDs, ["mission-1"])
        XCTAssertTrue(progress.geographyProgress.completedGeographyMissionIDs.isEmpty)
    }
}
