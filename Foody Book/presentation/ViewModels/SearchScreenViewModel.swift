//
//  SearchScreenViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation
import CoreData

class SearchScreenViewModel: ObservableObject {
    @Published var foundRecipes: [MinifiedRecipeModel] = []
    private var searchType: SearchType = .ingredients
    private var availableIngredients: [Ingredient] = []
    
    func loadDataUpdates(
        context: NSManagedObjectContext,
        searchType: SearchType,
        query: String
    ) {
        fetchAvailableProducts(context: context)
        
        if searchType == .ingredients {
            fetchRecipesByIngredients(
                availableIngredients.map { ingredient in
                    ingredient.name ?? ""
                },
                query: query
            )
        } else {
            fetchRecipesByName(query)
        }
    }
    
    func fetchRecipesByIngredients(_ ingredients: [String], query: String = "") {
        let request = RemoteNetworkService()
            .getSearchByIngredientsRequest(ingredients: ingredients)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([MinifiedRecipeModel].self, from: data)
                
                DispatchQueue.main.async {
                    self.foundRecipes = recipes.filter { recipe in
                        recipe.title.hasPrefix(query)
                    }
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func fetchRecipesByName(_ query: String) {
        let request = RemoteNetworkService()
            .getSearchRecipesRequest(query: query)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode(MinifiedRecipeSeacrhModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.foundRecipes = recipes.results
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    func fetchAvailableProducts(context: NSManagedObjectContext) {
        let request = Ingredient.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.id, ascending: true)]
        request.predicate = NSPredicate(format: "type == %@", IngredientType.available.rawValue)
        
        do {
            let data = try context.fetch(request)
            availableIngredients = data
        } catch {
            availableIngredients = []
        }
    }
}
