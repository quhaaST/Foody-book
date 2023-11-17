//
//  ContentView.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
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
            
            ProfileScreenView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Preferences")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
