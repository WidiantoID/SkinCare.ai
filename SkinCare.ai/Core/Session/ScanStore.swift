import Foundation

@MainActor
final class ScanStore: ObservableObject {
    @Published var lastResult: ScanResult?
    @Published var scanHistory: [ScanResult] = []
    
    func addScanResult(_ result: ScanResult) {
        lastResult = result
        scanHistory.insert(result, at: 0) // Add to beginning for chronological order
        
        // Keep only last 50 scans to manage memory
        if scanHistory.count > 50 {
            scanHistory = Array(scanHistory.prefix(50))
        }
    }
    
    var totalScans: Int {
        scanHistory.count
    }
    
    var averageScore: Double {
        guard !scanHistory.isEmpty else { return 0 }
        let totalScore = scanHistory.compactMap { result in
            result.scores.first?.confidence
        }.reduce(0, +)
        return (totalScore / Double(scanHistory.count)) * 100
    }
    
    var recentScans: [ScanHistoryItem] {
        return scanHistory.prefix(10).map { result in
            let primaryConcern = result.scores.max(by: { $0.confidence < $1.confidence })?.condition.rawValue ?? "General"
            let score = Int((result.scores.first?.confidence ?? 0) * 100)
            
            return ScanHistoryItem(
                date: result.capturedAt,
                score: score,
                primaryConcern: primaryConcern,
                improvementFromLast: calculateImprovement(for: result)
            )
        }
    }
    
    private func calculateImprovement(for result: ScanResult) -> Int {
        guard let currentIndex = scanHistory.firstIndex(where: { $0.id == result.id }),
              currentIndex + 1 < scanHistory.count else { return 0 }
        
        let previousResult = scanHistory[currentIndex + 1]
        let currentScore = Int((result.scores.first?.confidence ?? 0) * 100)
        let previousScore = Int((previousResult.scores.first?.confidence ?? 0) * 100)
        
        return currentScore - previousScore
    }
    
    var currentStreak: Int {
        // Calculate consecutive days with scans
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for result in scanHistory {
            let scanDate = calendar.startOfDay(for: result.capturedAt)
            if calendar.isDate(scanDate, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else if scanDate < currentDate {
                break
            }
        }
        
        return streak
    }
}


