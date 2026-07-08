import SwiftUI

struct ObservationActivityView: View {
    let activity: ObservationActivity
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                TokoGuideView(message: TokoMessageService().message(for: .observationSafety, language: appState.currentLanguage))

                AppCard(variant: isCompleted ? .success : .elevated) {
                    VStack(alignment: .leading, spacing: AppSpacing.medium) {
                        Label(typeTitle, systemImage: iconName)
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.forest)

                        Text(activity.title.displayText(for: appState.currentLanguage))
                            .font(AppTypography.largeTitle)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(activity.instruction.displayText(for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        if let ecosystemID = activity.ecosystemID,
                           let ecosystem = catalogue.ecosystemsByID[ecosystemID] {
                            Label(ecosystem.displayName(for: appState.currentLanguage), systemImage: "map.fill")
                                .font(AppTypography.caption)
                                .foregroundStyle(ecosystem.theme.accentColor)
                        }

                        Label(activity.safetyMessage.displayText(for: appState.currentLanguage), systemImage: "hand.raised.fill")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                PrimaryButton(title: isCompleted ? text("Completed", "დასრულებულია") : text("Mark as Completed", "დასრულებულად მონიშვნა")) {
                    appState.completeObservation(activity)
                    dismiss()
                }
                .disabled(isCompleted)
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(text("Observation", "დაკვირვება"))
    }

    private var isCompleted: Bool {
        appState.userProgress.completedObservationActivityIDs.contains(activity.id)
    }

    private var typeTitle: String {
        switch activity.activityType {
        case .draw: return text("Draw", "დახატე")
        case .listen: return text("Listen", "მოუსმინე")
        case .compare: return text("Compare", "შეადარე")
        case .count: return text("Count", "დათვალე")
        case .weather: return text("Weather", "ამინდი")
        case .notice: return text("Notice", "შენიშნე")
        }
    }

    private var iconName: String {
        switch activity.activityType {
        case .draw: return "pencil"
        case .listen: return "ear"
        case .compare: return "square.split.2x1"
        case .count: return "number"
        case .weather: return "cloud.sun.fill"
        case .notice: return "eye.fill"
        }
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}
