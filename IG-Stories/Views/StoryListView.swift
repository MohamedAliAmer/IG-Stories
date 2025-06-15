//
//  StoryListView.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI
import CoreData

struct StoryListView: View {
    @StateObject private var viewModel: StoryListViewModel
    
    init(context: NSManagedObjectContext, persistenceController: PersistenceController) {
        self._viewModel = StateObject(wrappedValue: StoryListViewModel(context: context, persistenceController: persistenceController))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Stories")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading)
                Spacer()
            }
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 100)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(viewModel.users, id: \.id) { user in
                            StoryBubbleView(user: user, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
            }
            
            Spacer()
        }
    }
}

// Instagram-style story bubble with gradient borders
struct StoryBubbleView: View {
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

#Preview {
    let persistenceController = PersistenceController.preview
    StoryListView(context: persistenceController.container.viewContext, persistenceController: persistenceController)
}
