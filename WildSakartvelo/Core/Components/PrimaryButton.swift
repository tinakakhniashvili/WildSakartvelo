import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var accessibilityIdentifier: String? = nil
    var isLoading = false

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.small) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }

                Text(title)
                    .font(AppTypography.button)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isLoading || !isEnabled)
        .accessibilityIdentifier(accessibilityIdentifier ?? "primary.button")
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.medium)
            .contentShape(RoundedRectangle(cornerRadius: AppRadius.button))
            .background(
                AppColors.forest.opacity(isEnabled ? (configuration.isPressed ? 0.82 : 1) : 0.45),
                in: RoundedRectangle(cornerRadius: AppRadius.button)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(AppAnimation.standard, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundStyle(AppColors.forest)
            .frame(maxWidth: .infinity, minHeight: 48)
            .padding(.horizontal, AppSpacing.medium)
            .background(AppColors.forest.opacity(isEnabled ? 0.10 : 0.05), in: RoundedRectangle(cornerRadius: AppRadius.button))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.button)
                    .stroke(AppColors.forest.opacity(isEnabled ? 0.35 : 0.12), lineWidth: 1)
            }
            .opacity(isEnabled ? 1 : 0.55)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: 48)
            .padding(.horizontal, AppSpacing.medium)
            .background(Color.red.opacity(configuration.isPressed ? 0.78 : 0.9), in: RoundedRectangle(cornerRadius: AppRadius.button))
    }
}

struct IconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: AppLayout.minimumTouchTarget, height: AppLayout.minimumTouchTarget)
            .background(AppColors.surface, in: Circle())
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
    }
}

struct ChoiceButtonStyle: ButtonStyle {
    var isSelected = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(AppSpacing.medium)
            .frame(maxWidth: .infinity, minHeight: AppLayout.minimumTouchTarget, alignment: .leading)
            .background(
                isSelected ? AppColors.forest.opacity(0.14) : AppColors.surface,
                in: RoundedRectangle(cornerRadius: AppRadius.largeCard)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.largeCard)
                    .stroke(isSelected ? AppColors.forest : AppColors.secondaryText.opacity(0.16), lineWidth: isSelected ? 2 : 1)
            }
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
    }
}

#Preview {
    VStack(spacing: AppSpacing.medium) {
        PrimaryButton(title: "Start Exploring") {}
        PrimaryButton(title: "Disabled") {}
            .disabled(true)
    }
    .padding()
}
