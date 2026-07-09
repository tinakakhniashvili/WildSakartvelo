import XCTest
@testable import WildSakartvelo

final class MissionSessionTests: XCTestCase {
    func testMultipleChoiceActivity() throws {
        let session = try makeSession(activity: .sample)
        XCTAssertFalse(session.canSubmit)

        session.selectedAnswerID = "wrong"
        XCTAssertTrue(session.canSubmit)
        session.submitAnswer()
        XCTAssertFalse(session.isAnswerCorrect)
        XCTAssertEqual(session.attempts, 1)

        session.selectedAnswerID = "rocky-mountain-slope"
        session.submitAnswer()
        XCTAssertTrue(session.isAnswerCorrect)
        XCTAssertEqual(session.attempts, 2)
        session.continueToNextActivity()
        XCTAssertTrue(session.isMissionCompleted)
    }

    func testMatchingActivity() throws {
        let session = try makeSession(activity: .sampleMatching)
        XCTAssertFalse(session.canSubmit)

        session.selectedPairs = ["tur": "bear-footprint", "bear": "tur-footprint", "frog": "frog-footprint"]
        session.submitAnswer()
        XCTAssertFalse(session.isAnswerCorrect)

        session.selectedPairs = ["tur": "tur-footprint", "bear": "bear-footprint", "frog": "frog-footprint"]
        session.submitAnswer()
        XCTAssertTrue(session.isAnswerCorrect)
    }

    func testClassificationActivity() throws {
        let session = try makeSession(activity: .sampleClassification)
        XCTAssertFalse(session.canSubmit)

        session.selectedCategories = ["tur": "wetland", "bear": "forest", "frog": "mountain"]
        session.submitAnswer()
        XCTAssertFalse(session.isAnswerCorrect)

        session.selectedCategories = ["tur": "mountain", "bear": "forest", "frog": "wetland"]
        session.submitAnswer()
        XCTAssertTrue(session.isAnswerCorrect)
    }

    func testSequencingActivity() throws {
        let activity = MissionActivity.sampleSequencing
        let session = try makeSession(activity: activity)
        XCTAssertTrue(session.canSubmit)

        session.orderedItemIDs = activity.sequenceItems?.map(\.id).reversed() ?? []
        session.submitAnswer()
        XCTAssertFalse(session.isAnswerCorrect)

        session.orderedItemIDs = activity.sequenceItems?
            .sorted { $0.correctPosition < $1.correctPosition }
            .map(\.id) ?? []
        session.submitAnswer()
        XCTAssertTrue(session.isAnswerCorrect)
    }

    func testHabitatPlacementActivity() throws {
        let session = try makeSession(activity: .sampleHabitatPlacement)
        XCTAssertFalse(session.canSubmit)

        session.habitatSelections = ["tur": "wetland", "bear": "mountain", "frog": "forest"]
        session.submitAnswer()
        XCTAssertFalse(session.isAnswerCorrect)

        session.habitatSelections = ["tur": "mountain", "bear": "forest", "frog": "wetland"]
        session.submitAnswer()
        XCTAssertTrue(session.isAnswerCorrect)
    }

    func testSessionUsesCatalogueLookupForActivities() throws {
        let mission = TestFixtures.mission(activityIDs: [MissionActivity.sampleMatching.id, MissionActivity.sample.id])
        let catalogue = try TestFixtures.catalogue(
            missions: [mission],
            activities: [.sample, .sampleMatching]
        )

        let session = MissionSession(mission: mission, catalogue: catalogue)

        XCTAssertEqual(session.activities.map(\.id), [MissionActivity.sampleMatching.id, MissionActivity.sample.id])
    }

    private func makeSession(activity: MissionActivity) throws -> MissionSession {
        let mission = TestFixtures.mission(activityIDs: [activity.id])
        let catalogue = try TestFixtures.catalogue(missions: [mission], activities: [activity])
        return MissionSession(mission: mission, catalogue: catalogue)
    }
}
