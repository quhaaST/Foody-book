//
//  BadgeType.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 20.11.2023.
//

import Foundation

struct BadgeModel {
    let title: String
    let type: BadgeType
}

enum BadgeType: String {
    case great, mixed, dangerous
}
