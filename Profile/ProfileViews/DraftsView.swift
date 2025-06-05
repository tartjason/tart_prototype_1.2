import SwiftUI

struct DraftsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = "art"
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with back button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                
                Text("Drafts")
                    .font(AppFont.subtitle.font)
                    .padding(.leading)
                
                Spacer()
            }
            .padding()
            
            // Tab Bar for switching between art and life updates
            HStack(spacing: 0) {
                ForEach(["art", "life updates"], id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        VStack(spacing: 8) {
                            Text(tab)
                                .font(AppFont.body.font)
                                .foregroundColor(selectedTab == tab ? .black : .gray)
                                .padding(.vertical, 8)
                            
                            // Underline indicator for selected tab
                            Rectangle()
                                .fill(selectedTab == tab ? Color.black : Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Divider()
            
            // Content based on selected tab
            ScrollView {
                if selectedTab == "art" {
                    // Art drafts content view
                    VStack(spacing: 16) {
                        // Art draft item that matches your screenshot
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .bottom) {
                                // Garden/plants image from the screenshot
                                Rectangle()
                                    .fill(Color.green.opacity(0.4))
                                    .frame(height: 200)
                                    .overlay(
                                        Image(systemName: "leaf.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(40)
                                            .foregroundColor(.white.opacity(0.8))
                                    )
                                
                                // "Just now" label with trash icon
                                HStack {
                                    Text("Just now")
                                        .font(AppFont.caption.font)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // Delete action
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.6))
                            }
                        }
                        .cornerRadius(8)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Spacer()
                    }
                } else {
                    // Life updates content view (empty as shown in screenshots)
                    VStack {
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// Add a proper preview for DraftsView
struct DraftsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DraftsView()
        }
    }
}
