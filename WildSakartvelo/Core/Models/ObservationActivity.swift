struct ObservationActivity: Identifiable, Codable, Hashable {
    let id: String
    let title: LocalizedContentText
    let instruction: LocalizedContentText
    let safetyMessage: LocalizedContentText
    let ecosystemID: String?
    let rewardBadgeID: String?
    let activityType: ObservationActivityType
}

enum ObservationActivityType: String, Codable, Hashable {
    case draw
    case listen
    case compare
    case count
    case weather
    case notice
}
