import SwiftUI

/// Displays a searchable list of ingredients
struct IngredientListView: View {
    // MARK: - Properties

    let title: String
    let ingredients: [Ingredient]
    @State private var query: String = ""
    @StateObject private var favoritesManager = FavoritesManager.shared

    // MARK: - Computed Properties

    var filtered: [Ingredient] {
        guard !query.isEmpty else { return ingredients }
        return ingredients.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.description.localizedCaseInsensitiveContains(query) ||
            $0.benefits.contains(where: { $0.localizedCaseInsensitiveContains(query) })
        }
    }

    var isEmpty: Bool {
        filtered.isEmpty
    }

    var isSearching: Bool {
        !query.isEmpty
    }

    // MARK: - Body

    var body: some View {
        Group {
            if isEmpty {
                emptyStateView
            } else {
                ingredientList
            }
        }
        .searchable(
            text: $query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search ingredients")
        )
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Subviews

    private var ingredientList: some View {
        List {
            Section {
                ForEach(filtered) { ingredient in
                    NavigationLink {
                        IngredientDetailView(ingredient: ingredient)
                    } label: {
                        IngredientRow(
                            ingredient: ingredient,
                            isFavorite: favoritesManager.isFavorite(ingredientName: ingredient.name)
                        )
                    }
                }
            } header: {
                if isSearching {
                    Text("\(filtered.count) results")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyStateView: some View {
        Group {
            if isSearching {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Results",
                    message: "No ingredients match '\(query)'. Try adjusting your search.",
                    iconColor: .gray
                )
            } else {
                EmptyStateView.noIngredients
            }
        }
    }
}

// MARK: - Ingredient Row Component

/// Individual ingredient row display
struct IngredientRow: View {
    let ingredient: Ingredient
    let isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(ingredient.name)
                    .font(.headline)

                Spacer()

                // Favorite indicator
                if isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .accessibilityLabel("Favorited")
                }

                // Condition tags
                HStack(spacing: 6) {
                    ForEach(ingredient.helpsWith.prefix(2)) { condition in
                        PillTag(text: condition.rawValue.capitalized)
                    }
                }
            }

            Text(ingredient.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            // Benefits preview (if available)
            if !ingredient.benefits.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle")
                        .font(.caption2)
                        .foregroundStyle(.green)

                    Text(ingredient.benefits.first ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(ingredient.name). \(ingredient.description)")
    }
}

#Preview {
    NavigationStack { IngredientListView(title: "All Ingredients", ingredients: IngredientCatalog.sample) }
}


