import SwiftUI

/// Reusable loading state view component
/// Displays a consistent loading indicator across the app
struct LoadingView: View {
    // MARK: - Properties

    /// Loading message to display
    var message: String = "Loading..."

    /// Progress indicator style
    var style: LoadingStyle = .spinning

    /// Whether to show message below indicator
    var showMessage: Bool = true

    // MARK: - Body

    var body: some View {
        VStack(spacing: 20) {
            // Progress indicator
            switch style {
            case .spinning:
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle())

            case .pulsing:
                PulsingCircles()

            case .dots:
                DotsLoader()
            }

            // Message
            if showMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - Loading Styles

enum LoadingStyle {
    case spinning
    case pulsing
    case dots
}

// MARK: - Custom Loaders

/// Pulsing circles animation
struct PulsingCircles: View {
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(Color.pink.opacity(0.3), lineWidth: 2)
                    .frame(width: 60, height: 60)
                    .scaleEffect(isPulsing ? 1.5 : 0.5)
                    .opacity(isPulsing ? 0 : 1)
                    .animation(
                        .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.5),
                        value: isPulsing
                    )
            }
        }
        .onAppear {
            isPulsing = true
        }
    }
}

/// Animated dots loader
struct DotsLoader: View {
    @State private var animatingDots: [Bool] = [false, false, false]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.pink.gradient)
                    .frame(width: 12, height: 12)
                    .scaleEffect(animatingDots[index] ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animatingDots[index]
                    )
            }
        }
        .onAppear {
            for index in 0..<3 {
                animatingDots[index] = true
            }
        }
    }
}

// MARK: - Overlay Loading View

/// Loading overlay that can be placed over content
struct LoadingOverlay: View {
    var message: String = "Loading..."
    var style: LoadingStyle = .spinning

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            // Loading content
            VStack(spacing: 20) {
                switch style {
                case .spinning:
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))

                case .pulsing:
                    PulsingCircles()

                case .dots:
                    DotsLoader()
                }

                Text(message)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
        .accessibilityAddTraits(.updatesFrequently)
    }
}

// MARK: - View Extension

extension View {
    /// Overlays a loading view on top of the current view
    /// - Parameters:
    ///   - isLoading: Whether to show the loading overlay
    ///   - message: Loading message
    ///   - style: Loading style
    /// - Returns: Modified view with loading overlay
    func loading(
        _ isLoading: Bool,
        message: String = "Loading...",
        style: LoadingStyle = .spinning
    ) -> some View {
        overlay {
            if isLoading {
                LoadingOverlay(message: message, style: style)
            }
        }
    }
}

// MARK: - Previews

#Preview("Spinning") {
    LoadingView(message: "Analyzing your skin...", style: .spinning)
}

#Preview("Pulsing") {
    LoadingView(message: "Processing image...", style: .pulsing)
}

#Preview("Dots") {
    LoadingView(message: "Please wait...", style: .dots)
}

#Preview("Overlay") {
    VStack {
        Text("Content behind loading")
            .font(.title)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
    .overlay {
        LoadingOverlay(message: "Analyzing...", style: .dots)
    }
}
