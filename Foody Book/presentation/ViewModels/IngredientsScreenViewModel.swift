//
//  IngredientsScreenViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 20.11.2023.
//

import Foundation
import CoreData

class IngredientsScreenViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var showAddIngredientView = false
    @Published var selectedType: IngredientType = .available
    
    func fetchIngredientsUpdates(context: NSManagedObjectContext) {
        let request = Ingredient.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]
        
        do {
            let data = try context.fetch(request)
            ingredients = data
        } catch {
            ingredients = []
        }
    }
    
    func deleteIngredient(offsets: IndexSet, context: NSManagedObjectContext) {
        offsets.map { getFilteredItems()[$0] }.forEach(context.delete)
        LocalDataController.shared.saveData(context: context)
        
        fetchIngredientsUpdates(context: context)
    }
    
    func getFilteredItems() -> [Ingredient] {
        return ingredients.filter { ingredient in
            ingredient.type == selectedType.rawValue
        }
    }
}
