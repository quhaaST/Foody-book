//
//  SearchType.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 20.11.2023.
//

import Foundation

enum SearchType: String, CaseIterable, Identifiable {
case ingredients, name
    var id: Self { self }
}
