import SwiftUI

struct ProfileView: View {
    @StateObject private var model = ProfileModel()
    @State private var selectedTab = 0
    @State private var showUploadView = false
    @State private var showEditProfileView = false
    @State private var showMenu = false  
    @State private var navigateToDrafts = false
    @State private var navigateToHistory = false
    @State private var navigateToSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                NavigationLink(destination: DraftsView(), isActive: $navigateToDrafts) {
                    EmptyView()
                }
                
                NavigationLink(destination: HistoryView(), isActive: $navigateToHistory) {
                                    EmptyView()
                                }
                NavigationLink(destination: SettingsView(), isActive: $navigateToSettings) {
                                    EmptyView()
                                }
                
                VStack(spacing: 0) {
                    // Navigation Bar
                    HStack {
                        Text("tart")
                            .font(AppFont.lightTitle.font)
                        
                        Spacer()
                        
                        // *** MODIFY THIS: Add showMenu.toggle() action ***
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Profile Section
                    VStack(spacing: 0) {
                        // Profile Info and Buttons Row
                        HStack(alignment: .top, spacing: 0) {
                            // Left side - Profile Info
                            VStack(alignment: .leading, spacing: 10) {
                                // Profile Avatar with better styling
                                ZStack {
                                    // Background circle
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 70, height: 70)
                                    
                                    // Character illustration
                                    VStack(spacing: 0) {
                                        // Head
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 28, height: 28)
                                            .overlay(
                                                // Simple face
                                                HStack(spacing: 4) {
                                                    Circle()
                                                        .fill(Color.black)
                                                        .frame(width: 3, height: 3)
                                                    Circle()
                                                        .fill(Color.black)
                                                        .frame(width: 3, height: 3)
                                                }
                                                    .offset(y: -2)
                                            )
                                        
                                        // Body
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.green.opacity(0.8))
                                            .frame(width: 32, height: 20)
                                            .offset(y: -2)
                                    }
                                }
                                
                                // Name and ID
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(model.user.name)
                                        .font(AppFont.title.font)
                                        .foregroundColor(.black)
                                    
                                    Text(model.user.username)
                                        .font(AppFont.subheadline.font)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.leading, 20)
                            
                            // Spacer to push profile info left
                            Spacer(minLength: 0)
                            
                            // Right side - Action Buttons (Edit Profile and Upgrade Vertically Stacked)
                            VStack(alignment: .trailing, spacing: 8) {
                                // Edit Profile Button
                                Button(action: {showEditProfileView = true}) {
                                    Text("Edit Profile")
                                        .font(AppFont.subheadline.font)
                                        .foregroundColor(.black)
                                        .frame(width: 88, height: 32)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.black, lineWidth: 0.8)
                                        )
                                }
                                
