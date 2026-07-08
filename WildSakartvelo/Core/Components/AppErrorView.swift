import SwiftUI

struct AppErrorView: View {
    let title: String
    let message: String
    var retryAction: (() -> Void)?
    var closeAction: (() -> Void)?

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(AppColors.mountain)
                .accessibilityHidden(true)

            Text(title)
                .font(AppTypography.screenTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)
                .multilineTextAlignment(.center)

            Text(message)
                .font(AppTypography.bodyFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)

            HStack(spacing: AppSpacing.small) {
                if let retryAction {
                    Button("action.retry", action: retryAction)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                }

                if let closeAction {
                    Button("action.close", action: closeAction)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                }
            }
        }
        .padding(AppSpacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    AppErrorView(
        title: "Content could not be loaded",
        message: "Check the app content and try again.",
        retryAction: {},
        closeAction: {}
    )
}
