import SwiftUI

struct GeographyMissionView: View {
    let mission: GeographyMission
    let catalogue: ContentCatalogue
    @EnvironmentObject private var appState: AppState
    @State private var activityIndex = 0
    @State private var selectedID: String?
    @State private var submitted = false
    @State private var correctCount = 0
    @State private var isComplete = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header

                if isComplete {
                    completionCard
                } else if let activity {
                    activityCard(activity)
                } else {
                    EmptyStateView(
                        systemImage: "map",
                        title: text("No map activities", "რუკის აქტივობები არ არის"),
                        description: text("This geography mission has no activities yet.", "ამ გეოგრაფიის მისიას ჯერ აქტივობები არ აქვს.")
                    )
                }
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(mission.title.displayText(for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        AppCard(variant: .elevated) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text(mission.title.displayText(for: appState.currentLanguage))
                    .font(AppTypography.screenTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text(mission.introduction.displayText(for: appState.currentLanguage))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                ProgressView(value: Double(activityIndex), total: Double(max(activities.count, 1)))
                    .tint(AppColors.forest)
            }
        }
    }

    private var completionCard: some View {
        AppCard(variant: .success) {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Label(text("Map mission complete", "რუკის მისია დასრულდა"), systemImage: "checkmark.seal.fill")
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.success)

                Text(mission.reward.displayTitle(for: appState.currentLanguage))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)

                NavigationLink {
                    GeographyHomeView(catalogue: catalogue)
                } label: {
                    Text(text("Continue Exploring", "გააგრძელე კვლევა"))
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private func activityCard(_ activity: GeographyActivity) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Label(activityTitle(for: activity.type), systemImage: icon(for: activity.type))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.water)

                Text(activity.prompt.displayText(for: appState.currentLanguage))
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                if activity.type == .regionSelection {
                    geographyMap(for: activity)
                }

                Label(text("Choose the option that matches the clue.", "აირჩიე ვარიანტი, რომელიც მინიშნებას შეესაბამება."), systemImage: "lightbulb.fill")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)

                optionList(for: activity)

                if submitted {
                    feedback(for: activity)
                }

                PrimaryButton(title: primaryActionTitle(for: activity)) {
                    handlePrimaryAction(activity)
                }
                .disabled(selectedID == nil && !submitted)
            }
        }
    }

    private func geographyMap(for activity: GeographyActivity) -> some View {
        let optionRegions = activity.optionIDs.compactMap { catalogue.regionsByID[$0] }
        return RegionMapOverlay(
            regions: optionRegions.isEmpty ? catalogue.regions : optionRegions,
            selectedRegionID: selectedID,
            language: appState.currentLanguage
        ) { region in
            selectedID = region.id
        }
        .padding(.vertical, AppSpacing.small)
    }

    private func optionList(for activity: GeographyActivity) -> some View {
        VStack(spacing: AppSpacing.small) {
            ForEach(activity.optionIDs, id: \.self) { id in
                Button {
                    selectedID = id
                } label: {
                    HStack {
                        Image(systemName: selectedID == id ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(selectedID == id ? AppColors.forest : AppColors.secondaryText)
                        Text(optionTitle(for: id))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                    }
                }
                .buttonStyle(ChoiceButtonStyle(isSelected: selectedID == id))
            }
        }
    }

    private func feedback(for activity: GeographyActivity) -> some View {
        let isCorrect = selectedID == correctID(for: activity)
        return TokoGuideView(
            message: isCorrect
                ? correctFeedback(for: activity)
                : activity.hint.displayText(for: appState.currentLanguage)
        )
    }

    private func handlePrimaryAction(_ activity: GeographyActivity) {
        if submitted {
            if selectedID == correctID(for: activity) {
                moveToNextActivity()
            } else {
                selectedID = nil
                submitted = false
            }
            return
        }

        submitted = true
        if selectedID == correctID(for: activity) {
            correctCount += 1
        }
    }

    private func moveToNextActivity() {
        selectedID = nil
        submitted = false

        if activityIndex + 1 >= activities.count {
            appState.completeGeographyMission(mission, score: correctCount)
            isComplete = true
        } else {
            activityIndex += 1
        }
    }

    private func correctID(for activity: GeographyActivity) -> String? {
        activity.correctRegionID ?? activity.correctCityID ?? activity.correctLandmarkID
    }

    private func primaryActionTitle(for activity: GeographyActivity) -> String {
        guard submitted else {
            return text("Check Answer", "პასუხის შემოწმება")
        }
        return selectedID == correctID(for: activity)
            ? text("Continue", "გაგრძელება")
            : text("Try Again", "სცადე თავიდან")
    }

    private func optionTitle(for id: String) -> String {
        if let region = catalogue.regionsByID[id] {
            return region.name.displayText(for: appState.currentLanguage)
        }
        if let city = catalogue.citiesByID[id] {
            return city.name.displayText(for: appState.currentLanguage)
        }
        if let landmark = catalogue.geographyLandmarksByID[id] {
            return landmark.name.displayText(for: appState.currentLanguage)
        }
        return id
    }

    private func correctFeedback(for activity: GeographyActivity) -> String {
        let answer = correctID(for: activity).map(optionTitle(for:)) ?? text("this answer", "ეს პასუხი")

        switch activity.type {
        case .regionSelection:
            return text("\(answer) matches the map clue.", "\(answer) შეესაბამება რუკის მინიშნებას.")
        case .cityPlacement:
            return text("\(answer) is the city that matches this clue.", "\(answer) არის ქალაქი, რომელიც ამ მინიშნებას შეესაბამება.")
        case .centerMatching:
            return text("\(answer) is the correct administrative center.", "\(answer) სწორი ადმინისტრაციული ცენტრია.")
        case .neighborSelection:
            return text("\(answer) is a neighboring region.", "\(answer) მეზობელი რეგიონია.")
        case .landmarkPlacement:
            return text("\(answer) is the landmark described by the clue.", "\(answer) არის მინიშნებით აღწერილი გეოგრაფიული ნიშანი.")
        }
    }

    private func activityTitle(for type: GeographyActivityType) -> String {
        switch type {
        case .regionSelection:
            return text("Read the Map Clue", "წაიკითხე რუკის მინიშნება")
        case .cityPlacement:
            return text("City Clue", "ქალაქის მინიშნება")
        case .centerMatching:
            return text("Region Center", "რეგიონის ცენტრი")
        case .neighborSelection:
            return text("Region Neighbors", "რეგიონის მეზობლები")
        case .landmarkPlacement:
            return text("Find the Landmark", "იპოვე ნიშანი")
        }
    }

    private func icon(for type: GeographyActivityType) -> String {
        switch type {
        case .regionSelection:
            return "map.fill"
        case .cityPlacement, .centerMatching:
            return "building.2.fill"
        case .neighborSelection:
            return "arrow.left.and.right"
        case .landmarkPlacement:
            return "mountain.2.fill"
        }
    }

    private var activities: [GeographyActivity] {
        mission.activityIDs.compactMap { catalogue.geographyActivitiesByID[$0] }
    }

    private var activity: GeographyActivity? {
        guard activities.indices.contains(activityIndex) else { return nil }
        return activities[activityIndex]
    }

    private func text(_ english: String, _ georgian: String) -> String {
        appState.currentLanguage == .georgian ? georgian : english
    }
}
