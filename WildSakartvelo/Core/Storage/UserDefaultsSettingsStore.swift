import Foundation

struct UserDefaultsSettingsStore: SettingsStoring {
    private let userDefaults: UserDefaults
    private let storageKey = "wildSakartvelo.appSettings"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadSettings() throws -> AppSettings {
        guard let data = userDefaults.data(forKey: storageKey) else {
            return .defaultValue
        }

        do {
            return try decoder.decode(AppSettings.self, from: data)
        } catch {
            AppLogger.content.error("Saved settings could not be decoded: \(error.localizedDescription, privacy: .public)")
            return .defaultValue
        }
    }

    func saveSettings(_ settings: AppSettings) throws {
        let data = try encoder.encode(settings)
        userDefaults.set(data, forKey: storageKey)
    }

    func resetSettings() throws {
        userDefaults.removeObject(forKey: storageKey)
    }
}
