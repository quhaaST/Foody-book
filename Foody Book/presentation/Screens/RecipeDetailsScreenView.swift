//
//  RecipeDetailsScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct RecipeDetailsScreenView: View {
    let recipeId: Int
    @StateObject var viewModel = RecipeDetailedScreenViewModel()
    
    var body: some View {
        if let recipeDetails = viewModel.recipeData {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AsyncImage(url: URL(string: recipeDetails.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 240)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 240)
                    }
                    .cornerRadius(16)
                    
                    Text(recipeDetails.title.capitalized)
                        .font(.system(size: 24, weight: .thin, design: .default))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .multilineTextAlignment(.leading)
                    
                    if let url = URL(string: recipeDetails.sourceUrl) {
                        HStack(alignment: .center, spacing: 8) {
                            Text("Link:")
                                .font(.system(size: 18, weight: .regular, design: .default))
                            
                            Link(destination: url) {
                                Text(recipeDetails.sourceUrl)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 8)
                    }
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text("Servings:")
                            .font(.system(size: 18, weight: .regular, design: .default))
                        
                        Text("\(recipeDetails.servings)")
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    
                    Text("Ready in \(recipeDetails.readyInMinutes) minutes")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .padding(.horizontal, 8)
                    
                    DisclosureGroup {
                        Text(recipeDetails.summary.html2String)
                            .padding(.vertical, 8)
                    } label: {
                        Text("Description")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .foregroundColor(Color.black)
                            .underline()
                    }
                    .padding(.horizontal, 8)
                    
                    DisclosureGroup {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            // Workaround for the stuff, as with default ForEach the space after first item is appearing
                            ForEach(1...recipeDetails.extendedIngredients.count - 1, id: \.self) { index in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 8, height: 8)
                                    
                                    Text(recipeDetails.extendedIngredients[index].original.capitalized)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    } label: {
                        Text("Ingredients")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .foregroundColor(Color.black)
                            .underline()
                    }
                    .padding(.horizontal, 8)
                    
                    Spacer()
                }
                .padding(.vertical, 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 0)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.fetchRecipeDetailedInformation(recipeId: recipeId)
                }
        }
    }
}

struct RecipeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsScreenView(
            recipeId: 2
        )
    }
}
