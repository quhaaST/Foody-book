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
        sortDescriptors: [NSSortDescriptor(keyPath: \AvailableIngredient.name, ascending: true)],
        animation: .default)
    private var availableIngredients: FetchedResults<AvailableIngredient>
    
    @State private var showAddIngredientView = false
    
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
                    AvailableIngredientModalView(isPresented: $showAddIngredientView)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            
            List {
                ForEach(availableIngredients) { ingredient in
                    IngredientInformationView(ingredientName: ingredient.name ?? "")
                }.onDelete(perform: deleteIngredient)
            }
            .listStyle(.plain)
        }
        .padding(.horizontal, 16)
    }
    
    private func deleteIngredient(offsets: IndexSet) {
        withAnimation {
            offsets.map { availableIngredients[$0] }.forEach(managedObjContext.delete)
            
            LocalDataController().saveData(context: managedObjContext)
        }
    }
}

struct IngredientsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsScreenView()
    }
}
