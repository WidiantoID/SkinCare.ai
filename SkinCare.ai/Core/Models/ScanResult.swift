import Foundation
import CoreGraphics

/// Represents a detected skin condition with confidence score
public struct ConditionScore: Codable, Equatable, Identifiable {
    public let id: UUID
    public let condition: SkinCondition
    public var confidence: Double
    public var affectedRegions: [CGRect]

    public init(
        id: UUID = UUID(),
        condition: SkinCondition,
        confidence: Double,
        affectedRegions: [CGRect] = []
    ) {
        self.id = id
        self.condition = condition
        self.confidence = confidence
        self.affectedRegions = affectedRegions
    }
}

/// Result of a skin analysis scan
/// Contains detected conditions, analysis text, and ingredient recommendations
public struct ScanResult: Codable, Equatable, Identifiable {
    public let id: UUID
    public let capturedAt: Date
    public var imageIdentifier: String
    public var scores: [ConditionScore]
    public var skinAnalysis: String?
    public var recommendedIngredients: [String]

    public init(
        id: UUID = UUID(),
        capturedAt: Date = Date(),
        imageIdentifier: String,
        scores: [ConditionScore],
        skinAnalysis: String? = nil,
        recommendedIngredients: [String] = []
    ) {
        self.id = id
        self.capturedAt = capturedAt
        self.imageIdentifier = imageIdentifier
        self.scores = scores
        self.skinAnalysis = skinAnalysis
        self.recommendedIngredients = recommendedIngredients
    }
}


