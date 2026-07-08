import SwiftUI

struct EcosystemProgressView: View {
    let ecosystem: Ecosystem
    let progress: UserProgress

    private var completedMissionCount: Int {
        ecosystem.missionIDs.filter { progress.completedMissionIDs.contains($0) }.count
    }

    private var totalMissionCount: Int {
        ecosystem.missionIDs.count
    }

    private var progressValue: Double {
        guard totalMissionCount > 0 else { return 0 }
        return Double(completedMissionCount) / Double(totalMissionCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            ProgressView(value: progressValue)
                .tint(ecosystem.theme.accentColor)

            Text(
                String(
                    localized: "ecosystem.progress.completed",
                    defaultValue: "\(completedMissionCount) of \(totalMissionCount) missions completed"
                )
            )
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)
        }
    }
}

#Preview {
    EcosystemProgressView(
        ecosystem: .sample,
        progress: UserProgress(
            completedMissionIDs: ["mountain-habitat-discovery"],
            discoveredAnimalIDs: [],
            discoveredPlantIDs: [],
            unlockedEcosystemIDs: [],
            earnedBadgeIDs: [],
            activeMissionID: nil,
            currentActivityIndexByMission: [:],
            totalAttemptsByMission: [:]
        )
    )
    .padding()
    .background(AppColors.background)
}
