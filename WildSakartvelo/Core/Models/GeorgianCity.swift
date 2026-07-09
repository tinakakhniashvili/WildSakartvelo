import Foundation

struct GeorgianCity: Identifiable, Codable, Hashable {
    let id: String
    let name: LocalizedContentText
    let regionID: String
    let description: LocalizedContentText
    let imageName: String
    let isAdministrativeCenter: Bool
    let mapPosition: MapPosition
    let fact: LocalizedContentText
}
