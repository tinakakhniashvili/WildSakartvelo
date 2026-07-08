struct DailyDiscovery: Identifiable, Codable, Hashable {
    let id: String
    let title: LocalizedContentText
    let description: LocalizedContentText
    let imageName: String
    let relatedAnimalID: String?
    let relatedPlantID: String?
    let relatedEcosystemID: String?
    let factType: DailyDiscoveryType
}

enum DailyDiscoveryType: String, Codable, Hashable {
    case animalFact
    case plantFact
    case ecosystemFact
    case observationTip
    case environmentTip
}
