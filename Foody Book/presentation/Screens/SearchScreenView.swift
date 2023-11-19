//
//  SearchScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct SearchScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var viewModel = SearchScreenViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)],
        predicate: NSPredicate(format: "type == %@", IngredientType.available.rawValue),
        animation: .default)
    private var availableIngredient: FetchedResults<Ingredient>
    
    var body: some View {
        if viewModel.minifiedRecipes.isEmpty {
            ProgressView()
                .onAppear {
                    viewModel.fetchRecipesByIngredients(
                        availableIngredient.map { ingredient in
                            ingredient.name ?? ""
                        }
                    )
                }
        } else {
            NavigationView {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.minifiedRecipes, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetailsScreenView(recipeId: recipe.id)) {
                                MinifiedRecipeView(minifiedRecipeModel: recipe)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
