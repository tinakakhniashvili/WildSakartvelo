import Foundation

protocol ProfileStoring {
    func loadProfiles() throws -> [ChildProfile]
    func saveProfiles(_ profiles: [ChildProfile]) throws
    func loadSelectedProfileID() -> UUID?
    func saveSelectedProfileID(_ id: UUID?)
    func deleteAllProfiles() throws
}
