import SwiftUI

struct ContentImageView: View {
    enum DisplayMode {
        case card
        case hero
        case thumbnail
        case journal
        case avatar
        case detail

        var height: CGFloat {
            switch self {
            case .card:
                return 150
            case .hero:
                return AppLayout.heroImageHeight
            case .thumbnail:
                return 72
            case .journal:
                return 64
            case .avatar:
                return AppIconSize.avatar
            case .detail:
                return 260
            }
        }

        var radius: CGFloat {
            switch self {
            case .hero:
                return AppRadius.heroImage
            case .thumbnail, .journal, .avatar:
                return AppRadius.thumbnail
            case .card:
                return AppRadius.largeCard
            case .detail:
                return AppRadius.heroImage
            }
        }

        var aspectRatio: CGFloat? {
            switch self {
            case .hero:
                return 16 / 9
            case .card:
                return 16 / 10
            case .thumbnail, .journal, .avatar:
                return 1
            case .detail:
                return nil
            }
        }

        var contentMode: ContentMode {
            switch self {
            case .detail:
                return .fit
            case .card, .hero, .thumbnail, .journal, .avatar:
                return .fill
            }
        }
    }

    let imageName: String?
    var remoteURL: URL? = nil
    var fallbackAssetName: String? = nil
    var fallbackSystemImage: String = "photo"
    var mode: DisplayMode = .card
    var height: CGFloat? = nil
    var accentColor: Color = AppColors.forest
    var accessibilityDescription: String? = nil

    var body: some View {
        imageContent
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: height ?? mode.height)
            .aspectRatio(mode.aspectRatio, contentMode: mode.contentMode)
            .clipShape(RoundedRectangle(cornerRadius: mode.radius))
            .contentShape(RoundedRectangle(cornerRadius: mode.radius))
            .accessibilityLabel(accessibilityDescription ?? "")
            .accessibilityHidden(accessibilityDescription == nil)
    }

    @ViewBuilder
    private var imageContent: some View {
        if let imageName,
           let localURL = ResourceResolver.shared.url(for: imageName),
           let image = UIImage(contentsOfFile: localURL.path) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: mode.contentMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let imageName, UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: mode.contentMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let fallbackAssetName, UIImage(named: fallbackAssetName) != nil {
            Image(fallbackAssetName)
                .resizable()
                .aspectRatio(contentMode: mode.contentMode)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let remoteURL {
            AsyncImage(url: remoteURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(accentColor.opacity(0.10))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: mode.contentMode)
                case .failure:
                    fallbackImage
                @unknown default:
                    fallbackImage
                }
            }
        } else {
            fallbackImage
        }
    }

    private var fallbackImage: some View {
        Image(systemName: fallbackSystemImage)
            .font(.system(size: min((height ?? mode.height) * 0.45, 88), weight: .semibold, design: .rounded))
            .foregroundStyle(accentColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(accentColor.opacity(0.12))
    }
}

struct LockedContentArtwork: View {
    let imageName: String?
    let title: String
    var accentColor: Color = AppColors.forest

    var body: some View {
        ZStack {
            if let imageName,
               UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 2)
                    .saturation(0.45)
            }

            Rectangle()
                .fill(.black.opacity(0.38))

            Label(title, systemImage: "lock.fill")
                .font(AppTypography.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, AppSpacing.medium)
                .padding(.vertical, AppSpacing.small)
                .background(.black.opacity(0.36), in: Capsule())
        }
    }
}

#Preview {
    ContentImageView(
        imageName: "missing_preview_asset",
        fallbackSystemImage: "leaf.fill",
        height: 180,
        accentColor: AppColors.forest
    )
    .padding()
    .background(AppColors.background)
}
