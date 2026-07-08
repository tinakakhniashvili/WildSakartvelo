struct Mission: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let localizedTitle: LocalizedContentText?
    let subtitle: String
    let localizedSubtitle: LocalizedContentText?
    let introduction: String
    let localizedIntroduction: LocalizedContentText?
    let ecosystemID: String
    let difficulty: DifficultyLevel
    let estimatedMinutes: Int
    let activityIDs: [String]
    let learningTopics: [String]
    let reward: MissionReward
    let prerequisiteMissionIDs: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case localizedTitle
        case subtitle
        case localizedSubtitle
        case introduction
        case localizedIntroduction
        case ecosystemID
        case difficulty
        case estimatedMinutes
        case activityIDs
        case learningTopics
        case reward
        case prerequisiteMissionIDs
    }

    init(
        id: String,
        title: String,
        localizedTitle: LocalizedContentText?,
        subtitle: String,
        localizedSubtitle: LocalizedContentText?,
        introduction: String,
        localizedIntroduction: LocalizedContentText?,
        ecosystemID: String,
        difficulty: DifficultyLevel,
        estimatedMinutes: Int,
        activityIDs: [String],
        learningTopics: [String],
        reward: MissionReward,
        prerequisiteMissionIDs: [String]
    ) {
        self.id = id
        self.title = title
        self.localizedTitle = localizedTitle
        self.subtitle = subtitle
        self.localizedSubtitle = localizedSubtitle
        self.introduction = introduction
        self.localizedIntroduction = localizedIntroduction
        self.ecosystemID = ecosystemID
        self.difficulty = difficulty
        self.estimatedMinutes = estimatedMinutes
        self.activityIDs = activityIDs
        self.learningTopics = learningTopics
        self.reward = reward
        self.prerequisiteMissionIDs = prerequisiteMissionIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        localizedTitle = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedTitle)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        localizedSubtitle = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedSubtitle)
        introduction = try container.decode(String.self, forKey: .introduction)
        localizedIntroduction = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedIntroduction)
        ecosystemID = try container.decode(String.self, forKey: .ecosystemID)
        difficulty = try container.decode(DifficultyLevel.self, forKey: .difficulty)
        estimatedMinutes = try container.decode(Int.self, forKey: .estimatedMinutes)
        activityIDs = try container.decode([String].self, forKey: .activityIDs)
        learningTopics = try container.decodeIfPresent([String].self, forKey: .learningTopics) ?? []
        reward = try container.decode(MissionReward.self, forKey: .reward)
        prerequisiteMissionIDs = try container.decodeIfPresent([String].self, forKey: .prerequisiteMissionIDs) ?? []
    }
}

struct MissionReward: Codable, Hashable {
    let type: RewardType
    let referenceID: String
    let title: String
    let localizedTitle: LocalizedContentText?
}

extension Mission {
    static let sample = Mission(
        id: "mountain-habitat-discovery",
        title: "Mountain Habitat Discovery",
        localizedTitle: LocalizedContentText(
            english: "Mountain Habitat Discovery",
            georgian: "მთის ჰაბიტატის აღმოჩენა"
        ),
        subtitle: "Find what helps a tur live on steep slopes",
        localizedSubtitle: LocalizedContentText(
            english: "Find what helps a tur live on steep slopes",
            georgian: "იპოვე, რა ეხმარება ჯიხვს ციცაბო ფერდობებზე ცხოვრებაში"
        ),
        introduction: "Explore the high mountain habitat and notice how animals survive among rocks, grass, and cold winds.",
        localizedIntroduction: LocalizedContentText(
            english: "Explore the high mountain habitat and notice how animals survive among rocks, grass, and cold winds.",
            georgian: "გამოიკვლიე მაღალი მთის ჰაბიტატი და შენიშნე, როგორ გადარჩებიან ცხოველები ქვებს, ბალახსა და ცივ ქარებს შორის."
        ),
        ecosystemID: "caucasus-mountains",
        difficulty: .beginner,
        estimatedMinutes: 5,
        activityIDs: ["tur-habitat-question"],
        learningTopics: ["habitats", "animalIdentification", "observation"],
        reward: MissionReward(
            type: .animalCard,
            referenceID: "caucasian-tur",
            title: "Caucasian Tur Card",
            localizedTitle: LocalizedContentText(
                english: "Caucasian Tur Card",
                georgian: "ჯიხვის ბარათი"
            )
        ),
        prerequisiteMissionIDs: []
    )
}
