import SwiftUI

struct ProfileSelectionView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @State private var isShowingCreateProfile = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    header

                    if appState.profiles.isEmpty {
                        emptyProfiles
                    } else {
                        profileList
                    }

                    addProfileButton
                }
                .padding(AppSpacing.medium)
            }
            .background(AppColors.background)
            .navigationTitle(String.localized("profile.selection.title", for: appState.currentLanguage))
            .sheet(isPresented: $isShowingCreateProfile) {
                CreateProfileView()
                    .environmentObject(appState)
            }
        }
    }

    private var header: some View {
        IllustratedHeaderView(
            title: String.localized("app.title", for: appState.currentLanguage),
            subtitle: String.localized("profile.selection.description", for: appState.currentLanguage),
            imageName: "onboarding_welcome",
            accentColor: AppColors.forest
        )
    }

    private var emptyProfiles: some View {
        EmptyStateView(
            systemImage: "person.crop.circle.badge.plus",
            imageName: "avatar_fox_explorer",
            title: String.localized("profile.selection.empty.title", for: appState.currentLanguage),
            description: String.localized("profile.selection.empty.description", for: appState.currentLanguage)
        )
        .padding(.vertical, AppSpacing.large)
    }

    private var profileList: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            KidSectionHeader(
                title: String.localized("profile.selection.title", for: appState.currentLanguage),
                symbol: "person.2.fill",
                color: AppColors.water
            )

            ForEach(appState.profiles) { profile in
                Button {
                    appState.selectProfile(profile)
                } label: {
                    ProfileCardView(profile: profile, language: appState.currentLanguage)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var addProfileButton: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            PrimaryButton(title: appState.profiles.isEmpty ? String.localized("profile.create", for: appState.currentLanguage) : String.localized("profile.add", for: appState.currentLanguage)) {
                isShowingCreateProfile = true
            }
            .disabled(!appState.canCreateProfile)
            .accessibilityIdentifier("profile.createButton")

            if !appState.canCreateProfile {
                Text(String.localized("profile.limit.reached", for: appState.currentLanguage))
                    .font(AppTypography.bodyFont(using: accessibilitySettings))
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
    }
}

private struct ProfileSelectionPreview: View {
    @StateObject private var appState = AppState()

    var body: some View {
        ProfileSelectionView()
            .environmentObject(appState)
            .onAppear {
                appState.profiles = [.sample]
            }
    }
}

#Preview {
    ProfileSelectionPreview()
}
