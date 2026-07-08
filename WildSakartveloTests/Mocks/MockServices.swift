import Foundation
@testable import WildSakartvelo

final class MockContentService: ContentProviding {
    var ecosystems: [Ecosystem]
    var animals: [Animal]
    var plants: [Plant]
    var missions: [Mission]
    var activities: [MissionActivity]
    var contentPacks: [ContentPack]
    var dailyDiscoveries: [DailyDiscovery]
    var explorerChallenges: [ExplorerChallenge]
    var observationActivities: [ObservationActivity]

    init(
        ecosystems: [Ecosystem] = [TestFixtures.ecosystem()],
        animals: [Animal] = [.sample],
        plants: [Plant] = [.sample],
        missions: [Mission] = [TestFixtures.mission()],
        activities: [MissionActivity] = [.sample],
        contentPacks: [ContentPack] = [.sample],
        dailyDiscoveries: [DailyDiscovery] = [TestFixtures.dailyDiscovery()],
        explorerChallenges: [ExplorerChallenge] = [TestFixtures.challenge()],
        observationActivities: [ObservationActivity] = [TestFixtures.observation()]
    ) {
        self.ecosystems = ecosystems
        self.animals = animals
        self.plants = plants
        self.missions = missions
        self.activities = activities
        self.contentPacks = contentPacks
        self.dailyDiscoveries = dailyDiscoveries
        self.explorerChallenges = explorerChallenges
        self.observationActivities = observationActivities
    }

    func loadEcosystems() throws -> [Ecosystem] { ecosystems }
    func loadAnimals() throws -> [Animal] { animals }
    func loadPlants() throws -> [Plant] { plants }
    func loadMissions() throws -> [Mission] { missions }
    func loadActivities() throws -> [MissionActivity] { activities }
    func loadContentPacks() throws -> [ContentPack] { contentPacks }
    func loadDailyDiscoveries() throws -> [DailyDiscovery] { dailyDiscoveries }
    func loadExplorerChallenges() throws -> [ExplorerChallenge] { explorerChallenges }
    func loadObservationActivities() throws -> [ObservationActivity] { observationActivities }
}

final class MockProgressStore: ProgressStoring {
    var values: [UUID: UserProgress] = [:]
    var shouldFailSaving = false

    func loadProgress(for profileID: UUID) throws -> UserProgress {
        values[profileID] ?? .empty
    }

    func saveProgress(_ progress: UserProgress, for profileID: UUID) throws {
        if shouldFailSaving {
            throw ContentError.invalidData("Mock progress save failed")
        }
        values[profileID] = progress
    }

    func resetProgress(for profileID: UUID) throws {
        values[profileID] = .empty
    }

    func deleteProgress(for profileID: UUID) throws {
        values.removeValue(forKey: profileID)
    }
}

final class MockProfileStore: ProfileStoring {
    var profiles: [ChildProfile] = []
    var selectedProfileID: UUID?

    func loadProfiles() throws -> [ChildProfile] { profiles }
    func saveProfiles(_ profiles: [ChildProfile]) throws { self.profiles = profiles }
    func loadSelectedProfileID() -> UUID? { selectedProfileID }
    func saveSelectedProfileID(_ id: UUID?) { selectedProfileID = id }
    func deleteAllProfiles() throws {
        profiles = []
        selectedProfileID = nil
    }
}

final class MockSettingsStore: SettingsStoring {
    var settings: AppSettings = .defaultValue
    func loadSettings() throws -> AppSettings { settings }
    func saveSettings(_ settings: AppSettings) throws { self.settings = settings }
    func resetSettings() throws { settings = .defaultValue }
}

final class MockDownloadManager: ContentDownloadManaging {
    var progressHandler: ((String, Double) -> Void)?
    var downloadedPackIDs: Set<String> = []
    var deletedPackIDs: Set<String> = []

    func download(_ pack: ContentPack) async throws {
        progressHandler?(pack.id, 1)
        downloadedPackIDs.insert(pack.id)
    }

    func cancelDownload(packID: String) {
        downloadedPackIDs.remove(packID)
    }

    func deleteDownload(packID: String) throws {
        deletedPackIDs.insert(packID)
        downloadedPackIDs.remove(packID)
    }

    func isDownloaded(_ pack: ContentPack) -> Bool {
        downloadedPackIDs.contains(pack.id)
    }

    func localURL(for resourceName: String, packID: String) -> URL? {
        nil
    }
}

final class MockAudioService: AudioPlaying {
    var isPlaying = false
    var currentFileName: String?

    func play(fileName: String) {
        currentFileName = fileName
        isPlaying = true
    }

    func pause() {
        isPlaying = false
    }

    func resume() {
        isPlaying = currentFileName != nil
    }

    func stop() {
        currentFileName = nil
        isPlaying = false
    }
}
