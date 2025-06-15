//
//  DataService.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import Foundation
import CoreData

class DataService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func updateUserHasUnseenStories(
        user: UserEntity,
        context: NSManagedObjectContext, persistenceController: PersistenceController
    ) {
        let userObjectID = user.objectID
        
        Task.detached(priority: .utility) {
            let backgroundContext = persistenceController.container.newBackgroundContext()
            backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            do {
                if let backgroundUser = try backgroundContext.existingObject(with: userObjectID) as? UserEntity {
                    let unseenStories = backgroundUser.storiesArray.filter { !$0.isSeen }
                    let hasUnseen = !unseenStories.isEmpty
                    
                    if backgroundUser.hasUnseenStories != hasUnseen {
                        backgroundUser.hasUnseenStories = hasUnseen
                        try backgroundContext.save()
                        
                        // Update main thread UI
                        await MainActor.run {
                            user.hasUnseenStories = hasUnseen
                            user.objectWillChange.send()
                        }
                    }
                }
            } catch { }
        }
    }
}

extension UserEntity {
    public var storiesArray: [StoryEntity] {
        let set = stories as? Set<StoryEntity> ?? []
        return set.sorted { $0.order < $1.order }
    }
}

extension StoryEntity {
    var userName: String {
        user?.name ?? "Unknown User"
    }
    var userProfilePicURL: String? {
        user?.profilePictureURL
    }
}
