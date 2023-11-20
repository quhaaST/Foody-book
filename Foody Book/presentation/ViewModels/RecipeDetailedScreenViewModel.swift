//
//  RecipeDetailedScreenViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation
import CoreData

class RecipeDetailedScreenViewModel: ObservableObject {
    @Published var recipeData: RecipeDetailedInformationModel?
    @Published var allergicIngredients: [Ingredient] = []
    @Published var unlikedIngredients: [Ingredient] = []
    
    func loadDataUpdates(
        context: NSManagedObjectContext,
        recipeId: Int
    ) {
        fetchRecipeDetailedInformation(recipeId: recipeId)
        loadAllergicIngredients(context: context)
        loadUnlikedIngredients(context: context)
    }
    
    func fetchRecipeDetailedInformation(recipeId: Int) {
        let request = RemoteNetworkService()
            .getRecipeDetailsRequest(recipeId: recipeId)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let detailedRecipe = try JSONDecoder().decode(RecipeDetailedInformationModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.recipeData = detailedRecipe
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func mapBadges(recipeModel: RecipeDetailedInformationModel) -> [BadgeModel] {
        var badges: [BadgeModel] = []
        
        let hasAllergicIngredients: Bool = recipeModel.extendedIngredients.contains { recipeIngredient in
            allergicIngredients.contains { allergicIngredient in
                guard let ingredientName = allergicIngredient.name else {
                    return false
                }
                
                return recipeIngredient.name.localizedCaseInsensitiveContains(ingredientName) ||
                ingredientName.localizedCaseInsensitiveContains(recipeIngredient.name)
            }
        }
        
        let hasUnlikedIngredients: Bool = recipeModel.extendedIngredients.contains { recipeIngredient in
            unlikedIngredients.contains { unlikedIngredient in
                guard let ingredientName = unlikedIngredient.name else {
                    return false
                }
                
                return recipeIngredient.name.localizedCaseInsensitiveContains(ingredientName) ||
                ingredientName.localizedCaseInsensitiveContains(recipeIngredient.name)
            }
        }
        
        if hasAllergicIngredients {
            badges.append(
                BadgeModel(
                    title: "Allergic products",
                    type: .dangerous
                )
            )
        }
        
        if hasUnlikedIngredients {
            badges.append(
                BadgeModel(
                    title: "Unliked products",
                    type: .mixed
                )
            )
        }
        
        if recipeModel.vegan {
            badges.append(
                BadgeModel(
                    title: "Vegan",
                    type: .great
                )
            )
        }
        
        if recipeModel.vegetarian {
            badges.append(
                BadgeModel(
                    title: "Vegetarian",
                    type: .great
                )
            )
        }
        
        if recipeModel.glutenFree {
            badges.append(
                BadgeModel(
                    title: "No gluten",
                    type: .great
                )
            )
        }
        
        if recipeModel.dairyFree {
            badges.append(
                BadgeModel(
                    title: "No dairy",
                    type: .great
                )
            )
        }
        
        if recipeModel.cheap {
            badges.append(
                BadgeModel(
                    title: "Cheap",
                    type: .great
                )
            )
        }
        
        return badges
    }
    
    func loadAllergicIngredients(context: NSManagedObjectContext) {
        let request = Ingredient.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.id, ascending: true)]
        request.predicate = NSPredicate(format: "type = %@", IngredientType.allergic.rawValue)
        
        do {
            let data = try context.fetch(request)
            allergicIngredients = data
        } catch {
            allergicIngredients = []
        }
    }
    
    func loadUnlikedIngredients(context: NSManagedObjectContext) {
        let request = Ingredient.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.id, ascending: true)]
        request.predicate = NSPredicate(format: "type = %@", IngredientType.unliked.rawValue)
        
        do {
            let data = try context.fetch(request)
            unlikedIngredients = data
        } catch {
            unlikedIngredients = []
        }
    }
}
