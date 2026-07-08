import SwiftUI

enum AppColors {
    static let background = Color(
        uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1)
                : UIColor(red: 0.97, green: 0.96, blue: 0.91, alpha: 1)
        }
    )
    static let surface = Color(
        uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(red: 0.10, green: 0.13, blue: 0.12, alpha: 1)
                : UIColor(red: 1.00, green: 0.99, blue: 0.95, alpha: 1)
        }
    )
    static let forest = Color(red: 0.12, green: 0.43, blue: 0.27)
    static let water = Color(red: 0.10, green: 0.48, blue: 0.68)
    static let mountain = Color(red: 0.39, green: 0.49, blue: 0.52)
    static let sunshine = Color(red: 0.92, green: 0.66, blue: 0.18)
    static let primaryText = Color(uiColor: .label)
    static let secondaryText = Color(uiColor: .secondaryLabel)
    static let success = Color(red: 0.20, green: 0.58, blue: 0.35)
    static let warning = Color(red: 0.78, green: 0.52, blue: 0.12)

    static func cardBorder(using settings: AppAccessibilitySettings) -> Color {
        settings.highContrastEnabled ? Color(uiColor: .label) : secondaryText.opacity(0.14)
    }

    static func cardShadow(using settings: AppAccessibilitySettings) -> Color {
        settings.highContrastEnabled ? .clear : .black.opacity(0.06)
    }

    static func progressTint(using settings: AppAccessibilitySettings) -> Color {
        settings.highContrastEnabled ? .black : forest
    }

    static func statusColor(_ baseColor: Color, using settings: AppAccessibilitySettings) -> Color {
        settings.highContrastEnabled ? .primary : baseColor
    }

    static func selectionFill(using settings: AppAccessibilitySettings) -> Color {
        settings.highContrastEnabled ? Color(uiColor: .label).opacity(0.16) : forest.opacity(0.12)
    }

    static func lockedFill(using settings: AppAccessibilitySettings) -> Color {
        settings.highContrastEnabled ? Color(uiColor: .secondaryLabel).opacity(0.18) : secondaryText.opacity(0.14)
    }
}
