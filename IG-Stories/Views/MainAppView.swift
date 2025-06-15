//
//  MainAppView.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct MainAppView: View {
    @Environment(\.managedObjectContext) private var viewContext
    private let persistenceController = PersistenceController()

    var body: some View {
        NavigationView {
            StoryListView(context: viewContext, persistenceController: persistenceController)
                .navigationTitle("Instagram Stories")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    let persistenceController = PersistenceController.preview
    MainAppView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
}
