import Foundation

struct UserDefaultsProfileStore: ProfileStoring {
    private let profilesKey = "wildSakartvelo.childProfiles"
    private let selectedProfileKey = "wildSakartvelo.selectedChildProfileID"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func loadProfiles() throws -> [ChildProfile] {
        guard let data = userDefaults.data(forKey: profilesKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([ChildProfile].self, from: data)
        } catch {
            throw ContentError.invalidData("Saved profiles could not be decoded: \(error.localizedDescription)")
        }
    }

    func saveProfiles(_ profiles: [ChildProfile]) throws {
        do {
            let data = try JSONEncoder().encode(profiles)
            userDefaults.set(data, forKey: profilesKey)
        } catch {
            throw ContentError.invalidData("Profiles could not be saved: \(error.localizedDescription)")
        }
    }

    func loadSelectedProfileID() -> UUID? {
        guard let idString = userDefaults.string(forKey: selectedProfileKey) else {
            return nil
        }

        return UUID(uuidString: idString)
    }

    func saveSelectedProfileID(_ id: UUID?) {
        if let id {
            userDefaults.set(id.uuidString, forKey: selectedProfileKey)
        } else {
            userDefaults.removeObject(forKey: selectedProfileKey)
        }
    }

    func deleteAllProfiles() throws {
        userDefaults.removeObject(forKey: profilesKey)
        userDefaults.removeObject(forKey: selectedProfileKey)
    }
}
