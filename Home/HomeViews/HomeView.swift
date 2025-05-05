import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .art
    @State private var isTyping: Bool = false
    @State private var inputText: String = ""
    @State private var showingBackButton: Bool = false
    @State private var artworks = ArtworkData.samples
    @State private var selectedArtwork: Artwork? = nil
    @State private var selectedAppTab: AppTab = .art
    
    enum Tab {
        case art, lifeUpdates
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        if showingBackButton {
                            Button(action: {
                                withAnimation {
                                    showingBackButton = false
                                    inputText = ""
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .padding()
                            }
                        } else {
                            Text("t")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // Tab Selection
                    HStack(spacing: 0) {
                        TabButton(title: "art", isSelected: selectedTab == .art) {
                            withAnimation {
                                selectedTab = .art
                            }
                        }
                        
                        TabButton(title: "life updates", isSelected: selectedTab == .lifeUpdates) {
                            withAnimation {
                                selectedTab = .lifeUpdates
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if selectedTab == .art {
                        // Help and Search
                        HStack {
                            Button(action: {
                                // Help action
                            }) {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 20))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    isTyping = true
                                }
                            }) {
                                Text("Type anything...")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(15)
                            }
                        }
                        .padding()
                        
                        // Artwork Cards
                        ScrollView {
                            VStack(spacing: 24) {
                                ForEach(artworks) { artwork in
                                    NavigationLink(
                                        destination: ArtworkDetailView(artwork: artwork),
                                        tag: artwork,
                                        selection: $selectedArtwork
                                    ) {
                                        ArtworkCardView(artwork: artwork)
                                            .padding(.horizontal, 16)
                                            .onTapGesture {
                                                selectedArtwork = artwork
                                            }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    } else {
                        // Life Updates Tab Content - using the content view without duplicating UI elements
                        LifeUpdatesContentView()
                    }
                    
                    Spacer()
                    
                    // Using the shared TabBarView component
                    TabBarView(selectedTab: $selectedAppTab)
                }
                
                // Typing Overlay
                if isTyping {
                    InputOverlay(
                        isVisible: $isTyping,
                        inputText: $inputText,
                        showBackButton: $showingBackButton
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Tab Button Component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .medium : .regular))
                    .foregroundColor(.black)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isSelected ? .black : .clear)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
