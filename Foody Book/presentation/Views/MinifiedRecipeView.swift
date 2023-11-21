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
    let onRecipeLiked: () -> Void
    let onRecipeDisliked: () -> Void
    @State var isInFavourites: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .center) {
                VStack {
                    HStack(alignment: .center) {
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
                            isInFavourites.toggle()
                            
                            if isInFavourites {
                                onRecipeLiked()
                            } else {
                                onRecipeDisliked()
                            }
                        } label: {
                            if isInFavourites {
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
                    
                    if let missedIngredientsCount = minifiedRecipeModel.missedIngredientCount {
                        HStack(alignment: .bottom) {
                            Spacer()
                            
                            Text("Missing \(missedIngredientsCount) ingredients")
                                .font(.system(size: 10, weight: .regular, design: .default))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .background(Color.init(uiColor: .lightText))
                                .cornerRadius(12, corners: [.topLeft])
                        }
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
                missedIngredientCount: 10
            ),
            onRecipeLiked: {},
            onRecipeDisliked: {},
            isInFavourites: true
        )
    }
}
