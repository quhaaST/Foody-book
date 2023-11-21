//
//  NewIngredientModalViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 20.11.2023.
//

import Foundation
import CoreData

class NewIngredientModelViewModel: ObservableObject {
    @Published var name = ""
    @Published var alertIsDisplayed = false
    
    func addIngredient(context: NSManagedObjectContext, selectedType: IngredientType) {
        LocalDataController
            .shared
            .addIngredient(
                context: context,
                name: name,
                type: selectedType
            )
    }
}
