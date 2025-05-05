import SwiftUI

struct ArtworkDetailView: View {
    let artwork: Artwork
    @Environment(\.presentationMode) var presentationMode
    @State private var isFavorite: Bool = false
    @State private var showCommentOptions: Bool = false
    @State private var likeCount: Int = 12
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header with back button - moved down to avoid Dynamic Island
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.system(size: 18))
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 36, height: 36)
                            )
                    }
                    .padding(.top, 60) // Increased top padding to avoid Dynamic Island
                    .padding(.leading, 24) // Increased horizontal margin
                    
                    Spacer()
                }
                
                // Artwork Image with increased margins
                if artwork.title == "Summer" {
                    Image("artwork-summer") // This would be a real image in your assets
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(
                            // Fallback in case image doesn't load
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.4), Color.mint.opacity(0.2)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.horizontal, 24) // Increased horizontal margins
                        .padding(.bottom, 24) // More vertical space
                } else {
                    // Placeholder for other artworks
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.6), Color.mint.opacity(0.3)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .aspectRatio(4/5, contentMode: .fit)
                        .padding(.horizontal, 24) // Increased horizontal margins
                        .padding(.bottom, 24) // More vertical space
                }
                
                // Artwork Description Section with increased spacing
                HStack {
                    Text("Artwork Description")
                        .font(.system(size: 22, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(isFavorite ? .yellow : .gray)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal, 24) // Increased horizontal padding
                .padding(.bottom, 12) // More vertical space
                
                Text("\"A long summer, a beautiful season full of memories and longing...\"")
                    .font(.system(size: 17, weight: .medium))
                    .italic()
                    .padding(.horizontal, 24) // Increased horizontal padding
                    .padding(.bottom, 32) // More vertical space
                
                // Inspiration Section with increased spacing
                Text("Inspiration")
                    .font(.system(size: 22, weight: .bold))
                    .padding(.horizontal, 24) // Increased horizontal padding
                    .padding(.bottom, 12) // More vertical space
                
                Text("The long summer days I spent with friends—sitting by the water, laughing until sunset, and feeling like time stood still. I wanted to capture that mix of happiness and the quiet longing that comes when those moments turn into memories.")
                    .font(.system(size: 17))
                    .lineSpacing(4) // Added line spacing for readability
                    .padding(.horizontal, 24) // Increased horizontal padding
                    .padding(.bottom, 32) // More vertical space
                
                // Related Images
                HStack(spacing: 12) { // Increased spacing between images
                    ForEach(1...3, id: \.self) { index in
                        RelatedImageView(index: index)
                    }
                }
                .padding(.horizontal, 24) // Increased horizontal padding
                .padding(.bottom, 32) // More vertical space
                
                // Artist Info with profile picture
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("3 hrs ago")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.gray)
                        
                        Text("China")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) { // Increased spacing
                        // Artist profile picture
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tong Cui")
                                .font(.system(size: 16, weight: .medium))
                            
                            Button(action: {
                                // Follow action
                            }) {
                                Text("Follow")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24) // Increased horizontal padding
                .padding(.bottom, 32) // More vertical space
                
                // Comments Section with like count
                HStack {
                    Text("Comments:")
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                        
                        Text("\(likeCount)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 24) // Increased horizontal padding
                .padding(.bottom, 12) // More vertical space
                
                // Comment 1
                HStack(alignment: .top) {
                    // Avatar with green background
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 38, height: 38)
                        
                        Image(systemName: "person.crop.artframe")
                            .foregroundColor(.green)
                            .font(.system(size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SuperAunt")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("I hear cicadas.")
                            .font(.system(size: 15))
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    
                    // Comment options button
                    Button(action: {
                        showCommentOptions.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal, 24) // Increased horizontal padding
                .padding(.bottom, 16) // More vertical space
                .overlay(
                    // Popup menu overlay that doesn't affect layout
                    Group {
                        if showCommentOptions {
                            VStack(alignment: .leading, spacing: 10) { // Reduced spacing
                                Button(action: {
                                    // Like action
                                    likeCount += 1
                                    showCommentOptions = false
                                }) {
                                    HStack(spacing: 6) { // Reduced spacing
                                        Image(systemName: "heart")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11)) // Even smaller icon
                                        Text("Like")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11)) // Even smaller text
                                    }
                                    .frame(width: 70, alignment: .leading) // Smaller width
                                }
                                .padding(.horizontal, 6) // Less padding
                                .padding(.vertical, 4) // Less padding
                                
                                Button(action: {
                                    // Reply action
                                    showCommentOptions = false
                                }) {
                                    HStack(spacing: 6) { // Reduced spacing
                                        Image(systemName: "bubble.right")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11)) // Even smaller icon
                                        Text("Reply")
                                            .foregroundColor(.black)
                                            .font(.system(size: 11)) // Even smaller text
                                    }
                                    .frame(width: 70, alignment: .leading) // Smaller width
                                }
                                .padding(.horizontal, 6) // Less padding
                                .padding(.vertical, 4) // Less padding
                            }
                            .padding(.vertical, 4) // Less padding
                            .background(Color.white)
                            .cornerRadius(8) // Smaller corners
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Smaller shadow
                            .position(x: UIScreen.main.bounds.width - 80, y: 0) // Position above instead of below
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
                            .font(.system(size: 16, weight: .medium))
                            + Text(" everything felt so hopeful")
                            .font(.system(size: 15))
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                }
                .padding(.horizontal, 24) // Increased horizontal padding
                .padding(.bottom, 24) // More vertical space
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

struct RelatedImageView: View {
    let index: Int
    
    var body: some View {
        ZStack {
            // This would be real images in your assets
            if index == 1 {
                Rectangle()
                    .fill(Color.green.opacity(0.3))
                    .aspectRatio(contentMode: .fill)
            } else if index == 2 {
                Rectangle()
                    .fill(Color.red.opacity(0.3))
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(height: 80)
        .cornerRadius(8)
    }
}

struct ArtworkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkDetailView(artwork: ArtworkData.samples[1]) // Summer by Tong Cui
    }
}
