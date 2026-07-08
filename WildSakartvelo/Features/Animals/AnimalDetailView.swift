import SwiftUI

struct AnimalDetailView: View {
    let animal: Animal
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header
                factSection(title: .localized("animal.section.summary", for: appState.currentLanguage), text: animal.displaySummary(for: appState.currentLanguage))
                factSection(title: .localized("animal.section.habitat", for: appState.currentLanguage), text: animal.displayHabitat(for: appState.currentLanguage))
                factSection(title: .localized("animal.section.diet", for: appState.currentLanguage), text: animal.displayDiet(for: appState.currentLanguage))
                factSection(title: .localized("animal.section.size", for: appState.currentLanguage), text: animal.displaySizeDescription(for: appState.currentLanguage))
                factSection(title: .localized("animal.section.fact", for: appState.currentLanguage), text: animal.displaySurprisingFact(for: appState.currentLanguage))
                conservationSection
                soundPlaybackSection
                footprintSection
            }
            .padding(AppSpacing.medium)
        }
        .background(AppColors.background)
        .navigationTitle(animal.displayName(for: appState.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            appState.stopAudio()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            ContentImageView(
                imageName: animal.imageName,
                fallbackSystemImage: "pawprint.fill",
                mode: .detail,
                height: 280,
                accentColor: animal.conservationStatus.color
            )

            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(animal.displayName(for: appState.currentLanguage))
                    .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .fixedSize(horizontal: false, vertical: true)

                if appState.currentLanguage == .english {
                    Text(animal.scientificName)
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .italic()
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
    }

    private func factSection(title: String, text: String) -> some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.small) {
                Text(title)
                    .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)

                Text(text)
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var conservationSection: some View {
        AppCard {
            HStack(alignment: .top, spacing: AppSpacing.medium) {
                Image(systemName: animal.conservationStatus.systemImage)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(animal.conservationStatus.color)

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(animal.conservationStatus.displayTitle(for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    Text(animal.conservationStatus.childFriendlyDescription(for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    @ViewBuilder
    private var footprintSection: some View {
        if let footprintImageName = animal.footprintImageName {
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text(String.localized("animal.section.footprint", for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    ContentImageView(
                        imageName: footprintImageName,
                        fallbackSystemImage: "pawprint.fill",
                        mode: .card,
                        height: 120,
                        accentColor: AppColors.mountain
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var soundPlaybackSection: some View {
        if appState.soundEffectsEnabled, animal.soundFileName != nil {
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(String.localized("animal.sound.title", for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    AudioControlButton(
                        fileName: animal.soundFileName,
                        label: .localized("animal.sound.play", for: appState.currentLanguage),
                        audioService: appState.audioService,
                        actionLabel: "\(animal.displayName(for: appState.currentLanguage)) sound",
                        accessibilityIdentifier: "animal.soundButton"
                    )

                    if appState.appSettings.subtitlesEnabled {
                        Text(animal.displaySummary(for: appState.currentLanguage))
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityHidden(true)
                    }
                }
            }
        } else if animal.soundFileName != nil {
            AppCard {
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(String.localized("animal.sound.title", for: appState.currentLanguage))
                        .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.primaryText)

                    Text(String.localized("animal.sound.disabled", for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        } else {
            AppCard {
                    Text(String.localized("animal.sound.unavailable", for: appState.currentLanguage))
                        .font(AppTypography.bodyFont(using: accessibilitySettings))
                        .foregroundStyle(AppColors.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AnimalDetailView(animal: .sample)
            .environmentObject(AppState())
    }
}
