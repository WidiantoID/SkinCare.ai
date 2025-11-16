import SwiftUI

/// Reusable error state view component
/// Displays errors consistently across the app
struct ErrorView: View {
    // MARK: - Properties

    /// Error title
    let title: String

    /// Error message or description
    let message: String

    /// Optional retry action title
    var retryTitle: String? = "Try Again"

    /// Optional retry handler
    var onRetry: (() -> Void)? = nil

    /// Optional dismiss handler
    var onDismiss: (() -> Void)? = nil

    /// Error icon
    var icon: String = "exclamationmark.triangle.fill"

    /// Icon color
    var iconColor: Color = .orange

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(iconColor.gradient)
                .symbolRenderingMode(.hierarchical)
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
                .lineLimit(5)
                .fixedSize(horizontal: false, vertical: true)

            // Action buttons
            VStack(spacing: 12) {
                // Retry button
                if let retryTitle = retryTitle, let onRetry = onRetry {
                    Button(action: onRetry) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 14, weight: .semibold))

                            Text(retryTitle)
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(iconColor.gradient, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: iconColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }

                // Dismiss button
                if let onDismiss = onDismiss {
                    Button(action: onDismiss) {
                        Text("Dismiss")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error: \(title). \(message)")
        .accessibilityAddTraits(.isStaticText)
    }
}

// MARK: - Compact Error View

/// Compact inline error view for displaying errors within forms or lists
struct CompactErrorView: View {
    let message: String
    var icon: String = "exclamationmark.circle.fill"
    var color: Color = .red

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(3)

            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error: \(message)")
    }
}

// MARK: - Banner Error View

/// Banner-style error for top-of-screen notifications
struct ErrorBanner: View {
    let message: String
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .lineLimit(2)

            Spacer()

            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.red.gradient)
        )
        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

// MARK: - Predefined Error Views

extension ErrorView {
    /// Network error
    static func networkError(onRetry: @escaping () -> Void) -> ErrorView {
        ErrorView(
            title: "Connection Error",
            message: "Unable to connect to the network. Please check your internet connection and try again.",
            onRetry: onRetry,
            icon: "wifi.exclamationmark",
            iconColor: .orange
        )
    }

    /// API error
    static func apiError(message: String? = nil, onRetry: @escaping () -> Void) -> ErrorView {
        ErrorView(
            title: "Service Error",
            message: message ?? "Something went wrong with the service. Please try again later.",
            onRetry: onRetry,
            icon: "server.rack",
            iconColor: .red
        )
    }

    /// Camera permission error
    static func cameraPermissionError(onSettings: @escaping () -> Void) -> ErrorView {
        ErrorView(
            title: "Camera Access Required",
            message: "SkinCare.ai needs camera access to analyze your skin. Please enable camera access in Settings.",
            retryTitle: "Open Settings",
            onRetry: onSettings,
            icon: "camera.fill",
            iconColor: .blue
        )
    }

    /// Generic error
    static func generic(error: Error, onRetry: (() -> Void)? = nil) -> ErrorView {
        ErrorView(
            title: "Something Went Wrong",
            message: error.localizedDescription,
            onRetry: onRetry,
            iconColor: .red
        )
    }

    /// Validation error
    static func validation(message: String, onDismiss: @escaping () -> Void) -> ErrorView {
        ErrorView(
            title: "Invalid Input",
            message: message,
            retryTitle: nil,
            onDismiss: onDismiss,
            icon: "checkmark.circle.trianglebadge.exclamationmark",
            iconColor: .orange
        )
    }
}

// MARK: - View Extension

extension View {
    /// Shows an error banner at the top of the view
    /// - Parameters:
    ///   - message: Error message to display
    ///   - isPresented: Binding to control visibility
    /// - Returns: Modified view with error banner
    func errorBanner(
        _ message: String?,
        isPresented: Binding<Bool>
    ) -> some View {
        ZStack(alignment: .top) {
            self

            if isPresented.wrappedValue, let message = message {
                ErrorBanner(message: message) {
                    withAnimation {
                        isPresented.wrappedValue = false
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.top, 8)
                .zIndex(999)
            }
        }
    }
}

// MARK: - Previews

#Preview("Network Error") {
    ErrorView.networkError(onRetry: { print("Retry tapped") })
}

#Preview("API Error") {
    ErrorView.apiError(onRetry: { print("Retry tapped") })
}

#Preview("Camera Permission") {
    ErrorView.cameraPermissionError(onSettings: { print("Settings tapped") })
}

#Preview("Compact Error") {
    VStack {
        CompactErrorView(message: "Please enter a valid email address")

        CompactErrorView(
            message: "Age must be between 13 and 100",
            icon: "exclamationmark.triangle.fill",
            color: .orange
        )
    }
    .padding()
}

#Preview("Error Banner") {
    VStack {
        ErrorBanner(message: "Failed to save changes. Please try again.") {
            print("Dismiss tapped")
        }

        Spacer()

        Text("Content below banner")
            .font(.title)
    }
}
