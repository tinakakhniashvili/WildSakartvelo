struct Ecosystem: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let localizedName: LocalizedContentText?
    let subtitle: String
    let localizedSubtitle: LocalizedContentText?
    let description: String
    let localizedDescription: LocalizedContentText?
    let imageName: String
    let theme: EcosystemTheme
    let animalIDs: [String]
    let plantIDs: [String]
    let missionIDs: [String]
    let isInitiallyUnlocked: Bool
}

extension Ecosystem {
    static let sample = Ecosystem(
        id: "caucasus-mountains",
        name: "Caucasus Mountains",
        localizedName: LocalizedContentText(
            english: "Caucasus Mountains",
            georgian: "კავკასიონის მთები"
        ),
        subtitle: "High ridges, alpine meadows, and rocky cliffs",
        localizedSubtitle: LocalizedContentText(
            english: "High ridges, alpine meadows, and rocky cliffs",
            georgian: "მაღალი ქედები, ალპური მდელოები და კლდოვანი ფერდობები"
        ),
        description: "The Caucasus Mountains are home to hardy wildlife, rare plants, and habitats shaped by snow, wind, and steep slopes.",
        localizedDescription: LocalizedContentText(
            english: "The Caucasus Mountains are home to hardy wildlife, rare plants, and habitats shaped by snow, wind, and steep slopes.",
            georgian: "კავკასიონის მთებში ბინადრობენ გამძლე ცხოველები, იშვიათი მცენარეები და თოვლით, ქარითა და ციცაბო ფერდობებით ჩამოყალიბებული ჰაბიტატები."
        ),
        imageName: "caucasus_mountains",
        theme: .mountain,
        animalIDs: ["caucasian-tur"],
        plantIDs: ["caucasus-rhododendron"],
        missionIDs: ["mountain-habitat-discovery"],
        isInitiallyUnlocked: true
    )
}
