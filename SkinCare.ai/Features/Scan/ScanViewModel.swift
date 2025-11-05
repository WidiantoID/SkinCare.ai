import Foundation
import Combine

/// View model for managing skin scan operations
/// Coordinates between the analyzer service and UI state
@MainActor
final class ScanViewModel: ObservableObject {
    /// Whether an analysis is currently in progress
    @Published var isAnalyzing: Bool = false

    /// The most recent scan result
    @Published var lastResult: ScanResult?

    /// Error message to display to the user
    @Published var errorMessage: String?

    /// The analyzer service for processing skin images
    private let analyzer: MLAnalyzing

    /// Store for persisting scan results
    private let scanStore: ScanStore?

    /// Initialize a new scan view model
    /// - Parameters:
    ///   - analyzer: The ML analyzer to use for skin analysis
    ///   - scanStore: Optional store for persisting scan results
    init(analyzer: MLAnalyzing, scanStore: ScanStore? = nil) {
        self.analyzer = analyzer
        self.scanStore = scanStore
    }

    /// Analyzes skin from image data
    /// - Parameter imageData: JPEG image data to analyze
    /// - Note: Updates isAnalyzing, lastResult, and errorMessage properties
    func analyze(imageData: Data) async {
        // Prevent concurrent analysis
        guard !isAnalyzing else { return }

        // Clear previous error
        errorMessage = nil

        isAnalyzing = true
        defer { isAnalyzing = false }

        do {
            let result = try await analyzer.analyzeSkin(from: imageData)
            self.lastResult = result
            self.scanStore?.addScanResult(result)
        } catch {
            self.errorMessage = error.localizedDescription
            print("Scan analysis error: \(error)")
        }
    }

    /// Clears the last result and any error messages
    func clearResults() {
        lastResult = nil
        errorMessage = nil
    }
}


