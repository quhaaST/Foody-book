//
//  RemoteNetworkService.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

struct RemoteNetworkService {
    private static let baseUrl = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes"
    private static let headers = [
        "X-RapidAPI-Key": "YOUR_API_KEY",
        "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]
    
    private static let encodedComma = "%2C"
    
    func getSearchByIngredientsRequest(ingredients: [String]) -> NSURLRequest {
        let ingredientsString = ingredients.joined(separator: RemoteNetworkService.encodedComma)
        let requstUrl = URL(
            string: "\(RemoteNetworkService.baseUrl)/findByIngredients?" +
            "ingredients=\(ingredientsString)&number=15&ignorePantry=true&ranking=2"
        )
        
        let request = NSMutableURLRequest(
            url: requstUrl!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = RemoteNetworkService.headers
        
        return request
    }
    
    func getRecipeDetailsRequest(recipeId: Int) -> NSURLRequest {
        let requstUrl = URL(
            string: "\(RemoteNetworkService.baseUrl)/\(recipeId)/information"
        )
        
        let request = NSMutableURLRequest(
            url: requstUrl!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = RemoteNetworkService.headers
        
        return request
    }
    
    func getSearchRecipesRequest(query: String) -> NSURLRequest {
        let requstUrl = URL(
            string: "\(RemoteNetworkService.baseUrl)/complexSearch?query=\(query)&number=10&ranking=2"
        )
        
        let request = NSMutableURLRequest(
            url: requstUrl!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = RemoteNetworkService.headers
        
        return request
    }
}
