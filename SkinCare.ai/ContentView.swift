import SwiftUI

/// Main content view of the application
/// Manages tab navigation and authentication state
struct ContentView: View {
    // MARK: - State Objects

    @StateObject private var session = SessionViewModel(auth: MockAuthService())
    @StateObject private var userData = UserData.shared
    @StateObject private var scanStore = ScanStore()
    @StateObject private var networkMonitor = NetworkMonitor.shared

    // MARK: - State

    @State private var selectedTab: Tab = .scan

    // MARK: - Computed Properties

    /// Returns the appropriate analyzer based on API key availability
    private var analyzer: MLAnalyzing {
        if let key = Secrets.geminiApiKey, !key.isEmpty {
            AppLogger.info("Using GeminiAnalyzer with API key", category: .general)
            return GeminiAnalyzer(apiKey: key)
        }
        AppLogger.info("Using MockAnalyzer (no API key configured)", category: .general)
        return MockAnalyzer()
    }

    // MARK: - Tab Definition

    enum Tab: Hashable {
        case scan, ingredients, progress, profile
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Theme.Gradients.appBackground
                .ignoresSafeArea()

            Group {
                if session.user == nil && userData.hasCompletedOnboarding == false {
                    // Show onboarding for new users
                    NavigationStack {
                        OnboardingView(session: session)
                    }
                } else {
                    // Main tab navigation
                    mainTabView
                }
            }
        }
        .networkStatusBanner() // Show network status banner when offline
        .task {
            await session.load()
            HapticManager.prepare() // Prepare haptic feedback generators
        }
        .onAppear {
            AppLogger.info("ContentView appeared", category: .ui)
        }
    }

    // MARK: - Subviews

    /// Main tab view with all app sections
    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            // Scan Tab
            NavigationStack {
                ScanView(viewModel: ScanViewModel(analyzer: analyzer, scanStore: scanStore))
            }
            .tabItem {
                Label("Scan", systemImage: "camera.viewfinder")
            }
            .tint(.pink)
            .tag(Tab.scan)

            // Ingredients Tab
            NavigationStack {
                IngredientsHubView()
                    .environmentObject(scanStore)
            }
            .tabItem {
                Label("Ingredients", systemImage: "leaf.fill")
            }
            .tag(Tab.ingredients)
            .tint(.mint)

            // Progress Tab
            NavigationStack {
                ProgressDashboardView()
                    .environmentObject(scanStore)
            }
            .tabItem {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(Tab.progress)
            .tint(.orange)

            // Profile Tab
            NavigationStack {
                ProfileView(session: session)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(Tab.profile)
            .tint(.teal)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedTab)
        .tint(Theme.primaryTint)
        .background(Theme.Materials.bar)
        .onChange(of: selectedTab) { oldValue, newValue in
            HapticManager.selection() // Use HapticManager instead of manual feedback
            AppLogger.debug("Tab changed from \(oldValue) to \(newValue)", category: .ui)
        }
    }
}

#Preview {
    ContentView()
}
