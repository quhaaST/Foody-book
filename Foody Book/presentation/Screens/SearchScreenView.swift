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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 12) {
                SearchField(searchText: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) { _ in
                        if viewModel.searchText.isEmpty || viewModel.searchText.count >= 3 {
                            viewModel.loadDataUpdates(
                                context: managedObjContext,
                                searchType: viewModel.searchType,
                                query: viewModel.searchText
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                Picker("Search type", selection: $viewModel.searchType) {
                    ForEach(SearchType.allCases) { type in
                        Text("By \(type.rawValue)")
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: viewModel.searchType) { _ in
                    viewModel.loadDataUpdates(
                        context: managedObjContext,
                        searchType: viewModel.searchType,
                        query: viewModel.searchText
                    )
                }
                .padding(.horizontal, 16)
                
                if viewModel.foundRecipes.isEmpty {
                    ProgressView()
                    
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.foundRecipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailsScreenView(recipeId: recipe.id)) {
                                    MinifiedRecipeView(
                                        minifiedRecipeModel: recipe,
                                        onRecipeLiked: {
                                            viewModel.onRecipeLiked(context: managedObjContext, recipe: recipe)
                                        },
                                        onRecipeDisliked: {
                                            viewModel.onRecipeDisliked(context: managedObjContext, recipeId: recipe.id)
                                        },
                                        isInFavourites: $viewModel.favouriteRecipes.contains { favoriteRecipe in
                                            favoriteRecipe.id == recipe.id
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.loadDataUpdates(
                context: managedObjContext,
                searchType: viewModel.searchType,
                query: viewModel.searchText
            )
        }
    }
}

struct SearchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreenView()
    }
}
