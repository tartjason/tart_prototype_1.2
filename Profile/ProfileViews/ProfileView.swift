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
                            .font(.system(size: 18, weight: .medium))
                        
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
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.black)
                                    
                                    Text(model.user.username)
                                        .font(.system(size: 14))
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
                                        .font(.system(size: 14))
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
                                        .font(.system(size: 14))
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
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            Spacer()
                            
                            // Register as artist link - right aligned at same level as connections
                            Button(action: {}) {
                                Text("Register as an artist")
                                    .font(.system(size: 14))
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
                        CollectionView()
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
                            .font(.system(size: 15))
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
                            .font(.system(size: 15))
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
                                .font(.system(size: 15))
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
        @State private var dragAmount = CGSize.zero
        
        var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    // Card stack
                    ZStack {
                        ForEach(0..<3, id: \.self) { index in
                            CollectionCard(index: index)
                                .offset(x: CGFloat(index * 5), y: CGFloat(index * -8))
                                .scaleEffect(1 - CGFloat(index) * 0.025)
                                .zIndex(Double(-index))
                        }
                    }
                    .frame(height: 400)
                    .padding(.top, 20)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragAmount = value.translation
                            }
                            .onEnded { value in
                                dragAmount = .zero
                            }
                    )
                    
                    // Date text
                    Text("You have collected this piece on Oct 6, 2024")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                }
            }
        }
    }
    
    struct CollectionCard: View {
        let index: Int
        
        var body: some View {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 8)
                .overlay(
                    // Art content - representing the garden scene
                    VStack {
                        if index == 0 {
                            // Garden scene representation
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.green.opacity(0.7),
                                            Color.blue.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    // Garden elements
                                    VStack(spacing: 0) {
                                        HStack(spacing: 10) {
                                            ForEach(0..<3) { _ in
                                                RoundedRectangle(cornerRadius: 4)
                                                    .fill(Color.red.opacity(0.7))
                                                    .frame(width: 20, height: 20)
                                            }
                                        }
                                        .padding(.top, 20)
                                        
                                        Spacer()
                                        
                                        // Tree-like structure
                                        Rectangle()
                                            .fill(Color.brown)
                                            .frame(width: 10, height: 60)
                                        
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Circle()
                                                    .fill(Color.green.opacity(0.5))
                                                    .frame(width: 30, height: 30)
                                            )
                                        
                                        Spacer()
                                    }
                                )
                        } else {
                            // Other cards with different art
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.yellow.opacity(0.6),
                                            Color.purple.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                    }
                        .cornerRadius(12)
                        .padding(4)
                )
                .frame(width: 260, height: 340)
        }
    }
    
    struct LifeUpdatesView: View {
        let lifeUpdates: [LifeUpdate]
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 1) {
                        ForEach(lifeUpdates) { update in
                            LifeUpdateCell(update: update)
                        }
                    }
                }
                
                // Floating Action Button
                Button(action: {}) {
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
    
    struct LifeUpdateCell: View {
        let update: LifeUpdate
        
        var body: some View {
            VStack {
                if let imageURLs = update.imageURLs, let firstImageURL = imageURLs.first {
                    AsyncImage(url: URL(string: firstImageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Text(update.content)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
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
                AsyncImage(url: URL(string: artwork.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                
                Text(artwork.title)
                    .font(.system(size: 14))
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