                                // Upgrade Button (Below Edit Profile)
                                Button(action: {}) {
                                    Text("Upgrade")
                                        .font(AppFont.subheadline.font)
                                        .foregroundColor(.black)
                                        .frame(width: 88, height: 32)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.black, lineWidth: 0.8)
                                        )
                                }
                            }
                            .padding(.trailing, 20)
                            .padding(.top, 5)
                        }
                        
                        // Bottom row with Connections and Register link
                        HStack(alignment: .center) {
                            Text("\(model.user.connections) Connections")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            // Register as artist link - right aligned at same level as connections
                            Button(action: {}) {
                                Text("Register as an artist")
                                    .font(AppFont.subheadline.font)
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.top, 3)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 25)
                    
                    // Tab Selector
                    TabSelectorView(selectedTab: $selectedTab)
                    
                    // Content based on selected tab
                    if selectedTab == 0 {
                        CollectionView(model: model)
                    } else if selectedTab == 1 {
                        LifeUpdatesView(lifeUpdates: model.lifeUpdates)
                    } else {
                        GalleryView(showUploadView: $showUploadView, artworks: model.artworks)
                    }
                }
                
                // *** ADD THIS: Your BottomSlidingMenuView ***
                BottomSlidingMenuView(
                    isShowing: $showMenu,
                    onDraftsTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMenu = false
                        }
                        // Add delay to ensure menu closes before navigation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigateToDrafts = true
                        }
                    },
                    onHistoryTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMenu = false
                                                }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigateToHistory = true  
                                                }
                    },
                    onSettingsTapped: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showMenu = false
                                                }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigateToSettings = true
                                                }
                    },
                    onHelpCenterTapped: {
                        print("Help Center tapped")
                    }
                )
            }
            .fullScreenCover(isPresented: $showUploadView) {
                ArtworkUploadView(model: model)
            }
            .fullScreenCover(isPresented: $showEditProfileView) {
                NavigationView {
                    EditProfileView(model: model)
                }
            }
            .task {
                do {
                    try await model.fetchUserArtworks()
                    try await model.fetchUserLifeUpdates()
                } catch {
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
    
    struct TabSelectorView: View {
        @Binding var selectedTab: Int
        
        var body: some View {
            HStack(spacing: 0) {
                // Collection Tab
                Button(action: { selectedTab = 0 }) {
                    VStack(spacing: 8) {
                        Text("Collection")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(selectedTab == 0 ? .black : .gray)
                        
                        Rectangle()
                            .fill(selectedTab == 0 ? Color.black : Color.clear)
                            .frame(height: 1)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Life Updates Tab
                Button(action: { selectedTab = 1 }) {
                    VStack(spacing: 8) {
                        Text("Life Updates")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(selectedTab == 1 ? .black : .gray)
                        
                        Rectangle()
                            .fill(selectedTab == 1 ? Color.black : Color.clear)
                            .frame(height: 1)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Gallery Tab
                Button(action: { selectedTab = 2 }) {
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Text("Gallery")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(selectedTab == 2 ? .black : .gray)
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10))
                                .foregroundColor(selectedTab == 2 ? .black : .gray)
                        }
                        
                        Rectangle()
                            .fill(selectedTab == 2 ? Color.black : Color.clear)
                            .frame(height: 1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            .background(Color.white)
        }
    }
    
    struct CollectionView: View {
        @State private var currentIndex = 0
        @State private var dragOffset = CGSize.zero
        @ObservedObject var model: ProfileModel
        
        var body: some View {
            VStack(spacing: 0) {
                if model.collectedArtworks.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "rectangle.stack")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No collected artworks yet")
                            .font(AppFont.body.font)
                            .foregroundColor(.gray)
                        
                        Text("Start collecting amazing art!")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                } else {
                    // Card carousel
                    GeometryReader { geometry in
                        ZStack {
                            ForEach(Array(model.collectedArtworks.enumerated()), id: \.offset) { index, artwork in
                                ArtworkCollectionCard(
                                    artwork: artwork,
                                    index: index,
                                    currentIndex: currentIndex,
                                    screenWidth: geometry.size.width
                                )
                                .offset(x: CGFloat(index - currentIndex) * (geometry.size.width * 0.85) + dragOffset.width)
                                .scaleEffect(index == currentIndex ? 1.0 : 0.85)
                                .opacity(index == currentIndex ? 1.0 : 0.7)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentIndex)
                                .animation(.spring(response: 0.3, dampingFraction: 0.9), value: dragOffset)
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 50
                                    let dragDistance = value.translation.width
                                    
                                    if dragDistance > threshold && currentIndex > 0 {
                                        currentIndex -= 1
                                    } else if dragDistance < -threshold && currentIndex < model.collectedArtworks.count - 1 {
                                        currentIndex += 1
                                    }
                                    
                                    dragOffset = .zero
                                }
                        )
                    }
                    .frame(height: 500)
                    .padding(.top, 20)
                    
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<model.collectedArtworks.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.black : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Current artwork info
                    if !model.collectedArtworks.isEmpty && currentIndex < model.collectedArtworks.count {
                        let currentArtwork = model.collectedArtworks[currentIndex]
                        ArtworkInfoView(artwork: currentArtwork)
                            .padding(.top, 16)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    struct ArtworkCollectionCard: View {
        let artwork: Artwork
        let index: Int
        let currentIndex: Int
        let screenWidth: CGFloat
        
        var body: some View {
            VStack(spacing: 0) {
                // Artwork image
                AsyncImage(url: URL(string: artwork.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(3/4, contentMode: .fill)
                            .clipped()
                    case .failure(_):
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .aspectRatio(3/4, contentMode: .fit)
                            .overlay(
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 32))
                                        .foregroundColor(.gray.opacity(0.5))
                                    
                                    Text("Image unavailable")
                                        .font(AppFont.caption.font)
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(3/4, contentMode: .fit)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: screenWidth * 0.75, height: (screenWidth * 0.75) * 4/3)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                
                // Quick info overlay
                VStack(alignment: .leading, spacing: 4) {
                    Text(artwork.title)
                        .font(AppFont.subtitle.font)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text("by \(artwork.artist)")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(1)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.7), Color.clear],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .offset(y: -60)
            }
        }
    }
    
    struct ArtworkInfoView: View {
        let artwork: Artwork
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Title and artist
                VStack(alignment: .leading, spacing: 4) {
                    Text(artwork.title)
                        .font(AppFont.title.font)
                        .foregroundColor(.black)
                    
                    Text("by \(artwork.artist)")
                        .font(AppFont.body.font)
                        .foregroundColor(.gray)
                }
                
                // Medium and location
                HStack {
                    Label(artwork.medium, systemImage: "paintbrush")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Label(artwork.location, systemImage: "location")
                        .font(AppFont.subheadline.font)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                // Collection date
                Text("Collected on \(artwork.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(AppFont.caption.font)
                    .foregroundColor(.gray.opacity(0.8))
                
                // Action buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // TODO: View details
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "eye")
                                .font(AppFont.subheadline.font)
                            Text("View Details")
                                .font(AppFont.subheadlineBold.font)
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // TODO: Share
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                                .font(AppFont.subheadline.font)
                            Text("Share")
                                .font(AppFont.subheadlineBold.font)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black)
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                }
                .padding(.top, 8)
            }
            .padding(.bottom, 20)
        }
    }
    
    struct LifeUpdatesView: View {
        let lifeUpdates: [LifeUpdate]
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                if lifeUpdates.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No life updates yet")
                            .font(AppFont.body.font)
                            .foregroundColor(.gray)
                        
                        Text("Share your artistic journey!")
                            .font(AppFont.subheadline.font)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 60)
                } else {
                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(lifeUpdates) { update in
                                LifeUpdateCard(update: update)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                
                // Floating Action Button
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 48, height: 48)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .thin))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    struct LifeUpdateCard: View {
        let update: LifeUpdate
        @State private var isLiked: Bool
        @State private var likesCount: Int
        
        init(update: LifeUpdate) {
            self.update = update
            self._isLiked = State(initialValue: update.isLiked)
            self._likesCount = State(initialValue: update.likes)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                // Header with username and time
                HStack {
                    Text(update.username)
                        .font(AppFont.subheadlineBold.font)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(update.createdAt.timeAgoDisplay())
                        .font(AppFont.caption.font)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                // Content
                Text(update.content)
                    .font(AppFont.subheadline.font)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Image if available
                if let imageURLs = update.imageURLs, 
                   !imageURLs.isEmpty,
                   let firstImageURL = imageURLs.first {
                    AsyncImage(url: URL(string: firstImageURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: 200)
                                .clipped()
                        case .failure(_):
                            Rectangle()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 150)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo")
                                            .font(.system(size: 32))
                                            .foregroundColor(.gray.opacity(0.5))
                                        
                                        Text("Image unavailable")
                                            .font(AppFont.caption.font)
                                            .foregroundColor(.gray.opacity(0.7))
                                    }
                                )
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 150)
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.top, 8)
                }
                
                // Actions bar
                HStack(spacing: 24) {
                    // Like button
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isLiked.toggle()
                            likesCount += isLiked ? 1 : -1
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(isLiked ? .red : .gray)
                            
                            if likesCount > 0 {
                                Text("\(likesCount)")
                                    .font(AppFont.caption.font)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Comment button
                    Button(action: {
                        // TODO: Navigate to comments view
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "message")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.gray)
                            
                            if !update.comments.isEmpty {
                                Text("\(update.comments.count)")
                                    .font(AppFont.caption.font)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Location if available
                    if let location = update.location {
                        HStack(spacing: 4) {
                            Image(systemName: "location")
                                .font(AppFont.caption.font)
                                .foregroundColor(.gray)
                            
                            Text(location)
                                .font(AppFont.caption.font)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color.white)
            .overlay(
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 0.5),
                alignment: .bottom
            )
        }
    }
    
    struct GalleryView: View {
        @Binding var showUploadView: Bool
        let artworks: [Artwork]
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 1) {
                        ForEach(artworks) { artwork in
                            ArtworkCell(artwork: artwork)
                        }
                    }
                }
                
                // Floating Action Button
                Button(action: {
                    showUploadView = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .thin))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }
    
    struct ArtworkCell: View {
        let artwork: Artwork
        
        var body: some View {
            VStack {
                AsyncImage(url: URL(string: artwork.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipped()
                    case .failure(_):
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 120)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 120)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(artwork.title)
                    .font(AppFont.subheadline.font)
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
    }
}

#Preview {
    ProfileView()
}
