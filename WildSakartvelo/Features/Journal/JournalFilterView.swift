import SwiftUI

struct JournalFilterView: View {
    @Binding var selectedFilter: JournalFilter
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Picker(String.localized("journal.filter.title", for: appState.currentLanguage), selection: $selectedFilter) {
            ForEach(JournalFilter.allCases) { filter in
                Label(filter.displayTitle(for: appState.currentLanguage), systemImage: filter.symbolName)
                    .tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel(String.localized("journal.filter.title", for: appState.currentLanguage))
        .accessibilityIdentifier("journal.filter.\(selectedFilter.rawValue)")
    }
}

#Preview {
    JournalFilterView(selectedFilter: .constant(.animals))
        .padding()
        .background(AppColors.background)
}
