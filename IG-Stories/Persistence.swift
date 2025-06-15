//
//  Persistence.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import CoreData

struct PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for SwiftUI Previews
        let sampleUser1 = UserEntity(context: viewContext)
        sampleUser1.id = 1
        sampleUser1.name = "PreviewUser1"
        sampleUser1.profilePictureURL = "https://i.pravatar.cc/150?u=preview1"
        sampleUser1.hasUnseenStories = true

        for i in 0..<3 {
            let story = StoryEntity(context: viewContext)
            story.storyID = UUID()
            story.contentURL = "\(Constants.storyContentBaseURL)/preview1_story\(i)/400/800"
            story.timestamp = Date().addingTimeInterval(-Double(i*1000))
            story.isSeen = (i == 0)
            story.isLiked = (i == 1)
            story.order = Int16(i)
            story.duration = 5.0
            sampleUser1.addToStories(story)
        }
        
        let sampleUser2 = UserEntity(context: viewContext)
        sampleUser2.id = 2
        sampleUser2.name = "PreviewUser2"
        sampleUser2.profilePictureURL = "https://i.pravatar.cc/150?u=preview2"
        sampleUser2.hasUnseenStories = false // All stories seen for this user

        for i in 0..<2 {
            let story = StoryEntity(context: viewContext)
            story.storyID = UUID()
            story.contentURL = "\(Constants.storyContentBaseURL)/preview2_story\(i)/400/800"
            story.timestamp = Date().addingTimeInterval(-Double(i*1000))
            story.isSeen = true
            story.isLiked = false
            story.order = Int16(i)
            story.duration = 5.0
            sampleUser2.addToStories(story)
        }


        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "IG_Stories") // Ensure this matches your .xcdatamodel file name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
}
