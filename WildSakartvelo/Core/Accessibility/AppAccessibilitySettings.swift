import Foundation
import SwiftUI

struct AppAccessibilitySettings: Hashable {
    var largerTextEnabled: Bool
    var reducedMotionEnabled: Bool
    var highContrastEnabled: Bool
    var subtitlesEnabled: Bool

    static let defaultValue = AppAccessibilitySettings(
        largerTextEnabled: false,
        reducedMotionEnabled: false,
        highContrastEnabled: false,
        subtitlesEnabled: false
    )
}

private struct AppAccessibilitySettingsKey: EnvironmentKey {
    static let defaultValue = AppAccessibilitySettings.defaultValue
}

extension EnvironmentValues {
    var appAccessibilitySettings: AppAccessibilitySettings {
        get { self[AppAccessibilitySettingsKey.self] }
        set { self[AppAccessibilitySettingsKey.self] = newValue }
    }
}
