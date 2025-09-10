import SwiftUI
import UIKit

enum Theme {
    // Palette
    static let primaryTint: Color = .accentColor
    static let background: Color = Color(.systemBackground)
    static let secondaryBackground: Color = Color(.secondarySystemBackground)
    static let tertiaryBackground: Color = Color(.tertiarySystemBackground)
    static let separator: Color = Color(.separator)
    static let secondaryText: Color = .secondary
    static let subtleText: Color = Color.primary.opacity(0.7)

    // Typography
    enum Typography {
        static let largeTitle: Font = .system(.largeTitle, design: .rounded).weight(.bold)
        static let title: Font = .system(.title2, design: .rounded).weight(.semibold)
        static let headline: Font = .system(.headline, design: .rounded)
        static let body: Font = .system(.body, design: .rounded)
        static let caption: Font = .system(.caption, design: .rounded)
        static let tabLabel: Font = .system(.footnote, design: .rounded).weight(.semibold)
    }

    // Spacing
    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    // Radii
    enum Radius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let pill: CGFloat = 999
    }

    // Shadows
    enum Shadow {
        static let subtle: ShadowStyle = ShadowStyle(color: Color.black.opacity(0.12), x: 0, y: 8, blur: 16)
        static let soft: ShadowStyle = ShadowStyle(color: Color.black.opacity(0.18), x: 0, y: 10, blur: 24)
    }

    // Gradients
    enum Gradients {
        static let appBackground = LinearGradient(colors: [
            Color.accentColor.opacity(0.07),
            Color.blue.opacity(0.05),
            Color.pink.opacity(0.06)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)

        static let pill = LinearGradient(colors: [
            Color.accentColor.opacity(0.18),
            Color.accentColor.opacity(0.06)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)

        static let card = LinearGradient(colors: [
            Color(.secondarySystemBackground),
            Color(.tertiarySystemBackground)
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    // Materials
    enum Materials {
        static let card: Material = .ultraThinMaterial
        static let bar: Material = .ultraThinMaterial
    }
}

enum Haptics {
    static func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

struct ShadowStyle {
    let color: Color
    let x: CGFloat
    let y: CGFloat
    let blur: CGFloat
}


