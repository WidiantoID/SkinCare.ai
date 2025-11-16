import Foundation
import SwiftUI

/// Store for managing user skincare goals and progress tracking
/// - Note: Goals are persisted to UserDefaults
@MainActor
final class ProgressStore: ObservableObject {
    /// User's skincare goals
    @Published var goals: [ProgressGoal] = []

    /// UserDefaults key for persisting goals
    private let goalsKey = "progress_goals"

    init() {
        loadGoals()
    }

    /// Loads goals from persistence or creates default goals
    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: goalsKey),
           let decoded = try? JSONDecoder().decode([ProgressGoal].self, from: data) {
            goals = decoded
        } else {
            loadDefaultGoals()
        }
    }

    /// Creates default sample goals for new users
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
        saveGoals()
    }

    /// Adds a new goal
    /// - Parameter goal: The goal to add
    func addGoal(_ goal: ProgressGoal) {
        goals.append(goal)
        saveGoals()
    }

    /// Updates an existing goal
    /// - Parameter goal: The updated goal
    func updateGoal(_ goal: ProgressGoal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }

    /// Deletes a goal by ID
    /// - Parameter id: The ID of the goal to delete
    func deleteGoal(withId id: UUID) {
        goals.removeAll { $0.id == id }
        saveGoals()
    }

    /// Goals that are not yet completed
    var activeGoals: [ProgressGoal] {
        goals.filter { !$0.isCompleted }
    }

    /// Number of completed goals
    var completedGoalsCount: Int {
        goals.filter { $0.isCompleted }.count
    }

    /// Generates comprehensive progress data from scan store
    /// - Parameter scanStore: The scan store containing scan history
    /// - Returns: ProgressData with all metrics
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

    /// Generates score history from scan results
    /// - Parameter scanStore: The scan store containing scan history
    /// - Returns: Array of score data points
    private func generateScoreHistory(from scanStore: ScanStore) -> [ScoreDataPoint] {
        return scanStore.scanHistory.map { result in
            ScoreDataPoint(
                date: result.capturedAt,
                score: (result.scores.first?.confidence ?? 0) * 100
            )
        }.reversed() // Reverse to show chronological order
    }

    // MARK: - Persistence

    /// Saves goals to UserDefaults
    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: goalsKey)
        }
    }
}
