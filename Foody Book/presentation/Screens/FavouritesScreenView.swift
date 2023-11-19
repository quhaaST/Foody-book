//
//  FavouritesScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct FavouritesScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MinifiedFavouriteRecipe.id, ascending: true)],
        animation: .default)
    private var favouriteRecipes: FetchedResults<MinifiedFavouriteRecipe>
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(favouriteRecipes, id: \.id) { recipe in
                        let recipeModel = MinifiedRecipeModel(
                            id: Int(recipe.id),
                            title: recipe.title ?? "",
                            image: recipe.image ?? "",
                            missedIngredientCount: Int(recipe.missedIngredientCount)
                        )
                        
                        NavigationLink(destination: RecipeDetailsScreenView(recipeId: recipeModel.id)) {
                            MinifiedRecipeView(minifiedRecipeModel: recipeModel)
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

struct FavouritesScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesScreenView()
    }
}
