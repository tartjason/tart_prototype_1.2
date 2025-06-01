import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Toggle states
    @State private var allowCommentsFromFollowingArtwork = true
    @State private var allowMentionsFromFollowingArtwork = true
    @State private var allowCommentsFromFollowingLifeUpdates = true
    @State private var allowMentionsFromFollowingLifeUpdates = true
    
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
                
                Text("Privacy Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.leading)
                
                Spacer()
            }
            .padding()
            
            // Settings Content
            ScrollView {
                VStack(spacing: 20) {
                    // Interaction for Uploaded Artwork Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Interaction for Uploaded Artwork")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            PrivacyToggleRow(
                                title: "Only allow comments from following",
                                isOn: $allowCommentsFromFollowingArtwork
                            )
                            
                            PrivacyToggleRow(
                                title: "Only allow mentions from following",
                                isOn: $allowMentionsFromFollowingArtwork
                            )
                        }
                    }
                    
                    // Interaction for Uploaded Life Updates Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Interaction for Uploaded Life Updates")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            PrivacyToggleRow(
                                title: "Only allow comments from following",
                                isOn: $allowCommentsFromFollowingLifeUpdates
                            )
                            
                            PrivacyToggleRow(
                                title: "Only allow mentions from following",
                                isOn: $allowMentionsFromFollowingLifeUpdates
                            )
                        }
                    }
                    
                    // Individual Settings
                    VStack(spacing: 0) {
                        PrivacySettingRow(
                            title: "Private messages",
                            value: "Default"
                        ) {
                            // Handle private messages setting
                        }
                        
                        PrivacySettingRow(
                            title: "My artwork collection",
                            value: "Not public"
                        ) {
                            // Handle artwork collection privacy
                        }
                    }
                    
                    // Relationship Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Relationship")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        VStack(spacing: 0) {
                            PrivacySettingRow(
                                title: "Following/Follower List",
                                value: nil
                            ) {
                                // Handle following/follower list
                            }
                            
                            PrivacySettingRow(
                                title: "Blocked users",
                                value: nil
                            ) {
                                // Handle blocked users
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
        .navigationBarHidden(true)
    }
}

struct PrivacyToggleRow: View {
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

struct PrivacySettingRow: View {
    let title: String
    let value: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                if let value = value {
                    Text(value)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color.gray.opacity(0.05))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        PrivacySettingsView()
    }
}
