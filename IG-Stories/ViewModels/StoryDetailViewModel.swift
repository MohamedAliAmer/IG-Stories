//
//  StoryDetailViewModel.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import Foundation
import SwiftUI

@MainActor
class StoryDetailViewModel: ObservableObject {
    @Published var currentStoryIndex = 0
    @Published var progress: Double = 0
    @Published var isPaused = false
    @Published var dragOffset: CGSize = .zero
    @Published var showLikeAnimation = false
    
    private var timer: Timer?
    
    let user: UserEntity
    let storyListViewModel: StoryListViewModel
    var onStoriesFinished: (() -> Void)?
    
    var stories: [StoryEntity] {
        user.storiesArray
    }
    
    var currentStory: StoryEntity? {
        guard currentStoryIndex < stories.count else { return nil }
        return stories[currentStoryIndex]
    }
    
    init(user: UserEntity, storyListViewModel: StoryListViewModel) {
        self.user = user
        self.storyListViewModel = storyListViewModel
    }
    
    func startStoryTimer() {
        guard let story = currentStory else { return }
        progress = 0
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                if !self.isPaused {
                    self.progress += 0.05 / story.duration
                    if self.progress >= 1.0 {
                        self.nextStory()
                    }
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func pauseTimer() {
        isPaused = true
    }
    
    func resumeTimer() {
        isPaused = false
    }
    
    func nextStory() {
        stopTimer()
        
        if currentStoryIndex < stories.count - 1 {
            currentStoryIndex += 1
            markCurrentStoryAsSeen()
            startStoryTimer()
        } else {
            markCurrentStoryAsSeen()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.onStoriesFinished?()
            }
        }
    }
    
    func previousStory() {
        stopTimer()
        
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            markCurrentStoryAsSeen()
            startStoryTimer()
        }
    }
    
    func toggleLike() {
        guard let story = currentStory else { return }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            storyListViewModel.toggleStoryLike(story: story)
        }
    }
    
    func markCurrentStoryAsSeen() {
        guard let story = currentStory else { return }
        
        storyListViewModel.markStoryAsSeen(story: story)
        
        let hasUnseen = user.storiesArray.contains { !$0.isSeen }
        if user.hasUnseenStories != hasUnseen {
            user.hasUnseenStories = hasUnseen
            user.objectWillChange.send()
        }
    }
    
    func progressForStory(at index: Int) -> Double {
        if index < currentStoryIndex {
            return 1.0
        } else if index == currentStoryIndex {
            return progress
        } else {
            return 0.0
        }
    }
    
    func triggerLikeAnimation() {
        showLikeAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.showLikeAnimation = false
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
