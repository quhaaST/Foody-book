//
//  FavouritesScreenViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 20.11.2023.
//

import Foundation
import CoreData

class FavouritesScreenViewModel: ObservableObject {
    @Published var favouriteRecipes: [MinifiedFavouriteRecipe] = []
    
    func fetchFavouritesData(context: NSManagedObjectContext) {
        let request = MinifiedFavouriteRecipe.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MinifiedFavouriteRecipe.id, ascending: true)]
        
        do {
            let data = try context.fetch(request)
            favouriteRecipes = data
        } catch {
            favouriteRecipes = []
        }
    }
    
    func onRecipeLiked(context: NSManagedObjectContext, recipe: MinifiedRecipeModel) {
        LocalDataController
            .shared
            .addFavouriteRecipe(
                context: context,
                recipeModel: recipe
            )
    }
    
    func onRecipeDisliked(context: NSManagedObjectContext, recipeId: Int) {
        favouriteRecipes
            .filter { recipe in
                recipe.id == Int32(recipeId)
            }
            .forEach { recipe in
                context.delete(recipe)
            }
        
        LocalDataController.shared.saveData(context: context)
        
        fetchFavouritesData(context: context)
    }
}
