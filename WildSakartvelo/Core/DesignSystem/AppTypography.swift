import SwiftUI

enum AppTypography {
    static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let screenTitle = Font.system(.title, design: .rounded, weight: .bold)
    static let cardTitle = Font.system(.title3, design: .rounded, weight: .semibold)
    static let body = Font.system(.body, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded)
    static let button = Font.system(.headline, design: .rounded, weight: .semibold)

    static func largeTitleFont(using settings: AppAccessibilitySettings = .defaultValue) -> Font {
        .system(settings.largerTextEnabled ? .largeTitle : .title, design: .rounded, weight: .bold)
    }

    static func screenTitleFont(using settings: AppAccessibilitySettings = .defaultValue) -> Font {
        .system(settings.largerTextEnabled ? .title : .title2, design: .rounded, weight: .bold)
    }

    static func cardTitleFont(using settings: AppAccessibilitySettings = .defaultValue) -> Font {
        .system(settings.largerTextEnabled ? .title3 : .headline, design: .rounded, weight: .semibold)
    }

    static func bodyFont(using settings: AppAccessibilitySettings = .defaultValue) -> Font {
        .system(settings.largerTextEnabled ? .body : .callout, design: .rounded)
    }

    static func captionFont(using settings: AppAccessibilitySettings = .defaultValue) -> Font {
        .system(settings.largerTextEnabled ? .callout : .caption, design: .rounded)
    }

    static func buttonFont(using settings: AppAccessibilitySettings = .defaultValue) -> Font {
        .system(settings.largerTextEnabled ? .headline : .subheadline, design: .rounded, weight: .semibold)
    }
}
