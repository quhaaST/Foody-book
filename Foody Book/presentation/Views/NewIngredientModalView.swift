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
    @Binding var selectedType: IngredientType
    
    @StateObject var viewModel = NewIngredientModelViewModel()
    
    var body: some View {
        Form {
            Section("New ingredient") {
                TextField("Ingredient name", text: $viewModel.name)
                    .alert("Empty field", isPresented: $viewModel.alertIsDisplayed) {
                        Button("Close") {
                            viewModel.alertIsDisplayed = false
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
                        if viewModel.name.isEmpty {
                            viewModel.alertIsDisplayed = true
                        } else {
                            viewModel.addIngredient(context: managedObjContext, selectedType: selectedType)
                            isPresented = false
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct NewIngredientModalView_Previews: PreviewProvider {
    static var previews: some View {
        NewIngredientModalView(
            isPresented: .constant(true),
            selectedType: .constant(.available)
        )
    }
}
