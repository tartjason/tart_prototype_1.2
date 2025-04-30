import SwiftUI

struct ArtworkCardView: View {
    let artwork: Artwork
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Artwork image (blurred in preview)
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(
                            gradient: artwork.title == "Apple" ?
                                Gradient(colors: [Color.yellow.opacity(0.7), Color.orange.opacity(0.5)]) :
                                artwork.title == "Summer" ?
                                Gradient(colors: [Color.green.opacity(0.4), Color.mint.opacity(0.2)]) :
                                Gradient(colors: [Color.blue.opacity(0.4), Color.gray.opacity(0.3)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .aspectRatio(artwork.title == "Apple" ? 4/3 : 3/4, contentMode: .fit) // Use 4:3 or 3:4 aspect ratio
                    .cornerRadius(8)
                    .blur(radius: 6) // Add blur effect
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240) // Increased from 180 to 240
            .padding(.horizontal, 4) // Reduced horizontal padding to allow for larger card
            
            // Artwork info
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(artwork.title) by \(artwork.artist)")
                        .font(.system(size: 14, weight: .regular))
                    
                    Text(artwork.medium)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Enter button
                HStack(spacing: 4) {
                    Text("Enter")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.bottom, 16)
    }
}

struct ArtworkCardView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkCardView(artwork: ArtworkData.samples[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
