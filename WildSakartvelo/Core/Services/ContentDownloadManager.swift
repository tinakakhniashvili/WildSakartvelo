import Foundation

enum ContentDownloadError: LocalizedError {
    case cancelled
    case invalidFileName(String)
    case missingBundledResource(String)
    case invalidRemoteURL(String)
    case insufficientStorage

    var errorDescription: String? {
        switch self {
        case .cancelled:
            return String(localized: "downloads.error.cancelled")
        case .invalidFileName:
            return String(localized: "downloads.error.invalidFile")
        case .missingBundledResource(let fileName):
            return String(format: String(localized: "downloads.error.missingBundleResource"), fileName)
        case .invalidRemoteURL:
            return String(localized: "downloads.error.network")
        case .insufficientStorage:
            return String(localized: "downloads.error.storage")
        }
    }
}

final class ContentDownloadManager: ContentDownloadManaging {
    var progressHandler: ((String, Double) -> Void)?

    private let fileManager: FileManager
    private let session: URLSession
    private var downloadTasks: [String: URLSessionDownloadTask] = [:]
    private var cancelledPackIDs = Set<String>()

    init(fileManager: FileManager = .default, session: URLSession = .shared) {
        self.fileManager = fileManager
        self.session = session
    }

    func download(_ pack: ContentPack) async throws {
        try validate(pack)
        try checkAvailableStorage(for: pack)
        cancelledPackIDs.remove(pack.id)

        let finalDirectory = packDirectory(for: pack.id)
        let temporaryDirectory = temporaryPackDirectory(for: pack.id)

        try removeDirectoryIfNeeded(temporaryDirectory)
        try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)

