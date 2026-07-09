import Foundation

struct GeographyLandmark: Identifiable, Codable, Hashable {
    let id: String
    let name: LocalizedContentText
    let type: GeographyLandmarkType
    let regionID: String?
    let description: LocalizedContentText
    let imageName: String
    let mapPosition: MapPosition
}

enum GeographyLandmarkType: String, Codable, Hashable {
    case mountain
    case river
    case lake
    case sea
    case protectedArea
    case historicalSite
    case city
}
