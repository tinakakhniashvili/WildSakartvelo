import XCTest
@testable import WildSakartvelo

final class ProfileStoreTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var store: UserDefaultsProfileStore!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "WildSakartvelo.ProfileStoreTests.\(UUID().uuidString)")!
        store = UserDefaultsProfileStore(userDefaults: userDefaults)
    }

    func testSaveLoadSelectUpdateAndDeleteProfiles() throws {
        let first = ChildProfile.sample
        var second = ChildProfile(
            id: UUID(),
            nickname: "Gio",
            avatarID: "bear",
            learningLevel: .explorerTwo,
            createdAt: Date(),
            lastOpenedAt: Date()
        )

        try store.saveProfiles([first, second])
        store.saveSelectedProfileID(first.id)

        XCTAssertEqual(try store.loadProfiles().count, 2)
        XCTAssertEqual(store.loadSelectedProfileID(), first.id)

        second.nickname = "Giorgi"
        try store.saveProfiles([first, second])
        XCTAssertEqual(try store.loadProfiles().first(where: { $0.id == second.id })?.nickname, "Giorgi")

        try store.saveProfiles([second])
        XCTAssertEqual(try store.loadProfiles(), [second])
    }

    @MainActor
    func testProfileLimitIsEnforcedByAppState() {
        let state = AppState(userDefaults: userDefaults, settingsStore: UserDefaultsSettingsStore(userDefaults: userDefaults))
        state.profiles = [
            ChildProfile.sample,
            ChildProfile(id: UUID(), nickname: "A", avatarID: "fox", learningLevel: .explorerOne, createdAt: Date(), lastOpenedAt: Date()),
            ChildProfile(id: UUID(), nickname: "B", avatarID: "fox", learningLevel: .explorerOne, createdAt: Date(), lastOpenedAt: Date()),
            ChildProfile(id: UUID(), nickname: "C", avatarID: "fox", learningLevel: .explorerOne, createdAt: Date(), lastOpenedAt: Date())
        ]
        XCTAssertFalse(state.canCreateProfile)
    }
}
