import Foundation

protocol ContentPackStoring {
    func loadStates() throws -> [String: ContentPackState]
    func saveStates(_ states: [String: ContentPackState]) throws
    func resetStates() throws
}

struct UserDefaultsContentPackStore: ContentPackStoring {
    private let userDefaults: UserDefaults
    private let storageKey = "wildSakartvelo.contentPackStates"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadStates() throws -> [String: ContentPackState] {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return [:]
        }

        do {
            return try decoder.decode([String: ContentPackState].self, from: data)
        } catch {
            AppLogger.downloads.error("Saved content pack states could not be decoded: \(error.localizedDescription, privacy: .public)")
            return [:]
        }
    }

    func saveStates(_ states: [String: ContentPackState]) throws {
        let data = try encoder.encode(states)
        userDefaults.set(data, forKey: storageKey)
    }

    func resetStates() throws {
        userDefaults.removeObject(forKey: storageKey)
    }
}
