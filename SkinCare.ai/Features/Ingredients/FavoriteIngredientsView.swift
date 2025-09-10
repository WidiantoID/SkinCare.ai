import SwiftUI

struct FavoriteIngredientsView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @State private var searchText = ""
    
    private let allIngredients = IngredientCatalog.sample
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            if favoriteIngredients.isEmpty {
                emptyStateView
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
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 64))
                .foregroundStyle(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Text("Tap the heart icon on ingredients you love to add them to your favorites.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct IngredientRow: View {
    let ingredient: Ingredient
    @StateObject private var favoritesManager = FavoritesManager.shared
    
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

#Preview {
    NavigationStack {
        FavoriteIngredientsView()
    }
}
