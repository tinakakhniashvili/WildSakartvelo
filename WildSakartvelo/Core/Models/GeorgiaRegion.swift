import Foundation

struct GeorgiaRegion: Identifiable, Codable, Hashable {
    let id: String
    let name: LocalizedContentText
    let administrativeCenter: LocalizedContentText
    let description: LocalizedContentText
    let mapShapeID: String
    let imageName: String
    let fact: LocalizedContentText
    let cityIDs: [String]
    let landmarkIDs: [String]
    let neighboringRegionIDs: [String]
    let ecosystemIDs: [String]
    let mapPosition: MapPosition
}

struct MapPosition: Codable, Hashable {
    let x: Double
    let y: Double
}
