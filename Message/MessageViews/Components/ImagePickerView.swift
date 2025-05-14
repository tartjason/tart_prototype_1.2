import SwiftUI
import PhotosUI

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0 // 0 means unlimited
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

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
    @State private var showCamera = false
    
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
                    showCamera = true
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
        .sheet(isPresented: $showCamera) {
            CameraView { image in
                if let image = image {
                    selectedImages.append(image)
                }
            }
        }
    }
}

// MARK: - Camera View
struct CameraView: UIViewControllerRepresentable {
    let onImageCaptured: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as? UIImage
            parent.onImageCaptured(image)
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImageCaptured(nil)
            picker.dismiss(animated: true)
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
