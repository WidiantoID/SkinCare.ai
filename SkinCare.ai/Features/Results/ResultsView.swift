import SwiftUI

struct ResultsView: View {
    let result: ScanResult

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
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(score.condition.rawValue.capitalized.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression))
                                .font(.body)
                            if score.confidence > 0.6 {
                                Text("High confidence")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            } else if score.confidence > 0.3 {
                                Text("Moderate confidence")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            } else {
                                Text("Low confidence")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        Spacer()
                        Text(String(format: "%.0f%%", score.confidence * 100))
                            .monospacedDigit()
                            .foregroundStyle(score.confidence > 0.6 ? .green : score.confidence > 0.3 ? .orange : .gray)
                            .accessibilityLabel("Confidence")
                            .accessibilityValue(String(format: "%.0f percent", score.confidence * 100))
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Results")
    }
}

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


