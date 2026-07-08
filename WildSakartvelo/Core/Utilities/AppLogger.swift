import Foundation
import os

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "ge.example.WildSakartvelo"

    static let content = Logger(subsystem: subsystem, category: "content")
    static let progress = Logger(subsystem: subsystem, category: "progress")
    static let profiles = Logger(subsystem: subsystem, category: "profiles")
    static let audio = Logger(subsystem: subsystem, category: "audio")
    static let downloads = Logger(subsystem: subsystem, category: "downloads")
    static let navigation = Logger(subsystem: subsystem, category: "navigation")
}
