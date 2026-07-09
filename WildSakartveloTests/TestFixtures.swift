import Foundation
@testable import WildSakartvelo

enum TestFixtures {
    static let profileA = UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!
    static let profileB = UUID(uuidString: "BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB")!

    static func catalogue(
        ecosystems: [Ecosystem]? = nil,
        animals: [Animal]? = nil,
        plants: [Plant]? = nil,
        missions: [Mission]? = nil,
        activities: [MissionActivity]? = nil,
        contentPacks: [ContentPack]? = nil,
        dailyDiscoveries: [DailyDiscovery]? = nil,
        explorerChallenges: [ExplorerChallenge]? = nil,
        observationActivities: [ObservationActivity]? = nil,
        regions: [GeorgiaRegion]? = nil,
        cities: [GeorgianCity]? = nil,
        geographyLandmarks: [GeographyLandmark]? = nil,
        geographyMissions: [GeographyMission]? = nil,
        geographyActivities: [GeographyActivity]? = nil
    ) throws -> ContentCatalogue {
        try ContentCatalogue(
            ecosystems: ecosystems ?? [ecosystem()],
            animals: animals ?? [.sample],
            plants: plants ?? [.sample],
            missions: missions ?? [mission()],
            activities: activities ?? [.sample],
            contentPacks: contentPacks ?? [.sample],
            dailyDiscoveries: dailyDiscoveries ?? [dailyDiscovery()],
            explorerChallenges: explorerChallenges ?? [challenge()],
            observationActivities: observationActivities ?? [observation()],
            regions: regions ?? [region()],
            cities: cities ?? [city()],
            geographyLandmarks: geographyLandmarks ?? [landmark()],
            geographyMissions: geographyMissions ?? [geographyMission()],
            geographyActivities: geographyActivities ?? [geographyActivity()]
        )
    }

    static func mission(
        id: String = "mountain-habitat-discovery",
        ecosystemID: String = "caucasus-mountains",
        activityIDs: [String] = ["identify-animal"],
        reward: MissionReward = MissionReward(type: .animalCard, referenceID: "caucasian-tur", title: "Tur", localizedTitle: nil),
        prerequisiteMissionIDs: [String] = []
    ) -> Mission {
        Mission(
            id: id,
            title: "Mission \(id)",
            localizedTitle: nil,
            subtitle: "Subtitle",
            localizedSubtitle: nil,
            introduction: "Intro",
            localizedIntroduction: nil,
            ecosystemID: ecosystemID,
            difficulty: .beginner,
            estimatedMinutes: 5,
            activityIDs: activityIDs,
            learningTopics: ["habitats"],
            reward: reward,
            prerequisiteMissionIDs: prerequisiteMissionIDs
        )
    }

    static func ecosystem(id: String = "caucasus-mountains", missionIDs: [String] = ["mountain-habitat-discovery"], initiallyUnlocked: Bool = true) -> Ecosystem {
        Ecosystem(
            id: id,
            name: "Ecosystem \(id)",
            localizedName: nil,
            subtitle: "Subtitle",
            localizedSubtitle: nil,
            description: "Description",
            localizedDescription: nil,
            imageName: "ecosystem",
            theme: .mountain,
            animalIDs: ["caucasian-tur"],
            plantIDs: ["caucasus-rhododendron"],
            missionIDs: missionIDs,
            isInitiallyUnlocked: initiallyUnlocked
        )
    }

    static func dailyDiscovery(id: String = "daily-1") -> DailyDiscovery {
        DailyDiscovery(
            id: id,
            title: LocalizedContentText(english: "Daily", georgian: "დღიური"),
            description: LocalizedContentText(english: "Fact", georgian: "ფაქტი"),
            imageName: "caucasian_tur",
            relatedAnimalID: "caucasian-tur",
            relatedPlantID: nil,
            relatedEcosystemID: "caucasus-mountains",
            factType: .animalFact
        )
    }

    static func challenge(
        id: String = "challenge-1",
        type: ExplorerChallengeType = .completeMissions,
        targetValue: Int = 1,
        relatedEcosystemID: String? = nil,
        rewardBadgeID: String? = "challenge-badge"
    ) -> ExplorerChallenge {
        ExplorerChallenge(
            id: id,
            title: LocalizedContentText(english: "Challenge", georgian: "გამოწვევა"),
            description: LocalizedContentText(english: "Complete it", georgian: "დაასრულე"),
            type: type,
            rewardBadgeID: rewardBadgeID,
            targetValue: targetValue,
            relatedEcosystemID: relatedEcosystemID,
            safetyMessage: nil
        )
    }

