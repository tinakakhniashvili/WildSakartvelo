import Combine
import Foundation

protocol AudioPlaying: AnyObject, ObservableObject {
    var isPlaying: Bool { get }
    var currentFileName: String? { get }

    func play(fileName: String)
    func pause()
    func resume()
    func stop()
}
