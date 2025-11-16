import SwiftUI

// MARK: - Modern Recommendation Card

/// Large card displaying AI recommendations with ingredient previews
/// Shows title, subtitle, and top ingredient chips
struct ModernRecommendationCard: View {
    // MARK: - Properties

    let title: String
    let subtitle: String
    let ingredientCount: Int
    let topIngredients: [String]

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            
            HStack(spacing: 8) {
                ForEach(topIngredients.prefix(3), id: \.self) { ingredient in
                    Text(ingredient)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.pink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.pink.opacity(0.1))
                        )
                }
                
                if ingredientCount > 3 {
                    Text("+\(ingredientCount - 3) more")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.secondary.opacity(0.1))
                        )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.pink.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.pink.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .shadow(color: .pink.opacity(0.1), radius: 12, x: 0, y: 6)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ModernRecommendationCard(
        title: "AI Recommendations",
        subtitle: "Based on your latest skin analysis",
        ingredientCount: 8,
        topIngredients: ["Niacinamide", "Hyaluronic Acid", "Vitamin C"]
    )
    .padding()
}
