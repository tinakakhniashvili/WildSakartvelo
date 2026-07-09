import Foundation

struct GeographyActivity: Identifiable, Codable, Hashable {
    let id: String
    let type: GeographyActivityType
    let prompt: LocalizedContentText
    let correctRegionID: String?
    let correctCityID: String?
    let correctLandmarkID: String?
    let optionIDs: [String]
    let hint: LocalizedContentText
}

enum GeographyActivityType: String, Codable, Hashable {
    case regionSelection
    case cityPlacement
    case centerMatching
    case neighborSelection
    case landmarkPlacement
}
