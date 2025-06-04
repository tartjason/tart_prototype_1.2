import SwiftUI

struct ArtworkDetailView: View {
    let artwork: Artwork
    @StateObject private var viewModel: ArtworkViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(artwork: Artwork) {
        self.artwork = artwork
        _viewModel = StateObject(wrappedValue: ArtworkViewModel(artwork: artwork))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header with back button
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
                    .padding(.top, 60)
                    .padding(.leading, 24)
                    
                    Spacer()
                }
                
                // Artwork Image
                if artwork.title == "Summer" {
                    Image("artwork-summer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.4), Color.mint.opacity(0.2)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.6), Color.mint.opacity(0.3)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .aspectRatio(4/5, contentMode: .fit)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                }
                
                // Artwork Description Section
                HStack {
                    Text("Artwork Description")
                        .font(AppFont.title.font)
                    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await viewModel.toggleFavorite()
                        }
                    }) {
                        Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                            .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
                            .font(.system(size: 24))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                Text(artwork.description)
                    .font(AppFont.body.font)
                    .italic()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                // Inspiration Section
                Text("Inspiration")
                    .font(AppFont.title.font)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                
                Text(artwork.inspiration)
                    .font(AppFont.body.font)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                // Related Images
                HStack(spacing: 12) {
                    ForEach(artwork.relatedImages, id: \.self) { imageName in
                        RelatedImageView(imageName: imageName)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Artist Info
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(artwork.createdAt.timeAgoDisplay())
                            .font(AppFont.lightText.font)
                            .foregroundColor(.gray)
                        
                        Text(artwork.location)
                            .font(AppFont.lightText.font)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(artwork.artist)
                                .font(AppFont.body.font)
                            
                            Button(action: {
                                // Follow action
                            }) {
                                Text("Follow")
                                    .font(AppFont.subheadline.font)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                
                // Comments Section
                HStack {
                    Text("Comments:")
                        .font(AppFont.title.font)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                        
                        Text("\(viewModel.likeCount)")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                // Comments List
                ForEach(viewModel.comments) { comment in
                    CommentView(comment: comment)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct RelatedImageView: View {
    let imageName: String
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(8)
    }
}

struct CommentView: View {
    let comment: Comment
    @State private var showOptions = false
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 38, height: 38)
                
                Image(systemName: "person.crop.artframe")
                    .foregroundColor(.green)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.username)
                    .font(AppFont.body.font)
                
                Text(comment.content)
                    .font(AppFont.subheadline.font)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(action: {
                showOptions.toggle()
            }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

struct ArtworkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkDetailView(artwork: Artwork(
            id: "1",
            imageURL: "summer",
            title: "Summer",
            artist: "Tong Cui",
            medium: "Ink",
            description: "A long summer, a beautiful season full of memories and longing...",
            inspiration: "The long summer days I spent with friends—sitting by the water, laughing until sunset, and feeling like time stood still.",
            relatedImages: ["summer-sketch-1", "summer-watermelon", "summer-forest"],
            location: "China",
            createdAt: Date(),
            likes: 42,
            isLiked: false,
            isSaved: false,
            comments: []
        ))
    }
}
