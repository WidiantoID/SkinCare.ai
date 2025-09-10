import Foundation

public protocol MLAnalyzing {
    func analyzeSkin(from imageData: Data) async throws -> ScanResult
}


