//
//  StoryLikeButton.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct StoryLikeButton: View {
    let story: StoryEntity
    let onToggleLike: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    onToggleLike()
                } label: {
                    Image(systemName: story.isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(story.isLiked ? .red : .white)
                        .scaleEffect(story.isLiked ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3), value: story.isLiked)
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .background(Color.clear)
                .allowsHitTesting(true)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let story = StoryEntity(context: context)
    story.isLiked = false
    
    return StoryLikeButton(
        story: story,
        onToggleLike: { print("Like toggled") }
    )
    .background(Color.black)
}
