import SwiftUI

extension EcosystemTheme {
    var accentColor: Color {
        switch self {
        case .forest:
            return AppColors.forest
        case .mountain:
            return AppColors.mountain
        case .wetland, .coast:
            return AppColors.water
        }
    }

    var fallbackSystemImage: String {
        switch self {
        case .forest:
            return "tree.fill"
        case .mountain:
            return "mountain.2.fill"
        case .wetland:
            return "water.waves"
        case .coast:
            return "beach.umbrella.fill"
        }
    }
}
