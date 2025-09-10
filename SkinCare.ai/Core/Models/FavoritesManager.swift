import Foundation
import SwiftUI

@MainActor
class FavoritesManager: ObservableObject {
    @Published var favoriteIngredients: Set<String> = []
    
    static let shared = FavoritesManager()
    
    private init() {
        loadFavorites()
    }
    
    func toggleFavorite(ingredientName: String) {
        if favoriteIngredients.contains(ingredientName) {
            favoriteIngredients.remove(ingredientName)
        } else {
            favoriteIngredients.insert(ingredientName)
        }
        saveFavorites()
    }
    
    func isFavorite(ingredientName: String) -> Bool {
        favoriteIngredients.contains(ingredientName)
    }
    
    private func saveFavorites() {
        let favoriteArray = Array(favoriteIngredients)
        UserDefaults.standard.set(favoriteArray, forKey: "favorite_ingredients")
    }
    
    private func loadFavorites() {
        if let favoriteArray = UserDefaults.standard.array(forKey: "favorite_ingredients") as? [String] {
            favoriteIngredients = Set(favoriteArray)
        }
    }
}
