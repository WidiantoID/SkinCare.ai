import SwiftUI

struct IngredientListView: View {
    let title: String
    let ingredients: [Ingredient]
    @State private var query: String = ""

    var filtered: [Ingredient] {
        guard !query.isEmpty else { return ingredients }
        return ingredients.filter { $0.name.localizedCaseInsensitiveContains(query) || $0.description.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        List {
            ForEach(filtered) { ingredient in
                NavigationLink {
                    IngredientDetailView(ingredient: ingredient)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(ingredient.name)
                                .font(.headline)
                            Spacer()
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
                    }
                }
            }
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search ingredients"))
        .navigationTitle(title)
        .listStyle(.insetGrouped)
    }
}

#Preview {
    NavigationStack { IngredientListView(title: "All Ingredients", ingredients: IngredientCatalog.sample) }
}


