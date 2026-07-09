import SwiftUI

struct MapLegendView: View {
    let language: AppLanguage

    var body: some View {
        HStack(spacing: AppSpacing.small) {
            legendItem(color: AppColors.forest, label: text("Region marker", "რეგიონის ნიშანი"))
            legendItem(color: AppColors.sunshine, label: text("Selected", "არჩეული"))
            legendItem(color: AppColors.water, label: text("Real map", "ნამდვილი რუკა"))
        }
        .font(AppTypography.caption)
        .foregroundStyle(AppColors.secondaryText)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func legendItem(color: Color, label: String) -> some View {
        Label {
            Text(label)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        } icon: {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
        }
    }

    private func text(_ english: String, _ georgian: String) -> String {
        language == .georgian ? georgian : english
    }
}
