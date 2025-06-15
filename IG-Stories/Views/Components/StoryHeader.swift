import SwiftUI

struct StoryHeader: View {
    let user: UserEntity
    let currentStory: StoryEntity
    let stories: [StoryEntity]
    let currentStoryIndex: Int
    let progressForStory: (Int) -> Double
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(0..<stories.count, id: \.self) { index in
                    ProgressBar(
                        progress: progressForStory(index),
                        isActive: index == currentStoryIndex
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // User info and close button
            HStack {
                AsyncImage(url: URL(string: user.profilePictureURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                Text(user.name ?? "Unknown")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(timeAgoString(from: currentStory.timestamp))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
                .background(Color.clear)
                .allowsHitTesting(true)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    private func timeAgoString(from date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let user = UserEntity(context: context)
    user.id = 1
    user.name = "Preview User"
    user.profilePictureURL = "https://i.pravatar.cc/150?u=1"
    
    let story = StoryEntity(context: context)
    story.timestamp = Date()
    
    return StoryHeader(
        user: user,
        currentStory: story,
        stories: [story, story, story],
        currentStoryIndex: 1,
        progressForStory: { index in
            if index == 0 { return 1.0 }
            if index == 1 { return 0.6 }
            return 0.0
        },
        onClose: { print("Close tapped") }
    )
    .background(Color.black)
}
