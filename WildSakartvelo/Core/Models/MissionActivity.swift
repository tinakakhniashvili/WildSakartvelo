struct MissionActivity: Identifiable, Codable, Hashable {
    let id: String
    let type: ActivityType
    let instruction: String
    let localizedInstruction: LocalizedContentText?
    let question: String
    let localizedQuestion: LocalizedContentText?
    let imageName: String?
    let narrationFileName: String?
    let narrationFileNameEnglish: String?
    let narrationFileNameGeorgian: String?
    let options: [ActivityOption]
    let categories: [ActivityCategory]?
    let sequenceItems: [SequenceItem]?
    let habitatZones: [HabitatZone]?
    let correctAnswerIDs: [String]
    let hint: String
    let localizedHint: LocalizedContentText?
    let successFeedback: String
    let localizedSuccessFeedback: LocalizedContentText?
    let failureFeedback: String
    let localizedFailureFeedback: LocalizedContentText?

    func narrationFileName(for language: AppLanguage) -> String? {
        switch language {
        case .english:
            return narrationFileNameEnglish ?? narrationFileNameGeorgian ?? narrationFileName
        case .georgian:
            return narrationFileNameGeorgian ?? narrationFileNameEnglish ?? narrationFileName
        }
    }
}

struct ActivityOption: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let localizedText: LocalizedContentText?
    let imageName: String?
    let pairID: String?
    let categoryID: String?
}

struct ActivityCategory: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let localizedTitle: LocalizedContentText?
    let imageName: String?
}

struct SequenceItem: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let localizedText: LocalizedContentText?
    let imageName: String?
    let correctPosition: Int
}

struct HabitatZone: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let localizedTitle: LocalizedContentText?
    let imageName: String?
    let acceptedItemIDs: [String]
}

extension MissionActivity {
    static let sample = MissionActivity(
        id: "identify-animal",
        type: .multipleChoice,
        instruction: "Choose the habitat where a Caucasian tur is most likely to feel at home.",
        localizedInstruction: LocalizedContentText(
            english: "Choose the habitat where a Caucasian tur is most likely to feel at home.",
            georgian: "აირჩიე ჰაბიტატი, სადაც ჯიხვი ყველაზე კარგად იგრძნობს თავს."
        ),
        question: "Where would you search for a Caucasian tur?",
        localizedQuestion: LocalizedContentText(
            english: "Where would you search for a Caucasian tur?",
            georgian: "სად ეძებდი ჯიხვს?"
        ),
        imageName: "caucasian_tur",
        narrationFileName: "identify_animal_instruction",
        narrationFileNameEnglish: "identify_animal_instruction_en",
        narrationFileNameGeorgian: "identify_animal_instruction_ka",
        options: [
            ActivityOption(id: "rocky-mountain-slope", text: "A rocky mountain slope with alpine grass", localizedText: LocalizedContentText(english: "A rocky mountain slope with alpine grass", georgian: "ალპური ბალახით დაფარული კლდოვანი მთის ფერდობი"), imageName: "rocky_mountain_slope", pairID: nil, categoryID: nil),
            ActivityOption(id: "black-sea-beach", text: "A sandy beach beside the Black Sea", localizedText: LocalizedContentText(english: "A sandy beach beside the Black Sea", georgian: "ქვიშიანი სანაპირო შავი ზღვის პირას"), imageName: "black_sea_beach", pairID: nil, categoryID: nil),
            ActivityOption(id: "lowland-marsh", text: "A quiet lowland marsh", localizedText: LocalizedContentText(english: "A quiet lowland marsh", georgian: "მშვიდი დაბლობური ჭაობი"), imageName: "lowland_marsh", pairID: nil, categoryID: nil)
        ],
        categories: nil,
        sequenceItems: nil,
        habitatZones: nil,
        correctAnswerIDs: ["rocky-mountain-slope"],
        hint: "Think about cliffs, high meadows, and strong hooves.",
        localizedHint: LocalizedContentText(
            english: "Think about cliffs, high meadows, and strong hooves.",
            georgian: "იფიქრე კლდეებზე, მაღალ მდელოებსა და ძლიერ ჩლიქებზე."
        ),
        successFeedback: "Correct. Caucasian turs are adapted for steep mountain terrain.",
        localizedSuccessFeedback: LocalizedContentText(
            english: "Correct. Caucasian turs are adapted for steep mountain terrain.",
            georgian: "სწორია. ჯიხვები ციცაბო მთის რელიეფს არიან შეგუებული."
        ),
        failureFeedback: "Try again. A tur needs rocky slopes and mountain vegetation.",
        localizedFailureFeedback: LocalizedContentText(
            english: "Try again. A tur needs rocky slopes and mountain vegetation.",
            georgian: "სცადე კიდევ ერთხელ. ჯიხვს სჭირდება კლდოვანი ფერდობები და მთის მცენარეულობა."
        )
    )

