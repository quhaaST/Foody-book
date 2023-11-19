//
//  RecipeDetailedInformationModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

struct RecipeDetailedInformationModel: Hashable, Codable {
    let id: Int
    let title: String
    let image: String
    let readyInMinutes: Int
    let servings: Int
    let sourceUrl: String
    let summary: String
    let extendedIngredients: [ExtendedIngredientModel]
}

struct ExtendedIngredientModel: Hashable, Codable {
    let id: Int
    let original: String
}
