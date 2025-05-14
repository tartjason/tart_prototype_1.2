import SwiftUI

struct CommentsMentionsView: View {
    @ObservedObject var viewModel: MessageViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                .padding(.leading, 16)
                
                Text("Comments & Mentions")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading, 8)
                
                Spacer()
            }
            .padding(.vertical, 12)
            
            // Comments list
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.comments) { comment in
                        CommentRow(comment: comment)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarHidden(true)
    }
}

struct CommentRow: View {
    let comment: CommentItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // User info and optional artwork
            HStack(alignment: .center) {
                // User avatar and info
                HStack(spacing: 12) {
                    // Avatar
                    Image(comment.avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .background(Circle().fill(Color.gray.opacity(0.1)))
                    
                    // User info
                    VStack(alignment: .leading, spacing: 2) {
                        Text(comment.username)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text("comments on \(comment.workTitle) \(comment.timeText)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // Artwork thumbnail if available
                if let artworkImage = comment.artworkImage {
                    Image(artworkImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            
            // Comment text
            Text(comment.commentText)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .padding(.leading, 52) // Aligns with the start of the username
            
            // Reply button
            Button(action: {
                // Reply action
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text("Reply")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 52)
            .padding(.top, 2)
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CommentsMentionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommentsMentionsView(viewModel: MessageViewModel())
        }
    }
}
