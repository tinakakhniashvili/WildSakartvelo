import SwiftUI

struct MissionRowView: View {
    let mission: Mission
    let status: MissionStatus
    let lockReason: String?
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                    Image(systemName: status.systemImage)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(status.color(using: accessibilitySettings))
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                    Text(mission.displayTitle(for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)
                        .lineLimit(2)

                    Text(mission.displaySubtitle(for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .lineLimit(2)

                    Text(
                        String(
                            localized: "mission.row.meta",
                            defaultValue: "\(mission.difficulty.displayTitle) • \(mission.estimatedMinutes) min"
                        )
                    )
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)

                    Text(status.displayTitle)
                        .font(AppTypography.captionFont(using: accessibilitySettings))
                        .foregroundStyle(status.color)

                    if let lockReason, status == .locked {
                        Text(lockReason)
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Spacer(minLength: AppSpacing.small)

                if status != .locked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
        .opacity(status == .locked ? 0.72 : 1)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(mission.displayTitle(for: appState.currentLanguage))
        .accessibilityValue(status.displayTitle)
    }
}

private extension MissionStatus {
    var displayTitle: String {
        switch self {
        case .locked:
            return String(localized: "mission.status.locked")
        case .available:
            return String(localized: "mission.status.available")
        case .inProgress:
            return String(localized: "mission.status.inProgress")
        case .completed:
            return String(localized: "mission.status.completed")
        }
    }

    var systemImage: String {
        switch self {
        case .locked:
            return "lock.fill"
        case .available:
            return "play.circle.fill"
        case .inProgress:
            return "arrow.clockwise.circle.fill"
        case .completed:
            return "checkmark.circle.fill"
        }
    }

    var color: Color {
        color(using: .defaultValue)
    }

    func color(using settings: AppAccessibilitySettings) -> Color {
        switch self {
        case .locked:
            return AppColors.statusColor(AppColors.secondaryText, using: settings)
        case .available:
            return AppColors.statusColor(AppColors.forest, using: settings)
        case .inProgress:
            return AppColors.statusColor(AppColors.warning, using: settings)
        case .completed:
            return AppColors.statusColor(AppColors.success, using: settings)
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.medium) {
        MissionRowView(mission: .sample, status: .locked, lockReason: "Complete another mission first.")
        MissionRowView(mission: .sample, status: .available, lockReason: nil)
        MissionRowView(mission: .sample, status: .inProgress, lockReason: nil)
        MissionRowView(mission: .sample, status: .completed, lockReason: nil)
    }
    .padding()
    .background(AppColors.background)
}
