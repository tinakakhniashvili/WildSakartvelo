import SwiftUI

struct ContentPackRowView: View {
    let pack: ContentPack
    let ecosystemName: String
    let ecosystemImageName: String?
    let state: ContentPackState
    let hasUpdate: Bool
    let onDownload: () -> Void
    let onCancel: () -> Void
    let onDelete: () -> Void

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                ContentImageView(
                    imageName: ecosystemImageName,
                    fallbackAssetName: "offline_pack",
                    fallbackSystemImage: "square.and.arrow.down",
                    mode: .thumbnail,
                    height: 72,
                    accentColor: AppColors.water,
                    accessibilityDescription: ecosystemName
                )
                .frame(width: 84, height: 72)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(pack.title)
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    Text(ecosystemName)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                }

                Spacer()

                Text(formattedSize(pack.estimatedSizeBytes))
                    .font(AppTypography.captionFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
            }

            VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                HStack {
                    Text(statusText)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(statusColor)

                    Spacer()

                    Text(progressText)
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                }

                ProgressView(value: progressValue)
                    .tint(AppColors.progressTint(using: accessibilitySettings))
                    .accessibilityLabel(Text("downloads.progress.accessibility"))
                    .accessibilityValue(Text(progressText))
            }

            if let errorMessage = state.errorMessage, state.status == .failed {
                Text(errorMessage)
                    .font(AppTypography.captionFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.statusColor(.red, using: accessibilitySettings))
            }

            HStack(spacing: AppSpacing.small) {
                switch state.status {
                case .notDownloaded:
                    Button("downloads.action.download", action: onDownload)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                case .downloading:
                    Button("downloads.action.cancel", action: onCancel)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                case .downloaded:
                    if hasUpdate {
                        Button("downloads.action.update", action: onDownload)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                    Button("downloads.action.delete", role: .destructive, action: onDelete)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                case .failed:
                    Button("downloads.action.retry", action: onDownload)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                }
            }
        }
        .padding(.vertical, AppSpacing.small)
        .accessibilityElement(children: .combine)
    }

    private var statusText: String {
        if hasUpdate {
            return String(localized: "downloads.status.updateAvailable")
        }

        switch state.status {
        case .notDownloaded:
            return String(localized: "downloads.status.notDownloaded")
        case .downloading:
            return String(localized: "downloads.status.downloading")
        case .downloaded:
            return String(localized: "downloads.status.downloaded")
        case .failed:
            return String(localized: "downloads.status.failed")
        }
    }

    private var statusColor: Color {
        switch state.status {
        case .downloaded:
            return AppColors.statusColor(.green, using: accessibilitySettings)
        case .failed:
            return AppColors.statusColor(.red, using: accessibilitySettings)
        case .downloading:
            return AppColors.progressTint(using: accessibilitySettings)
        case .notDownloaded:
            return AppColors.secondaryText
        }
    }

    private var progressValue: Double {
        state.status == .downloaded ? 1 : state.progress
    }

    private var progressText: String {
        progressValue.formatted(.percent.precision(.fractionLength(0)))
    }

    private func formattedSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

#Preview("Content Pack Row") {
    List {
        ContentPackRowView(
            pack: .sample,
            ecosystemName: "Caucasus Mountains",
            ecosystemImageName: "caucasus_mountains_cover",
            state: ContentPackState(
                packID: ContentPack.sample.id,
                status: .downloading,
                progress: 0.45,
                installedVersion: nil,
                errorMessage: nil
            ),
            hasUpdate: false,
            onDownload: {},
            onCancel: {},
            onDelete: {}
        )
    }
}
