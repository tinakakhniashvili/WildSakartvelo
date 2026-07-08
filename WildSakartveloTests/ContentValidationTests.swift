import XCTest
@testable import WildSakartvelo

final class ContentValidationTests: XCTestCase {
    func testDuplicateEcosystemIDsFail() {
        XCTAssertThrowsError(try TestFixtures.catalogue(ecosystems: [
            TestFixtures.ecosystem(id: "duplicate"),
            TestFixtures.ecosystem(id: "duplicate")
        ]))
    }

    func testDuplicateAnimalIDsFail() {
        XCTAssertThrowsError(try TestFixtures.catalogue(animals: [.sample, .sample]))
    }

    func testMissingMissionReferencesFail() {
        XCTAssertThrowsError(try TestFixtures.catalogue(ecosystems: [
            TestFixtures.ecosystem(missionIDs: ["missing"])
        ]))
    }

    func testMissingActivityReferencesFail() {
        let mission = TestFixtures.mission(activityIDs: ["missing-activity"])
        XCTAssertThrowsError(try TestFixtures.catalogue(missions: [mission]))
    }

    func testInvalidMissionEcosystemReferenceFails() {
        let mission = TestFixtures.mission(ecosystemID: "missing-ecosystem")
        XCTAssertThrowsError(try TestFixtures.catalogue(missions: [mission]))
    }

    func testInvalidContentPackEcosystemIDFails() {
        let pack = ContentPack(
            id: "bad-pack",
            ecosystemID: "missing-ecosystem",
            title: "Bad Pack",
            version: 1,
            estimatedSizeBytes: 1,
            remoteBaseURL: nil,
            resourceFiles: []
        )
        XCTAssertThrowsError(try TestFixtures.catalogue(contentPacks: [pack]))
    }

    func testValidCatalogueLoads() throws {
        let catalogue = try ContentCatalogue(provider: MockContentService())
        XCTAssertEqual(catalogue.ecosystems.count, 1)
        XCTAssertEqual(catalogue.contentPacks.count, 1)
    }
}
