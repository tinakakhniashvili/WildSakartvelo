import SwiftUI

enum AppShadows {
    static func small(using settings: AppAccessibilitySettings) -> (color: Color, radius: CGFloat, y: CGFloat) {
        settings.highContrastEnabled ? (.clear, 0, 0) : (.black.opacity(0.05), 5, 2)
    }

    static func card(using settings: AppAccessibilitySettings) -> (color: Color, radius: CGFloat, y: CGFloat) {
        settings.highContrastEnabled ? (.clear, 0, 0) : (.black.opacity(0.08), 10, 5)
    }

    static func modal(using settings: AppAccessibilitySettings) -> (color: Color, radius: CGFloat, y: CGFloat) {
        settings.highContrastEnabled ? (.clear, 0, 0) : (.black.opacity(0.14), 20, 10)
    }
}
