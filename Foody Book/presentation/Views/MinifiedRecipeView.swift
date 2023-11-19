//
//  MinifiedRecipeView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 19.11.2023.
//

import SwiftUI

struct MinifiedRecipeView: View {
    let minifiedRecipeModel: MinifiedRecipeModel
    let onLiked: (Int) -> Void
    let onDisliked: (Int) -> Void
    @State var isInFavorites: Bool
    
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
                                onLiked(minifiedRecipeModel.id)
                            } else {
                                onDisliked(minifiedRecipeModel.id)
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
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct MinifiedRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        MinifiedRecipeView(
            minifiedRecipeModel: MinifiedRecipeModel(
                id: 1,
                title: "Title",
                image: "https://spoonacular.com/recipeImages/615374-312x231.jpg",
                usedIngredientCount: 10,
                missedIngredientCount: 10,
                likes: 0
            ),
            onLiked: { _ in },
            onDisliked: { _ in },
            isInFavorites: false
        )
    }
}
