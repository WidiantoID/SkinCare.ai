import SwiftUI

/// Detailed view for a single ingredient
/// Shows description, benefits, concerns it helps with, and cautions
struct IngredientDetailView: View {
    // MARK: - Properties

    let ingredient: Ingredient

    // MARK: - State Objects

    @StateObject private var favoritesManager = FavoritesManager.shared

    // MARK: - State

    @State private var showingFavoriteAnimation = false

    // MARK: - Computed Properties

    private var isFavorite: Bool {
        favoritesManager.isFavorite(ingredientName: ingredient.name)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 16) {
                    // Ingredient Icon/Image
                    ZStack {
                        Circle()
                            .fill(.green.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.green.gradient)
                    }
                    
                    VStack(spacing: 8) {
                        Text(ingredient.name)
                            .font(.title.weight(.bold))
                            .multilineTextAlignment(.center)
                        
                        // Favorite Button
                        Button {
                            toggleFavorite()
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(isFavorite ? .red : .secondary)
                                    .scaleEffect(showingFavoriteAnimation ? 1.3 : 1.0)
                                
                                Text(isFavorite ? "Favorited" : "Add to Favorites")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(isFavorite ? .red : .secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(isFavorite ? Color.red.opacity(0.1) : Color.gray.opacity(0.2))
                            )
                        }
                    }
                }
                .padding(.top, 20)
                
                // About Section
                IngredientInfoCard(
                    title: "About",
                    icon: "info.circle.fill",
                    color: .blue
                ) {
                    Text(ingredient.description)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineSpacing(4)
                }

                // Benefits Section
                if !ingredient.benefits.isEmpty {
                    IngredientInfoCard(
                        title: "Benefits",
                        icon: "star.fill",
                        color: .green
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(ingredient.benefits, id: \.self) { benefit in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.green)
                                        .padding(.top, 2)
                                    
                                    Text(benefit)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }

                // Helps With Section
                if !ingredient.helpsWith.isEmpty {
                    IngredientInfoCard(
                        title: "Helps With",
                        icon: "cross.fill",
                        color: .purple
                    ) {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(ingredient.helpsWith) { condition in
                                Text(condition.rawValue.capitalized)
                                    .font(.caption.weight(.medium))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.purple.opacity(0.1))
                                    )
                                    .foregroundStyle(.purple)
                            }
                        }
                    }
                }

                // Cautions Section
                if !ingredient.cautions.isEmpty {
                    IngredientInfoCard(
                        title: "Cautions",
                        icon: "exclamationmark.triangle.fill",
                        color: .orange
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(ingredient.cautions, id: \.self) { caution in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.orange)
                                        .padding(.top, 2)
                                    
                                    Text(caution)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isFavorite ? .red : .secondary)
                        .scaleEffect(showingFavoriteAnimation ? 1.2 : 1.0)
                }
            }
        }
        .onAppear {
            AppLogger.info("IngredientDetailView appeared for: \(ingredient.name)", category: .ui)
        }
    }

    // MARK: - Helper Methods

    /// Toggles favorite status with haptic feedback and animation
    private func toggleFavorite() {
        let wasFavorite = isFavorite

        if wasFavorite {
            HapticManager.light()
            AppLogger.debug("Removed \(ingredient.name) from favorites", category: .ui)
        } else {
            HapticManager.success()
            AppLogger.debug("Added \(ingredient.name) to favorites", category: .ui)
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            favoritesManager.toggleFavorite(ingredientName: ingredient.name)
            showingFavoriteAnimation = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showingFavoriteAnimation = false
        }
    }
}

// MARK: - Ingredient Info Card

/// Reusable card component for displaying ingredient information sections
struct IngredientInfoCard<Content: View>: View {
    // MARK: - Properties

    let title: String
    let icon: String
    let color: Color
    let content: Content

    // MARK: - Initialization

    init(title: String, icon: String, color: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color.gradient)
                
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            content
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: color.opacity(0.1), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Previews

#Preview {
    NavigationStack { IngredientDetailView(ingredient: IngredientCatalog.sample.first!) }
}
