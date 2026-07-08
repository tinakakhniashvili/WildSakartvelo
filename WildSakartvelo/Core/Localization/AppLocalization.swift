import Foundation

extension AppLanguage {
    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }

    var localizedBundle: Bundle {
        guard let path = Bundle.main.path(forResource: localeIdentifier, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }

        return bundle
    }
}

extension String {
    static func localized(_ key: String, for language: AppLanguage) -> String {
        language.localizedBundle.localizedString(forKey: key, value: nil, table: nil)
    }

    static func localizedFormat(_ key: String, for language: AppLanguage, _ arguments: CVarArg...) -> String {
        String(format: localized(key, for: language), locale: language.locale, arguments: arguments)
    }
}
