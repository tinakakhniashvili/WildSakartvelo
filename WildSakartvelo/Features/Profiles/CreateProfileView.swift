import SwiftUI

struct CreateProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var nickname = ""
    @State private var selectedAvatarID = AvatarSelectionView.avatarIDs[0]
    @State private var selectedLevel = LearningLevel.explorerOne

    private var trimmedNickname: String {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canCreate: Bool {
        !trimmedNickname.isEmpty && appState.canCreateProfile
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    nicknameSection
                    avatarSection
                    levelSection

                    if !appState.canCreateProfile {
                        Text(String(localized: "profile.limit.description"))
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                    }

                    PrimaryButton(title: String(localized: "profile.create")) {
                        appState.createProfile(
                            nickname: trimmedNickname,
                            avatarID: selectedAvatarID,
                            learningLevel: selectedLevel
                        )
                        dismiss()
                    }
                    .disabled(!canCreate)
                }
                .padding(AppSpacing.medium)
            }
            .background(AppColors.background)
            .navigationTitle(String(localized: "profile.create.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "action.cancel")) {
                        dismiss()
                    }
                }
            }
            .onChange(of: nickname) { _, newValue in
                if newValue.count > 20 {
                    nickname = String(newValue.prefix(20))
                }
            }
        }
    }

    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String(localized: "profile.nickname"))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

            TextField(String(localized: "profile.nickname.placeholder"), text: $nickname)
                .textInputAutocapitalization(.words)
                .padding(AppSpacing.medium)
                .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppSpacing.medium))
        }
    }

    private var avatarSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String(localized: "profile.avatar"))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

            AvatarSelectionView(selectedAvatarID: $selectedAvatarID)
        }
    }

    private var levelSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String(localized: "profile.learningLevel"))
                .font(AppTypography.cardTitle)
                .foregroundStyle(AppColors.primaryText)

            LearningLevelSelectionView(selectedLevel: $selectedLevel)
        }
    }
}

private struct CreateProfilePreview: View {
    @StateObject private var appState = AppState()

    var body: some View {
        CreateProfileView()
            .environmentObject(appState)
    }
}

#Preview {
    CreateProfilePreview()
}
