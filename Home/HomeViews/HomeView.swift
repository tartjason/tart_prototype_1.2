import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    enum Tab {
        case art, lifeUpdates
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        if viewModel.showingBackButton {
                            Button(action: {
                                viewModel.clearInput()
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18))
                                    .padding()
                            }
                        } else {
                            Text("t")
                                .font(AppFont.lightTitle.font)
                                .foregroundColor(.black)
                                .padding()
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    // Tab Selection
                    HStack(spacing: 0) {
                        TabButton(title: "art", isSelected: viewModel.selectedTab == .art) {
                            viewModel.toggleTab(.art)
                        }
                        
                        TabButton(title: "life updates", isSelected: viewModel.selectedTab == .lifeUpdates) {
                            viewModel.toggleTab(.lifeUpdates)
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.selectedTab == .art {
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
                                viewModel.showInputOverlay()
                            }) {
                                Text("Type anything...")
                                    .foregroundColor(.gray)
                                    .font(AppFont.subheadline.font)
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
                                ForEach(viewModel.homeService.artworks) { artwork in
                                    NavigationLink(
                                        destination: ArtworkDetailView(artwork: artwork),
                                        tag: artwork,
                                        selection: $viewModel.selectedArtwork
                                    ) {
                                        ArtworkCardView(artwork: artwork)
                                            .padding(.horizontal, 16)
                                            .onTapGesture {
                                                viewModel.selectedArtwork = artwork
                                            }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    } else {
                        // Life Updates Tab Content
                        LifeUpdatesContentView()
                    }
                    
                    Spacer()
                    
                    // Using the shared TabBarView component
                    TabBarView(selectedTab: $viewModel.selectedAppTab)
                }
                
                // Typing Overlay
                if viewModel.isInputOverlayVisible {
                    InputOverlay(
                        isVisible: $viewModel.isInputOverlayVisible,
                        inputText: $viewModel.inputText,
                        showBackButton: $viewModel.showingBackButton
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchArtworks()
            await viewModel.fetchLifeUpdates()
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
                    .font(isSelected ? AppFont.bodyBold.font : AppFont.body.font)
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
