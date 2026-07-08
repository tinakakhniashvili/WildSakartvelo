struct Plant: Identifiable, Codable, Hashable {
    let id: String
    let georgianName: String
    let englishName: String
    let description: String
    let localizedDescription: LocalizedContentText?
    let imageName: String
    let surprisingFact: String
    let localizedSurprisingFact: LocalizedContentText?
    let ecosystemIDs: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case georgianName
        case englishName
        case description
        case localizedDescription
        case imageName
        case surprisingFact
        case localizedSurprisingFact
        case ecosystemIDs
    }

    init(
        id: String,
        georgianName: String,
        englishName: String,
        description: String,
        localizedDescription: LocalizedContentText?,
        imageName: String,
        surprisingFact: String,
        localizedSurprisingFact: LocalizedContentText?,
        ecosystemIDs: [String]
    ) {
        self.id = id
        self.georgianName = georgianName
        self.englishName = englishName
        self.description = description
        self.localizedDescription = localizedDescription
        self.imageName = imageName
        self.surprisingFact = surprisingFact
        self.localizedSurprisingFact = localizedSurprisingFact
        self.ecosystemIDs = ecosystemIDs
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        georgianName = try container.decode(String.self, forKey: .georgianName)
        englishName = try container.decode(String.self, forKey: .englishName)
        description = try container.decode(String.self, forKey: .description)
        localizedDescription = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedDescription)
        imageName = try container.decode(String.self, forKey: .imageName)
        surprisingFact = try container.decode(String.self, forKey: .surprisingFact)
        localizedSurprisingFact = try container.decodeIfPresent(LocalizedContentText.self, forKey: .localizedSurprisingFact)
        ecosystemIDs = try container.decode([String].self, forKey: .ecosystemIDs)
    }
}

extension Plant {
    static let sample = Plant(
        id: "caucasus-rhododendron",
        georgianName: "დეკა",
        englishName: "Caucasus Rhododendron",
        description: "A hardy mountain shrub that grows near alpine meadows and slopes in the Caucasus.",
        localizedDescription: LocalizedContentText(
            english: "A hardy mountain shrub that grows near alpine meadows and slopes in the Caucasus.",
            georgian: "გამძლე მთის ბუჩქი, რომელიც კავკასიონის ალპურ მდელოებსა და ფერდობებზე იზრდება."
        ),
        imageName: "caucasus_rhododendron",
        surprisingFact: "Its dense patches can help protect fragile mountain soil from erosion.",
        localizedSurprisingFact: LocalizedContentText(
            english: "Its dense patches can help protect fragile mountain soil from erosion.",
            georgian: "მისი ხშირი გუნდა მყიფე მთის ნიადაგს ეროზიისგან იცავს."
        ),
        ecosystemIDs: ["caucasus-mountains"]
    )
}
