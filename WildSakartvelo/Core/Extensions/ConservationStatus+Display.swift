import SwiftUI

extension ConservationStatus {
    var displayTitle: String {
        displayTitle(for: .english)
    }

    func displayTitle(for language: AppLanguage) -> String {
        switch self {
        case .common:
            return .localized("conservation.common", for: language)
        case .protected:
            return .localized("conservation.protected", for: language)
        case .endangered:
            return .localized("conservation.endangered", for: language)
        case .unknown:
            return .localized("conservation.unknown", for: language)
        }
    }

    var systemImage: String {
        switch self {
        case .common:
            return "checkmark.circle.fill"
        case .protected:
            return "shield.fill"
        case .endangered:
            return "exclamationmark.triangle.fill"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .common:
            return AppColors.success
        case .protected:
            return AppColors.forest
        case .endangered:
            return AppColors.warning
        case .unknown:
            return AppColors.secondaryText
        }
    }

    var childFriendlyDescription: String {
        childFriendlyDescription(for: .english)
    }

    func childFriendlyDescription(for language: AppLanguage) -> String {
        switch self {
        case .common:
            return .localized("conservation.common.description", for: language)
        case .protected:
            return .localized("conservation.protected.description", for: language)
        case .endangered:
            return .localized("conservation.endangered.description", for: language)
        case .unknown:
            return .localized("conservation.unknown.description", for: language)
        }
    }
}
