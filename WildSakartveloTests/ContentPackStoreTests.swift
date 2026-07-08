import XCTest
@testable import WildSakartvelo

final class ContentPackStoreTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var store: UserDefaultsContentPackStore!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "WildSakartvelo.ContentPackStoreTests.\(UUID().uuidString)")!
        store = UserDefaultsContentPackStore(userDefaults: userDefaults)
    }

    func testInitialStateIsEmpty() throws {
        XCTAssertTrue(try store.loadStates().isEmpty)
    }

    func testSavingDownloadedFailedDeletingAndSeparateStates() throws {
        let downloaded = ContentPackState(packID: "pack-a", status: .downloaded, progress: 1, installedVersion: 2, errorMessage: nil)
        let failed = ContentPackState(packID: "pack-b", status: .failed, progress: 0.25, installedVersion: nil, errorMessage: "Network error")

        try store.saveStates(["pack-a": downloaded, "pack-b": failed])
        var states = try store.loadStates()
        XCTAssertEqual(states["pack-a"]?.installedVersion, 2)
        XCTAssertEqual(states["pack-b"]?.status, .failed)

        states.removeValue(forKey: "pack-a")
        try store.saveStates(states)
        XCTAssertNil(try store.loadStates()["pack-a"])
        XCTAssertEqual(try store.loadStates()["pack-b"], failed)

        try store.resetStates()
        XCTAssertTrue(try store.loadStates().isEmpty)
    }
}
