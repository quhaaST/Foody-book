//
//  IngredientTypes.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import Foundation

enum IngredientType: String, CaseIterable, Identifiable {
    case available, unliked, allergic
    var id: Self { self }
}