    static let sampleMatching = MissionActivity(
        id: "match-animal-footprints",
        type: .matching,
        instruction: "Match each animal with its footprint.",
        localizedInstruction: LocalizedContentText(
            english: "Match each animal with its footprint.",
            georgian: "დაამთხვიე თითოეული ცხოველი მის ნაკვალევს."
        ),
        question: "Which footprint belongs to each animal?",
        localizedQuestion: LocalizedContentText(
            english: "Which footprint belongs to each animal?",
            georgian: "რომელი ნაკვალევი ეკუთვნის თითოეულ ცხოველს?"
        ),
        imageName: nil,
        narrationFileName: "match_animal_footprints_instruction",
        narrationFileNameEnglish: "match_animal_footprints_instruction_en",
        narrationFileNameGeorgian: "match_animal_footprints_instruction_ka",
        options: [
            ActivityOption(id: "tur", text: "Caucasian tur", localizedText: LocalizedContentText(english: "Caucasian tur", georgian: "ჯიხვი"), imageName: "caucasian_tur", pairID: "tur-track", categoryID: nil),
            ActivityOption(id: "tur-footprint", text: "Split hoof print", localizedText: LocalizedContentText(english: "Split hoof print", georgian: "გაყოფილი ჩლიქის ნაკვალევი"), imageName: nil, pairID: "tur-track", categoryID: nil),
            ActivityOption(id: "bear", text: "Brown bear", localizedText: LocalizedContentText(english: "Brown bear", georgian: "დათვი"), imageName: "brown_bear", pairID: "bear-track", categoryID: nil),
            ActivityOption(id: "bear-footprint", text: "Wide paw print", localizedText: LocalizedContentText(english: "Wide paw print", georgian: "ფართო თათის ნაკვალევი"), imageName: nil, pairID: "bear-track", categoryID: nil),
            ActivityOption(id: "frog", text: "Marsh frog", localizedText: LocalizedContentText(english: "Marsh frog", georgian: "ჭაობის ბაყაყი"), imageName: "marsh_frog", pairID: "frog-track", categoryID: nil),
            ActivityOption(id: "frog-footprint", text: "Tiny webbed print", localizedText: LocalizedContentText(english: "Tiny webbed print", georgian: "პატარა მემბრანიანი ნაკვალევი"), imageName: nil, pairID: "frog-track", categoryID: nil)
        ],
        categories: nil,
        sequenceItems: nil,
        habitatZones: nil,
        correctAnswerIDs: [],
        hint: "Look at hooves, paws, and webbed feet.",
        localizedHint: LocalizedContentText(
            english: "Look at hooves, paws, and webbed feet.",
            georgian: "დააკვირდი ჩლიქებს, თათებს და მემბრანიან თათებს."
        ),
        successFeedback: "Correct. Each track matches the animal that made it.",
        localizedSuccessFeedback: LocalizedContentText(
            english: "Correct. Each track matches the animal that made it.",
            georgian: "სწორია. თითოეული ნაკვალევი ემთხვევა მის შემქმნელ ცხოველს."
        ),
        failureFeedback: "Try again. Compare the shape of each footprint.",
        localizedFailureFeedback: LocalizedContentText(
            english: "Try again. Compare the shape of each footprint.",
            georgian: "სცადე კიდევ ერთხელ. შეადარე თითოეული ნაკვალევის ფორმა."
        )
    )

