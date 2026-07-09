import Foundation

struct GeographyMission: Identifiable, Codable, Hashable {
    let id: String
    let title: LocalizedContentText
    let introduction: LocalizedContentText
    let regionIDs: [String]
    let activityIDs: [String]
    let difficulty: DifficultyLevel
    let reward: MissionReward
    let prerequisiteMissionIDs: [String]
}
