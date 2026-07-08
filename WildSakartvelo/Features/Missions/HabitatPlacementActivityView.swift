import SwiftUI

struct HabitatPlacementActivityView: View {
    let activity: MissionActivity
    @Binding var habitatSelections: [String: String]
    @EnvironmentObject private var appState: AppState

    private var zones: [HabitatZone] {
        activity.habitatZones ?? []
    }

    private var zonesByID: [String: HabitatZone] {
        Dictionary(uniqueKeysWithValues: zones.map { ($0.id, $0) })
    }

    private var selectedItemsByZoneID: [String: [ActivityOption]] {
        var grouped: [String: [ActivityOption]] = [:]

        for option in activity.options {
            guard let zoneID = habitatSelections[option.id], !zoneID.isEmpty else { continue }
            grouped[zoneID, default: []].append(option)
        }

        return grouped.mapValues { $0.sorted { $0.displayText(for: appState.currentLanguage) < $1.displayText(for: appState.currentLanguage) } }
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
                ForEach(activity.options) { option in
                    itemRow(option)
                }
            }

            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                ForEach(zones) { zone in
                    zoneCard(zone)
                }
            }
        }
    }

    private func itemRow(_ option: ActivityOption) -> some View {
        let selectedZoneID = habitatSelections[option.id]
        let selectedZoneTitle = selectedZoneID.flatMap { zonesByID[$0]?.displayTitle(for: appState.currentLanguage) } ?? String(localized: "habitatPlacement.noSelection", defaultValue: "No habitat selected")

        return AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(alignment: .top, spacing: AppSpacing.medium) {
                    if option.imageName != nil {
                        ContentImageView(
                            imageName: option.imageName,
                            fallbackSystemImage: "photo.fill",
                            height: 64,
                            accentColor: AppColors.water
                        )
                        .frame(width: 76)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(option.displayText(for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(selectedZoneTitle)
                            .font(AppTypography.caption)
                            .foregroundStyle(selectedZoneID == nil ? AppColors.secondaryText : AppColors.forest)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Picker(
                    String(localized: "habitatPlacement.picker.title", defaultValue: "Habitat for \(option.displayText(for: appState.currentLanguage))"),
                    selection: Binding(
                        get: { habitatSelections[option.id] ?? "" },
                        set: { newValue in
                            if newValue.isEmpty {
                                habitatSelections[option.id] = nil
                            } else {
                                habitatSelections[option.id] = newValue
                            }
                        }
                    )
                ) {
                    Text(String(localized: "habitatPlacement.picker.placeholder", defaultValue: "Choose habitat")).tag("")
                    ForEach(zones) { zone in
                        Text(zone.displayTitle(for: appState.currentLanguage)).tag(zone.id)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityLabel(
                    String(localized: "habitatPlacement.accessibility.select", defaultValue: "Select habitat for \(option.displayText(for: appState.currentLanguage))")
                )
                .accessibilityValue(selectedZoneTitle)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel(for: option))
        }
    }

    private func zoneCard(_ zone: HabitatZone) -> some View {
        let selectedItems = selectedItemsByZoneID[zone.id] ?? []

        return AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                HStack(alignment: .center, spacing: AppSpacing.small) {
                    Image(systemName: iconName(for: zone.id))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppColors.forest)
                        .frame(width: 28, height: 28)
                        .background(AppColors.forest.opacity(0.12), in: RoundedRectangle(cornerRadius: AppSpacing.small))

                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        Text(zone.displayTitle(for: appState.currentLanguage))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.primaryText)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(
                            String(
                                localized: "habitatPlacement.selectedCount",
                                defaultValue: "\(selectedItems.count) item\(selectedItems.count == 1 ? "" : "s") selected"
                            )
                        )
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                }

                if selectedItems.isEmpty {
                    Text(String(localized: "habitatPlacement.emptyZone", defaultValue: "No items placed here yet."))
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                        ForEach(selectedItems) { item in
                            Text(item.displayText(for: appState.currentLanguage))
                                .font(AppTypography.caption)
                                .foregroundStyle(AppColors.primaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(zoneAccessibilityLabel(zone, selectedItems: selectedItems))
        }
    }

    private func accessibilityLabel(for option: ActivityOption) -> String {
        let zoneTitle = habitatSelections[option.id].flatMap { zonesByID[$0]?.displayTitle(for: appState.currentLanguage) } ?? String(localized: "habitatPlacement.noSelection", defaultValue: "No habitat selected")
        return String(
            localized: "habitatPlacement.accessibility.label",
            defaultValue: "\(option.displayText(for: appState.currentLanguage)). Habitat: \(zoneTitle)."
        )
    }

    private func zoneAccessibilityLabel(_ zone: HabitatZone, selectedItems: [ActivityOption]) -> String {
        if selectedItems.isEmpty {
            return String(
                localized: "habitatPlacement.accessibility.emptyZone",
                defaultValue: "\(zone.displayTitle(for: appState.currentLanguage)). No items placed here yet."
            )
        }

        let itemNames = selectedItems.map { $0.displayText(for: appState.currentLanguage) }.joined(separator: ", ")
        return String(
            localized: "habitatPlacement.accessibility.zone",
            defaultValue: "\(zone.displayTitle(for: appState.currentLanguage)). Items placed here: \(itemNames)."
        )
    }

    private func iconName(for zoneID: String) -> String {
        switch zoneID {
        case "mountain":
            return "mountain.2.fill"
        case "forest":
            return "tree.fill"
        case "wetland":
            return "drop.fill"
        default:
            return "square.grid.2x2.fill"
        }
    }
}

#Preview {
    HabitatPlacementActivityView(
        activity: .sampleHabitatPlacement,
        habitatSelections: .constant(["tur": "mountain", "bear": "forest"])
    )
    .padding()
    .background(AppColors.background)
}
