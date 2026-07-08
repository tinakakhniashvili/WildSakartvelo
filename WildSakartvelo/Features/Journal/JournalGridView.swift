import SwiftUI

struct JournalGridView: View {
    let items: [JournalItem]

    private let columns = [
        GridItem(.adaptive(minimum: 300), spacing: AppSpacing.medium)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
            ForEach(items) { item in
                NavigationLink(value: item) {
                    JournalCardView(item: item)
                        .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    JournalGridView(
        items: [
            JournalItem(
                sourceID: "caucasian-tur",
                type: .animal,
                title: "Caucasian Tur",
                subtitle: "ჯიხვი",
                imageName: "caucasian_tur",
                fallbackSymbol: "pawprint.fill"
            ),
            JournalItem(
                sourceID: "caucasus-rhododendron",
                type: .plant,
                title: "Caucasus Rhododendron",
                subtitle: "დეკა",
                imageName: "caucasus_rhododendron",
                fallbackSymbol: "leaf.fill"
            )
        ]
    )
    .padding()
    .background(AppColors.background)
}
