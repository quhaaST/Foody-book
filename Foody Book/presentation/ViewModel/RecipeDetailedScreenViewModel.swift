//
//  RecipeDetailedScreenViewModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

class RecipeDetailedScreenViewModel: ObservableObject {
    @Published var recipeData: RecipeDetailedInformationModel?
    
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
}
