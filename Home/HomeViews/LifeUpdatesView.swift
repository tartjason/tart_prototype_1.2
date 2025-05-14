import SwiftUI

struct LifeUpdatesContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedUpdate: LifeUpdate? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.homeService.lifeUpdates) { update in
                    NavigationLink(
                        destination: LifeUpdateDetailView(update: update),
                        tag: update,
                        selection: $selectedUpdate
                    ) {
                        UpdateCardView(update: update)
                            .onTapGesture {
                                selectedUpdate = update
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if update.id != viewModel.homeService.lifeUpdates.last?.id {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// Update Card View
struct UpdateCardView: View {
    let update: LifeUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if update.imageURLs == nil || update.imageURLs!.isEmpty {
                // Text-only update layout
                HStack(alignment: .top, spacing: 12) {
                    // Username on the left
                    Text(update.username)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 80, alignment: .leading)
                    
                    // Content to the right of username
                    Text(update.content)
                        .font(.system(size: 16))
                }
                .padding(.horizontal)
                .padding(.top, 16)
            } else {
                // Image update layout
                // Username above content
                Text(update.username)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // Image with more margins and 4:3 aspect ratio
                if let firstImageURL = update.imageURLs?.first {
                    AsyncImage(url: URL(string: firstImageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(4/3, contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(4/3, contentMode: .fit)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Caption below image
                Text(update.content)
                    .font(.system(size: 16))
                    .padding(.horizontal)
            }
            
            // Time and Navigate Arrow
            HStack {
                Text(update.createdAt.timeAgoDisplay())
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(Color.white)
    }
}

struct LifeUpdatesContentView_Previews: PreviewProvider {
    static var previews: some View {
        LifeUpdatesContentView()
    }
}
