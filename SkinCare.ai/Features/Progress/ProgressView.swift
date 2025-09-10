import SwiftUI

struct ProgressDashboardView: View {
    @State private var animateCards = false
    @StateObject private var progressStore = ProgressStore()
    @EnvironmentObject var scanStore: ScanStore
    @State private var showingAIRecommendations = false
    @State private var scrollTarget: String?
    
    private var progressData: ProgressData {
        progressStore.generateProgressData(from: scanStore)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Progress Overview Cards
                    progressOverviewSection
                    
                    // Skin Health Trends
                    trendsSection
                        .id("trends")
                    
                    // Recent Scans
                    recentScansSection
                        .id("recent")
                    
                    // Goals & Achievements
                    goalsSection
                        .id("goals")
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .onChange(of: scrollTarget) { _, newValue in
                if let target = newValue {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.9)) {
                        proxy.scrollTo(target, anchor: .top)
                    }
                }
            }
        }
        .background(Theme.Gradients.appBackground.ignoresSafeArea())
        .navigationTitle("Your Progress")
        .sheet(isPresented: $showingAIRecommendations) {
            AIRecommendationsView(scanStore: scanStore)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Track your skin health journey with AI insights")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // AI Recommendations Button
                Button {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    showingAIRecommendations = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.caption.weight(.semibold))
                        Text("AI Insights")
                            .font(.subheadline.weight(.medium))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.orange.gradient)
                    )
                }
                .scaleEffect(animateCards ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: animateCards)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Progress Overview Section
    private var progressOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                Button {
                    let h = UIImpactFeedbackGenerator(style: .light)
                    h.impactOccurred()
                    scrollTarget = "recent"
                } label: {
                    ProgressMetricCard(
                        title: "Scans Completed",
                        value: "\(progressData.totalScans)",
                        change: "+\(max(1, progressData.totalScans / 4)) this week",
                        color: .pink,
                        icon: "camera.viewfinder"
                    )
                }
                
                Button {
                    let h = UIImpactFeedbackGenerator(style: .light)
                    h.impactOccurred()
                    scrollTarget = "trends"
                } label: {
                    ProgressMetricCard(
                        title: "Skin Score",
                        value: progressData.averageScoreString,
                        change: progressData.improvementPercentage + " improvement",
                        color: .green,
                        icon: "chart.line.uptrend.xyaxis"
                    )
                }
                
                Button {
                    let h = UIImpactFeedbackGenerator(style: .light)
                    h.impactOccurred()
                    scrollTarget = "goals"
                } label: {
                    ProgressMetricCard(
                        title: "Active Goals",
                        value: "\(progressData.goals.filter { !$0.isCompleted }.count)",
                        change: "\(progressData.completedGoals) completed",
                        color: .blue,
                        icon: "target"
                    )
                }
                
                Button {
                    let h = UIImpactFeedbackGenerator(style: .light)
                    h.impactOccurred()
                    scrollTarget = "recent"
                } label: {
                    ProgressMetricCard(
                        title: "Streak",
                        value: progressData.streakString,
                        change: progressData.currentStreak > 5 ? "Great progress!" : "Keep it up!",
                        color: .orange,
                        icon: "flame.fill"
                    )
                }
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }
    
    // MARK: - Trends Section
    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Skin Health Trends")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            ProgressChartCard()
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Recent Scans Section
    private var recentScansSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Scans")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button("View All") {
                    showingAIRecommendations = true
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.orange)
            }
            
            VStack(spacing: 12) {
                ForEach(progressData.recentScans.prefix(3)) { scan in
                    RecentScanRow(
                        date: scan.date,
                        score: scan.score,
                        primaryConcern: scan.primaryConcern
                    )
                }
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 40)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
    }
    
    // MARK: - Goals Section
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Goals & Achievements")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 12) {
                ForEach(progressData.goals) { goal in
                    GoalProgressCard(
                        title: goal.title,
                        progress: goal.progress,
                        target: goal.description,
                        color: goal.progressColor
                    )
                }
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 50)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
    }
}

#Preview {
    NavigationStack { ProgressDashboardView() }
}


