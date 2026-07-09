import Foundation

struct GeographyProgress: Codable, Hashable {
    var completedGeographyMissionIDs: Set<String>
    var discoveredRegionIDs: Set<String>
    var learnedAdministrativeCenterIDs: Set<String>
    var discoveredLandmarkIDs: Set<String>
    var bestResultsByMissionID: [String: Int]

    static let empty = GeographyProgress(
        completedGeographyMissionIDs: [],
        discoveredRegionIDs: [],
        learnedAdministrativeCenterIDs: [],
        discoveredLandmarkIDs: [],
        bestResultsByMissionID: [:]
    )
}
