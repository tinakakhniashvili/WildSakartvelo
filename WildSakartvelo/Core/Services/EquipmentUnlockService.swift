struct EquipmentUnlockService {
    private let calculator = ProgressCalculator()

    let equipment: [ExplorerEquipment] = [
        ExplorerEquipment(
            id: "field-notebook",
            title: LocalizedContentText(english: "Field Notebook", georgian: "მკვლევრის რვეული"),
            description: LocalizedContentText(english: "A place to remember discoveries.", georgian: "ადგილი აღმოჩენების დასამახსოვრებლად."),
            imageName: "app_logo",
            unlockRequirement: .completedMissionCount(1)
        ),
        ExplorerEquipment(
            id: "binoculars",
            title: LocalizedContentText(english: "Binoculars", georgian: "ბინოკლი"),
            description: LocalizedContentText(english: "Look closely from a safe distance.", georgian: "დააკვირდი უსაფრთხო მანძილიდან."),
            imageName: "mission_adventure",
            unlockRequirement: .discoveredAnimalCount(3)
        ),
        ExplorerEquipment(
            id: "compass",
            title: LocalizedContentText(english: "Compass", georgian: "კომპასი"),
            description: LocalizedContentText(english: "A symbol of careful exploring.", georgian: "ფრთხილი კვლევის სიმბოლო."),
            imageName: "onboarding_map",
            unlockRequirement: .completedMissionCount(4)
        ),
        ExplorerEquipment(
            id: "track-guide",
            title: LocalizedContentText(english: "Track Guide", georgian: "ნაკვალევის გზამკვლევი"),
            description: LocalizedContentText(english: "Compare clues without disturbing animals.", georgian: "შეადარე ნიშნები ცხოველების შეწუხების გარეშე."),
            imageName: "empty_journal",
            unlockRequirement: .earnedBadge("first-observation")
        ),
        ExplorerEquipment(
            id: "plant-magnifier",
            title: LocalizedContentText(english: "Plant Magnifier", georgian: "მცენარის გამადიდებელი"),
            description: LocalizedContentText(english: "Notice shapes, colors, and patterns.", georgian: "შენიშნე ფორმები, ფერები და მოხატულობა."),
            imageName: "caucasus_rhododendron",
            unlockRequirement: .discoveredPlantCount(3)
        ),
        ExplorerEquipment(
            id: "explorer-backpack",
            title: LocalizedContentText(english: "Explorer Backpack", georgian: "მკვლევრის ზურგჩანთა"),
            description: LocalizedContentText(english: "Ready for the next ecosystem.", georgian: "მზად ხარ შემდეგი ეკოსისტემისთვის."),
            imageName: "onboarding_welcome",
            unlockRequirement: .completedEcosystem("borjomi-forest")
        )
    ]

    func isUnlocked(_ equipment: ExplorerEquipment, catalogue: ContentCatalogue, progress: UserProgress) -> Bool {
        let values = calculator.equipmentProgress(for: equipment.unlockRequirement, catalogue: catalogue, progress: progress)
        return values.current >= values.target
    }

    func featuredEquipment(catalogue: ContentCatalogue, progress: UserProgress) -> ExplorerEquipment? {
        equipment.last { isUnlocked($0, catalogue: catalogue, progress: progress) } ?? equipment.first
    }

    func requirementText(for requirement: EquipmentUnlockRequirement, language: AppLanguage) -> String {
        switch requirement {
        case .completedMissionCount(let count):
            return language == .georgian ? "დაასრულე \(count) მისია." : "Complete \(count) missions."
        case .discoveredAnimalCount(let count):
            return language == .georgian ? "აღმოაჩინე \(count) ცხოველი." : "Discover \(count) animals."
        case .discoveredPlantCount(let count):
            return language == .georgian ? "აღმოაჩინე \(count) მცენარე." : "Discover \(count) plants."
        case .completedEcosystem:
            return language == .georgian ? "დაასრულე ერთი ეკოსისტემა." : "Complete an ecosystem."
        case .earnedBadge:
            return language == .georgian ? "მიიღე შესაბამისი ბეჯი." : "Earn the related badge."
        }
    }
}
