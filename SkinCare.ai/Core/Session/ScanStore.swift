import Foundation

/// Centralized store for managing scan results and history
/// - Note: All scan data is stored in memory and persisted to UserDefaults
@MainActor
final class ScanStore: ObservableObject {
    /// The most recent scan result
    @Published var lastResult: ScanResult?

    /// Full history of all scan results
    @Published var scanHistory: [ScanResult] = []

    /// UserDefaults key for persisting scan history
    private let scanHistoryKey = "scan_history"

    /// Maximum number of scans to keep in history
    private let maxHistorySize = 50

    init() {
        loadScanHistory()
    }

    /// Adds a new scan result to the store
    /// - Parameter result: The scan result to add
    func addScanResult(_ result: ScanResult) {
        lastResult = result
        scanHistory.insert(result, at: 0) // Add to beginning for chronological order

        // Keep only last scans to manage memory
        if scanHistory.count > maxHistorySize {
            scanHistory = Array(scanHistory.prefix(maxHistorySize))
        }

        saveScanHistory()
    }
    
    /// Total number of scans performed
    var totalScans: Int {
        scanHistory.count
    }

    /// Average confidence score across all scans
    var averageScore: Double {
        guard !scanHistory.isEmpty else { return 0 }
        let totalScore = scanHistory.compactMap { result in
            result.scores.first?.confidence
        }.reduce(0, +)
        return (totalScore / Double(scanHistory.count)) * 100
    }

    /// Recent scans formatted for display
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

    /// Calculates improvement from previous scan
    /// - Parameter result: The scan result to compare
    /// - Returns: Improvement percentage
    private func calculateImprovement(for result: ScanResult) -> Int {
        guard let currentIndex = scanHistory.firstIndex(where: { $0.id == result.id }),
              currentIndex + 1 < scanHistory.count else { return 0 }

        let previousResult = scanHistory[currentIndex + 1]
        let currentScore = Int((result.scores.first?.confidence ?? 0) * 100)
        let previousScore = Int((previousResult.scores.first?.confidence ?? 0) * 100)

        return currentScore - previousScore
    }

    /// Current streak of consecutive days with scans
    var currentStreak: Int {
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

    /// Clears all scan history
    func clearHistory() {
        scanHistory.removeAll()
        lastResult = nil
        saveScanHistory()
    }

    // MARK: - Persistence

    /// Saves scan history to UserDefaults
    private func saveScanHistory() {
        if let encoded = try? JSONEncoder().encode(scanHistory) {
            UserDefaults.standard.set(encoded, forKey: scanHistoryKey)
        }
    }

    /// Loads scan history from UserDefaults
    private func loadScanHistory() {
        guard let data = UserDefaults.standard.data(forKey: scanHistoryKey),
              let decoded = try? JSONDecoder().decode([ScanResult].self, from: data) else {
            return
        }
        scanHistory = decoded
        lastResult = decoded.first
    }
}


