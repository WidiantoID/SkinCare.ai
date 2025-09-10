import Foundation
import SwiftUI

@MainActor
final class ProgressStore: ObservableObject {
    @Published var goals: [ProgressGoal] = []
    
    init() {
        loadDefaultGoals()
    }
    
    private func loadDefaultGoals() {
        goals = [
            ProgressGoal(
                id: UUID(),
                title: "Reduce Acne",
                description: "Clear skin in 30 days",
                progress: 0.3,
                targetDate: Calendar.current.date(byAdding: .day, value: 23, to: Date()) ?? Date(),
                isCompleted: false
            ),
            ProgressGoal(
                id: UUID(),
                title: "Improve Hydration",
                description: "Better moisture levels",
                progress: 0.6,
                targetDate: Calendar.current.date(byAdding: .day, value: 45, to: Date()) ?? Date(),
                isCompleted: false
            ),
            ProgressGoal(
                id: UUID(),
                title: "Even Skin Tone",
                description: "Reduce dark spots",
                progress: 1.0,
                targetDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                isCompleted: true
            )
        ]
    }
    
    func addGoal(_ goal: ProgressGoal) {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: ProgressGoal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func deleteGoal(withId id: UUID) {
        goals.removeAll { $0.id == id }
    }
    
    var activeGoals: [ProgressGoal] {
        goals.filter { !$0.isCompleted }
    }
    
    var completedGoalsCount: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    func generateProgressData(from scanStore: ScanStore) -> ProgressData {
        return ProgressData(
            totalScans: scanStore.totalScans,
            averageScore: scanStore.averageScore,
            currentStreak: scanStore.currentStreak,
            completedGoals: completedGoalsCount,
            recentScans: scanStore.recentScans,
            scoreHistory: generateScoreHistory(from: scanStore),
            goals: goals
        )
    }
    
    private func generateScoreHistory(from scanStore: ScanStore) -> [ScoreDataPoint] {
        return scanStore.scanHistory.map { result in
            ScoreDataPoint(
                date: result.capturedAt,
                score: (result.scores.first?.confidence ?? 0) * 100
            )
        }.reversed() // Reverse to show chronological order
    }
}
