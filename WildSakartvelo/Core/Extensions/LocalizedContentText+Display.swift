import Foundation

extension LocalizedContentText {
    func displayText(for language: AppLanguage) -> String {
        switch language {
        case .english:
            return english?.isEmpty == false ? english ?? "" : (georgian ?? "")
        case .georgian:
            return georgian?.isEmpty == false ? georgian ?? "" : (english ?? "")
        }
    }
}

extension Optional where Wrapped == LocalizedContentText {
    func displayText(for language: AppLanguage, fallback: String = "") -> String {
        switch self {
        case .some(let value):
            return value.displayText(for: language)
        case .none:
            return fallback
        }
    }
}
