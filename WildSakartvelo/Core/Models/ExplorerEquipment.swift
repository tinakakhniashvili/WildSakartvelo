struct ExplorerEquipment: Identifiable, Hashable {
    let id: String
    let title: LocalizedContentText
    let description: LocalizedContentText
    let imageName: String
    let unlockRequirement: EquipmentUnlockRequirement
}

enum EquipmentUnlockRequirement: Hashable {
    case completedMissionCount(Int)
    case discoveredAnimalCount(Int)
    case discoveredPlantCount(Int)
    case completedEcosystem(String)
    case earnedBadge(String)
}
