import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @State private var selectedPageIndex = 0

    private let pages = OnboardingPage.pages

    private var isLastPage: Bool {
        selectedPageIndex == pages.count - 1
    }

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            HStack {
                Spacer()

                Button(String.localized("action.skip", for: appState.currentLanguage)) {
                    appState.stopAudio()
                    appState.completeOnboarding()
                }
                .font(AppTypography.buttonFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.forest)
                .opacity(isLastPage ? 0 : 1)
                .disabled(isLastPage)
                .accessibilityIdentifier("onboarding.skipButton")
            }
            .padding(.horizontal, AppSpacing.medium)
            .padding(.top, AppSpacing.medium)

            TabView(selection: $selectedPageIndex) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .environmentObject(appState)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onChange(of: selectedPageIndex) { _, _ in
                appState.stopAudio()
            }

            PrimaryButton(title: isLastPage ? String.localized("action.getStarted", for: appState.currentLanguage) : String.localized("action.next", for: appState.currentLanguage)) {
                if isLastPage {
                    appState.stopAudio()
                    appState.completeOnboarding()
                } else {
                    selectedPageIndex += 1
                }
            }
            .accessibilityIdentifier(isLastPage ? "onboarding.getStartedButton" : "onboarding.nextButton")
            .padding(.horizontal, AppSpacing.medium)
            .padding(.bottom, AppSpacing.medium)
        }
        .background(AppColors.background)
        .onDisappear {
            appState.stopAudio()
        }
        .transaction { transaction in
            if appState.appSettings.reducedMotionEnabled || systemReduceMotion {
                transaction.animation = nil
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer(minLength: AppSpacing.large)

            ContentImageView(
                imageName: page.imageName,
                fallbackSystemImage: page.systemImage,
                mode: .hero,
                height: 210,
                accentColor: AppColors.forest,
                accessibilityDescription: page.displayTitle(for: appState.currentLanguage)
            )
            .frame(maxWidth: 280)

            VStack(spacing: AppSpacing.medium) {
                Text(page.displayTitle(for: appState.currentLanguage))
                    .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(page.displayDescription(for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                if appState.narrationEnabled, page.narrationFileName(for: appState.currentLanguage) != nil {
                    AudioControlButton(
                        fileName: page.narrationFileName(for: appState.currentLanguage),
                        label: String.localized("audio.playNarration", for: appState.currentLanguage),
                        audioService: appState.audioService,
                        actionLabel: "narration",
                        accessibilityIdentifier: "onboarding.narrationButton"
                    )
                    if appState.appSettings.subtitlesEnabled {
                        Text(page.displayDescription(for: appState.currentLanguage))
                            .font(AppTypography.captionFont(using: accessibilitySettings))
                            .foregroundStyle(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityHidden(true)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.large)

            Spacer(minLength: AppSpacing.large)
        }
        .padding(.vertical, AppSpacing.large)
    }
}

private struct OnboardingPreview: View {
    @StateObject private var appState = AppState()

    var body: some View {
        OnboardingView()
            .environmentObject(appState)
    }
}

#Preview("Onboarding Page") {
    OnboardingPageView(page: .sample)
        .environmentObject(AppState())
        .background(AppColors.background)
}

#Preview("Onboarding View") {
    OnboardingPreview()
}
