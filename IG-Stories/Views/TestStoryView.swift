//
//  TestStoryView.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct TestStoryView: View {
    @State private var showingStory = false
    
    var body: some View {
        VStack {
            Text("Test Story Navigation")
                .font(.title)
                .padding()
            
            Button("Open Test Story") {
                showingStory = true
            }
            .font(.title2)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showingStory) {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    Text("TEST STORY VIEW")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                    
                    Text("This is a test story")
                        .foregroundColor(.white)
                        .padding()
                    
                    Button("Close") {
                        showingStory = false
                    }
                    .foregroundColor(.blue)
                    .font(.title2)
                    .padding()
                }
            }
        }
    }
}

#Preview {
    TestStoryView()
}
