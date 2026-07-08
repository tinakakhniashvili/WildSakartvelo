import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        Form {
            languageSection

            if let selectedProfile = appState.selectedProfile {
                Section(String.localized("settings.section.profile", for: appState.currentLanguage)) {
                    LabeledContent(String.localized("settings.profile.nickname", for: appState.currentLanguage), value: selectedProfile.nickname)
                    LabeledContent(
                        String.localized("settings.profile.learningLevel", for: appState.currentLanguage),
                        value: selectedProfile.learningLevel.displayTitle(for: appState.currentLanguage)
                    )

                    Button(String.localized("settings.action.switchProfile", for: appState.currentLanguage)) {
                        appState.clearSelectedProfile()
                    }
                }
            }

            Section(String.localized("settings.section.general", for: appState.currentLanguage)) {
                Toggle(
                    String.localized("settings.toggle.narration", for: appState.currentLanguage),
                    isOn: Binding(
                        get: { appState.appSettings.narrationEnabled },
                        set: { appState.updateNarrationEnabled($0) }
                    )
                )

                Toggle(
                    String.localized("settings.toggle.soundEffects", for: appState.currentLanguage),
                    isOn: Binding(
                        get: { appState.appSettings.soundEffectsEnabled },
                        set: { appState.updateSoundEffectsEnabled($0) }
                    )
                )
            }

            if let catalogue = appState.contentCatalogue {
                Section(String.localized("downloads.title", for: appState.currentLanguage)) {
                    NavigationLink {
                        OfflineContentView(catalogue: catalogue)
                    } label: {
                        VStack(alignment: .leading, spacing: AppSpacing.extraSmall) {
                            Text(String.localized("downloads.title", for: appState.currentLanguage))
                                .font(AppTypography.bodyFont(using: accessibilitySettings))

                            Text(downloadSummary)
                                .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                        }
                    }
                    .accessibilityLabel(Text(String.localized("downloads.title", for: appState.currentLanguage)))
                    .accessibilityValue(Text(downloadSummary))
                }
            }

            Section(String.localized("settings.section.accessibility", for: appState.currentLanguage)) {
                Toggle(
                    String.localized("settings.toggle.largerText", for: appState.currentLanguage),
                    isOn: Binding(
                        get: { appState.appSettings.largerTextEnabled },
                        set: { appState.updateLargerTextEnabled($0) }
                    )
                )
                .accessibilityIdentifier("settings.largerTextToggle")

                Toggle(
                    String.localized("settings.toggle.reducedMotion", for: appState.currentLanguage),
                    isOn: Binding(
                        get: { appState.appSettings.reducedMotionEnabled },
                        set: { appState.updateReducedMotionEnabled($0) }
                    )
                )
                .accessibilityIdentifier("settings.reducedMotionToggle")

                Toggle(
                    String.localized("settings.toggle.highContrast", for: appState.currentLanguage),
                    isOn: Binding(
                        get: { appState.appSettings.highContrastEnabled },
                        set: { appState.updateHighContrastEnabled($0) }
                    )
                )
                .accessibilityIdentifier("settings.highContrastToggle")

                Toggle(
                    String.localized("settings.toggle.subtitles", for: appState.currentLanguage),
                    isOn: Binding(
                        get: { appState.appSettings.subtitlesEnabled },
                        set: { appState.updateSubtitlesEnabled($0) }
                    )
                )
                .accessibilityIdentifier("settings.subtitlesToggle")

                Text(String.localized("settings.accessibility.description", for: appState.currentLanguage))
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }

            Section(String.localized("settings.section.about", for: appState.currentLanguage)) {
                LabeledContent(String.localized("settings.about.application", for: appState.currentLanguage), value: String.localized("app.title", for: appState.currentLanguage))
                LabeledContent(String.localized("settings.about.version", for: appState.currentLanguage), value: "1.0.0")

                Text(String.localized("settings.about.description", for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)

                Button(String.localized("settings.action.replayOnboarding", for: appState.currentLanguage)) {
                    appState.resetOnboarding()
                }
                .accessibilityIdentifier("settings.replayOnboardingButton")
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
        .navigationTitle(String.localized("settings.title", for: appState.currentLanguage))
    }

    private var languageSection: some View {
        Section(String.localized("settings.section.language", for: appState.currentLanguage)) {
            Picker(
                String.localized("settings.language", for: appState.currentLanguage),
                selection: Binding(
                    get: { appState.appSettings.language },
                    set: { appState.updateLanguage($0) }
                )
            ) {
                ForEach(AppLanguage.allCases, id: \.self) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .accessibilityIdentifier("settings.languagePicker")
        }
    }

    private var downloadSummary: String {
        String(
            format: String.localized("downloads.settings.summary", for: appState.currentLanguage),
            appState.downloadedContentPackCount,
            formattedSize(appState.approximateDownloadedContentSize)
        )
    }

    private func formattedSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

#Preview("Settings - Georgian") {
    NavigationStack {
        SettingsView()
            .environmentObject({
                let state = AppState()
                state.updateLanguage(.georgian)
                state.updateHighContrastEnabled(true)
                return state
            }())
    }
}
