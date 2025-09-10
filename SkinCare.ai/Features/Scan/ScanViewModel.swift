import Foundation
import Combine

@MainActor
final class ScanViewModel: ObservableObject {
    @Published var isAnalyzing: Bool = false
    @Published var lastResult: ScanResult?
    @Published var errorMessage: String?

    private let analyzer: MLAnalyzing
    private let scanStore: ScanStore?

    init(analyzer: MLAnalyzing, scanStore: ScanStore? = nil) {
        self.analyzer = analyzer
        self.scanStore = scanStore
    }

    func analyze(imageData: Data) async {
        guard !isAnalyzing else { return }
        isAnalyzing = true
        defer { isAnalyzing = false }
        do {
            let result = try await analyzer.analyzeSkin(from: imageData)
            self.lastResult = result
            self.scanStore?.addScanResult(result)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}


