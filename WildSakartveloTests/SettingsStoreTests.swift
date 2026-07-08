import XCTest
@testable import WildSakartvelo

final class SettingsStoreTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var store: UserDefaultsSettingsStore!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "WildSakartvelo.SettingsStoreTests.\(UUID().uuidString)")!
        store = UserDefaultsSettingsStore(userDefaults: userDefaults)
    }

    func testDefaultSettings() throws {
        XCTAssertEqual(try store.loadSettings(), .defaultValue)
    }

    func testSavingLanguageAndAccessibilitySettings() throws {
        var settings = AppSettings.defaultValue
        settings.language = .georgian
        settings.largerTextEnabled = true
        settings.highContrastEnabled = true

        try store.saveSettings(settings)

        let loaded = try store.loadSettings()
        XCTAssertEqual(loaded.language, .georgian)
        XCTAssertTrue(loaded.largerTextEnabled)
        XCTAssertTrue(loaded.highContrastEnabled)
    }

    func testLoadingOldSettingsWithMissingFields() throws {
        userDefaults.set(Data(#"{"language":"english"}"#.utf8), forKey: "wildSakartvelo.appSettings")
        let settings = try store.loadSettings()
        XCTAssertEqual(settings.language, .english)
        XCTAssertTrue(settings.narrationEnabled)
        XCTAssertFalse(settings.reducedMotionEnabled)
    }

    func testResetSettings() throws {
        var settings = AppSettings.defaultValue
        settings.language = .georgian
        try store.saveSettings(settings)
        try store.resetSettings()
        XCTAssertEqual(try store.loadSettings(), .defaultValue)
    }
}
