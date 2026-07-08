import SwiftUI

struct LearningTopicsView: View {
    let catalogue: ContentCatalogue
    let completedMissionIDs: Set<String>
    let language: AppLanguage

    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    private var topicCounts: [(topic: String, count: Int)] {
        let completedMissions = catalogue.missions.filter { completedMissionIDs.contains($0.id) }
        let counts = completedMissions
            .flatMap(\.learningTopics)
            .reduce(into: [String: Int]()) { result, topic in
                result[topic, default: 0] += 1
            }

        return counts
            .map { ($0.key, $0.value) }
            .sorted { localizedTopic($0.topic) < localizedTopic($1.topic) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text(String.localized("parent.learningTopics.title", for: language))
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            if topicCounts.isEmpty {
                EmptyStateView(
                    systemImage: "lightbulb.fill",
                    title: String.localized("parent.learningTopics.empty.title", for: language),
                    description: String.localized("parent.learningTopics.empty.description", for: language)
                )
            } else {
                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        ForEach(topicCounts, id: \.topic) { item in
                            HStack(alignment: .top, spacing: AppSpacing.medium) {
                                Image(systemName: icon(for: item.topic))
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(AppColors.forest)
                                    .frame(width: 28)

                                VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                                    Text(localizedTopic(item.topic))
                                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                                        .foregroundStyle(AppColors.primaryText)

                                    Text(String.localizedFormat("parent.learningTopics.recentlyExplored", for: language, item.count))
                                        .font(AppTypography.captionFont(using: accessibilitySettings))
                                        .foregroundStyle(AppColors.secondaryText)
                                }
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }
            }
        }
    }

    private func localizedTopic(_ topic: String) -> String {
        switch topic {
        case "habitats":
            return String.localized("learningTopic.habitats", for: language)
        case "animalIdentification":
            return String.localized("learningTopic.animalIdentification", for: language)
        case "plants":
            return String.localized("learningTopic.plants", for: language)
        case "foodChains":
            return String.localized("learningTopic.foodChains", for: language)
        case "observation":
            return String.localized("learningTopic.observation", for: language)
        case "environmentalResponsibility":
            return String.localized("learningTopic.environmentalResponsibility", for: language)
        default:
            return String.localized("learningTopic.general", for: language)
        }
    }

    private func icon(for topic: String) -> String {
        switch topic {
        case "habitats":
            return "leaf.circle.fill"
        case "animalIdentification":
            return "pawprint.circle.fill"
        case "plants":
            return "camera.macro.circle.fill"
        case "foodChains":
            return "arrow.triangle.branch"
        case "observation":
            return "eye.fill"
        case "environmentalResponsibility":
            return "shield.lefthalf.filled"
        default:
            return "lightbulb.fill"
        }
    }
}

#Preview("Empty Topics") {
    LearningTopicsView(
        catalogue: try! ContentCatalogue(
            ecosystems: [.sample],
            animals: [.sample],
            plants: [.sample],
            missions: [.sample],
            activities: [.sample]
        ),
        completedMissionIDs: [],
        language: .english
    )
    .padding()
    .background(AppColors.background)
}

#Preview("Completed Topics") {
    LearningTopicsView(
        catalogue: try! ContentCatalogue(
            ecosystems: [.sample],
            animals: [.sample],
            plants: [.sample],
            missions: [.sample],
            activities: [.sample]
        ),
        completedMissionIDs: ["mountain-habitat-discovery"],
        language: .english
    )
    .padding()
    .background(AppColors.background)
}
