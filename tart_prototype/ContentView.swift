import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .art
    
    // Shared view models that need to persist across tab changes
    @StateObject private var messageViewModel = MessageViewModel()
    // Add other view models as needed
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main content area based on selected tab
                switch selectedTab {
                case .art:
                    HomeView()
                case .message:
                    MessageView(viewModel: messageViewModel)
                case .profile:
                    ProfileView()
                }
                
                // Tab bar
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard) // Prevents keyboard from pushing up tab bar
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
