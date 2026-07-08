import SwiftUI

struct ExploreThumbnail: View {
    let imageName: String?
    let fallbackSystemImage: String
    let accentColor: Color
    let accessibilityDescription: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.thumbnail)
                .fill(accentColor.opacity(0.10))

            if let imageName, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
            } else {
                Image(systemName: fallbackSystemImage)
                    .font(.system(size: min(width, height) * 0.42, weight: .semibold))
                    .foregroundStyle(accentColor)
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.thumbnail))
        .clipped()
        .accessibilityLabel(accessibilityDescription)
    }
}
