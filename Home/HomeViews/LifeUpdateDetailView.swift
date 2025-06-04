import SwiftUI

struct LifeUpdateDetailView: View {
    let update: LifeUpdate
    @StateObject private var viewModel: LifeUpdateViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(update: LifeUpdate) {
        self.update = update
        _viewModel = StateObject(wrappedValue: LifeUpdateViewModel(update: update))
    }
    
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
                .padding(.top, 60)
                .padding(.leading, 24)
                .padding(.bottom, 16)
                
                // Update Image
                if let imageURLs = update.imageURLs, !imageURLs.isEmpty {
                    AsyncImage(url: URL(string: imageURLs[0])) { image in
                        image
                            .resizable()
                            .aspectRatio(4/3, contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(4/3, contentMode: .fit)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                // Update content text
                Text(update.content)
                    .font(AppFont.subheadline.font)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                // Uploader profile and info
                HStack(spacing: 14) {
                    // Profile picture
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    
                    // Name and location
                    VStack(alignment: .leading, spacing: 4) {
                        Text(update.username)
                            .font(AppFont.subheadline.font)
                        
                        HStack(spacing: 12) {
                            Text(update.createdAt.timeAgoDisplay())
                                .font(AppFont.lightText.font)
                                .foregroundColor(.gray)
                            
                            if let location = update.location {
                                Text(location)
                                    .font(AppFont.lightText.font)
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
                        .font(AppFont.subheadlineBold.font)
                    
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
                .padding(.bottom, 16)
                
                // Comments List
                ForEach(viewModel.comments) { comment in
                    CommentView(comment: comment)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LifeUpdateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LifeUpdateDetailView(update: LifeUpdate(
            id: "1",
            username: "Tong Cui",
            content: "Today I went past the Kangding Rd. and saw these beautiful watermelons.",
            imageURLs: ["watermelon-image"],
            location: "China",
            createdAt: Date(),
            likes: 15,
            isLiked: false,
            comments: []
        ))
    }
}
