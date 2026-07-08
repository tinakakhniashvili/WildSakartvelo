import SwiftUI
import UIKit

struct MatchingActivityView: View {
    let activity: MissionActivity
    @Binding var selectedPairs: [String: String]
    @EnvironmentObject private var appState: AppState

    @State private var selectedLeftID: String?

    private var leftOptions: [ActivityOption] {
        var seenPairIDs: Set<String> = []

        return activity.options.filter { option in
            guard let pairID = option.pairID else { return false }
            let isFirstOptionForPair = !seenPairIDs.contains(pairID)
            seenPairIDs.insert(pairID)
            return isFirstOptionForPair
        }
    }

    private var rightOptions: [ActivityOption] {
        let leftOptionIDs = Set(leftOptions.map(\.id))
        return activity.options.filter { option in
            option.pairID != nil && !leftOptionIDs.contains(option.id)
        }
    }

    private var optionsByID: [String: ActivityOption] {
        Dictionary(uniqueKeysWithValues: activity.options.map { ($0.id, $0) })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.large) {
            Text(activity.displayInstruction(for: appState.currentLanguage))
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            if activity.imageName != nil {
                ContentImageView(
                    imageName: activity.imageName,
                    fallbackSystemImage: "questionmark.circle.fill",
                    height: 160,
                    accentColor: AppColors.mountain
                )
            }

            Text(activity.displayQuestion(for: appState.currentLanguage))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .top, spacing: AppSpacing.medium) {
                optionColumn(title: String(localized: "matching.column.left"), options: leftOptions, side: .left)
                optionColumn(title: String(localized: "matching.column.right"), options: rightOptions, side: .right)
            }
        }
    }

    private func optionColumn(title: String, options: [ActivityOption], side: MatchSide) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(title)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)

            ForEach(options) { option in
                matchButton(for: option, side: side)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private func matchButton(for option: ActivityOption, side: MatchSide) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
            Button {
                handleTap(option, side: side)
            } label: {
                matchCard(for: option, side: side)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(accessibilityLabel(for: option, side: side))
            .accessibilityHint(
                side == .left
                ? String(localized: "matching.accessibility.select")
                : String(localized: "matching.accessibility.pair")
            )

            if side == .left, selectedPairs[option.id] != nil {
                Button {
                    clearPair(for: option)
                } label: {
                        Label(String(localized: "matching.action.removePair"), systemImage: "xmark.circle")
                            .font(AppTypography.caption)
                    }
                .buttonStyle(.plain)
                .foregroundStyle(AppColors.warning)
                .accessibilityLabel(
                    String(
                        localized: "matching.accessibility.removePair",
                        defaultValue: "Remove pair for \(option.displayText(for: appState.currentLanguage))"
                    )
                )
            }
        }
    }

    private func matchCard(for option: ActivityOption, side: MatchSide) -> some View {
        let isSelected = selectedLeftID == option.id
        let pairedText = pairedDescription(for: option, side: side)
        let isPaired = pairedText != nil

        return VStack(alignment: .leading, spacing: AppSpacing.small) {
            HStack(alignment: .center, spacing: AppSpacing.small) {
                Text(option.displayText(for: appState.currentLanguage))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Image(systemName: isSelected ? "target" : isPaired ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isSelected || isPaired ? AppColors.forest : AppColors.secondaryText)
            }

            if let pairedText {
                Text(pairedText)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

        }
        .padding(AppSpacing.medium)
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppSpacing.small))
        .overlay {
            RoundedRectangle(cornerRadius: AppSpacing.small)
                .stroke(isSelected ? AppColors.forest : isPaired ? AppColors.water : AppColors.secondaryText.opacity(0.14), lineWidth: isSelected || isPaired ? 2 : 1)
        }
    }

    private func handleTap(_ option: ActivityOption, side: MatchSide) {
        switch side {
        case .left:
            if selectedLeftID == option.id {
                selectedLeftID = nil
            } else {
                selectedLeftID = option.id
            }
        case .right:
            guard let selectedLeftID else { return }
            selectedPairs = selectedPairs.filter { $0.value != option.id }
            selectedPairs[selectedLeftID] = option.id
            self.selectedLeftID = nil

            let leftText = optionsByID[selectedLeftID]?.displayText(for: appState.currentLanguage) ?? String(localized: "common.item")
            UIAccessibility.post(
                notification: .announcement,
                argument: String(
                    localized: "matching.accessibility.paired",
                    defaultValue: "\(leftText) paired with \(option.displayText(for: appState.currentLanguage))."
                )
            )
        }
    }

    private func clearPair(for option: ActivityOption) {
        selectedPairs[option.id] = nil
        if selectedLeftID == option.id {
            selectedLeftID = nil
        }
        UIAccessibility.post(
            notification: .announcement,
            argument: String(
                localized: "matching.accessibility.removed",
                defaultValue: "Pair removed for \(option.displayText(for: appState.currentLanguage))."
            )
        )
    }

    private func pairedDescription(for option: ActivityOption, side: MatchSide) -> String? {
        switch side {
        case .left:
            guard
                let pairedOptionID = selectedPairs[option.id],
                let pairedOption = optionsByID[pairedOptionID]
            else {
                return nil
            }
            return String(
                localized: "matching.accessibility.pairedWith",
                defaultValue: "Paired with \(pairedOption.displayText(for: appState.currentLanguage))"
            )
        case .right:
            guard
                let pairedLeftID = selectedPairs.first(where: { $0.value == option.id })?.key,
                let pairedOption = optionsByID[pairedLeftID]
            else {
                return nil
            }
            return String(
                localized: "matching.accessibility.pairedWith",
                defaultValue: "Paired with \(pairedOption.displayText(for: appState.currentLanguage))"
            )
        }
    }

    private func accessibilityLabel(for option: ActivityOption, side: MatchSide) -> String {
        if let pairedDescription = pairedDescription(for: option, side: side) {
            return "\(option.displayText(for: appState.currentLanguage)). \(pairedDescription)."
        }

        return option.displayText(for: appState.currentLanguage)
    }
}

private enum MatchSide {
    case left
    case right
}

#Preview {
    MatchingActivityView(
        activity: .sampleMatching,
        selectedPairs: .constant(["tur": "tur-footprint"])
    )
    .padding()
    .background(AppColors.background)
}