        do {
            if let remoteBaseURL = pack.remoteBaseURL {
                try await downloadRemotePack(pack, remoteBaseURL: remoteBaseURL, to: temporaryDirectory)
            } else {
                try copyBundledPack(pack, to: temporaryDirectory)
            }

            try checkCancellation(for: pack.id)
            try replaceDirectory(at: finalDirectory, with: temporaryDirectory)
            progressHandler?(pack.id, 1)
        } catch {
            try? removeDirectoryIfNeeded(temporaryDirectory)
            cancelledPackIDs.remove(pack.id)
            if (error as? CancellationError) != nil {
                throw ContentDownloadError.cancelled
            }
            throw error
        }
    }

    func cancelDownload(packID: String) {
        cancelledPackIDs.insert(packID)
        downloadTasks[packID]?.cancel()
        downloadTasks[packID] = nil
        try? removeDirectoryIfNeeded(temporaryDirectory(for: packID))
    }

    func deleteDownload(packID: String) throws {
        cancelDownload(packID: packID)
        try removeDirectoryIfNeeded(packDirectory(for: packID))
    }

    func isDownloaded(_ pack: ContentPack) -> Bool {
        fileManager.fileExists(atPath: packDirectory(for: pack.id).path)
    }

    func localURL(for resourceName: String, packID: String) -> URL? {
        guard let safeFileName = try? safeResourceFileName(resourceName) else { return nil }
        let url = packDirectory(for: packID).appendingPathComponent(safeFileName, isDirectory: false)
        return fileManager.fileExists(atPath: url.path) ? url : nil
    }

    private func downloadRemotePack(_ pack: ContentPack, remoteBaseURL: String, to directory: URL) async throws {
        guard let baseURL = URL(string: remoteBaseURL) else {
            throw ContentDownloadError.invalidRemoteURL(remoteBaseURL)
        }

        for (index, fileName) in pack.resourceFiles.enumerated() {
            try Task.checkCancellation()
            try checkCancellation(for: pack.id)
            let safeFileName = try safeResourceFileName(fileName)
            let destinationURL = directory.appendingPathComponent(safeFileName, isDirectory: false)

            if fileManager.fileExists(atPath: destinationURL.path) {
                progressHandler?(pack.id, progress(for: index + 1, total: pack.resourceFiles.count))
                continue
            }

            let resourceURL = baseURL.appendingPathComponent(safeFileName)
            let (downloadedURL, _) = try await session.download(from: resourceURL)
            try checkCancellation(for: pack.id)
            try fileManager.moveItem(at: downloadedURL, to: destinationURL)
            progressHandler?(pack.id, progress(for: index + 1, total: pack.resourceFiles.count))
        }
    }

    private func copyBundledPack(_ pack: ContentPack, to directory: URL) throws {
        for (index, fileName) in pack.resourceFiles.enumerated() {
            try checkCancellation(for: pack.id)
            let safeFileName = try safeResourceFileName(fileName)
            let destinationURL = directory.appendingPathComponent(safeFileName, isDirectory: false)

            if fileManager.fileExists(atPath: destinationURL.path) {
                progressHandler?(pack.id, progress(for: index + 1, total: pack.resourceFiles.count))
                continue
            }

            guard let sourceURL = bundledURL(for: safeFileName) else {
                throw ContentDownloadError.missingBundledResource(safeFileName)
            }

            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            try checkCancellation(for: pack.id)
            progressHandler?(pack.id, progress(for: index + 1, total: pack.resourceFiles.count))
        }
    }

    private func checkCancellation(for packID: String) throws {
        if cancelledPackIDs.contains(packID) {
            throw CancellationError()
        }
    }

    private func validate(_ pack: ContentPack) throws {
        for fileName in pack.resourceFiles {
            _ = try safeResourceFileName(fileName)
        }
    }

    private func safeResourceFileName(_ fileName: String) throws -> String {
        let url = URL(fileURLWithPath: fileName)
        let lastPathComponent = url.lastPathComponent
        guard !lastPathComponent.isEmpty,
              lastPathComponent == fileName,
              !fileName.contains(".."),
              !fileName.contains("/") else {
            throw ContentDownloadError.invalidFileName(fileName)
        }
        return lastPathComponent
    }

    private func bundledURL(for fileName: String) -> URL? {
        let baseName = (fileName as NSString).deletingPathExtension
        let fileExtension = (fileName as NSString).pathExtension

        if !fileExtension.isEmpty,
           let url = Bundle.main.url(forResource: baseName, withExtension: fileExtension) {
            return url
        }

        return Bundle.main.url(forResource: fileName, withExtension: nil)
    }

    private func progress(for completedCount: Int, total: Int) -> Double {
        guard total > 0 else { return 1 }
        return min(1, max(0, Double(completedCount) / Double(total)))
    }

    private func checkAvailableStorage(for pack: ContentPack) throws {
        let supportDirectory = try applicationSupportDirectory()
        let values = try supportDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        guard let available = values.volumeAvailableCapacityForImportantUsage else { return }
        guard available > Int64(pack.estimatedSizeBytes) else {
            throw ContentDownloadError.insufficientStorage
        }
    }

    private func replaceDirectory(at finalDirectory: URL, with temporaryDirectory: URL) throws {
        let backupDirectory = finalDirectory
            .deletingLastPathComponent()
            .appendingPathComponent("\(finalDirectory.lastPathComponent)-previous", isDirectory: true)

        try removeDirectoryIfNeeded(backupDirectory)

        if fileManager.fileExists(atPath: finalDirectory.path) {
            try fileManager.moveItem(at: finalDirectory, to: backupDirectory)
        }

        do {
            try fileManager.moveItem(at: temporaryDirectory, to: finalDirectory)
            try removeDirectoryIfNeeded(backupDirectory)
        } catch {
            if fileManager.fileExists(atPath: backupDirectory.path) {
                try? fileManager.moveItem(at: backupDirectory, to: finalDirectory)
            }
            throw error
        }
    }

    private func removeDirectoryIfNeeded(_ url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    private func packDirectory(for packID: String) -> URL {
        contentPacksDirectory().appendingPathComponent(packID, isDirectory: true)
    }

    private func temporaryPackDirectory(for packID: String) -> URL {
        temporaryDirectory(for: packID)
    }

    private func temporaryDirectory(for packID: String) -> URL {
        contentPacksDirectory().appendingPathComponent(".\(packID)-download", isDirectory: true)
    }

    private func contentPacksDirectory() -> URL {
        (try? applicationSupportDirectory())?
            .appendingPathComponent("ContentPacks", isDirectory: true)
        ?? fileManager.temporaryDirectory.appendingPathComponent("ContentPacks", isDirectory: true)
    }

    private func applicationSupportDirectory() throws -> URL {
        let url = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }
}
