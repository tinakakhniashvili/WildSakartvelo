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
            .navigationTitle(String(localized: "profile.selection.title"))
            .sheet(isPresented: $isShowingCreateProfile) {
                CreateProfileView()
                    .environmentObject(appState)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String(localized: "app.title"))
                .font(AppTypography.largeTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            Text(String(localized: "profile.selection.description"))
                .font(AppTypography.bodyFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var emptyProfiles: some View {
        EmptyStateView(
            systemImage: "person.crop.circle.badge.plus",
            title: String(localized: "profile.selection.empty.title"),
            description: String(localized: "profile.selection.empty.description")
        )
        .padding(.vertical, AppSpacing.large)
    }

    private var profileList: some View {
        VStack(spacing: AppSpacing.medium) {
            ForEach(appState.profiles) { profile in
                Button {
                    appState.selectProfile(profile)
                } label: {
                    ProfileCardView(profile: profile)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var addProfileButton: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            PrimaryButton(title: appState.profiles.isEmpty ? String(localized: "profile.create") : String(localized: "profile.add")) {
                isShowingCreateProfile = true
            }
            .disabled(!appState.canCreateProfile)
            .accessibilityIdentifier("profile.createButton")

            if !appState.canCreateProfile {
                Text(String(localized: "profile.limit.reached"))
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
