import Foundation

/// Protocol for machine learning-based skin analysis
/// Implementations should provide skin condition detection and analysis capabilities
public protocol MLAnalyzing {
    /// Analyzes skin from image data
    /// - Parameter imageData: JPEG or PNG image data containing a face
    /// - Returns: ScanResult with detected conditions and analysis
    /// - Throws: Error if analysis fails
    func analyzeSkin(from imageData: Data) async throws -> ScanResult
}


