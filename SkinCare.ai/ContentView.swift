//
//  ContentView.swift
//  SkinCare.ai
//
//  Created by Aryan Signh on 10/09/25.
//

import SwiftUI

struct ContentView: View {
    private var analyzer: MLAnalyzing {
        if let key = Secrets.geminiApiKey, !key.isEmpty {
            return GeminiAnalyzer(apiKey: key)
        }
        return MockAnalyzer()
    }
    @StateObject private var session = SessionViewModel(auth: MockAuthService())
    @StateObject private var userData = UserData.shared
    @State private var selectedTab: Tab = .scan
    @StateObject private var scanStore = ScanStore()

    enum Tab: Hashable {
        case scan, ingredients, progress, profile
    }

    var body: some View {
        ZStack {
            Theme.Gradients.appBackground
                .ignoresSafeArea()
            Group {
                if session.user == nil && userData.hasCompletedOnboarding == false {
                    NavigationStack {
                        OnboardingView(session: session)
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        NavigationStack {
                            ScanView(viewModel: ScanViewModel(analyzer: analyzer, scanStore: scanStore))
                        }
                        .tabItem {
                            Label("Scan", systemImage: "camera.viewfinder")
                        }
                        .tint(.pink)
                        .tag(Tab.scan)

                        NavigationStack {
                            IngredientsHubView()
                                .environmentObject(scanStore)
                        }
                        .tabItem {
                            Label("Ingredients", systemImage: "list.bullet")
                        }
                        .tag(Tab.ingredients)
                        .tint(.mint)

                        NavigationStack {
                            ProgressDashboardView()
                                .environmentObject(scanStore)
                        }
                        .tabItem {
                            Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .tag(Tab.progress)
                        .tint(.orange)

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
                    .onChange(of: selectedTab) { _, newValue in
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
            }
        }
        .task { await session.load() }
    }
}

#Preview {
    ContentView()
}
