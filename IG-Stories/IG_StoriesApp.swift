//
//  IG_StoriesApp.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

@main
struct IG_StoriesApp: App {
    let persistenceController = PersistenceController()

    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
