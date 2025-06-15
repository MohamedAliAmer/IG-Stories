//
//  StoryDetailView.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct StoryDetailView: View {
    let user: UserEntity
    let viewModel: StoryListViewModel
    @Binding var isPresented: Bool
    
    @StateObject private var storyViewModel: StoryDetailViewModel
    
    init(user: UserEntity, viewModel: StoryListViewModel, isPresented: Binding<Bool>) {
        self.user = user
        self.viewModel = viewModel
        self._isPresented = isPresented
        self._storyViewModel = StateObject(wrappedValue: StoryDetailViewModel(user: user, storyListViewModel: viewModel))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if storyViewModel.stories.isEmpty {
                // Fallback if no stories
                VStack {
                    Text("No stories available")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Button("Close") {
                        closeStoryView()
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            } else if let story = storyViewModel.currentStory {
                StoryContent(
                    story: story,
                    dragOffset: storyViewModel.dragOffset,
                    showLikeAnimation: storyViewModel.showLikeAnimation
                )
                
                VStack {
                    StoryHeader(
                        user: user,
                        currentStory: story,
                        stories: storyViewModel.stories,
                        currentStoryIndex: storyViewModel.currentStoryIndex,
                        progressForStory: storyViewModel.progressForStory,
                        onClose: closeStoryView
                    )
                    
                    Spacer()
                    
                    // Bottom controls
                    StoryLikeButton(
                        story: story,
                        onToggleLike: {
                            storyViewModel.toggleLike()
                        }
                    )
                }
                
                StoryNavigationAreas(
                    onPrevious: {
                        storyViewModel.previousStory()
                    },
                    onNext: {
                        storyViewModel.nextStory()
                    }
                )
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    storyViewModel.dragOffset = value.translation
                    storyViewModel.pauseTimer()
                }
                .onEnded { value in
                    if value.translation.height > 50 {
                        closeStoryView()
                    } else {
                        withAnimation(.easeOut(duration: 0.1)) {
                            storyViewModel.dragOffset = .zero
                        }
                        storyViewModel.resumeTimer()
                    }
                }
        )
        .onTapGesture(count: 2) {
            storyViewModel.toggleLike()
            storyViewModel.triggerLikeAnimation()
        }
        .onAppear {
            storyViewModel.onStoriesFinished = {
                closeStoryView()
            }
            storyViewModel.startStoryTimer()
            storyViewModel.markCurrentStoryAsSeen()
        }
        .onDisappear {
            storyViewModel.stopTimer()
        }
    }
    
    private func closeStoryView() {
        storyViewModel.stopTimer()
        withAnimation(.easeInOut(duration: 0.2)) {
            isPresented = false
        }
    }
}

#Preview {
    let persistenceController = PersistenceController.preview
    let context = persistenceController.container.viewContext
    let viewModel = StoryListViewModel(context: context, persistenceController: persistenceController)
    
    let user = UserEntity(context: context)
    user.id = 1
    user.name = "Preview User"
    user.profilePictureURL = "https://i.pravatar.cc/150?u=1"
    user.hasUnseenStories = true
    
    return StoryDetailView(
        user: user,
        viewModel: viewModel,
        isPresented: .constant(true)
    )
}
