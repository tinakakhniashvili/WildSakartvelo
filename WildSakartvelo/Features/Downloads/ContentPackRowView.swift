import SwiftUI

struct ContentPackRowView: View {
    let pack: ContentPack
    let ecosystemName: String
    let ecosystemImageName: String?
    let state: ContentPackState
    let hasUpdate: Bool
    let language: AppLanguage
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
                    .accessibilityLabel(String.localized("downloads.progress.accessibility", for: language))
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
                    Button(String.localized("downloads.action.download", for: language), action: onDownload)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                case .downloading:
                    Button(String.localized("downloads.action.cancel", for: language), action: onCancel)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                case .downloaded:
                    if hasUpdate {
                        Button(String.localized("downloads.action.update", for: language), action: onDownload)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                    }
                    Button(String.localized("downloads.action.delete", for: language), role: .destructive, action: onDelete)
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                case .failed:
                    Button(String.localized("downloads.action.retry", for: language), action: onDownload)
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
            return String.localized("downloads.status.updateAvailable", for: language)
        }

        switch state.status {
        case .notDownloaded:
            return String.localized("downloads.status.notDownloaded", for: language)
        case .downloading:
            return String.localized("downloads.status.downloading", for: language)
        case .downloaded:
            return String.localized("downloads.status.downloaded", for: language)
        case .failed:
            return String.localized("downloads.status.failed", for: language)
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
            language: .english,
            onDownload: {},
            onCancel: {},
            onDelete: {}
        )
    }
}
