//
//  MinifiedRecipeModel.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

struct MinifiedRecipeModel: Hashable, Codable {
    let id: Int
    let title: String
    let image: String
    let missedIngredientCount: Int?
}

struct MinifiedRecipeSeacrhModel: Hashable, Codable {
    let results: [MinifiedRecipeModel]
}
