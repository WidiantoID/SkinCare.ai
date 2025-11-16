import SwiftUI

/// Main hub for exploring skincare ingredients
/// Provides personalized recommendations, browsing by concern, and trending ingredients
struct IngredientsHubView: View {
    // MARK: - Environment Objects

    @EnvironmentObject var scanStore: ScanStore

    // MARK: - State

    @State private var selectedCategory: String? = nil
    @State private var showingSearch = false
    @State private var showingFavorites = false
    @State private var showingRecent = false
    @State private var showingConcernIngredients = false
    @State private var selectedConcern: SkinCondition?
    @State private var animateCards = false

    // MARK: - Constants

    private let concerns = SkinCondition.allCases
    private let allIngredients = IngredientCatalog.all

    // MARK: - Body

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // Modern Header with gradient background
                headerSection
                
                // Enhanced Quick Actions
                quickActionsSection
                
                // Personalized Recommendations
                if scanStore.lastResult != nil {
                    personalizedSection
                }
                
                // Featured Categories
                featuredCategoriesSection
                
                // Trending Ingredients Grid
                trendingIngredientsSection
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
        .background(Theme.Gradients.appBackground.ignoresSafeArea())
        .navigationTitle("Ingredients")
        .onAppear {
            AppLogger.info("IngredientsHubView appeared", category: .ui)
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateCards = true
            }
        }
        .sheet(isPresented: $showingSearch) {
            NavigationStack {
                IngredientListView(title: "Search Ingredients", ingredients: allIngredients)
            }
        }
        .sheet(isPresented: $showingFavorites) {
            NavigationStack {
                FavoriteIngredientsView()
            }
        }
        .sheet(isPresented: $showingRecent) {
            NavigationStack {
                IngredientListView(title: "Recently Added", ingredients: Array(allIngredients.suffix(5)))
            }
        }
        .sheet(isPresented: $showingConcernIngredients) {
            NavigationStack {
                if let concern = selectedConcern {
                    IngredientListView(
                        title: formatConcernName(concern.rawValue),
                        ingredients: allIngredients.filter { $0.helpsWith.contains(concern) }
                    )
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Personalized skincare ingredients powered by AI")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()

                Button(action: {
                    HapticManager.light()
                    AppLogger.debug("Search button tapped", category: .ui)
                    showingSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .foregroundStyle(.mint)
                        .frame(width: 44, height: 44)
                        .background(.mint.opacity(0.1))
                        .clipShape(Circle())
                }
                .scaleEffect(animateCards ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: animateCards)
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CategoryActionChip(
                        title: "All",
                        icon: "circle.grid.3x3.fill",
                        color: .mint,
                        count: allIngredients.count,
                        isSelected: selectedCategory == "all"
                    ) {
                        HapticManager.light()
                        AppLogger.debug("Viewing all ingredients (\(allIngredients.count))", category: .ui)
                        selectedCategory = "all"
                        showingSearch = true
                    }

                    CategoryActionChip(
                        title: "Favorites",
                        icon: "heart.fill",
                        color: .pink,
                        count: FavoritesManager.shared.favoriteIngredients.count,
                        isSelected: selectedCategory == "favorites"
                    ) {
                        HapticManager.light()
                        AppLogger.debug("Viewing favorite ingredients", category: .ui)
                        selectedCategory = "favorites"
                        showingFavorites = true
                    }

                    CategoryActionChip(
                        title: "Recent",
                        icon: "clock.fill",
                        color: .orange,
                        count: 5,
                        isSelected: selectedCategory == "recent"
                    ) {
                        HapticManager.light()
                        AppLogger.debug("Viewing recent ingredients", category: .ui)
                        selectedCategory = "recent"
                        showingRecent = true
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 20)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
    }

    
    // MARK: - Personalized Section
    private var personalizedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(.pink.gradient)
                    .font(.title2)
                
                Text("Just for You")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            if let scan = scanStore.lastResult {
                NavigationLink {
                    IngredientListView(title: "Recommended", ingredients: recommended(from: scan))
                } label: {
                    ModernRecommendationCard(
                        title: "AI Recommendations",
                        subtitle: "Based on your latest skin analysis",
                        ingredientCount: recommended(from: scan).count,
                        topIngredients: Array(scan.recommendedIngredients.prefix(3))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .opacity(animateCards ? 1.0 : 0.0)
        .offset(y: animateCards ? 0 : 30)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    // MARK: - Featured Categories Section
    private var featuredCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse by Concern")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(Array(concerns.enumerated()), id: \.element) { index, concern in
                    let count = allIngredients.filter { $0.helpsWith.contains(concern) }.count
                    ModernConcernCard(
                        title: formatConcernName(concern.rawValue),
                        count: count,
                        icon: icon(for: concern),
                        color: colorForConcern(concern)
                    ) {
                        HapticManager.light()
                        AppLogger.debug("Viewing ingredients for concern: \(concern.rawValue)", category: .ui)
                        selectedConcern = concern
                        showingConcernIngredients = true
                    }
                    .opacity(animateCards ? 1.0 : 0.0)
                    .offset(y: animateCards ? 0 : 40)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5 + Double(index) * 0.1), value: animateCards)
                }
            }
        }
    }
    
    // MARK: - Trending Ingredients Section
    private var trendingIngredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending Ingredients")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                NavigationLink("See All") {
                    IngredientListView(title: "All Ingredients", ingredients: allIngredients)
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.mint)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(allIngredients.prefix(6).enumerated()), id: \.element.id) { index, ingredient in
                        NavigationLink(destination: IngredientDetailView(ingredient: ingredient)) {
                            TrendingIngredientCard(ingredient: ingredient)
                        }
                        .buttonStyle(.plain)
                        .opacity(animateCards ? 1.0 : 0.0)
                        .offset(x: animateCards ? 0 : 50)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6 + Double(index) * 0.08), value: animateCards)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    // MARK: - Helper Functions
    private func icon(for concern: SkinCondition) -> String {
        switch concern {
        case .acne: return "face.dashed"
        case .redness: return "drop.fill"
        case .darkSpots: return "sun.min.fill"
        case .wrinkles: return "waveform.path"
        case .pigmentation: return "circle.lefthalf.filled"
        case .dryness: return "wind"
        case .oiliness: return "drop.triangle.fill"
        case .sensitivity: return "heart.text.square"
        case .dullness: return "cloud.fill"
        case .dehydration: return "humidity.fill"
        case .sunDamage: return "sun.max.fill"
        case .pores: return "circle.grid.2x1.fill"
        case .texture: return "square.grid.3x3.fill"
        }
    }
    
    private func colorForConcern(_ concern: SkinCondition) -> Color {
        switch concern {
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
    
    private func formatConcernName(_ rawValue: String) -> String {
        return rawValue.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
            .capitalized
    }

    private func recommended(from scan: ScanResult) -> [Ingredient] {
        let sortedConditions = scan.scores.sorted(by: { $0.confidence > $1.confidence }).map { $0.condition }
        var seen = Set<UUID>()
        var out: [Ingredient] = []
        for cond in sortedConditions {
            for ing in IngredientCatalog.sample where ing.helpsWith.contains(cond) {
                if !seen.contains(ing.id) { out.append(ing); seen.insert(ing.id) }
            }
        }
        return out
    }
}

// MARK: - Previews

#Preview {
    NavigationStack { IngredientsHubView() }
}
