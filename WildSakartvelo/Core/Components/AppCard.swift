import SwiftUI

struct AppCard<Content: View>: View {
    enum Variant {
        case standard
        case elevated
        case selected
        case locked
        case success
        case warning
    }

    var variant: Variant = .standard
    @ViewBuilder let content: Content
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        let shadow = shadowStyle

        content
            .padding(AppSpacing.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background, in: RoundedRectangle(cornerRadius: AppRadius.largeCard))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.largeCard)
                    .stroke(borderColor, lineWidth: accessibilitySettings.highContrastEnabled ? 1.5 : 1)
            }
            .shadow(color: shadow.color, radius: shadow.radius, x: 0, y: shadow.y)
            .contentShape(RoundedRectangle(cornerRadius: AppRadius.largeCard))
    }

    private var background: Color {
        switch variant {
        case .standard, .elevated:
            return AppColors.surface
        case .selected:
            return AppColors.forest.opacity(0.10)
        case .locked:
            return AppColors.lockedFill(using: accessibilitySettings)
        case .success:
            return AppColors.success.opacity(0.10)
        case .warning:
            return AppColors.warning.opacity(0.12)
        }
    }

    private var borderColor: Color {
        switch variant {
        case .selected:
            return AppColors.forest
        case .success:
            return AppColors.success
        case .warning:
            return AppColors.warning
        default:
            return AppColors.cardBorder(using: accessibilitySettings)
        }
    }

    private var shadowStyle: (color: Color, radius: CGFloat, y: CGFloat) {
        switch variant {
        case .elevated:
            return AppShadows.card(using: accessibilitySettings)
        default:
            return AppShadows.small(using: accessibilitySettings)
        }
    }
}

#Preview {
    AppCard {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Card Title")
                .font(AppTypography.cardTitle)
            Text("Reusable content container.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
        }
    }
    .padding()
    .background(AppColors.background)
}
