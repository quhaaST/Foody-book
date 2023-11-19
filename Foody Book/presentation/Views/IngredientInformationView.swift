//
//  IngredientInformationView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct IngredientInformationView: View {
    let ingredientName: String
    let onCrossClick: () -> Void = {}
    
    var body: some View {
        HStack {
            Text(ingredientName)
                .font(.system(size: 16, weight: .medium, design: .default))
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

struct IngredientInformationView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientInformationView(
            ingredientName: "Sample product"
        )
    }
}
