//
//  ContentView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    
    var body: some View {
        TabView {
            SearchScreenView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            IngredientsScreenView()
                .tabItem {
                    Image(systemName: "takeoutbag.and.cup.and.straw")
                    Text("Ingredients")
                }
            
            FavouritesScreenView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favourites")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
