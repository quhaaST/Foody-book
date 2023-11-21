//
//  FavouritesScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct FavouritesScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @StateObject var viewModel = FavouritesScreenViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.favouriteRecipes, id: \.id) { recipe in
                        let recipeModel = MinifiedRecipeModel(
                            id: Int(recipe.id),
                            title: recipe.title ?? "",
                            image: recipe.image ?? "",
                            missedIngredientCount: Int(recipe.missedIngredientCount)
                        )
                        
                        NavigationLink(destination: RecipeDetailsScreenView(recipeId: recipeModel.id)) {
                            MinifiedRecipeView(
                                minifiedRecipeModel: recipeModel,
                                onRecipeLiked: {
                                    viewModel.onRecipeLiked(context: managedObjContext, recipe: recipeModel)
                                },
                                onRecipeDisliked: {
                                    viewModel.onRecipeDisliked(context: managedObjContext, recipeId: recipeModel.id)
                                },
                                isInFavourites: $viewModel.favouriteRecipes.contains { favoriteRecipe in
                                    favoriteRecipe.id == recipeModel.id
                                })
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.fetchFavouritesData(context: managedObjContext)
        }
    }
}

struct FavouritesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesScreenView()
    }
}
