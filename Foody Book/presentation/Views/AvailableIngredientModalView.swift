//
//  AvailableIngredientModalView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 18.11.2023.
//

import SwiftUI

struct AvailableIngredientModalView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Binding var isPresented: Bool
        
    @State private var name = ""
    @State private var alertIsDisplayed = false
    
    var body: some View {
        Form {
            Section("New available ingredient") {
                TextField("Ingredient name", text: $name)
                    .alert("Empty field", isPresented: $alertIsDisplayed) {
                        Button("Close") {
                            alertIsDisplayed = false
                        }
                    } message: {
                        Text("The ingredient name should be non-empty.")
                    }
                    
                HStack {
                    Spacer()
                    
                    Button("Create") {
                        if name.isEmpty {
                            alertIsDisplayed = true
                        } else {
                            addAvailableIngredient()
                            isPresented = false
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private func addAvailableIngredient() {
        LocalDataController()
            .addAvailableIngredient(context: managedObjContext, name: name)
    }
}

struct AvailableIngredientModalView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableIngredientModalView(isPresented: .constant(true))
    }
}
