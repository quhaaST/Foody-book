//
//  SearchScreenViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

class SearchScreenViewModel: ObservableObject {
    @Published var minifiedRecipes: [MinifiedRecipeModel] = []
    
    func fetchRecipesByIngredients(_ ingredients: [String]) {
        let request = RemoteNetworkService()
            .getSearchByIngredientsRequest(ingredients: ingredients)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode([MinifiedRecipeModel].self, from: data)
                
                DispatchQueue.main.async {
                    self.minifiedRecipes = recipes
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