    static func observation(id: String = "observation-1") -> ObservationActivity {
        ObservationActivity(
            id: id,
            title: LocalizedContentText(english: "Observe", georgian: "დააკვირდი"),
            instruction: LocalizedContentText(english: "Look safely", georgian: "დააკვირდი უსაფრთხოდ"),
            safetyMessage: LocalizedContentText(english: "Ask an adult", georgian: "ჰკითხე ზრდასრულს"),
            ecosystemID: "caucasus-mountains",
            rewardBadgeID: "first-observation",
            activityType: .notice
        )
    }

    static func region(id: String = "kakheti", cityIDs: [String] = ["telavi"], landmarkIDs: [String] = ["alazani-valley"], neighboringRegionIDs: [String] = [], ecosystemIDs: [String] = ["caucasus-mountains"], mapPosition: MapPosition = MapPosition(x: 0.75, y: 0.45)) -> GeorgiaRegion {
        GeorgiaRegion(
            id: id,
            name: LocalizedContentText(english: "Kakheti", georgian: "კახეთი"),
            administrativeCenter: LocalizedContentText(english: "Telavi", georgian: "თელავი"),
            description: LocalizedContentText(english: "Eastern region", georgian: "აღმოსავლეთის რეგიონი"),
            mapShapeID: id,
            imageName: "onboarding_map",
            fact: LocalizedContentText(english: "Telavi is the center.", georgian: "თელავი ცენტრია."),
            cityIDs: cityIDs,
            landmarkIDs: landmarkIDs,
            neighboringRegionIDs: neighboringRegionIDs,
            ecosystemIDs: ecosystemIDs,
            mapPosition: mapPosition
        )
    }

    static func city(id: String = "telavi", regionID: String = "kakheti", mapPosition: MapPosition = MapPosition(x: 0.75, y: 0.45)) -> GeorgianCity {
        GeorgianCity(
            id: id,
            name: LocalizedContentText(english: "Telavi", georgian: "თელავი"),
            regionID: regionID,
            description: LocalizedContentText(english: "Administrative center", georgian: "ადმინისტრაციული ცენტრი"),
            imageName: "onboarding_map",
            isAdministrativeCenter: true,
            mapPosition: mapPosition,
            fact: LocalizedContentText(english: "It is in Kakheti.", georgian: "ის კახეთშია.")
        )
    }

    static func landmark(id: String = "alazani-valley", regionID: String? = "kakheti", mapPosition: MapPosition = MapPosition(x: 0.78, y: 0.46)) -> GeographyLandmark {
        GeographyLandmark(
            id: id,
            name: LocalizedContentText(english: "Alazani Valley", georgian: "ალაზნის ველი"),
            type: .river,
            regionID: regionID,
            description: LocalizedContentText(english: "A valley in eastern Georgia", georgian: "ველი აღმოსავლეთ საქართველოში"),
            imageName: "onboarding_map",
            mapPosition: mapPosition
        )
    }

    static func geographyActivity(id: String = "find-kakheti", optionIDs: [String] = ["kakheti"], correctRegionID: String? = "kakheti") -> GeographyActivity {
        GeographyActivity(
            id: id,
            type: .regionSelection,
            prompt: LocalizedContentText(english: "Find Kakheti", georgian: "იპოვე კახეთი"),
            correctRegionID: correctRegionID,
            correctCityID: nil,
            correctLandmarkID: nil,
            optionIDs: optionIDs,
            hint: LocalizedContentText(english: "Look east", georgian: "აღმოსავლეთს დააკვირდი")
        )
    }

    static func geographyMission(id: String = "geo-1", regionIDs: [String] = ["kakheti"], activityIDs: [String] = ["find-kakheti"], prerequisiteMissionIDs: [String] = []) -> GeographyMission {
        GeographyMission(
            id: id,
            title: LocalizedContentText(english: "Map Mission", georgian: "რუკის მისია"),
            introduction: LocalizedContentText(english: "Find a region", georgian: "იპოვე რეგიონი"),
            regionIDs: regionIDs,
            activityIDs: activityIDs,
            difficulty: .beginner,
            reward: MissionReward(type: .badge, referenceID: "geo-badge", title: "Geo Badge", localizedTitle: nil),
            prerequisiteMissionIDs: prerequisiteMissionIDs
        )
    }
}
