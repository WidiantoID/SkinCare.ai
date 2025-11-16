import SwiftUI

/// Displays detailed skin analysis results
/// Shows AI analysis, condition scores, and recommended ingredients
struct ResultsView: View {
    // MARK: - Properties

    let result: ScanResult

    // MARK: - State

    @State private var showingShareSheet = false

    // MARK: - Computed Properties

    /// Formats condition name from camelCase to Title Case
    private func formattedConditionName(_ condition: SkinCondition) -> String {
        let raw = condition.rawValue
        return raw.prefix(1).uppercased() + raw.dropFirst()
            .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
    }

    /// Returns color based on confidence level
    private func confidenceColor(_ confidence: Double) -> Color {
        if confidence > 0.6 { return .green }
        else if confidence > 0.3 { return .orange }
        else { return .gray }
    }

    /// Returns text label for confidence level
    private func confidenceLabel(_ confidence: Double) -> String {
        if confidence > 0.6 { return "High confidence" }
        else if confidence > 0.3 { return "Moderate confidence" }
        else { return "Low confidence" }
    }

    // MARK: - Body

    var body: some View {
        List {
            // Skin Analysis Section
            if let skinAnalysis = result.skinAnalysis {
                Section("AI Skin Analysis") {
                    Text(skinAnalysis)
                        .font(.body)
                        .lineLimit(nil)
                        .textSelection(.enabled)
                }
            }
            
            // Recommended Ingredients Section
            if !result.recommendedIngredients.isEmpty {
                Section("Recommended Ingredients") {
                    ForEach(result.recommendedIngredients, id: \.self) { ingredient in
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundStyle(.green)
                                .font(.caption)
                            Text(ingredient)
                                .font(.body)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            Section("Overview") {
                HStack {
                    Text("Captured")
                    Spacer()
                    Text(result.capturedAt, style: .date)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Image ID")
                    Spacer()
                    Text(result.imageIdentifier)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .textSelection(.enabled)
                }
            }

            Section("Detected Conditions") {
                ForEach(result.scores.filter { $0.confidence > 0.1 }) { score in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(formattedConditionName(score.condition))
                                .font(.body.weight(.medium))

                            Spacer()

                            Text(String(format: "%.0f%%", score.confidence * 100))
                                .monospacedDigit()
                                .font(.body.weight(.semibold))
                                .foregroundStyle(confidenceColor(score.confidence))
                                .accessibilityLabel("Confidence")
                                .accessibilityValue(String(format: "%.0f percent", score.confidence * 100))
                        }

                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 8)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(confidenceColor(score.confidence).gradient)
                                    .frame(width: geometry.size.width * score.confidence, height: 8)
                            }
                        }
                        .frame(height: 8)

                        Text(confidenceLabel(score.confidence))
                            .font(.caption)
                            .foregroundStyle(confidenceColor(score.confidence))
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    HapticManager.light()
                    showingShareSheet = true
                    AppLogger.info("Sharing results", category: .ui)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.body.weight(.medium))
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [generateShareText()])
        }
        .onAppear {
            AppLogger.info("ResultsView appeared", category: .ui)
            AppLogger.debug("Displaying results for scan: \(result.imageIdentifier)", category: .scan)
        }
    }

    // MARK: - Helper Methods

    /// Generates formatted text for sharing
    private func generateShareText() -> String {
        var text = "SkinCare.ai Analysis Results\n"
        text += "Date: \(result.capturedAt.formatted(date: .long, time: .shortened))\n\n"

        if let analysis = result.skinAnalysis {
            text += "Analysis:\n\(analysis)\n\n"
        }

        let topConditions = result.scores.filter { $0.confidence > 0.3 }.sorted { $0.confidence > $1.confidence }
        if !topConditions.isEmpty {
            text += "Top Conditions Detected:\n"
            for score in topConditions.prefix(5) {
                text += "• \(formattedConditionName(score.condition)): \(String(format: "%.0f%%", score.confidence * 100))\n"
            }
            text += "\n"
        }

        if !result.recommendedIngredients.isEmpty {
            text += "Recommended Ingredients:\n"
            for ingredient in result.recommendedIngredients {
                text += "• \(ingredient)\n"
            }
        }

        return text
    }
}

// MARK: - Share Sheet

/// UIKit share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Previews

#Preview {
    let scores = SkinCondition.allCases.map { ConditionScore(condition: $0, confidence: Double.random(in: 0.3...0.9)) }
    let sampleResult = ScanResult(
        imageIdentifier: "preview", 
        scores: scores,
        skinAnalysis: "Your skin shows signs of mild acne and slight oiliness in the T-zone. Overall skin texture appears healthy with good hydration levels. Some minor pores are visible around the nose area.",
        recommendedIngredients: ["Salicylic Acid", "Niacinamide", "Hyaluronic Acid"]
    )
    return NavigationStack { ResultsView(result: sampleResult) }
}
