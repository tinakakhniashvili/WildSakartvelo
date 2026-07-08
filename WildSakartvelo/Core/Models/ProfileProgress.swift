import Foundation

struct ProfileProgress: Codable, Hashable {
    var profileID: UUID
    var progress: UserProgress

    static func empty(for profileID: UUID) -> ProfileProgress {
        ProfileProgress(profileID: profileID, progress: .empty)
    }
}
