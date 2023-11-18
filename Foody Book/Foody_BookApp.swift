//
//  Foody_BookApp.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

@main
struct FoodyBookApp: App {
    @StateObject private var localDataController = LocalDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, localDataController.container.viewContext)
        }
    }
}
