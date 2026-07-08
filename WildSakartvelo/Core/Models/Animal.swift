struct Animal: Identifiable, Codable, Hashable {
    let id: String
    let georgianName: String
    let englishName: String
    let scientificName: String
    let summary: String
    let localizedSummary: LocalizedContentText?
    let habitat: String
    let localizedHabitat: LocalizedContentText?
    let diet: String
    let localizedDiet: LocalizedContentText?
    let sizeDescription: String
    let localizedSizeDescription: LocalizedContentText?
    let surprisingFact: String
    let localizedSurprisingFact: LocalizedContentText?
    let imageName: String
    let footprintImageName: String?
    let soundFileName: String?
    let conservationStatus: ConservationStatus
    let ecosystemIDs: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case georgianName
        case englishName
        case scientificName
        case summary
        case localizedSummary
        case habitat
        case localizedHabitat
        case diet
        case localizedDiet
        case sizeDescription
        case localizedSizeDescription
        case surprisingFact
        case localizedSurprisingFact
        case imageName
        case footprintImageName
        case soundFileName
        case conservationStatus
        case ecosystemIDs
    }

    init(
        id: String,
        georgianName: String,
        englishName: String,
        scientificName: String,
        summary: String,
        localizedSummary: LocalizedContentText?,
        habitat: String,
        localizedHabitat: LocalizedContentText?,
        diet: String,
        localizedDiet: LocalizedContentText?,
        sizeDescription: String,
        localizedSizeDescription: LocalizedContentText?,
        surprisingFact: String,
        localizedSurprisingFact: LocalizedContentText?,
        imageName: String,
        footprintImageName: String?,
        soundFileName: String?,
        conservationStatus: ConservationStatus,
        ecosystemIDs: [String]
    ) {
        self.id = id
        self.georgianName = georgianName
        self.englishName = englishName
        self.scientificName = scientificName
        self.summary = summary
        self.localizedSummary = localizedSummary
        self.habitat = habitat
        self.localizedHabitat = localizedHabitat
        self.diet = diet
        self.localizedDiet = localizedDiet
        self.sizeDescription = sizeDescription
        self.localizedSizeDescription = localizedSizeDescription
        self.surprisingFact = surprisingFact
        self.localizedSurprisingFact = localizedSurprisingFact
        self.imageName = imageName
        self.footprintImageName = footprintImageName
        self.soundFileName = soundFileName
        self.conservationStatus = conservationStatus
        self.ecosystemIDs = ecosystemIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        georgianName = try container.decode(String.self, forKey: .georgianName)
        englishName = try container.decode(String.self, forKey: .englishName)
        scientificName = try container.decode(String.self, forKey: .scientificName)
        summary = try container.decode(String.self, forKey: .summary)
        localizedSummary = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedSummary)
        habitat = try container.decode(String.self, forKey: .habitat)
        localizedHabitat = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedHabitat)
        diet = try container.decode(String.self, forKey: .diet)
        localizedDiet = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedDiet)
        sizeDescription = try container.decode(String.self, forKey: .sizeDescription)
        localizedSizeDescription = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedSizeDescription)
        surprisingFact = try container.decode(String.self, forKey: .surprisingFact)
        localizedSurprisingFact = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedSurprisingFact)
        imageName = try container.decode(String.self, forKey: .imageName)
        footprintImageName = try container.decodeIfPresent(String.self, forKey: .footprintImageName)
        soundFileName = try container.decodeIfPresent(String.self, forKey: .soundFileName)
        conservationStatus = try container.decode(ConservationStatus.self, forKey: .conservationStatus)
        ecosystemIDs = try container.decode([String].self, forKey: .ecosystemIDs)
    }
}

extension Animal {
    static let sample = Animal(
        id: "caucasian-tur",
        georgianName: "ჯიხვი",
        englishName: "Caucasian Tur",
        scientificName: "Capra caucasica",
        summary: "A sure-footed wild goat that lives on steep rocky slopes in the Greater Caucasus.",
        localizedSummary: LocalizedContentText(
            english: "A sure-footed wild goat that lives on steep rocky slopes in the Greater Caucasus.",
            georgian: "გაფრთხილებულად მოძრავი ველური თხა, რომელიც დიდ კავკასიონის ციცაბო კლდოვან ფერდობებზე ცხოვრობს."
        ),
        habitat: "Alpine meadows, cliffs, and high mountain ridges.",
        localizedHabitat: LocalizedContentText(
            english: "Alpine meadows, cliffs, and high mountain ridges.",
            georgian: "ალპური მდელოები, კლდეები და მაღალი მთის ქედები."
        ),
        diet: "Mountain grasses, herbs, leaves, and young shoots.",
        localizedDiet: LocalizedContentText(
            english: "Mountain grasses, herbs, leaves, and young shoots.",
            georgian: "მთის ბალახები, ბალახეულობა, ფოთლები და ახალგაზრდა ყლორტები."
        ),
        sizeDescription: "A large mountain goat with strong legs and curved horns.",
        localizedSizeDescription: LocalizedContentText(
            english: "A large mountain goat with strong legs and curved horns.",
            georgian: "დიდი მთის თხა ძლიერი ფეხებითა და მოხრილი რქებით."
        ),
        surprisingFact: "Caucasian turs can move across narrow cliff ledges that would be difficult for most animals.",
        localizedSurprisingFact: LocalizedContentText(
            english: "Caucasian turs can move across narrow cliff ledges that would be difficult for most animals.",
            georgian: "ჯიხვებს შეუძლიათ ვიწრო კლდის ბილიკებზე გადაადგილება, რაც უმეტეს ცხოველებს გაუჭირდებოდათ."
        ),
        imageName: "caucasian_tur",
        footprintImageName: "caucasian_tur_footprint",
        soundFileName: "caucasian_tur_sound",
        conservationStatus: .protected,
        ecosystemIDs: ["caucasus-mountains"]
    )
}
