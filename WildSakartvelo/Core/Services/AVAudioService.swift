import AVFoundation
import Combine
import Foundation
import UIKit

final class AVAudioService: NSObject, AudioPlaying {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentFileName: String?

    private var player: AVAudioPlayer?

    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func play(fileName: String) {
        guard let url = audioURL(for: fileName) else { return }

        if currentFileName != fileName {
            stop()
            startPlayback(url: url, fileName: fileName)
            return
        }

        if player?.isPlaying == true {
            return
        }

        if let player {
            player.currentTime = 0
            if player.play() {
                isPlaying = true
            }
            return
        }

        startPlayback(url: url, fileName: fileName)
    }

    func pause() {
        guard player?.isPlaying == true else { return }
        player?.pause()
        isPlaying = false
    }

    func resume() {
        guard let player, currentFileName != nil else { return }
        if player.play() {
            isPlaying = true
        }
    }

    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
        currentFileName = nil
    }

    private func startPlayback(url: URL, fileName: String) {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            self.player = player
            currentFileName = fileName
            isPlaying = player.play()
            if !isPlaying {
                stop()
            }
        } catch {
            stop()
        }
    }

    private func audioURL(for fileName: String) -> URL? {
        if let resolvedURL = ResourceResolver.shared.url(for: fileName) {
            return resolvedURL
        }

        let baseName = (fileName as NSString).deletingPathExtension
        let explicitExtension = (fileName as NSString).pathExtension

        if !explicitExtension.isEmpty,
           let url = Bundle.main.url(forResource: baseName, withExtension: explicitExtension) {
            return url
        }

        if let url = Bundle.main.url(forResource: fileName, withExtension: nil) {
            return url
        }

        return Bundle.main.url(forResource: baseName, withExtension: "m4a")
            ?? Bundle.main.url(forResource: baseName, withExtension: "mp3")
    }

    @objc
    private func handleDidEnterBackground() {
        stop()
    }
}

extension AVAudioService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
}
