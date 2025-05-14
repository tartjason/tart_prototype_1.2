import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
    @State private var showUploadView = false
    @State private var showEditProfileView = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Bar
                HStack {
                    Text("tart")
                        .font(.system(size: 18, weight: .medium))
                    
                    Spacer()
                    
                    Button(action: {}) {
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
                                Text("Jason")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("ld.jajasoso")
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
                        Text("6 Connections")
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
                    LifeUpdatesView()
                } else {
                    GalleryView(showUploadView: $showUploadView)
                }
            }
        }
        .fullScreenCover(isPresented: $showUploadView) {
            ArtworkUploadView()
        }
        .fullScreenCover(isPresented: $showEditProfileView) {
                    NavigationView {
                        EditProfileView()
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
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    // Image grid - precisely matching your screenshots
                    VStack(spacing: 1) {
                        // First row
                        HStack(spacing: 1) {
                            // Left - Single large image
                            LifeUpdateCell(index: 0, isLarge: true)
                            
                            // Right column - 4 smaller images in grid
                            VStack(spacing: 1) {
                                HStack(spacing: 1) {
                                    LifeUpdateCell(index: 1)
                                    LifeUpdateCell(index: 2)
                                }
                                HStack(spacing: 1) {
                                    LifeUpdateCell(index: 3)
                                    LifeUpdateCell(index: 4)
                                }
                            }
                        }
                        
                        // Second row - 2 images
                        HStack(spacing: 1) {
                            LifeUpdateCell(index: 5)
                            LifeUpdateCell(index: 6)
                        }
                    }
                    .padding(.horizontal, 0)
                    .padding(.top, 0)
                    
                    Spacer()
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
    let index: Int
    var isLarge: Bool = false
    
    var body: some View {
        let colors: [(Color, Color)] = [
            (.green, .blue),
            (.orange, .yellow),
            (.purple, .blue),
            (.red, .pink),
            (.blue, .green),
            (.pink, .red),
            (.yellow, .orange)
        ]
        
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        colors[index % colors.count].0.opacity(0.7),
                        colors[index % colors.count].1.opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                // Art content based on screenshot
                Group {
                    if index == 0 {
                        // Green garden scene (large)
                        VStack {
                            HStack(spacing: 5) {
                                ForEach(0..<3) { _ in
                                    Circle()
                                        .fill(Color.white.opacity(0.8))
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            Rectangle()
                                .fill(Color.brown)
                                .frame(width: 8, height: 40)
                            
                            Circle()
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                        }
                    } else if index == 2 {
                        // Purple pattern
                        VStack(spacing: 2) {
                            ForEach(0..<8) { _ in
                                Rectangle()
                                    .fill(Color.white.opacity(0.6))
                                    .frame(height: 4)
                            }
                        }
                    } else if index == 3 {
                        // Character on red background
                        VStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 30, height: 30)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.brown)
                                .frame(width: 25, height: 15)
                        }
                    } else {
                        // Default placeholder
                        Image(systemName: "photo")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 20))
                    }
                }
            )
            .aspectRatio(isLarge ? 1 : 1, contentMode: .fill)
            .clipped()
    }
}

struct GalleryView: View {
    @Binding var showUploadView: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                Text("Gallery Content")
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.top, 20)
            
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

#Preview {
    ProfileView()
}
