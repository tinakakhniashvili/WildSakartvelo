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
        observationActivities: [ObservationActivity]? = nil
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
            observationActivities: observationActivities ?? [observation()]
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
}
