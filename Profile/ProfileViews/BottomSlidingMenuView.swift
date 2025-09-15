import SwiftUI

// Bottom Sliding Menu View
struct BottomSlidingMenuView: View {
    @Binding var isShowing: Bool
    let backgroundColor = Color.white
    
    var onDraftsTapped: () -> Void = {}
    var onHistoryTapped: () -> Void = {}
    var onSettingsTapped: () -> Void = {}
    var onHelpCenterTapped: () -> Void = {}
    var onSignOutTapped: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Semi-transparent background for dismissing menu
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowing = false
                        }
                    }
            }
            
            // Menu panel
            if isShowing || true { // Always render but control visibility with offset
                 VStack(spacing: 0) {
                     // Drag indicator
                     RoundedRectangle(cornerRadius: 2)
                         .fill(Color.gray.opacity(0.3))
                         .frame(width: 40, height: 4)
                         .padding(.top, 12)
                         .padding(.bottom, 24)
                     
                     // Menu Items
                     VStack(spacing: 0) {
                         // Drafts
                        MenuButton(
                            icon: "doc.text",
                                   label: "Drafts",
                                   action: {
                                       onDraftsTapped()
                                   }
                               )
                        
                        // History
                        MenuButton(
                            icon: "clock",
                                label: "History",
                                action: {
                                    onHistoryTapped()
                            }
                        )
                        
                        // Divider
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        
                        // Settings
                        MenuButton(
                            icon: "gearshape",
                            label: "Settings",
                            action: {
                                onSettingsTapped()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isShowing = false
                                }
                            }
                        )
                        
                        // Help Center
                        MenuButton(
                            icon: "questionmark.circle",
                            label: "Help Center",
                            action: {
                                onHelpCenterTapped()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isShowing = false
                                }
                            }
                        )
                        
                        // Divider
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                        
                        // Sign Out
                        MenuButton(
                            icon: "rectangle.portrait.and.arrow.right",
                            label: "Sign Out",
                            action: {
                                onSignOutTapped()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isShowing = false
                                }
                            }
                        )
                    }
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .offset(y: isShowing ? 0 : 500) // Increased offset to ensure complete hiding
                .animation(.easeInOut(duration: 0.3), value: isShowing)
                .clipped() // Ensure no part of the menu shows when hidden
            }
        }
        .allowsHitTesting(isShowing) // Only allow interaction when showing
    }
}

// Menu Button Component
struct MenuButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                
                Text(label)
                    .font(AppFont.body.font)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
        }
    }
}

// Extension for custom corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        BottomSlidingMenuView(isShowing: .constant(false)) // Preview with menu hidden
    }
}
