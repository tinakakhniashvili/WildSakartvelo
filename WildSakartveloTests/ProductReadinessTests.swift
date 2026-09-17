import XCTest

final class ProductReadinessTests: XCTestCase {
    func testPrivacyManifestDeclaresRequiredReasonAPIs() throws {
        let manifest = try loadPlist(named: "PrivacyInfo", extension: "xcprivacy")

        XCTAssertEqual(manifest["NSPrivacyTracking"] as? Bool, false)
        XCTAssertEqual((manifest["NSPrivacyCollectedDataTypes"] as? [Any])?.count, 0)

        let accessedAPIs = try XCTUnwrap(manifest["NSPrivacyAccessedAPITypes"] as? [[String: Any]])
        let reasonsByCategory = Dictionary(
            uniqueKeysWithValues: accessedAPIs.compactMap { entry -> (String, [String])? in
                guard let category = entry["NSPrivacyAccessedAPIType"] as? String,
                      let reasons = entry["NSPrivacyAccessedAPITypeReasons"] as? [String] else {
                    return nil
                }
                return (category, reasons)
            }
        )

        XCTAssertEqual(reasonsByCategory["NSPrivacyAccessedAPICategoryUserDefaults"], ["CA92.1"])
        XCTAssertEqual(reasonsByCategory["NSPrivacyAccessedAPICategoryDiskSpace"], ["E174.1"])
    }

    func testInfoPlistSupportsIPadOrientationsForUniversalProduct() throws {
        let info = try loadPlist(named: "Info", extension: "plist")

        XCTAssertEqual(info["CFBundleDisplayName"] as? String, "Wild Sakartvelo")
        XCTAssertEqual(
            info["UISupportedInterfaceOrientations"] as? [String],
            ["UIInterfaceOrientationPortrait"]
        )

        let ipadOrientations = info["UISupportedInterfaceOrientations~ipad"] as? [String]
        XCTAssertEqual(Set(ipadOrientations ?? []), [
            "UIInterfaceOrientationPortrait",
            "UIInterfaceOrientationPortraitUpsideDown",
            "UIInterfaceOrientationLandscapeLeft",
            "UIInterfaceOrientationLandscapeRight"
        ])
    }

    private func loadPlist(named name: String, extension fileExtension: String) throws -> [String: Any] {
        let url = try XCTUnwrap(Bundle.main.url(forResource: name, withExtension: fileExtension))
        let data = try Data(contentsOf: url)
        let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
        return try XCTUnwrap(plist as? [String: Any])
    }
}
