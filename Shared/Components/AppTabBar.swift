import SwiftUI

// Tab type enum used across the app
enum AppTab {
    case art
    case message
    case profile
}

struct TabBarView: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "house.fill",
                text: "Home",
                isSelected: selectedTab == .art,
                action: { selectedTab = .art }
            )
            
            
            TabBarButton(
                icon: "envelope",
                text: "Message",
                isSelected: selectedTab == .message,
                action: { selectedTab = .message }
            )
            
            TabBarButton(
                icon: "person",
                text: "Profile",
                isSelected: selectedTab == .profile,
                action: { selectedTab = .profile }
            )
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(Color.white)
    }
}

struct TabBarButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .black : .gray)
                
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .black : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// For preview purposes
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selectedTab: AppTab = .art
        
        return TabBarView(selectedTab: $selectedTab)
            .previewLayout(.sizeThatFits)
    }
}
