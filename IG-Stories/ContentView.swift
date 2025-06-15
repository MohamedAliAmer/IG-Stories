//
//  ContentView.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                Text("Instagram Stories Clone")
                    .font(.title)
                    .padding()
                
                Text("This is a placeholder view.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .navigationTitle("Stories App")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
