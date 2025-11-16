import Foundation

struct ProgressData {
    let totalScans: Int
    let averageScore: Double
    let currentStreak: Int
    let completedGoals: Int
    let recentScans: [ScanHistoryItem]
    let scoreHistory: [ScoreDataPoint]
    let goals: [ProgressGoal]
    
    static let mock = ProgressData(
        totalScans: 12,
        averageScore: 78.5,
        currentStreak: 7,
        completedGoals: 2,
        recentScans: [
            ScanHistoryItem(
                date: Date(),
                score: 82,
                primaryConcern: "Acne",
                improvementFromLast: 5
            ),
            ScanHistoryItem(
                date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                score: 77,
                primaryConcern: "Redness",
                improvementFromLast: -2
            ),
            ScanHistoryItem(
                date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
                score: 79,
                primaryConcern: "Dryness",
                improvementFromLast: 8
            )
        ],
        scoreHistory: generateMockScoreHistory(),
        goals: [
            ProgressGoal(
                id: UUID(),
                title: "Reduce Acne",
                description: "Clear skin in 30 days",
                progress: 0.7,
                targetDate: Calendar.current.date(byAdding: .day, value: 23, to: Date()) ?? Date(),
                isCompleted: false
            ),
            ProgressGoal(
                id: UUID(),
                title: "Improve Hydration",
                description: "Better moisture levels",
                progress: 0.4,
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
    )
    
    private static func generateMockScoreHistory() -> [ScoreDataPoint] {
        let calendar = Calendar.current
        var dataPoints: [ScoreDataPoint] = []
        
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let baseScore = 70.0
            let variation = Double.random(in: -10...15)
            let trendImprovement = Double(30 - i) * 0.3 // Gradual improvement over time
            let score = min(100, max(0, baseScore + variation + trendImprovement))
            
            dataPoints.append(ScoreDataPoint(date: date, score: score))
        }
        
        return dataPoints.reversed()
    }
}

struct ScanHistoryItem: Identifiable {
    let id = UUID()
    let date: Date
    let score: Int
    let primaryConcern: String
    let improvementFromLast: Int
}

struct ScoreDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let score: Double
}

/// Represents a user's skincare goal with progress tracking
struct ProgressGoal: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let progress: Double // 0.0 to 1.0
    let targetDate: Date
    let isCompleted: Bool

    /// Color representation based on progress level
    var progressColor: Color {
        if isCompleted {
            return .green
        } else if progress >= 0.7 {
            return .blue
        } else if progress >= 0.4 {
            return .orange
        } else {
            return .red
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, progress, targetDate, isCompleted
    }
}

// MARK: - Extensions for formatting
extension ProgressData {
    var averageScoreString: String {
        return String(format: "%.0f%%", averageScore)
    }
    
    var streakString: String {
        return "\(currentStreak) days"
    }
    
    var improvementTrend: Double {
        guard recentScans.count >= 2 else { return 0 }
        let recent = recentScans.prefix(5)
        let older = recentScans.dropFirst(5).prefix(5)
        
        let recentAvg = recent.reduce(0) { $0 + $1.score } / recent.count
        let olderAvg = older.isEmpty ? recentAvg : older.reduce(0) { $0 + $1.score } / older.count
        
        return Double(recentAvg - olderAvg)
    }
    
    var improvementPercentage: String {
        let trend = improvementTrend
        let sign = trend >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.0f", trend))%"
    }
}

import SwiftUI

extension Color {
    static func forScore(_ score: Int) -> Color {
        switch score {
        case 80...100: return .green
        case 60...79: return .orange
        default: return .red
        }
    }
}
