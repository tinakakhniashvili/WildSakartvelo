import Foundation

protocol SettingsStoring {
    func loadSettings() throws -> AppSettings
    func saveSettings(_ settings: AppSettings) throws
    func resetSettings() throws
}