    static let sampleClassification = MissionActivity(
        id: "classify-animal-habitats",
        type: .classification,
        instruction: "Choose the habitat where each animal belongs.",
        localizedInstruction: LocalizedContentText(
            english: "Choose the habitat where each animal belongs.",
            georgian: "აირჩიე ჰაბიტატი, სადაც თითოეული ცხოველი ცხოვრობს."
        ),
        question: "Sort the animals into habitats.",
        localizedQuestion: LocalizedContentText(
            english: "Sort the animals into habitats.",
            georgian: "დაალაგე ცხოველები ჰაბიტატებში."
        ),
        imageName: nil,
        narrationFileName: "habitat_classification_instruction",
        narrationFileNameEnglish: "habitat_classification_instruction_en",
        narrationFileNameGeorgian: "habitat_classification_instruction_ka",
        options: [
            ActivityOption(id: "tur", text: "Caucasian tur", localizedText: LocalizedContentText(english: "Caucasian tur", georgian: "ჯიხვი"), imageName: "caucasian_tur", pairID: nil, categoryID: "mountain"),
            ActivityOption(id: "bear", text: "Brown bear", localizedText: LocalizedContentText(english: "Brown bear", georgian: "დათვი"), imageName: "brown_bear", pairID: nil, categoryID: "forest"),
            ActivityOption(id: "frog", text: "Marsh frog", localizedText: LocalizedContentText(english: "Marsh frog", georgian: "ჭაობის ბაყაყი"), imageName: "marsh_frog", pairID: nil, categoryID: "wetland")
        ],
        categories: [
            ActivityCategory(id: "mountain", title: "Mountain", localizedTitle: LocalizedContentText(english: "Mountain", georgian: "მთა"), imageName: nil),
            ActivityCategory(id: "forest", title: "Forest", localizedTitle: LocalizedContentText(english: "Forest", georgian: "ტყე"), imageName: nil),
            ActivityCategory(id: "wetland", title: "Wetland", localizedTitle: LocalizedContentText(english: "Wetland", georgian: "ჭაობი"), imageName: nil)
        ],
        sequenceItems: nil,
        habitatZones: nil,
        correctAnswerIDs: [],
        hint: "Think about cliffs, trees, and calm water.",
        localizedHint: LocalizedContentText(
            english: "Think about cliffs, trees, and calm water.",
            georgian: "იფიქრე კლდეებზე, ხეებზე და მშვიდ წყალზე."
        ),
        successFeedback: "Correct. Every animal is in its habitat.",
        localizedSuccessFeedback: LocalizedContentText(
            english: "Correct. Every animal is in its habitat.",
            georgian: "სწორია. თითოეული ცხოველი თავის ჰაბიტატშია."
        ),
        failureFeedback: "Try again. Each habitat has different shelter and food.",
        localizedFailureFeedback: LocalizedContentText(
            english: "Try again. Each habitat has different shelter and food.",
            georgian: "სცადე კიდევ ერთხელ. თითოეულ ჰაბიტატს თავისი თავშესაფარი და საკვები აქვს."
        )
    )

    static let sampleSequencing = MissionActivity(
        id: "food-chain-sequence",
        type: .sequencing,
        instruction: "Put the food chain in the right order.",
        localizedInstruction: LocalizedContentText(
            english: "Put the food chain in the right order.",
            georgian: "დაალაგე საკვები ჯაჭვი სწორ რიგში."
        ),
        question: "What comes first, second, and third?",
        localizedQuestion: LocalizedContentText(
            english: "What comes first, second, and third?",
            georgian: "რა მოდის პირველ, მეორე და მესამე ადგილზე?"
        ),
        imageName: nil,
        narrationFileName: "food_chain_sequence_instruction",
        narrationFileNameEnglish: "food_chain_sequence_instruction_en",
        narrationFileNameGeorgian: "food_chain_sequence_instruction_ka",
        options: [],
        categories: nil,
        sequenceItems: [
            SequenceItem(id: "grass", text: "Grass", localizedText: LocalizedContentText(english: "Grass", georgian: "ბალახი"), imageName: nil, correctPosition: 1),
            SequenceItem(id: "deer", text: "Deer", localizedText: LocalizedContentText(english: "Deer", georgian: "ირემი"), imageName: nil, correctPosition: 2),
            SequenceItem(id: "wolf", text: "Wolf", localizedText: LocalizedContentText(english: "Wolf", georgian: "მგელი"), imageName: nil, correctPosition: 3)
        ],
        habitatZones: nil,
        correctAnswerIDs: [],
        hint: "Plants are eaten by herbivores, and herbivores are eaten by predators.",
        localizedHint: LocalizedContentText(
            english: "Plants are eaten by herbivores, and herbivores are eaten by predators.",
            georgian: "მცენარეებს ჭამენ ბალახისმჭამელები, ხოლო მათ თავად ჭამენ მტაცებლები."
        ),
        successFeedback: "Correct. The food chain starts with grass.",
        localizedSuccessFeedback: LocalizedContentText(
            english: "Correct. The food chain starts with grass.",
            georgian: "სწორია. საკვები ჯაჭვი ბალახით იწყება."
        ),
        failureFeedback: "Try again. Think about who eats whom.",
        localizedFailureFeedback: LocalizedContentText(
            english: "Try again. Think about who eats whom.",
            georgian: "სცადე კიდევ ერთხელ. იფიქრე, ვინ ვის ჭამს."
        )
    )

