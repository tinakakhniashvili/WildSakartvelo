import SwiftUI

struct ExplorerChallengesView: View {
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    private let service = ExplorerChallengeService()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                challengeSection(
                    title: text("Active Challenges", "აქტიური გამოწვევები"),
                    challenges: service.activeChallenges(in: catalogue, progress: appState.userProgress)
                )

                challengeSection(
                    title: text("Completed", "დასრულებული"),
                    challenges: service.completedChallenges(in: catalogue, progress: appState.userProgress)
                )
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(text("Explorer Challenges", "მკვლევრის გამოწვევები"))
    }

    private func challengeSection(title: String, challenges: [ExplorerChallenge]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(title)
                .font(AppTypography.screenTitle)
                .foregroundStyle(AppColors.primaryText)

            if challenges.isEmpty {
                AppCard {
                    Text(text("No challenges here yet.", "აქ ჯერ გამოწვევები არ არის."))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                }
            } else {
                ForEach(challenges) { challenge in
                    ExplorerChallengeCard(
                        challenge: challenge,
                        progress: service.progress(for: challenge, catalogue: catalogue, progress: appState.userProgress),
                        ecosystemName: challenge.relatedEcosystemID.flatMap { catalogue.ecosystemsByID[$0]?.displayName(for: appState.currentLanguage) },
                        language: appState.currentLanguage,
                        destination: destination(for: challenge)
                    )
                }
            }
        }
    }

    private func destination(for challenge: ExplorerChallenge) -> AnyView? {
        if let ecosystemID = challenge.relatedEcosystemID,
           let ecosystem = catalogue.ecosystemsByID[ecosystemID] {
            return AnyView(EcosystemDetailView(ecosystem: ecosystem, catalogue: catalogue))
        }
        return nil
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}
