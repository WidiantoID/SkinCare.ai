import Foundation

public final class MockAnalyzer: MLAnalyzing {
    public init() {}

    public func analyzeSkin(from imageData: Data) async throws -> ScanResult {
        let scores = SkinCondition.allCases.map { condition in
            ConditionScore(condition: condition, confidence: Double.random(in: 0.2...0.95))
        }
        
        let mockAnalysis = "Your skin appears to have good overall health with some areas that could benefit from targeted care. The analysis shows balanced hydration levels with minor concerns in specific areas that can be addressed with the right skincare routine."
        
        let mockIngredients = ["Niacinamide", "Hyaluronic Acid", "Vitamin C", "Salicylic Acid"].shuffled().prefix(3)
        
        return ScanResult(
            imageIdentifier: UUID().uuidString, 
            scores: scores,
            skinAnalysis: mockAnalysis,
            recommendedIngredients: Array(mockIngredients)
        )
    }
}


