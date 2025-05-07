import SwiftUI

// MARK: - Main Message View
struct MessageView: View {
    @ObservedObject var viewModel: MessageViewModel
    @State private var navigateToChatDetail: MessagePreview?
    @State private var showFollowers: Bool = false
    @State private var showCommentsMentions: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with absolutely positioned elements using GeometryReader
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    // Title positioned exactly in the center
                    Text("Message")
                        .font(.system(size: 20, weight: .semibold))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    // Plus button positioned at trailing edge
                    Button(action: {
                        // Action for new message
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    .position(x: geometry.size.width - 30, y: geometry.size.height / 2)
                }
            }
            .frame(height: 44)
            .padding(.vertical, 4)
            
            // Categories
            HStack(spacing: 0) {
                Spacer()
                
                // New Followers button
                Button(action: {
                    showFollowers = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(UIColor.systemBlue).opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "link")
                                .font(.system(size: 20))
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                        Text("New Followers")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Comments & Mentions button
                Button(action: {
                    showCommentsMentions = true
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "bubble.right")
                                .font(.system(size: 20))
                                .foregroundColor(.green)
                        }
                        Text("Comments & @")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(.vertical, 16)
            
            Divider()
            
            // Message List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.conversations) { message in
                        Button(action: {
                            navigateToChatDetail = message
                        }) {
                            MessageRowView(message: message)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if message.id != viewModel.conversations.last?.id {
                            Divider()
                                .padding(.leading, 70)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        // Navigation links in the background
        .background(
            Group {
                // Chat detail navigation
                NavigationLink(
                    destination: navigateToChatDetail.map { conversation in
                        ChatDetailView(viewModel: viewModel, conversation: conversation)
                    },
                    isActive: Binding(
                        get: { navigateToChatDetail != nil },
                        set: { if !$0 { navigateToChatDetail = nil } }
                    )
                ) {
                    EmptyView()
                }
                
                // Followers navigation
                NavigationLink(
                    destination: FollowersView(),
                    isActive: $showFollowers
                ) {
                    EmptyView()
                }
                
                // Comments & Mentions navigation
                NavigationLink(
                    destination: CommentsMentionsView(),
                    isActive: $showCommentsMentions
                ) {
                    EmptyView()
                }
            }
        )
    }
}

// MARK: - Message Row Component
struct MessageRowView: View {
    let message: MessagePreview
    
    var body: some View {
        HStack(spacing: 12) {
            Image(message.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .background(Circle().fill(Color.gray.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.username)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text(message.lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(message.time)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                if message.isRead {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                } else if message.unreadCount > 0 {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 18, height: 18)
                        
                        Text("\(message.unreadCount)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

// MARK: - Preview
struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock viewModel for preview
        let previewViewModel = MessageViewModel()
        
        // Return the view wrapped in a NavigationView for proper preview
        NavigationView {
            MessageView(viewModel: previewViewModel)
                .previewLayout(.device)
                .previewDisplayName("Message View")
        }
    }
}
