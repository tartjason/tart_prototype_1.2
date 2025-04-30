import SwiftUI

struct LifeUpdatesContentView: View {
    @State private var selectedUpdate: Update? = nil
    let updates = UpdatesData.samples
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(updates) { update in
                    NavigationLink(
                        destination: LifeUpdateDetailView(update: update),
                        tag: update,
                        selection: $selectedUpdate
                    ) {
                        UpdateCardView(update: update)
                            .onTapGesture {
                                selectedUpdate = update
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if update.id != updates.last?.id {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// Update Card View
struct UpdateCardView: View {
    let update: Update
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !update.hasImage {
                // Text-only update layout (Vicky's case)
                HStack(alignment: .top, spacing: 12) {
                    // Username on the left
                    Text(update.username)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 80, alignment: .leading)
                    
                    // Content to the right of username
                    Text(update.content)
                        .font(.system(size: 16))
                }
                .padding(.horizontal)
                .padding(.top, 16)
            } else {
                // Image update layout
                // Username above content
                Text(update.username)
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                // Image with more margins and 4:3 aspect ratio
                ZStack {
                    if update.imageName == "turtle-image" {
                        Rectangle()
                            .fill(Color.blue.opacity(0.3))
                            .aspectRatio(4/3, contentMode: .fit) // Changed to 4:3
                    } else if update.imageName == "watermelon-image" {
                        Rectangle()
                            .fill(Color.red.opacity(0.3))
                            .aspectRatio(4/3, contentMode: .fit) // Changed to 4:3
                    }
                }
                .padding(.horizontal, 24) // Increased horizontal margins
                
                // Caption below image
                Text(update.content)
                    .font(.system(size: 16))
                    .padding(.horizontal)
            }
            
            // Time and Navigate Arrow
            HStack {
                Text(update.timeAgo)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .background(Color.white)
    }
}

struct LifeUpdatesContentView_Previews: PreviewProvider {
    static var previews: some View {
        LifeUpdatesContentView()
    }
}