    static let sampleHabitatPlacement = MissionActivity(
        id: "habitat-placement-sort",
        type: .habitatPlacement,
        instruction: "Place each animal into the habitat where it belongs.",
        localizedInstruction: LocalizedContentText(
            english: "Place each animal into the habitat where it belongs.",
            georgian: "მოათავსე თითოეული ცხოველი მისთვის შესაფერის ჰაბიტატში."
        ),
        question: "Choose mountain, forest, or wetland for each item.",
        localizedQuestion: LocalizedContentText(
            english: "Choose mountain, forest, or wetland for each item.",
            georgian: "აირჩიე მთის, ტყის ან ჭაობის ჰაბიტატი თითოეული ნივთისთვის."
        ),
        imageName: nil,
        narrationFileName: "habitat_placement_instruction",
        narrationFileNameEnglish: "habitat_placement_instruction_en",
        narrationFileNameGeorgian: "habitat_placement_instruction_ka",
        options: [
            ActivityOption(id: "tur", text: "Caucasian tur", localizedText: LocalizedContentText(english: "Caucasian tur", georgian: "ჯიხვი"), imageName: "caucasian_tur", pairID: nil, categoryID: nil),
            ActivityOption(id: "bear", text: "Brown bear", localizedText: LocalizedContentText(english: "Brown bear", georgian: "დათვი"), imageName: "brown_bear", pairID: nil, categoryID: nil),
            ActivityOption(id: "frog", text: "Marsh frog", localizedText: LocalizedContentText(english: "Marsh frog", georgian: "ჭაობის ბაყაყი"), imageName: "marsh_frog", pairID: nil, categoryID: nil)
        ],
        categories: nil,
        sequenceItems: nil,
        habitatZones: [
            HabitatZone(id: "mountain", title: "Mountain", localizedTitle: LocalizedContentText(english: "Mountain", georgian: "მთა"), imageName: nil, acceptedItemIDs: ["tur"]),
            HabitatZone(id: "forest", title: "Forest", localizedTitle: LocalizedContentText(english: "Forest", georgian: "ტყე"), imageName: nil, acceptedItemIDs: ["bear"]),
            HabitatZone(id: "wetland", title: "Wetland", localizedTitle: LocalizedContentText(english: "Wetland", georgian: "ჭაობი"), imageName: nil, acceptedItemIDs: ["frog"])
        ],
        correctAnswerIDs: [],
        hint: "Match each animal to the place it naturally lives.",
        localizedHint: LocalizedContentText(
            english: "Match each animal to the place it naturally lives.",
            georgian: "შეადარე თითოეული ცხოველი იმ ადგილს, სადაც ის ბუნებრივად ცხოვრობს."
        ),
        successFeedback: "Correct. Each animal is in the right habitat.",
        localizedSuccessFeedback: LocalizedContentText(
            english: "Correct. Each animal is in the right habitat.",
            georgian: "სწორია. თითოეული ცხოველი სწორ ჰაბიტატშია."
        ),
        failureFeedback: "Try again. Think about cliffs, trees, and calm water.",
        localizedFailureFeedback: LocalizedContentText(
            english: "Try again. Think about cliffs, trees, and calm water.",
            georgian: "სცადე კიდევ ერთხელ. იფიქრე კლდეებზე, ხეებზე და მშვიდ წყალზე."
        )
    )

    static let sampleFiveActivityMission = Mission(
        id: "mountain-wildlife-path",
        title: "Mountain Wildlife Path",
        localizedTitle: LocalizedContentText(
            english: "Mountain Wildlife Path",
            georgian: "მთის ველური ბუნების გზა"
        ),
        subtitle: "Try every core activity type",
        localizedSubtitle: LocalizedContentText(
            english: "Try every core activity type",
            georgian: "გამოსცადე ყველა ძირითადი აქტივობის ტიპი"
        ),
        introduction: "Work through five activities to find the animals, sort them, and place them in the right order and habitat.",
        localizedIntroduction: LocalizedContentText(
            english: "Work through five activities to find the animals, sort them, and place them in the right order and habitat.",
            georgian: "შეასრულე ხუთი აქტივობა, რათა იპოვო ცხოველები, დაალაგო ისინი და მოათავსო სწორ რიგსა და ჰაბიტატში."
        ),
        ecosystemID: "caucasus-mountains",
        difficulty: .beginner,
        estimatedMinutes: 10,
        activityIDs: [
            sample.id,
            sampleMatching.id,
            sampleClassification.id,
            sampleSequencing.id,
            sampleHabitatPlacement.id
        ],
        learningTopics: ["habitats", "animalIdentification", "foodChains", "observation"],
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
