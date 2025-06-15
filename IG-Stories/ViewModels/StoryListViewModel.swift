//
//  StoryListViewModel.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
class StoryListViewModel: ObservableObject {
    @Published var users: [UserEntity] = []
    @Published var isLoading = false
    
    let context: NSManagedObjectContext
    let persistenceController: PersistenceController
    private let dataService: DataService
    
    init(context: NSManagedObjectContext, persistenceController: PersistenceController) {
        self.context = context
        self.persistenceController = persistenceController
        self.dataService = DataService(context: context)
        loadUsers()
    }
    
    func loadUsers() {
        isLoading = true
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \UserEntity.id, ascending: true)]
        
        do {
            users = try context.fetch(fetchRequest)
            isLoading = false
        } catch {
            isLoading = false
        }
    }

    func markAllStoriesAsSeen(for user: UserEntity) {
        for story in user.storiesArray {
            if !story.isSeen {
                story.isSeen = true
            }
        }
        
        dataService.updateUserHasUnseenStories(user: user, context: context, persistenceController: persistenceController)
    }
    
    func toggleStoryLike(story: StoryEntity) {
        story.isLiked.toggle()
        
        let storyObjectID = story.objectID
        let isLiked = story.isLiked
        
        Task.detached(priority: .utility) {
            let backgroundContext = self.persistenceController.container.newBackgroundContext()
            backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            do {
                if let backgroundStory = try backgroundContext.existingObject(with: storyObjectID) as? StoryEntity {
                    backgroundStory.isLiked = isLiked
                    try backgroundContext.save()
                }
            } catch {
                await MainActor.run {
                    story.isLiked.toggle()
                }
            }
        }
    }
    
    func markStoryAsSeen(story: StoryEntity) {
        guard !story.isSeen else { return }
        
        story.isSeen = true
        
        let storyObjectID = story.objectID
        let userObjectID = story.user?.objectID
        
        Task.detached(priority: .utility) {
            let backgroundContext = self.persistenceController.container.newBackgroundContext()
            backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            do {
                if let backgroundStory = try backgroundContext.existingObject(with: storyObjectID) as? StoryEntity {
                    backgroundStory.isSeen = true
                    
                    if let userOID = userObjectID,
                       let backgroundUser = try backgroundContext.existingObject(with: userOID) as? UserEntity {
                        let userStories = backgroundUser.storiesArray
                        let hasUnseenStories = userStories.contains { !$0.isSeen }
                        backgroundUser.hasUnseenStories = hasUnseenStories
                    }
                    
                    try backgroundContext.save()
                    
                    // Update main thread UI
                    await MainActor.run {
                        if let user = story.user {
                            let hasUnseen = user.storiesArray.contains { !$0.isSeen }
                            if user.hasUnseenStories != hasUnseen {
                                user.hasUnseenStories = hasUnseen
                                user.objectWillChange.send()
                            }
                        }
                    }
                }
            } catch {
                print("Error marking story as seen in background: \(error)")
            }
        }
    }
}
