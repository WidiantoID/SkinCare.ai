import SwiftUI

struct ConcernCard: View {
    let title: String
    let count: Int
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.tint)
            Text(title)
                .font(Theme.Typography.headline)
            Text("\(count) ingredients")
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            ZStack {
                Theme.Gradients.card
                .background(Theme.Materials.card)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous))
        .shadow(color: Theme.Shadow.subtle.color, radius: Theme.Shadow.subtle.blur, x: Theme.Shadow.subtle.x, y: Theme.Shadow.subtle.y)
    }
}

#Preview {
    ConcernCard(title: "Acne", count: 12, systemImage: "face.smiling")
}


