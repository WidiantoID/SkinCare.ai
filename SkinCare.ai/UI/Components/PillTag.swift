import SwiftUI

struct PillTag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(Theme.Typography.caption)
            .padding(.horizontal, Theme.Spacing.sm)
            .padding(.vertical, 6)
            .background(
                Theme.Gradients.pill
                    .overlay(
                        Capsule()
                            .stroke(Theme.separator.opacity(0.3), lineWidth: 0.5)
                    )
            )
            .clipShape(Capsule())
            .accessibilityLabel(Text("Tag: \(text)"))
    }
}

#Preview {
    PillTag(text: "Brightening")
}


