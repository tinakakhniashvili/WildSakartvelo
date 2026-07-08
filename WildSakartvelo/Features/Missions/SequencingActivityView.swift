import SwiftUI
import UIKit

struct SequencingActivityView: View {
    let activity: MissionActivity
    @Binding var orderedItemIDs: [String]
    @EnvironmentObject private var appState: AppState

    private var sequenceItems: [SequenceItem] {
        activity.sequenceItems ?? []
    }

    private var itemsByID: [String: SequenceItem] {
        Dictionary(uniqueKeysWithValues: sequenceItems.map { ($0.id, $0) })
    }

    private var orderedItems: [SequenceItem] {
        orderedItemIDs.compactMap { itemsByID[$0] }
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

            VStack(spacing: AppSpacing.medium) {
                ForEach(Array(orderedItems.enumerated()), id: \.element.id) { index, item in
                    sequenceRow(item, position: index)
                }
            }
        }
    }

    private func sequenceRow(_ item: SequenceItem, position: Int) -> some View {
        let isFirst = position == 0
        let isLast = position == orderedItems.count - 1

        return AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(alignment: .top, spacing: AppSpacing.medium) {
                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(String(localized: "sequencing.position", defaultValue: "Position \(position + 1)"))
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText)

                        Text(item.displayText(for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: AppSpacing.small)

                    VStack(spacing: AppSpacing.small) {
                        Button {
                            moveItem(item.id, offset: -1)
                        } label: {
                            Label(String(localized: "sequencing.action.moveUp", defaultValue: "Move Up"), systemImage: "arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(AppColors.forest)
                        .disabled(isFirst)
                        .accessibilityLabel(
                            String(localized: "sequencing.accessibility.moveUp", defaultValue: "Move \(item.displayText(for: appState.currentLanguage)) up")
                        )

                        Button {
                            moveItem(item.id, offset: 1)
                        } label: {
                            Label(String(localized: "sequencing.action.moveDown", defaultValue: "Move Down"), systemImage: "arrow.down")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(AppColors.water)
                        .disabled(isLast)
                        .accessibilityLabel(
                            String(localized: "sequencing.accessibility.moveDown", defaultValue: "Move \(item.displayText(for: appState.currentLanguage)) down")
                        )
                    }
                    .frame(width: 132)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel(for: item, position: position))
        }
    }

    private func moveItem(_ itemID: String, offset: Int) {
        guard let currentIndex = orderedItemIDs.firstIndex(of: itemID) else { return }
        let newIndex = currentIndex + offset
        guard orderedItemIDs.indices.contains(newIndex) else { return }

        orderedItemIDs.moveItem(at: currentIndex, to: newIndex)

        guard let item = itemsByID[itemID] else { return }
        UIAccessibility.post(
            notification: .announcement,
            argument: String(localized: "sequencing.accessibility.moved", defaultValue: "\(item.displayText(for: appState.currentLanguage)) moved to position \(newIndex + 1).")
        )
    }

    private func accessibilityLabel(for item: SequenceItem, position: Int) -> String {
        let movementState: String
        switch (position == 0, position == orderedItems.count - 1) {
        case (true, true):
            movementState = String(localized: "sequencing.accessibility.noMovement", defaultValue: "No movement available.")
        case (true, false):
            movementState = String(localized: "sequencing.accessibility.canMoveDown", defaultValue: "Can move down.")
        case (false, true):
            movementState = String(localized: "sequencing.accessibility.canMoveUp", defaultValue: "Can move up.")
        default:
            movementState = String(localized: "sequencing.accessibility.canMoveBoth", defaultValue: "Can move up or down.")
        }

        return String(
            localized: "sequencing.accessibility.label",
            defaultValue: "\(item.displayText(for: appState.currentLanguage)). Position \(position + 1). \(movementState)"
        )
    }
}

private extension Array where Element: Equatable {
    mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard sourceIndex != destinationIndex else { return }
        let element = remove(at: sourceIndex)
        insert(element, at: destinationIndex)
    }
}

#Preview {
    SequencingActivityView(
        activity: .sampleSequencing,
        orderedItemIDs: .constant(["grass", "deer", "wolf"])
    )
    .padding()
    .background(AppColors.background)
}
