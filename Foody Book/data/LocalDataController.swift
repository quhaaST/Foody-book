//
//  LocalDataController.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 18.11.2023.
//

import Foundation
import CoreData

class LocalDataController: ObservableObject {
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
    
    func addAvailableIngredient(context: NSManagedObjectContext, name: String) {
        let availableIngredient = AvailableIngredient(context: context)
        availableIngredient.id = UUID()
        availableIngredient.name = name
        
        saveData(context: context)
    }
}
