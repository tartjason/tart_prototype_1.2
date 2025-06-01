import SwiftUI

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Toggle states
    @State private var receiveMessageNotifications = true
    @State private var likesAndCollects = true
    @State private var newFollowers = true
    @State private var comments = true
    @State private var mentions = true
    @State private var chat = true
    @State private var updatesFromFollowed = true
    @State private var contentRecommendation = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                
                Text("Notification Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading)
                
                Spacer()
            }
            .padding()
            
            // Notification Settings Content
            ScrollView {
                VStack(spacing: 20) {
                    // Message notifications
                    VStack(spacing: 0) {
                        NotificationToggleRow(
                            title: "Receive message notifications",
                            isOn: $receiveMessageNotifications
                        )
                    }
                    
                    // Engagement notification section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Engagement notification")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            NotificationToggleRow(
                                title: "Likes & Collects",
                                isOn: $likesAndCollects
                            )
                            
                            NotificationToggleRow(
                                title: "New followers",
                                isOn: $newFollowers
                            )
                            
                            NotificationToggleRow(
                                title: "Comments",
                                isOn: $comments
                            )
                            
                            NotificationToggleRow(
                                title: "@",
                                isOn: $mentions
                            )
                            
                            NotificationToggleRow(
                                title: "Chat",
                                isOn: $chat
                            )
                        }
                    }
                    
                    // Content notification section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Content notification")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            NotificationToggleRow(
                                title: "Updates from the followed",
                                isOn: $updatesFromFollowed
                            )
                            
                            NotificationToggleRow(
                                title: "Content recommendation",
                                isOn: $contentRecommendation
                            )
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true)
    }
}

struct NotificationToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.black)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(Color.gray.opacity(0.05))
    }
}

#Preview {
    NavigationView {
        NotificationSettingsView()
    }
}
