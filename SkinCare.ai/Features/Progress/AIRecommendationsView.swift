import SwiftUI

struct AIRecommendationsView: View {
    let scanStore: ScanStore
    @Environment(\.dismiss) private var dismiss
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                    
                    // Personalized Recommendations
                    recommendationsSection
                    
                    // Ingredient Insights
                    ingredientsSection
                    
                    // Routine Suggestions
                    routineSection
                    
                    // Progress Insights
                    insightsSection
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .background(Theme.Gradients.appBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.orange)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.orange.gradient)
                
                Text("AI Recommendations")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            
            Text("Personalized insights based on your skin analysis")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: animateCards)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Recommendations Section
    private var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("For Your Skin Type")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 12) {
                RecommendationCard(
                    title: "Hydration Focus",
                    description: "Your recent scans show improved moisture levels. Continue with hyaluronic acid serums.",
                    priority: .high,
                    color: .blue
                )
                
                RecommendationCard(
                    title: "Gentle Exfoliation",
                    description: "Consider adding a mild BHA product 2-3 times per week for texture improvement.",
                    priority: .medium,
                    color: .green
                )
                
                RecommendationCard(
                    title: "Sun Protection",
                    description: "Daily SPF 30+ is crucial for preventing further pigmentation issues.",
                    priority: .high,
                    color: .orange
                )
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(0.4), value: animateCards)
    }
    
    // MARK: - Ingredients Section
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommended Ingredients")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                IngredientRecommendationCard(
                    name: "Niacinamide",
                    benefit: "Reduces redness & pores",
                    confidence: 92,
                    color: .pink
                )
                
                IngredientRecommendationCard(
                    name: "Vitamin C",
                    benefit: "Brightens & protects",
                    confidence: 88,
                    color: .orange
                )
                
                IngredientRecommendationCard(
                    name: "Retinol",
                    benefit: "Anti-aging & texture",
                    confidence: 85,
                    color: .purple
                )
                
                IngredientRecommendationCard(
                    name: "Ceramides",
                    benefit: "Barrier repair",
                    confidence: 90,
                    color: .blue
                )
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 30)
        .animation(.easeOut(duration: 0.6).delay(0.5), value: animateCards)
    }
    
    // MARK: - Routine Section
    private var routineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Suggested Routine")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 12) {
                RoutineStepCard(
                    timeOfDay: "Morning",
                    steps: ["Gentle Cleanser", "Vitamin C Serum", "Moisturizer", "SPF 30+"],
                    color: .orange
                )
                
                RoutineStepCard(
                    timeOfDay: "Evening",
                    steps: ["Oil Cleanser", "Water Cleanser", "Niacinamide Serum", "Night Moisturizer"],
                    color: .blue
                )
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 40)
        .animation(.easeOut(duration: 0.6).delay(0.6), value: animateCards)
    }
    
    // MARK: - Insights Section
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Insights")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            VStack(spacing: 12) {
                InsightCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Improvement Trend",
                    description: "Your skin scores have improved by 15% over the last month. Keep up the great work!",
                    color: .green
                )
                
                InsightCard(
                    icon: "target",
                    title: "Goal Progress",
                    description: "You're 70% towards your acne reduction goal. Consider adding salicylic acid to your routine.",
                    color: .blue
                )
                
                InsightCard(
                    icon: "calendar",
                    title: "Consistency",
                    description: "You've maintained a 7-day scanning streak. Regular monitoring helps track progress effectively.",
                    color: .orange
                )
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 50)
        .animation(.easeOut(duration: 0.6).delay(0.7), value: animateCards)
    }
}

// MARK: - Supporting Views

struct RecommendationCard: View {
    let title: String
    let description: String
    let priority: Priority
    let color: Color
    
    enum Priority {
        case high, medium, low
        
        var text: String {
            switch self {
            case .high: return "High Priority"
            case .medium: return "Medium Priority"
            case .low: return "Low Priority"
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .high: return .red.opacity(0.1)
            case .medium: return .orange.opacity(0.1)
            case .low: return .green.opacity(0.1)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(priority.text)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(priority.backgroundColor)
                    )
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(nil)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct IngredientRecommendationCard: View {
    let name: String
    let benefit: String
    let confidence: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("\(confidence)%")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
            }
            
            Text(benefit)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // Confidence bar
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color.opacity(0.2))
                    .overlay(
                        HStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(color.gradient)
                                .frame(width: geometry.size.width * (Double(confidence) / 100))
                            Spacer(minLength: 0)
                        }
                    )
            }
            .frame(height: 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
}

struct RoutineStepCard: View {
    let timeOfDay: String
    let steps: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: timeOfDay == "Morning" ? "sun.max.fill" : "moon.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(color.gradient)
                
                Text(timeOfDay)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                            .background(
                                Circle()
                                    .fill(color.gradient)
                            )
                        
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2.weight(.semibold))
                .foregroundStyle(color.gradient)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    AIRecommendationsView(scanStore: ScanStore())
}
