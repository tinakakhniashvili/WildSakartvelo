import Foundation

struct ChildProfile: Identifiable, Codable, Hashable {
    let id: UUID
    var nickname: String
    var avatarID: String
    var learningLevel: LearningLevel
    let createdAt: Date
    var lastOpenedAt: Date

    static let sample = ChildProfile(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        nickname: "Nini",
        avatarID: "fox",
        learningLevel: .explorerOne,
        createdAt: Date(timeIntervalSince1970: 1_735_689_600),
        lastOpenedAt: Date(timeIntervalSince1970: 1_735_689_600)
    )
}
