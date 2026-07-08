import Foundation

protocol ProgressStoring {
    func loadProgress(for profileID: UUID) throws -> UserProgress
    func saveProgress(_ progress: UserProgress, for profileID: UUID) throws
    func resetProgress(for profileID: UUID) throws
    func deleteProgress(for profileID: UUID) throws
}
