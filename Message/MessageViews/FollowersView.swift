import SwiftUI

struct FollowersView: View {
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
                
                Text("Followers")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading, 8)
                
                Spacer()
            }
            .padding(.vertical, 12)
            
            // Followers list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.followers) { follower in
                        FollowerRow(follower: follower)
                        
                        Divider()
                            .padding(.leading, 70)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct FollowerRow: View {
    let follower: Follower
    @State private var isFollowing: Bool
    
    init(follower: Follower) {
        self.follower = follower
        self._isFollowing = State(initialValue: follower.isFollowing)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(follower.avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .background(Circle().fill(Color.gray.opacity(0.1)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(follower.username)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Text("starts following you \(follower.timeText)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: {
                isFollowing.toggle()
            }) {
                Text(isFollowing ? "Following" : "Follow")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isFollowing ? .gray : .black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(isFollowing ? Color.gray.opacity(0.1) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isFollowing ? Color.gray.opacity(0.3) : Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .cornerRadius(16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

struct Follower: Identifiable {
    let id: Int
    let username: String
    let avatar: String
    let timeText: String
    var isFollowing: Bool
}

struct FollowersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FollowersView(viewModel: MessageViewModel())
        }
    }
}
