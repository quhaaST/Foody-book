//
//  MinifiedRecipeView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import SwiftUI
import CoreData

struct MinifiedRecipeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    let minifiedRecipeModel: MinifiedRecipeModel
    
    @State private var isInFavorites = false
    @State private var favouriteRecipes: [MinifiedFavouriteRecipe] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .center) {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: minifiedRecipeModel.image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        Spacer()
                        
                        Button {
                            isInFavorites.toggle()
                            
                            if isInFavorites {
                                onRecipeLiked(recipe: minifiedRecipeModel)
                            } else {
                                onRecipeDisliked(recipeId: minifiedRecipeModel.id)
                            }
                        } label: {
                            if isInFavorites {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .padding(.all, 8)
                                    .background(Color.init(uiColor: .lightText))
                                    .foregroundColor(Color.red)
                                    .cornerRadius(24)
                            } else {
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .padding(.all, 8)
                                    .background(Color.init(uiColor: .lightText))
                                    .cornerRadius(24)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    
                    Spacer()
                    
                    HStack(alignment: .bottom) {
                        Spacer()
                        
                        Text("Missing \(minifiedRecipeModel.missedIngredientCount) ingredients")
                            .font(.system(size: 10, weight: .regular, design: .default))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.init(uiColor: .lightText))
                            .cornerRadius(12, corners: [.topLeft])
                    }
                }
            }
            .frame(height: 180)
            
            Text(minifiedRecipeModel.title.capitalized)
                .font(.system(size: 24, weight: .thin, design: .default))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .onAppear {
            loadFavouritesStatus()
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private func onRecipeLiked(recipe: MinifiedRecipeModel) {
        LocalDataController()
            .addFavouriteRecipe(
                context: managedObjContext,
                recipeModel: recipe
            )
    }
    
    private func onRecipeDisliked(recipeId: Int) {
        favouriteRecipes
            .filter { recipe in
                recipe.id == Int32(recipeId)
            }
            .forEach { recipe in
                managedObjContext.delete(recipe)
            }
        
        LocalDataController().saveData(context: managedObjContext)
    }
    
    private func loadFavouritesStatus() {
        let request = MinifiedFavouriteRecipe.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MinifiedFavouriteRecipe.title, ascending: true)]
        request.predicate = NSPredicate(format: "id = %@", String(minifiedRecipeModel.id))
        
        do {
            let data = try managedObjContext.fetch(request)
            favouriteRecipes = data
            isInFavorites = !data.isEmpty
        } catch {
            favouriteRecipes = []
            isInFavorites = false
        }
    }
}

struct MinifiedRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MinifiedRecipeView(
            minifiedRecipeModel: MinifiedRecipeModel(
                id: 1,
                title: "Title",
                image: "https://spoonacular.com/recipeImages/615374-312x231.jpg",
                missedIngredientCount: 10
            )
        )
    }
}
