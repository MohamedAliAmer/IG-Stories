//
//  UserStoryBubbleView.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct UserStoryBubbleView: View {
    let user: UserEntity
    let size: CGFloat
    let onTap: () -> Void
    
    init(user: UserEntity, size: CGFloat = 70, onTap: @escaping () -> Void) {
        self.user = user
        self.size = size
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Button(action: onTap) {
                ZStack {
                    // Gradient border for unseen stories
                    if user.hasUnseenStories {
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
                            .frame(width: size, height: size)
                    } else {
                        // Gray border for seen stories
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: size, height: size)
                    }
                    
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
                                    .font(.system(size: size * 0.4))
                            )
                    }
                    .frame(width: size - 6, height: size - 6)
                    .clipShape(Circle())
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // User name
            Text(user.name ?? "Unknown")
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(width: size)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let user = UserEntity(context: context)
    user.id = 1
    user.name = "Preview User"
    user.profilePictureURL = "https://i.pravatar.cc/150?u=1"
    user.hasUnseenStories = true
    
    return UserStoryBubbleView(user: user) {
        print("Tapped user story")
    }
    .padding()
}
