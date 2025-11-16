import SwiftUI

/// Displays user's favorite ingredients
/// Supports search and quick access to ingredient details
struct FavoriteIngredientsView: View {
    // MARK: - State Objects

    @StateObject private var favoritesManager = FavoritesManager.shared

    // MARK: - State

    @State private var searchText = ""

    // MARK: - Constants

    private let allIngredients = IngredientCatalog.sample

    // MARK: - Computed Properties

    private var favoriteIngredients: [Ingredient] {
        allIngredients.filter { ingredient in
            favoritesManager.isFavorite(ingredientName: ingredient.name)
        }
    }

    private var filteredIngredients: [Ingredient] {
        if searchText.isEmpty {
            return favoriteIngredients
        } else {
            return favoriteIngredients.filter { ingredient in
                ingredient.name.localizedCaseInsensitiveContains(searchText) ||
                ingredient.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            if favoriteIngredients.isEmpty {
                EmptyStateView.noFavorites
            } else {
                List {
                    ForEach(filteredIngredients) { ingredient in
                        NavigationLink(destination: IngredientDetailView(ingredient: ingredient)) {
                            IngredientRow(ingredient: ingredient)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search favorites...")
            }
        }
        .navigationTitle("Favorite Ingredients")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            AppLogger.info("FavoriteIngredientsView appeared with \(favoriteIngredients.count) favorites", category: .ui)
        }
    }
}

// MARK: - Ingredient Row

/// Row component for displaying an ingredient in a list
struct IngredientRow: View {
    // MARK: - Properties

    let ingredient: Ingredient

    // MARK: - State Objects

    @StateObject private var favoritesManager = FavoritesManager.shared

    // MARK: - Body

    var body: some View {
        HStack(spacing: 12) {
            // Ingredient Icon
            ZStack {
                Circle()
                    .fill(.green.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.green)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(ingredient.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()

            Button {
                let wasFavorite = favoritesManager.isFavorite(ingredientName: ingredient.name)
                if wasFavorite {
                    HapticManager.light()
                } else {
                    HapticManager.success()
                }
                favoritesManager.toggleFavorite(ingredientName: ingredient.name)
            } label: {
                Image(systemName: favoritesManager.isFavorite(ingredientName: ingredient.name) ? "heart.fill" : "heart")
                    .font(.system(size: 16))
                    .foregroundStyle(favoritesManager.isFavorite(ingredientName: ingredient.name) ? .red : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack {
        FavoriteIngredientsView()
    }
}
