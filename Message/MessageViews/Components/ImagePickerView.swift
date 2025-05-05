import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @Binding var isShowing: Bool
    @Binding var selectedImages: [UIImage]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Semi-transparent background
            if isShowing {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
            }
            
            // Color picker panel
            VStack(spacing: 0) {
                // Color selection grid as shown in the third screenshot
                HStack(spacing: 0) {
                    // Light gray
                    ColorOptionButton(color: Color(white: 0.95))
                    
                    // Medium gray
                    ColorOptionButton(color: Color(UIColor.systemGray4))
                    
                    // Dark gray
                    ColorOptionButton(color: Color(UIColor.systemGray))
                    
                    // Reddish brown
                    ColorOptionButton(color: Color(hex: "A0635D"))
                }
                .frame(height: 60)
            }
            .background(Color.white)
            .transition(.move(edge: .bottom))
            .animation(.easeInOut(duration: 0.3), value: isShowing)
        }
    }
}

struct ColorOptionButton: View {
    let color: Color
    
    var body: some View {
        Button(action: {
            // Action for selecting this color
        }) {
            Rectangle()
                .fill(color)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .contentShape(Rectangle())
        }
    }
}

// MARK: - Custom Sheet for Image Selection
struct CustomImagePickerSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedImages: [UIImage]
    @State private var showPhotosPicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle indicator
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 20)
            
            // Title
            Text("Select Image")
                .font(.system(size: 18, weight: .semibold))
                .padding(.bottom, 20)
            
            // Options
            VStack(spacing: 16) {
                Button(action: {
                    showPhotosPicker = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        
                        Text("Photo Library")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button(action: {
                    // Camera action would go here
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                        
                        Text("Take Photo")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5)
        .sheet(isPresented: $showPhotosPicker) {
            ImagePicker(selectedImages: $selectedImages)
        }
    }
}

// MARK: - Preview
struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ImagePickerView(isShowing: .constant(true), selectedImages: .constant([]))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
