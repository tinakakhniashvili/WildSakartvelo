import SwiftUI

struct EmptyStateView: View {
    let systemImage: String
    let imageName: String?
    let title: String
    let description: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?

    init(
        systemImage: String,
        imageName: String? = nil,
        title: String,
        description: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.imageName = imageName
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            if let imageName {
                ContentImageView(
                    imageName: imageName,
                    fallbackSystemImage: systemImage,
                    mode: .avatar,
                    height: 104,
                    accentColor: AppColors.forest,
                    accessibilityDescription: title
                )
                .frame(width: 118, height: 104)
            } else {
                Image(systemName: systemImage)
                    .font(.system(size: 56, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppColors.forest)
                    .accessibilityHidden(true)
            }

            VStack(spacing: AppSpacing.small) {
                Text(title)
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let buttonTitle, let buttonAction {
                PrimaryButton(title: buttonTitle, action: buttonAction)
                    .padding(.top, AppSpacing.small)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.large)
    }
}

#Preview {
    EmptyStateView(
        systemImage: "book.closed.fill",
        title: "Your journal is empty",
        description: "Discovered animals and plants will appear here later.",
        buttonTitle: "Explore"
    ) {}
    .padding()
}
