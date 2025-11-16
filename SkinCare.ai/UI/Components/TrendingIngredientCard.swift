import SwiftUI

// MARK: - Trending Ingredient Card

/// Compact card displaying trending ingredient information
/// Shows name, description, concern tags, and ingredient count
struct TrendingIngredientCard: View {
    // MARK: - Properties

    let ingredient: Ingredient

    // MARK: - State

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(ingredient.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(ingredient.helpsWith.count) concerns")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(ingredient.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 4) {
                    ForEach(ingredient.helpsWith.prefix(2)) { condition in
                        Text(formatConditionName(condition.rawValue))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(colorForCondition(condition))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(colorForCondition(condition).opacity(0.1))
                            )
                    }
                    
                    if ingredient.helpsWith.count > 2 {
                        Text("+\(ingredient.helpsWith.count - 2)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(.secondary.opacity(0.1))
                            )
                    }
                }
            }
        }
        .padding(16)
        .frame(width: 160, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.quaternary, lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
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

    // MARK: - Helper Methods

    private func formatConditionName(_ rawValue: String) -> String {
        return rawValue.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
            .capitalized
    }
    
    private func colorForCondition(_ condition: SkinCondition) -> Color {
        switch condition {
        case .acne: return .red
        case .redness: return .pink
        case .darkSpots: return .orange
        case .wrinkles: return .purple
        case .pigmentation: return .brown
        case .dryness: return .blue
        case .oiliness: return .green
        case .sensitivity: return .mint
        case .dullness: return .gray
        case .dehydration: return .cyan
        case .sunDamage: return .yellow
        case .pores: return .indigo
        case .texture: return .teal
        }
    }
}

// MARK: - Previews

#Preview {
    ScrollView(.horizontal) {
        HStack(spacing: 16) {
            ForEach(IngredientCatalog.sample.prefix(3)) { ingredient in
                TrendingIngredientCard(ingredient: ingredient)
            }
        }
        .padding()
    }
}
