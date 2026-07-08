import SwiftUI

struct AvatarSelectionView: View {
    @Binding var selectedAvatarID: String

    static let avatarIDs = ["fox", "bear", "bird", "deer", "mountain", "leaf"]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 84), spacing: AppSpacing.medium)], spacing: AppSpacing.medium) {
            ForEach(Self.avatarIDs, id: \.self) { avatarID in
                Button {
                    selectedAvatarID = avatarID
                } label: {
                    VStack(spacing: AppSpacing.small) {
                        ContentImageView(
                            imageName: Self.assetName(for: avatarID),
                            fallbackSystemImage: Self.systemImage(for: avatarID),
                            mode: .avatar,
                            height: 50,
                            accentColor: AppColors.forest,
                            accessibilityDescription: Self.displayTitle(for: avatarID)
                        )
                        .frame(width: 50, height: 50)

                        Text(Self.displayTitle(for: avatarID))
                            .font(AppTypography.caption)
                            .foregroundStyle(selectedAvatarID == avatarID ? .white : AppColors.primaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(
                        selectedAvatarID == avatarID ? AppColors.forest : AppColors.surface,
                        in: RoundedRectangle(cornerRadius: AppSpacing.medium)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: AppSpacing.medium)
                            .stroke(AppColors.forest.opacity(selectedAvatarID == avatarID ? 0 : 0.25), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    static func systemImage(for avatarID: String) -> String {
        switch avatarID {
        case "fox":
            return "pawprint.fill"
        case "bear":
            return "pawprint.circle.fill"
        case "bird":
            return "bird.fill"
        case "deer":
            return "ant.fill"
        case "mountain":
            return "mountain.2.fill"
        case "leaf":
            return "leaf.fill"
        default:
            return "person.crop.circle.fill"
        }
    }

    static func assetName(for avatarID: String) -> String {
        "avatar_\(avatarID)_explorer"
    }

    static func displayTitle(for avatarID: String) -> String {
        avatarID.capitalized
    }
}

#Preview {
    @Previewable @State var selectedAvatarID = "fox"

    return AvatarSelectionView(selectedAvatarID: $selectedAvatarID)
        .padding()
        .background(AppColors.background)
}
