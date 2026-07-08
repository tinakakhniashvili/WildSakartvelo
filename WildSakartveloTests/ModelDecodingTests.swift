import XCTest
@testable import WildSakartvelo

final class ModelDecodingTests: XCTestCase {
    private let decoder = JSONDecoder()

    func testDecodesCoreContentModels() throws {
        XCTAssertEqual(try decode(Ecosystem.self, from: ecosystemJSON()).id, "caucasus-mountains")
        XCTAssertEqual(try decode(Animal.self, from: animalJSON()).id, "caucasian-tur")
        XCTAssertEqual(try decode(Plant.self, from: plantJSON()).id, "caucasian-rhododendron")
        XCTAssertEqual(try decode(Mission.self, from: missionJSON()).id, "mission-1")
        XCTAssertEqual(try decode(MissionActivity.self, from: activityJSON()).id, "activity-1")
        XCTAssertEqual(try decode(ContentPack.self, from: contentPackJSON()).id, "pack-1")
    }

    func testDecodesAppAndUserModels() throws {
        let settings = try decode(AppSettings.self, from: #"{"language":"georgian"}"#)
        XCTAssertEqual(settings.language, .georgian)
        XCTAssertTrue(settings.narrationEnabled)
        XCTAssertFalse(settings.largerTextEnabled)

        let profile = try decode(
            ChildProfile.self,
            from: """
            {
              "id":"11111111-1111-1111-1111-111111111111",
              "nickname":"Nini",
              "avatarID":"fox",
              "learningLevel":"explorerOne",
              "createdAt":735689600,
              "lastOpenedAt":735689600
            }
            """
        )
        XCTAssertEqual(profile.nickname, "Nini")

        let progress = try decode(UserProgress.self, from: #"{"completedMissionIDs":["mission-1"]}"#)
        XCTAssertEqual(progress.completedMissionIDs, ["mission-1"])
        XCTAssertTrue(progress.discoveredAnimalIDs.isEmpty)
        XCTAssertTrue(progress.totalAttemptsByMission.isEmpty)
        XCTAssertTrue(progress.challengeProgress.isEmpty)
        XCTAssertTrue(progress.completedObservationActivityIDs.isEmpty)
    }

    func testDecodesOptionalFieldCasesForOlderJSON() throws {
        let animal = try decode(Animal.self, from: animalJSON(omitOptionalMedia: true))
        XCTAssertNil(animal.footprintImageName)
        XCTAssertNil(animal.soundFileName)

        let mission = try decode(Mission.self, from: missionJSON(omitLearningTopics: true))
        XCTAssertTrue(mission.learningTopics.isEmpty)

        let pack = try decode(ContentPack.self, from: #"{"id":"pack","ecosystemID":"caucasus-mountains","title":"Pack"}"#)
        XCTAssertEqual(pack.version, 1)
        XCTAssertEqual(pack.estimatedSizeBytes, 0)
        XCTAssertTrue(pack.resourceFiles.isEmpty)
    }

    private func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try decoder.decode(T.self, from: Data(json.utf8))
    }

    private func ecosystemJSON() -> String {
        """
        {
          "id":"caucasus-mountains",
          "name":"Caucasus Mountains",
          "localizedName":{"english":"Caucasus Mountains","georgian":"კავკასიონის მთები"},
          "subtitle":"High ridges",
          "localizedSubtitle":null,
          "description":"Description",
          "localizedDescription":null,
          "imageName":"caucasus_mountains",
          "theme":"mountain",
          "animalIDs":["caucasian-tur"],
          "plantIDs":["caucasian-rhododendron"],
          "missionIDs":["mission-1"],
          "isInitiallyUnlocked":true
        }
        """
    }

    private func animalJSON(omitOptionalMedia: Bool = false) -> String {
        """
        {
          "id":"caucasian-tur",
          "georgianName":"ჯიხვი",
          "englishName":"Caucasian Tur",
          "scientificName":"Capra caucasica",
          "summary":"Summary",
          "habitat":"Habitat",
          "diet":"Diet",
          "sizeDescription":"Size",
          "surprisingFact":"Fact",
          "imageName":"caucasian_tur",
          \(omitOptionalMedia ? "" : #""footprintImageName":"caucasian_tur_footprint","soundFileName":"caucasian_tur_sound","#)
          "conservationStatus":"protected",
          "ecosystemIDs":["caucasus-mountains"]
        }
        """
    }

    private func plantJSON() -> String {
        """
        {
          "id":"caucasian-rhododendron",
          "georgianName":"დეკა",
          "englishName":"Caucasian Rhododendron",
          "description":"Description",
          "imageName":"rhododendron",
          "surprisingFact":"Fact",
          "ecosystemIDs":["caucasus-mountains"]
        }
        """
    }

    private func missionJSON(omitLearningTopics: Bool = false) -> String {
        """
        {
          "id":"mission-1",
          "title":"Mission",
          "subtitle":"Subtitle",
          "introduction":"Intro",
          "ecosystemID":"caucasus-mountains",
          "difficulty":"beginner",
          "estimatedMinutes":5,
          "activityIDs":["activity-1"],
          \(omitLearningTopics ? "" : #""learningTopics":["habitats"],"#)
          "reward":{"type":"animalCard","referenceID":"caucasian-tur","title":"Tur"},
          "prerequisiteMissionIDs":[]
        }
        """
    }

    private func activityJSON() -> String {
        """
        {
          "id":"activity-1",
          "type":"multipleChoice",
          "instruction":"Choose",
          "question":"Question",
          "imageName":null,
          "narrationFileName":null,
          "options":[{"id":"a","text":"A","imageName":null,"pairID":null,"categoryID":null}],
          "categories":null,
          "sequenceItems":null,
          "habitatZones":null,
          "correctAnswerIDs":["a"],
          "hint":"Hint",
          "successFeedback":"Correct",
          "failureFeedback":"Try again"
        }
        """
    }

    private func contentPackJSON() -> String {
        """
        {
          "id":"pack-1",
          "ecosystemID":"caucasus-mountains",
          "title":"Pack",
          "version":2,
          "estimatedSizeBytes":1024,
          "remoteBaseURL":null,
          "resourceFiles":["audio.m4a"]
        }
        """
    }
}
