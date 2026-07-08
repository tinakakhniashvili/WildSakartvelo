import Foundation

final class ResourceResolver {
    static let shared = ResourceResolver()

    private let downloadManager: ContentDownloadManaging
    private var contentPacks: [ContentPack] = []
    private var states: [String: ContentPackState] = [:]

    init(downloadManager: ContentDownloadManaging = ContentDownloadManager()) {
        self.downloadManager = downloadManager
    }

    func configure(contentPacks: [ContentPack], states: [String: ContentPackState]) {
        self.contentPacks = contentPacks
        self.states = states
    }

    func url(for resourceName: String?) -> URL? {
        guard let resourceName, !resourceName.isEmpty else { return nil }

        for pack in contentPacks where states[pack.id]?.status == .downloaded {
            if let url = downloadManager.localURL(for: resourceName, packID: pack.id)
                ?? downloadManager.localURL(for: resourceNameWithDefaultAudioExtension(resourceName), packID: pack.id) {
                return url
            }
        }

        return bundledURL(for: resourceName)
    }

    private func bundledURL(for resourceName: String) -> URL? {
        let baseName = (resourceName as NSString).deletingPathExtension
        let explicitExtension = (resourceName as NSString).pathExtension

        if !explicitExtension.isEmpty,
           let url = Bundle.main.url(forResource: baseName, withExtension: explicitExtension) {
            return url
        }

        if let url = Bundle.main.url(forResource: resourceName, withExtension: nil) {
            return url
        }

        return Bundle.main.url(forResource: baseName, withExtension: "m4a")
            ?? Bundle.main.url(forResource: baseName, withExtension: "mp3")
    }

    private func resourceNameWithDefaultAudioExtension(_ resourceName: String) -> String {
        let explicitExtension = (resourceName as NSString).pathExtension
        return explicitExtension.isEmpty ? "\(resourceName).m4a" : resourceName
    }
}
