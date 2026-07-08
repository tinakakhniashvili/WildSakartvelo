import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .explore
    @Published var hasCompletedOnboarding = false
    @Published var contentCatalogue: ContentCatalogue?
    @Published var contentErrorMessage: String?
    @Published var isLoadingContent = false
    @Published var profiles: [ChildProfile] = []
    @Published var selectedProfile: ChildProfile?
    @Published var userProgress: UserProgress = .empty
    @Published var appSettings: AppSettings
    @Published var contentPackStates: [String: ContentPackState] = [:]

    let applicationTitle = "Wild Sakartvelo"
    let audioService: AVAudioService
    let contentDownloadManager: ContentDownloadManaging
    private let contentService: ContentProviding
    private let onboardingCompletedKey = "wildSakartvelo.hasCompletedOnboarding"
    private let settingsStore: SettingsStoring
    private let contentPackStore: ContentPackStoring
    private let progressService: ProgressService
    private let profileStore: ProfileStoring
    private let challengeService = ExplorerChallengeService()
    private let profileLimit = 4
    private let userDefaults: UserDefaults

    init(
        userDefaults: UserDefaults = .standard,
        audioService: AVAudioService = AVAudioService(),
        contentService: ContentProviding = ContentService(),
        profileStore: ProfileStoring = UserDefaultsProfileStore(),
        progressService: ProgressService = ProgressService(),
        settingsStore: SettingsStoring = UserDefaultsSettingsStore(),
        contentPackStore: ContentPackStoring = UserDefaultsContentPackStore(),
        contentDownloadManager: ContentDownloadManaging = ContentDownloadManager()
    ) {
        self.userDefaults = userDefaults
        self.audioService = audioService
        self.contentService = contentService
        self.profileStore = profileStore
        self.progressService = progressService
        self.settingsStore = settingsStore
        self.contentPackStore = contentPackStore
        self.contentDownloadManager = contentDownloadManager
        self.hasCompletedOnboarding = userDefaults.bool(forKey: onboardingCompletedKey)
        do {
            self.appSettings = try settingsStore.loadSettings()
        } catch {
            AppLogger.content.error("Settings load failed: \(error.localizedDescription, privacy: .public)")
            self.appSettings = .defaultValue
        }

        do {
            self.contentPackStates = try contentPackStore.loadStates()
        } catch {
            AppLogger.downloads.error("Content pack state load failed: \(error.localizedDescription, privacy: .public)")
            self.contentPackStates = [:]
        }

        self.contentDownloadManager.progressHandler = { [weak self] packID, progress in
            Task { @MainActor in
                self?.updateContentPackProgress(packID: packID, progress: progress)
            }
        }
    }

    func loadContent() {
        guard !isLoadingContent else { return }
        guard contentCatalogue == nil else { return }

        isLoadingContent = true
        contentErrorMessage = nil
        selectedTab = .explore

        do {
            contentCatalogue = try ContentCatalogue.load(using: contentService)
            configureResourceResolver()
            loadProfiles()
        } catch {
            AppLogger.content.error("Content load failed: \(error.localizedDescription, privacy: .public)")
            contentCatalogue = nil
            setErrorMessage("error.contentLoad.message")
        }

        isLoadingContent = false
    }

    func loadProfiles() {
        do {
            profiles = try profileStore.loadProfiles()

            guard let selectedProfileID = profileStore.loadSelectedProfileID(),
                  let profile = profiles.first(where: { $0.id == selectedProfileID }) else {
                selectedProfile = nil
                userProgress = .empty
                return
            }

            selectProfile(profile)
        } catch {
            AppLogger.profiles.error("Profile load failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.profiles.load")
        }
    }

    func createProfile(nickname: String, avatarID: String, learningLevel: LearningLevel) {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNickname.isEmpty, profiles.count < profileLimit else { return }

        let limitedNickname = String(trimmedNickname.prefix(20))
        let now = Date()
        let profile = ChildProfile(
            id: UUID(),
            nickname: limitedNickname,
            avatarID: avatarID,
            learningLevel: learningLevel,
            createdAt: now,
            lastOpenedAt: now
        )

        do {
            profiles.append(profile)
            try profileStore.saveProfiles(profiles)
            selectProfile(profile)
        } catch {
            AppLogger.profiles.error("Profile create failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.profiles.save")
        }
    }

    func selectProfile(_ profile: ChildProfile) {
        do {
            var updatedProfile = profile
            updatedProfile.lastOpenedAt = Date()

            if let index = profiles.firstIndex(where: { $0.id == updatedProfile.id }) {
                profiles[index] = updatedProfile
                try profileStore.saveProfiles(profiles)
            }

            selectedProfile = updatedProfile
            profileStore.saveSelectedProfileID(updatedProfile.id)
            userProgress = try progressService.loadProgress(for: updatedProfile.id)
            selectedTab = .explore
        } catch {
            AppLogger.profiles.error("Profile selection failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.profiles.load")
        }
    }

    func clearSelectedProfile() {
        stopAudio()
        selectedProfile = nil
        userProgress = .empty
        profileStore.saveSelectedProfileID(nil)
        selectedTab = .explore
    }

    func deleteProfile(_ profile: ChildProfile) {
        do {
            profiles.removeAll { $0.id == profile.id }
            try profileStore.saveProfiles(profiles)
            try progressService.deleteProgress(for: profile.id)

            if selectedProfile?.id == profile.id {
                selectedProfile = nil
                userProgress = .empty

                if let nextProfile = profiles.first {
                    selectProfile(nextProfile)
                } else {
                    profileStore.saveSelectedProfileID(nil)
                }
            }
        } catch {
            AppLogger.profiles.error("Profile delete failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.profiles.save")
        }
    }

    func updateProfile(_ profile: ChildProfile) {
        do {
            guard let index = profiles.firstIndex(where: { $0.id == profile.id }) else { return }
            profiles[index] = profile
            try profileStore.saveProfiles(profiles)

            if selectedProfile?.id == profile.id {
                selectedProfile = profile
            }
        } catch {
            AppLogger.profiles.error("Profile update failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.profiles.save")
        }
    }

    func startMission(_ mission: Mission) {
        guard let profileID = selectedProfile?.id else { return }

        do {
            userProgress = try progressService.startMission(mission, for: profileID)
        } catch {
            AppLogger.progress.error("Start mission failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.progress.save")
        }
    }

    func saveMissionProgress(_ mission: Mission, activityIndex: Int, attempts: Int) {
        guard let profileID = selectedProfile?.id else { return }

        do {
            userProgress = try progressService.updateMission(
                mission,
                activityIndex: activityIndex,
                attempts: attempts,
                for: profileID
            )
        } catch {
            AppLogger.progress.error("Mission progress save failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.progress.save")
        }
    }

    func completeMission(_ mission: Mission) {
        guard let profileID = selectedProfile?.id else { return }

        do {
            let completedProgress = try progressService.completeMission(mission, for: profileID)
            userProgress = try saveChallengeRewardsIfNeeded(completedProgress, for: profileID)
        } catch {
            AppLogger.progress.error("Mission completion failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.progress.save")
        }
    }

    func completeObservation(_ observation: ObservationActivity) {
        guard let profileID = selectedProfile?.id else { return }

        do {
            let completedProgress = try progressService.completeObservation(observation, for: profileID)
            userProgress = try saveChallengeRewardsIfNeeded(completedProgress, for: profileID)
        } catch {
            AppLogger.progress.error("Observation completion failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.progress.save")
        }
    }

    private func saveChallengeRewardsIfNeeded(_ progress: UserProgress, for profileID: UUID) throws -> UserProgress {
        guard let contentCatalogue else { return progress }
        let updated = challengeService.applyingCompletedRewards(in: contentCatalogue, to: progress)
        guard updated != progress else { return progress }
        return try progressService.saveProgress(updated, for: profileID)
    }

    func resetProgress() {
        guard let profileID = selectedProfile?.id else { return }

        do {
            userProgress = try progressService.resetProgress(for: profileID)
        } catch {
            AppLogger.progress.error("Progress reset failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.progress.save")
        }
    }

    var canCreateProfile: Bool {
        profiles.count < profileLimit
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingCompletedKey)
    }

    func resetOnboarding() {
        stopAudio()
        hasCompletedOnboarding = false
        userDefaults.set(false, forKey: onboardingCompletedKey)
        clearSelectedProfile()
    }

    func playAudio(_ fileName: String) {
        audioService.play(fileName: fileName)
    }

    func contentPackState(for pack: ContentPack) -> ContentPackState {
        let storedState = contentPackStates[pack.id] ?? ContentPackState(
            packID: pack.id,
            status: .notDownloaded,
            progress: 0,
            installedVersion: nil,
            errorMessage: nil
        )

        if storedState.status == .downloaded,
           let installedVersion = storedState.installedVersion,
           pack.version > installedVersion {
            return ContentPackState(
                packID: pack.id,
                status: .downloaded,
                progress: storedState.progress,
                installedVersion: installedVersion,
                errorMessage: nil
            )
        }

        return storedState
    }

    func downloadContentPack(_ pack: ContentPack) async {
        setContentPackState(
            ContentPackState(
                packID: pack.id,
                status: .downloading,
                progress: 0,
                installedVersion: contentPackStates[pack.id]?.installedVersion,
                errorMessage: nil
            )
        )

        do {
            try await contentDownloadManager.download(pack)
            setContentPackState(
                ContentPackState(
                    packID: pack.id,
                    status: .downloaded,
                    progress: 1,
                    installedVersion: pack.version,
                    errorMessage: nil
                )
            )
        } catch {
            AppLogger.downloads.error("Content pack download failed: \(error.localizedDescription, privacy: .public)")
            setContentPackState(
                ContentPackState(
                    packID: pack.id,
                    status: .failed,
                    progress: 0,
                    installedVersion: contentPackStates[pack.id]?.installedVersion,
                    errorMessage: error.localizedDescription
                )
            )
        }
    }

    func cancelContentPackDownload(_ pack: ContentPack) {
        contentDownloadManager.cancelDownload(packID: pack.id)
        setContentPackState(
            ContentPackState(
                packID: pack.id,
                status: .notDownloaded,
                progress: 0,
                installedVersion: contentPackStates[pack.id]?.installedVersion,
                errorMessage: nil
            )
        )
    }

    func deleteContentPack(_ pack: ContentPack) {
        do {
            try contentDownloadManager.deleteDownload(packID: pack.id)
            setContentPackState(
                ContentPackState(
                    packID: pack.id,
                    status: .notDownloaded,
                    progress: 0,
                    installedVersion: nil,
                    errorMessage: nil
                )
            )
        } catch {
            AppLogger.downloads.error("Content pack delete failed: \(error.localizedDescription, privacy: .public)")
            setContentPackState(
                ContentPackState(
                    packID: pack.id,
                    status: .failed,
                    progress: 0,
                    installedVersion: contentPackStates[pack.id]?.installedVersion,
                    errorMessage: error.localizedDescription
                )
            )
        }
    }

    var downloadedContentPackCount: Int {
        guard let packs = contentCatalogue?.contentPacks else { return 0 }
        return packs.filter { contentPackState(for: $0).status == .downloaded }.count
    }

    var approximateDownloadedContentSize: Int {
        guard let packs = contentCatalogue?.contentPacks else { return 0 }
        return packs
            .filter { contentPackState(for: $0).status == .downloaded }
            .reduce(0) { $0 + $1.estimatedSizeBytes }
    }

    func pauseAudio() {
        audioService.pause()
    }

    func resumeAudio() {
        audioService.resume()
    }

    func stopAudio() {
        audioService.stop()
    }

    func updateLanguage(_ language: AppLanguage) {
        appSettings.language = language
        saveSettings()
    }

    func updateNarrationEnabled(_ value: Bool) {
        appSettings.narrationEnabled = value
        if !value {
            audioService.stop()
        }
        saveSettings()
    }

    func updateSoundEffectsEnabled(_ value: Bool) {
        appSettings.soundEffectsEnabled = value
        if !value {
            audioService.stop()
        }
        saveSettings()
    }

    func updateLargerTextEnabled(_ value: Bool) {
        appSettings.largerTextEnabled = value
        saveSettings()
    }

    func updateReducedMotionEnabled(_ value: Bool) {
        appSettings.reducedMotionEnabled = value
        saveSettings()
    }

    func updateHighContrastEnabled(_ value: Bool) {
        appSettings.highContrastEnabled = value
        saveSettings()
    }

    func updateSubtitlesEnabled(_ value: Bool) {
        appSettings.subtitlesEnabled = value
        saveSettings()
    }

    private func saveSettings() {
        do {
            try settingsStore.saveSettings(appSettings)
        } catch {
            AppLogger.content.error("Settings save failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.settings.save")
        }
    }

    private func updateContentPackProgress(packID: String, progress: Double) {
        guard var state = contentPackStates[packID], state.status == .downloading else { return }
        state.progress = progress
        contentPackStates[packID] = state
        saveContentPackStates()
    }

    private func setContentPackState(_ state: ContentPackState) {
        contentPackStates[state.packID] = state
        saveContentPackStates()
        configureResourceResolver()
    }

    private func saveContentPackStates() {
        do {
            try contentPackStore.saveStates(contentPackStates)
        } catch {
            AppLogger.downloads.error("Content pack state save failed: \(error.localizedDescription, privacy: .public)")
            setErrorMessage("error.downloads.save")
        }
    }

    private func setErrorMessage(_ key: String) {
        contentErrorMessage = String.localized(key, for: currentLanguage)
    }

    private func configureResourceResolver() {
        ResourceResolver.shared.configure(
            contentPacks: contentCatalogue?.contentPacks ?? [],
            states: contentPackStates
        )
    }

    var narrationEnabled: Bool {
        appSettings.narrationEnabled
    }

    var soundEffectsEnabled: Bool {
        appSettings.soundEffectsEnabled
    }

    var largerTextEnabled: Bool {
        appSettings.largerTextEnabled
    }

    var reducedMotionEnabled: Bool {
        appSettings.reducedMotionEnabled
    }

    var highContrastEnabled: Bool {
        appSettings.highContrastEnabled
    }

    var subtitlesEnabled: Bool {
        appSettings.subtitlesEnabled
    }

    var currentLanguage: AppLanguage {
        appSettings.language
    }

    var appAccessibilitySettings: AppAccessibilitySettings {
        AppAccessibilitySettings(
            largerTextEnabled: appSettings.largerTextEnabled,
            reducedMotionEnabled: appSettings.reducedMotionEnabled,
            highContrastEnabled: appSettings.highContrastEnabled,
            subtitlesEnabled: appSettings.subtitlesEnabled
        )
    }
}

enum AppTab: Hashable {
    case explore
    case journal
    case parent
    case settings
}
