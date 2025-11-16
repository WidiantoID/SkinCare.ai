import SwiftUI

/// Reusable empty state view component
/// Displays a consistent empty state across the app
struct EmptyStateView: View {
    // MARK: - Properties

    /// SF Symbol name for the icon
    let icon: String

    /// Title text
    let title: String

    /// Description text
    let message: String

    /// Optional action button title
    var actionTitle: String? = nil

    /// Optional action handler
    var action: (() -> Void)? = nil

    /// Icon color
    var iconColor: Color = .secondary

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(iconColor.gradient)
                .symbolRenderingMode(.hierarchical)
                .padding(.bottom, 8)
                .accessibilityHidden(true)

            // Title
            Text(title)
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)

            // Message
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)

            // Action button (if provided)
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(iconColor.gradient, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Predefined Empty States

extension EmptyStateView {
    /// Empty state for no scans
    static var noScans: EmptyStateView {
        EmptyStateView(
            icon: "camera.metering.center.weighted",
            title: "No Scans Yet",
            message: "Start your skincare journey by taking your first skin scan.",
            actionTitle: "Take First Scan",
            iconColor: .pink
        )
    }

    /// Empty state for no goals
    static var noGoals: EmptyStateView {
        EmptyStateView(
            icon: "target",
            title: "No Goals Set",
            message: "Set skincare goals to track your progress and stay motivated.",
            actionTitle: "Add Goal",
            iconColor: .green
        )
    }

    /// Empty state for no ingredients
    static var noIngredients: EmptyStateView {
        EmptyStateView(
            icon: "leaf",
            title: "No Ingredients",
            message: "Explore our comprehensive ingredient database to learn about skincare ingredients.",
            actionTitle: "Browse Ingredients",
            iconColor: .orange
        )
    }

    /// Empty state for no favorites
    static var noFavorites: EmptyStateView {
        EmptyStateView(
            icon: "heart",
            title: "No Favorites",
            message: "Favorite ingredients you love to quickly find them later.",
            iconColor: .red
        )
    }

    /// Empty state for no results
    static var noResults: EmptyStateView {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results",
            message: "Try adjusting your search or filters to find what you're looking for.",
            iconColor: .blue
        )
    }

    /// Empty state for no history
    static var noHistory: EmptyStateView {
        EmptyStateView(
            icon: "clock",
            title: "No History",
            message: "Your scan history will appear here as you track your skincare journey.",
            iconColor: .purple
        )
    }
}

// MARK: - Preview

#Preview("No Scans") {
    EmptyStateView.noScans
}

#Preview("No Goals") {
    EmptyStateView.noGoals
}

#Preview("Custom") {
    EmptyStateView(
        icon: "star.fill",
        title: "Custom Empty State",
        message: "This is a custom empty state message with a longer description to show how it wraps.",
        actionTitle: "Take Action",
        action: { print("Action tapped") },
        iconColor: .yellow
    )
}
