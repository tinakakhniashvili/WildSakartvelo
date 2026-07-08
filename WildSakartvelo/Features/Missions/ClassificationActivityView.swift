import SwiftUI

struct ClassificationActivityView: View {
    let activity: MissionActivity
    @Binding var selectedCategories: [String: String]
    @EnvironmentObject private var appState: AppState

    private var categories: [ActivityCategory] {
        activity.categories ?? []
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

            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                ForEach(categories) { category in
                    categorySection(category)
                }
            }

            VStack(spacing: AppSpacing.medium) {
                ForEach(activity.options) { option in
                    itemRow(option)
                }
            }
        }
    }

    private func categorySection(_ category: ActivityCategory) -> some View {
        HStack(spacing: AppSpacing.small) {
            Image(systemName: iconName(for: category.id))
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppColors.forest)
                .frame(width: 28, height: 28)
                .background(AppColors.forest.opacity(0.12), in: RoundedRectangle(cornerRadius: AppSpacing.small))

            Text(category.displayTitle(for: appState.currentLanguage))
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            String(
                localized: "classification.accessibility.category",
                defaultValue: "Category \(category.displayTitle(for: appState.currentLanguage))"
            )
        )
    }

    private func itemRow(_ option: ActivityOption) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack(spacing: AppSpacing.medium) {
                    if option.imageName != nil {
                        ContentImageView(
                            imageName: option.imageName,
                            fallbackSystemImage: "photo.fill",
                            height: 64,
                            accentColor: AppColors.water
                        )
                        .frame(width: 76)
                    }

                    Text(option.displayText(for: appState.currentLanguage))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Picker(
                    String(
                        localized: "classification.picker.title",
                        defaultValue: "Habitat for \(option.displayText(for: appState.currentLanguage))"
                    ),
                    selection: Binding(
                        get: { selectedCategories[option.id] ?? "" },
                        set: { newValue in
                            if newValue.isEmpty {
                                selectedCategories[option.id] = nil
                            } else {
                                selectedCategories[option.id] = newValue
                            }
                        }
                    )
                ) {
                    Text(String(localized: "classification.picker.placeholder")).tag("")
                    ForEach(categories) { category in
                        Text(category.displayTitle(for: appState.currentLanguage)).tag(category.id)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityLabel(
                    String(
                        localized: "classification.accessibility.select",
                        defaultValue: "Select habitat for \(option.displayText(for: appState.currentLanguage))"
                    )
                )
            }
        }
    }

    private func iconName(for categoryID: String) -> String {
        switch categoryID {
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
    ClassificationActivityView(
        activity: .sampleClassification,
        selectedCategories: .constant(["tur": "mountain"])
    )
    .padding()
    .background(AppColors.background)
}
