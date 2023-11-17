//
//  Foody_BookApp.swift
//  Foody Book
//
//  Created by Aleksandr Evdokimov on 17.11.2023.
//

import SwiftUI

@main
struct Foody_BookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
