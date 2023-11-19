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
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)],
        animation: .default)
    private var ingredients: FetchedResults<Ingredient>
    
    @State private var showAddIngredientView = false
    @State private var selectedType: IngredientType = .available
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                EditButton()
                    .buttonStyle(.bordered)
                
                Spacer()
                
                Button {
                    showAddIngredientView = true
                } label: {
                    Label("Indredient", systemImage: "plus.circle")
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showAddIngredientView) {
                    NewIngredientModalView(
                        isPresented: $showAddIngredientView,
                        selectedType: selectedType
                    )
                }
            }
            .padding(.vertical, 12)
            
            Picker("Ingredient type", selection: $selectedType) {
                ForEach(IngredientType.allCases) { type in
                    Text(type.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            
            List {
                ForEach(getFilteredItems()) { ingredient in
                    IngredientInformationView(ingredientName: ingredient.name ?? "")
                }.onDelete(perform: deleteIngredient)
            }
            .listStyle(.plain)
            .padding(.horizontal, -16)
        }
        .padding(.horizontal, 16)
    }
    
    private func deleteIngredient(offsets: IndexSet) {
        withAnimation {
            offsets.map { getFilteredItems()[$0] }.forEach(managedObjContext.delete)
            LocalDataController().saveData(context: managedObjContext)
        }
    }
    
    private func getFilteredItems() -> [Ingredient] {
        return self.ingredients.filter { ingredient in
            ingredient.type == selectedType.rawValue
        }
    }
}

struct IngredientsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsScreenView()
    }
}
