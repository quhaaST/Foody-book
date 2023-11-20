//
//  LocalDataController.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 18.11.2023.
//

import Foundation
import CoreData

class LocalDataController: ObservableObject {
    static let shared = LocalDataController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveData(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addIngredient(context: NSManagedObjectContext, name: String, type: IngredientType) {
        let ingredient = Ingredient(context: context)
        ingredient.id = UUID()
        ingredient.name = name
        ingredient.type = type.rawValue
        
        saveData(context: context)
    }
    
    func addFavouriteRecipe(context: NSManagedObjectContext, recipeModel: MinifiedRecipeModel) {
        let minifiedRecipe = MinifiedFavouriteRecipe(context: context)
        minifiedRecipe.id = Int32(recipeModel.id)
        minifiedRecipe.title = recipeModel.title
        minifiedRecipe.image = recipeModel.image
        
        if let missedIngredientsCount = recipeModel.missedIngredientCount {
            minifiedRecipe.missedIngredientCount = Int32(missedIngredientsCount)
        }
        saveData(context: context)
    }
}
