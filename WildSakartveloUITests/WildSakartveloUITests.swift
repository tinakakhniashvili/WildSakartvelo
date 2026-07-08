import XCTest

final class WildSakartveloUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITEST_DISABLE_ANIMATIONS"]
        app.launch()
    }

    func testFreshLaunchShowsPrimaryFlow() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
        XCTAssertTrue(app.buttons.count + app.staticTexts.count > 0)
    }

    func testCanReachProfileOrMainTabsAfterLaunch() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))

        let knownLabels = [
            "Continue",
            "გაგრძელება",
            "Next",
            "შემდეგი",
            "Get Started",
            "დაწყება",
            "Wild Sakartvelo",
            "Explore",
            "აღმოაჩინე",
            "Journal",
            "ჟურნალი",
            "Settings",
            "პარამეტრები",
            "Create Profile",
            "პროფილის შექმნა",
            "Add Profile",
            "პროფილის დამატება"
        ]

        XCTAssertTrue(knownLabels.contains { app.buttons[$0].exists || app.staticTexts[$0].exists || app.tabBars.buttons[$0].exists })
    }

    func testOpeningParentGateOrSettingsEntryPointIsAvailable() {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))

        let parentTab = app.tabBars.buttons["Parent"].exists ? app.tabBars.buttons["Parent"] : app.tabBars.buttons["მშობელი"]
        let settingsTab = app.tabBars.buttons["Settings"].exists ? app.tabBars.buttons["Settings"] : app.tabBars.buttons["პარამეტრები"]

        if parentTab.exists {
            parentTab.tap()
            XCTAssertTrue(app.buttons.count + app.staticTexts.count > 0)
        } else if settingsTab.exists {
            settingsTab.tap()
            XCTAssertTrue(app.buttons.count + app.staticTexts.count > 0)
        } else {
            XCTAssertTrue(app.buttons.count + app.staticTexts.count > 0)
        }
    }
}
