import Foundation

/// Mock analyzer for testing and development
/// Generates realistic but randomized skin analysis results without requiring an API key
/// Useful for testing the UI and app flow without consuming API quota
public final class MockAnalyzer: MLAnalyzing {
    // MARK: - Configuration

    /// Simulates network delay to make the experience more realistic
    private let simulatedDelay: TimeInterval

    /// Whether to occasionally simulate errors for testing error handling
    private let shouldSimulateErrors: Bool

    // MARK: - Mock Data

    private let mockAnalyses = [
        "Your skin appears to have good overall health with some areas that could benefit from targeted care. The analysis shows balanced hydration levels with minor concerns in specific areas that can be addressed with the right skincare routine.",
        "Analysis reveals healthy skin with good moisture balance. Some minor texture irregularities are present but overall complexion appears even and well-maintained.",
        "Your skin shows signs of excellent care with strong barrier function. Hydration levels are optimal and pore size is minimal. Continue your current routine.",
        "Mild concerns detected in the T-zone area with slight oiliness. Overall skin health is good with room for improvement in specific targeted areas.",
        "Skin appears well-hydrated with good elasticity. Minor areas of unevenness detected but overall texture and tone are balanced and healthy."
    ]

    private let mockIngredientSets = [
        ["Niacinamide", "Hyaluronic Acid", "Vitamin C"],
        ["Salicylic Acid", "Retinol", "Ceramides"],
        ["Peptides", "Alpha Arbutin", "Centella Asiatica"],
        ["Azelaic Acid", "Glycolic Acid", "Vitamin E"],
        ["Squalane", "Panthenol", "Green Tea Extract"]
    ]

    // MARK: - Initialization

    /// Creates a new mock analyzer
    /// - Parameters:
    ///   - simulatedDelay: How long to wait before returning results (default: 2 seconds)
    ///   - shouldSimulateErrors: Whether to occasionally throw errors for testing (default: false)
    public init(simulatedDelay: TimeInterval = 2.0, shouldSimulateErrors: Bool = false) {
        self.simulatedDelay = simulatedDelay
        self.shouldSimulateErrors = shouldSimulateErrors
        AppLogger.info("MockAnalyzer initialized with \(simulatedDelay)s delay", category: .general)
    }

    // MARK: - MLAnalyzing Protocol

    public func analyzeSkin(from imageData: Data) async throws -> ScanResult {
        AppLogger.info("MockAnalyzer: Starting skin analysis", category: .scan)

        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))

        // Occasionally simulate errors if configured
        if shouldSimulateErrors && Double.random(in: 0...1) < 0.1 {
            AppLogger.warning("MockAnalyzer: Simulating error for testing", category: .scan)
            throw NSError(
                domain: "MockAnalyzerError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Simulated error for testing purposes"]
            )
        }

        // Generate random but realistic condition scores
        let scores = SkinCondition.allCases.map { condition in
            ConditionScore(condition: condition, confidence: Double.random(in: 0.15...0.85))
        }

        // Select random analysis text
        let mockAnalysis = mockAnalyses.randomElement() ?? mockAnalyses[0]

        // Select random ingredient recommendations
        let mockIngredients = mockIngredientSets.randomElement() ?? mockIngredientSets[0]

        let result = ScanResult(
            imageIdentifier: UUID().uuidString,
            scores: scores,
            skinAnalysis: mockAnalysis,
            recommendedIngredients: mockIngredients
        )

        AppLogger.info("MockAnalyzer: Analysis completed with \(scores.count) condition scores", category: .scan)

        return result
    }
}
