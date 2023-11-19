//
//  NewIngredientModalView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 18.11.2023.
//

import SwiftUI

struct NewIngredientModalView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Binding var isPresented: Bool
    
    @State private var name = ""
    @State private var alertIsDisplayed = false
    @State var selectedType: IngredientType
    
    var body: some View {
        Form {
            Section("New ingredient") {
                TextField("Ingredient name", text: $name)
                    .alert("Empty field", isPresented: $alertIsDisplayed) {
                        Button("Close") {
                            alertIsDisplayed = false
                        }
                    } message: {
                        Text("The ingredient name should be non-empty.")
                    }
                
                HStack {
                    Text("Ingredient type")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(Color.init(uiColor: .lightGray))
                    
                    Spacer()
                    
                    Picker("Ingredient type", selection: $selectedType) {
                        ForEach(IngredientType.allCases) { type in
                            Text(type.rawValue.capitalized)
                                .tag(type.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                HStack {
                    Spacer()
                    
                    Button("Create") {
                        if name.isEmpty {
                            alertIsDisplayed = true
                        } else {
                            addIngredient()
                            isPresented = false
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private func addIngredient() {
        LocalDataController
            .shared
            .addIngredient(
                context: managedObjContext,
                name: name,
                type: selectedType
            )
    }
}

struct NewIngredientModalView_Previews: PreviewProvider {
    static var previews: some View {
        NewIngredientModalView(
            isPresented: .constant(true),
            selectedType: .available
        )
    }
}
