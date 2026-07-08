import SwiftUI

struct EditProfileView: View {
    let profile: ChildProfile
    let onSave: (ChildProfile) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appAccessibilitySettings) private var accessibilitySettings
    @EnvironmentObject private var appState: AppState
    @State private var nickname: String
    @State private var selectedAvatarID: String
    @State private var selectedLevel: LearningLevel

    init(profile: ChildProfile, onSave: @escaping (ChildProfile) -> Void) {
        self.profile = profile
        self.onSave = onSave
        _nickname = State(initialValue: profile.nickname)
        _selectedAvatarID = State(initialValue: profile.avatarID)
        _selectedLevel = State(initialValue: profile.learningLevel)
    }

    private var trimmedNickname: String {
        nickname.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedNickname.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    nicknameSection
                    avatarSection
                    levelSection
                }
                .padding(AppSpacing.medium)
            }
            .background(AppColors.background)
            .navigationTitle(String.localized("parent.editProfile.title", for: appState.currentLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(String.localized("action.cancel", for: appState.currentLanguage)) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(String.localized("action.save", for: appState.currentLanguage)) {
                        saveProfile()
                    }
                    .disabled(!canSave)
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
            Text(String.localized("profile.nickname", for: appState.currentLanguage))
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            TextField(String.localized("profile.nickname.placeholder", for: appState.currentLanguage), text: $nickname)
                .textInputAutocapitalization(.words)
                .padding(AppSpacing.medium)
                .background(AppColors.surface, in: RoundedRectangle(cornerRadius: AppSpacing.medium))
                .accessibilityIdentifier("parent.editProfile.nickname")
        }
    }

    private var avatarSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String.localized("profile.avatar", for: appState.currentLanguage))
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            AvatarSelectionView(selectedAvatarID: $selectedAvatarID)
        }
    }

    private var levelSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(String.localized("profile.learningLevel", for: appState.currentLanguage))
                .font(AppTypography.cardTitleFont(using: accessibilitySettings))
                .foregroundStyle(AppColors.primaryText)

            LearningLevelSelectionView(selectedLevel: $selectedLevel)
        }
    }

    private func saveProfile() {
        var updatedProfile = profile
        updatedProfile.nickname = String(trimmedNickname.prefix(20))
        updatedProfile.avatarID = selectedAvatarID
        updatedProfile.learningLevel = selectedLevel
        onSave(updatedProfile)
        dismiss()
    }
}

#Preview("Edit Profile") {
    EditProfileView(profile: .sample) { _ in }
        .environmentObject(AppState())
        .environment(\.appAccessibilitySettings, AppAccessibilitySettings.defaultValue)
}
