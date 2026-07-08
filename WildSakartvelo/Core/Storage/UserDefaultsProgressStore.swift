import Foundation

struct UserDefaultsProgressStore: ProgressStoring {
    private let keyPrefix = "wildSakartvelo.progress."
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadProgress(for profileID: UUID) throws -> UserProgress {
        guard let data = userDefaults.data(forKey: storageKey(for: profileID)) else {
            return .empty
        }

        do {
            return try JSONDecoder().decode(UserProgress.self, from: data)
        } catch {
            throw ContentError.invalidData("Saved progress could not be decoded: \(error.localizedDescription)")
        }
    }

    func saveProgress(_ progress: UserProgress, for profileID: UUID) throws {
        do {
            let data = try JSONEncoder().encode(progress)
            userDefaults.set(data, forKey: storageKey(for: profileID))
        } catch {
            throw ContentError.invalidData("Progress could not be saved: \(error.localizedDescription)")
        }
    }

    func resetProgress(for profileID: UUID) throws {
        try saveProgress(.empty, for: profileID)
    }

    func deleteProgress(for profileID: UUID) throws {
        userDefaults.removeObject(forKey: storageKey(for: profileID))
    }

    private func storageKey(for profileID: UUID) -> String {
        "\(keyPrefix)\(profileID.uuidString)"
    }
}
