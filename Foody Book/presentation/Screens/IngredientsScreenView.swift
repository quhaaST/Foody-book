//
//  IngredientsScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI
import CoreData

struct IngredientsScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var viewModel = IngredientsScreenViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                EditButton()
                    .buttonStyle(.bordered)
                
                Spacer()
                
                Button {
                    viewModel.showAddIngredientView = true
                } label: {
                    Label("Indredient", systemImage: "plus.circle")
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $viewModel.showAddIngredientView) {
                    NewIngredientModalView(
                        isPresented: $viewModel.showAddIngredientView,
                        selectedType: $viewModel.selectedType
                    )
                }
                .onChange(of: viewModel.showAddIngredientView) { value in
                    if !value {
                        viewModel.fetchIngredientsUpdates(context: managedObjContext)
                    }
                }
            }
            .padding(.vertical, 12)
            
            Picker("Ingredient type", selection: $viewModel.selectedType) {
                ForEach(IngredientType.allCases) { type in
                    Text(type.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            
            List {
                ForEach(viewModel.getFilteredItems()) { ingredient in
                    IngredientInformationView(ingredientName: ingredient.name ?? "")
                }.onDelete { offsets in
                    viewModel.deleteIngredient(offsets: offsets, context: managedObjContext)
                }
            }
            .listStyle(.plain)
            .padding(.horizontal, -16)
        }
        .onAppear {
            viewModel.fetchIngredientsUpdates(context: managedObjContext)
        }
        .padding(.horizontal, 16)
    }
}

struct IngredientsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsScreenView()
    }
}
