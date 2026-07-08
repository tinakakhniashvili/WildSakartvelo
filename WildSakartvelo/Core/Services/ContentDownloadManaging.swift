import Foundation

protocol ContentDownloadManaging: AnyObject {
    var progressHandler: ((String, Double) -> Void)? { get set }

    func download(_ pack: ContentPack) async throws
    func cancelDownload(packID: String)
    func deleteDownload(packID: String) throws
    func isDownloaded(_ pack: ContentPack) -> Bool
    func localURL(for resourceName: String, packID: String) -> URL?
}
