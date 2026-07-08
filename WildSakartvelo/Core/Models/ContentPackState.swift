import Foundation

enum ContentPackStatus: Codable, Hashable {
    case notDownloaded
    case downloading
    case downloaded
    case failed
}

struct ContentPackState: Codable, Hashable {
    let packID: String
    var status: ContentPackStatus
    var progress: Double
    var installedVersion: Int?
    var errorMessage: String?
}
