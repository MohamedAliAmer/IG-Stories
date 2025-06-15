//
//  StoryContent.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct StoryContent: View {
    let story: StoryEntity
    let dragOffset: CGSize
    let showLikeAnimation: Bool
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: story.contentURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Loading story...")
                                .foregroundColor(.white)
                                .font(.caption)
                                .padding(.top, 8)
                        }
                    )
            }
            .offset(dragOffset)
            .scaleEffect(showLikeAnimation ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: showLikeAnimation)
            .animation(.spring(response: 0.3), value: dragOffset)
            
            if showLikeAnimation {
                Image(systemName: "heart.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(showLikeAnimation ? 1.2 : 0.5)
                    .opacity(showLikeAnimation ? 1 : 0)
                    .animation(.spring(response: 0.3), value: showLikeAnimation)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let story = StoryEntity(context: context)
    story.contentURL = "https://picsum.photos/400/800"
    
    return StoryContent(
        story: story,
        dragOffset: .zero,
        showLikeAnimation: false
    )
    .background(Color.black)
}
