//
//  RecipeDetailsScreenView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

struct RecipeDetailsScreenView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    let recipeId: Int
    
    @StateObject var viewModel = RecipeDetailedScreenViewModel()
    
    var body: some View {
        if let recipeDetails = viewModel.recipeData {
            ScrollView(showsIndicators: false) {
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
                    
                    let badges = viewModel.mapBadges(recipeModel: recipeDetails)
                    if !badges.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(alignment: .center, spacing: 12) {
                                ForEach(badges, id: \.title.hashValue) { badge in
                                    badgeView(badge: badge)
                                }
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    
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
                            .foregroundColor(.primary)
                            .underline()
                    }
                    .padding(.horizontal, 8)
                    
                    DisclosureGroup {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            let enumeratedIngredients = Array(recipeDetails.extendedIngredients.enumerated())
                            ForEach(enumeratedIngredients, id: \.element) { _, value in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 8, height: 8)
                                    
                                    Text(value.original.capitalized)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    } label: {
                        Text("Ingredients")
                            .font(.system(size: 20, weight: .semibold, design: .default))
                            .foregroundColor(.primary)
                            .underline()
                    }
                    .padding(.horizontal, 8)
                    
                    Spacer()
                }
            }
            .onAppear {
                viewModel.loadDataUpdates(context: managedObjContext, recipeId: recipeId)
            }
            .padding(.horizontal, 16)
        } else {
            ProgressView()
                .onAppear {
                    viewModel.loadDataUpdates(context: managedObjContext, recipeId: recipeId)
                }
        }
    }
    
    private func badgeView(badge: BadgeModel) -> AnyView {
        var backgroundColor = Color.green
        
        switch badge.type {
        case .dangerous:
            backgroundColor = Color.red
        case .mixed:
            backgroundColor = Color.yellow
        default:
            break
        }
        
        return AnyView(
            Text(badge.title)
                .font(.system(size: 12, weight: .regular, design: .default))
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .foregroundColor(.secondary)
                .cornerRadius(8)
        )
    }
}

struct RecipeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailsScreenView(
            recipeId: 2
        )
    }
}
