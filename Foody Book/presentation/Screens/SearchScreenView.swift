//
//  SearchScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct SearchScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @StateObject var viewModel = SearchScreenViewModel()
    
    @State private var availableIngredients: [Ingredient] = []
    @State private var searchText: String = ""
    @State private var selectedType: SearchType = .ingredients
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            SearchField(searchText: $searchText)
                .onChange(of: searchText) { _ in
                    if searchText.isEmpty || searchText.count >= 3 {
                        viewModel.loadDataUpdates(
                            context: managedObjContext,
                            searchType: selectedType,
                            query: searchText
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            
            Picker("Search type", selection: $selectedType) {
                ForEach(SearchType.allCases) { type in
                    Text("By \(type.rawValue)")
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedType) { _ in
                viewModel.loadDataUpdates(
                    context: managedObjContext,
                    searchType: selectedType,
                    query: searchText
                )
            }
            .padding(.horizontal, 16)
            
            if viewModel.foundRecipes.isEmpty {
                ProgressView()
                    .onAppear {
                        viewModel.loadDataUpdates(
                            context: managedObjContext,
                            searchType: selectedType,
                            query: searchText
                        )
                    }
                
                Spacer()
            } else {
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.foundRecipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailsScreenView(recipeId: recipe.id)) {
                                    MinifiedRecipeView(minifiedRecipeModel: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            viewModel.loadDataUpdates(
                context: managedObjContext,
                searchType: selectedType,
                query: searchText
            )
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
