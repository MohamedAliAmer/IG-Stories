//
//  InstagramStoryBubble.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import Foundation
import SwiftUI

struct InstagramStoryBubble: View {
    @ObservedObject var user: UserEntity
    let viewModel: StoryListViewModel
    
    @State private var showingStoryDetail = false
    
    private var hasUnseenStories: Bool {
        user.storiesArray.contains { !$0.isSeen }
    }
    
    var body: some View {
        Button(action: {
            showingStoryDetail = true
        }) {
            VStack(spacing: 6) {
                ZStack {
                    if hasUnseenStories {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.purple,
                                        Color.pink,
                                        Color.orange,
                                        Color.yellow
                                    ]),
                                    startPoint: .topTrailing,
                                    endPoint: .bottomLeading
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 70, height: 70)
                    } else {
                        // Gray border for seen stories
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 70, height: 70)
                    }
                    
                    // Profile picture
                    AsyncImage(url: URL(string: user.profilePictureURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28))
                            )
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                }
                
                // User name
                Text(user.name ?? "Unknown")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(width: 70)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingStoryDetail) {
            StoryDetailView(
                user: user,
                viewModel: viewModel,
                isPresented: $showingStoryDetail
            )
        }
    }
}
