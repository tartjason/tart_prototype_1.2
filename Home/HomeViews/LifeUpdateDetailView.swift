import SwiftUI

struct LifeUpdateDetailView: View {
    let update: Update
    @Environment(\.presentationMode) var presentationMode
    @State private var showCommentOptions: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Back button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 36, height: 36)
                        )
                }
                .padding(.top, 60) // Avoid Dynamic Island
                .padding(.leading, 24)
                .padding(.bottom, 16)
                
                // Update Image
                if update.hasImage {
                    ZStack {
                        if update.imageName == "watermelon-image" {
                            // This would be a real image in your assets
                            Image("watermelon")
                                .resizable()
                                .aspectRatio(4/3, contentMode: .fit) // Changed to 4:3
                                .frame(maxWidth: .infinity)
                                .background(
                                    Rectangle()
                                        .fill(Color.red.opacity(0.2))
                                )
                        } else {
                            // Placeholder for other images
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .aspectRatio(4/3, contentMode: .fit) // Changed to 4:3
                        }
                    }
                    .padding(.horizontal, 24) // Added horizontal margins
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 24)
                }
                
                // Update content text
                Text(update.content)
                    .font(.system(size: 14))
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                // Uploader profile and info
                HStack(spacing: 14) {
                    // Profile picture
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(update.username == "Tong Cui" ? Color.red.opacity(0.2) :
                                 update.username == "PickleLover" ? Color.blue.opacity(0.2) :
                                 Color.gray.opacity(0.2))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    
                    // Name and location
                    VStack(alignment: .leading, spacing: 4) {
                        Text(update.username)
                            .font(.system(size: 14, weight: .medium))
                        
                        HStack(spacing: 12) {
                            Text(update.timeAgo)
                                .font(.system(size: 12, weight: .light))
                                .foregroundColor(.gray)
                            
                            if update.username == "Tong Cui" {
                                Text("China")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Inspired Artworks section (conditionally shown for the watermelon update)
                if update.imageName == "watermelon-image" {
                    Text("Inspired Artworks")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                    
                    // Inspired artwork grid
                    HStack(spacing: 16) {
                        // First inspired artwork
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.2))
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                        
                        // Second inspired artwork
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
                
                // Comments Section
                Text("Comments:")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                
                // Comment 1
                HStack(alignment: .top) {
                    // Avatar with green background
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 38, height: 38)
                        
                        Image(systemName: "person.crop.artframe")
                            .foregroundColor(.green)
                            .font(.system(size: 14))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SuperAunt")
                            .font(.system(size: 12, weight: .medium))
                        
                        Text("I hear cicadas.")
                            .font(.system(size: 11))
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    // Comment options button
                    Button(action: {
                        showCommentOptions.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                .overlay(
                    // Popup menu overlay that doesn't affect layout
                    Group {
                        if showCommentOptions {
                            VStack(alignment: .leading, spacing: 10) {
                                Button(action: {
                                    showCommentOptions = false
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "heart")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11))
                                        Text("Like")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11))
                                    }
                                    .frame(width: 70, alignment: .leading)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                
                                Button(action: {
                                    showCommentOptions = false
                                }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bubble.right")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11))
                                        Text("Reply")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11))
                                    }
                                    .frame(width: 70, alignment: .leading)
                                }
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                            }
                            .padding(.vertical, 4)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            .position(x: UIScreen.main.bounds.width - 60, y: 0)
                            .transition(.opacity)
                            .zIndex(100)
                            .onTapGesture {
                                showCommentOptions = false
                            }
                            .onAppear {
                                // Auto-dismiss after 3 seconds
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showCommentOptions = false
                                    }
                                }
                            }
                        }
                    },
                    alignment: .topTrailing
                )
                
                // Comment 2
                HStack(alignment: .top) {
                    Spacer()
                        .frame(width: 38)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PickleLover:")
                            .font(.system(size: 12, weight: .medium))
                            + Text(" everything felt so hopeful")
                            .font(.system(size: 11))
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

struct LifeUpdateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUpdate = Update(
            username: "Tong Cui",
            content: "Today I went past the Kangding Rd. and saw these beautiful watermelons.",
            timeAgo: "3 hrs ago",
            imageName: "watermelon-image"
        )
        
        LifeUpdateDetailView(update: sampleUpdate)
    }
}
