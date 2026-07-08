import Foundation

struct AppSettings: Codable, Hashable {
    var language: AppLanguage
    var narrationEnabled: Bool
    var soundEffectsEnabled: Bool
    var largerTextEnabled: Bool
    var reducedMotionEnabled: Bool
    var highContrastEnabled: Bool
    var subtitlesEnabled: Bool

    static let defaultValue = AppSettings(
        language: .english,
        narrationEnabled: true,
        soundEffectsEnabled: true,
        largerTextEnabled: false,
        reducedMotionEnabled: false,
        highContrastEnabled: false,
        subtitlesEnabled: false
    )

    enum CodingKeys: String, CodingKey {
        case language
        case narrationEnabled
        case soundEffectsEnabled
        case largerTextEnabled
        case reducedMotionEnabled
        case highContrastEnabled
        case subtitlesEnabled
    }

    init(
        language: AppLanguage,
        narrationEnabled: Bool,
        soundEffectsEnabled: Bool,
        largerTextEnabled: Bool,
        reducedMotionEnabled: Bool,
        highContrastEnabled: Bool,
        subtitlesEnabled: Bool
    ) {
        self.language = language
        self.narrationEnabled = narrationEnabled
        self.soundEffectsEnabled = soundEffectsEnabled
        self.largerTextEnabled = largerTextEnabled
        self.reducedMotionEnabled = reducedMotionEnabled
        self.highContrastEnabled = highContrastEnabled
        self.subtitlesEnabled = subtitlesEnabled
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .english
        narrationEnabled = try container.decodeIfPresent(Bool.self, forKey: .narrationEnabled) ?? true
        soundEffectsEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundEffectsEnabled) ?? true
        largerTextEnabled = try container.decodeIfPresent(Bool.self, forKey: .largerTextEnabled) ?? false
        reducedMotionEnabled = try container.decodeIfPresent(Bool.self, forKey: .reducedMotionEnabled) ?? false
        highContrastEnabled = try container.decodeIfPresent(Bool.self, forKey: .highContrastEnabled) ?? false
        subtitlesEnabled = try container.decodeIfPresent(Bool.self, forKey: .subtitlesEnabled) ?? false
    }
}
