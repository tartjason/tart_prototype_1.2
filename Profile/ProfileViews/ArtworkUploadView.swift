import SwiftUI
import PhotosUI

struct ArtworkUploadView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model: ProfileModel
    @State private var artworkDescription = ""
    @State private var selectedMedium = ""
    @State private var selectedLocation = ""
    @State private var showMediumSheet = false
    @State private var showLocationSheet = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var isUploading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let artMediums = [
        "Painting",
        "Sculpture",
        "Photography",
        "Jewelry",
        "Poem",
        "Digital Art",
        "Mixed Media",
        "Drawing",
        "Printmaking",
        "Ceramics",
        "Textiles",
        "Installation",
        "Video",
        "Performance"
    ]
    
    private let locations = [
        "New York, NY",
        "Los Angeles, CA",
        "Chicago, IL",
        "San Francisco, CA",
        "Paris, France",
        "London, UK",
        "Berlin, Germany",
        "Tokyo, Japan",
        "Toronto, Canada",
        "Sydney, Australia"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Navigation Bar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Upload Artwork")
                            .font(AppFont.subtitle.font)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: uploadArtwork) {
                            Text("Post")
                                .font(AppFont.bodyBold.font)
                                .foregroundColor(.blue)
                        }
                        .disabled(isUploading || selectedImage == nil || selectedMedium.isEmpty || selectedLocation.isEmpty)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    // Text area
                    VStack(spacing: 12) {
                        TextEditor(text: $artworkDescription)
                            .font(AppFont.body.font)
                            .foregroundColor(.black)
                            .background(Color.clear)
                            .frame(minHeight: 40, maxHeight: 120)
                            .overlay(
                                Text("Detailed description of your artwork...")
                                    .font(AppFont.body.font)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                                    .opacity(artworkDescription.isEmpty ? 1 : 0)
                                , alignment: .topLeading
                            )
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        
                        Spacer().frame(height: 20)
                        
                        // Pick medium button
                        Button(action: {
                            showMediumSheet = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "paintbrush")
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                
                                Text(selectedMedium.isEmpty ? "Pick medium" : selectedMedium)
                                    .font(AppFont.body.font)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.clear)
                        }
                        
                        // Mark location button
                        Button(action: {
                            showLocationSheet = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "location")
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundColor(.black)
                                    .frame(width: 24, height: 24)
                                
                                Text(selectedLocation.isEmpty ? "Mark location" : selectedLocation)
                                    .font(AppFont.body.font)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.clear)
                        }
                        
                        // Advanced options and Camera in same row
                        HStack(alignment: .center) {
                            // Advanced options button
                            Button(action: {}) {
                                HStack {
                                    Text("Advanced options")
                                        .font(AppFont.body.font)
                                        .foregroundColor(.gray)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            
                            Spacer()
                            
                            // Camera button (no circle, just the icon)
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Image(systemName: "camera")
                                    .font(.system(size: 24, weight: .light))
                                    .foregroundColor(Color(hex: "5c5c5c"))
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            selectedImage = Image(uiImage: uiImage)
                                        }
                                    }
                                }
                            }
                            .padding(.trailing, 16)
                        }
                        
                        Spacer()
                        
                        // Bottom buttons
                        HStack(spacing: 20) {
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                    
                                    Text("Save draft")
                                        .font(AppFont.subheadline.font)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Button(action: {}) {
                                HStack(spacing: 8) {
                                    Image(systemName: "eye")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                    
                                    Text("Preview")
                                        .font(AppFont.subheadline.font)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .sheet(isPresented: $showMediumSheet) {
            ArtMediumPickerView(selectedMedium: $selectedMedium, mediums: artMediums)
        }
        .sheet(isPresented: $showLocationSheet) {
            ArtLocationPickerView(selectedLocation: $selectedLocation, locations: locations)
        }
    }
    
    private func uploadArtwork() {
        guard let image = selectedImage else { return }
        
        isUploading = true
        
        Task {
            do {
                // Convert SwiftUI Image to UIImage
                let renderer = ImageRenderer(content: image)
                if let uiImage = renderer.uiImage {
                    try await model.uploadArtwork(
                        description: artworkDescription,
                        medium: selectedMedium,
                        location: selectedLocation,
                        image: uiImage
                    )
                    dismiss()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            isUploading = false
        }
    }
}

// Renamed to avoid conflicts with existing views
struct ArtMediumPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMedium: String
    let mediums: [String]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFont.body.font)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Pick Medium")
                        .font(AppFont.bodyBold.font)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFont.bodyBold.font)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                Divider()
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(mediums, id: \.self) { medium in
                            Button(action: {
                                selectedMedium = medium
                                dismiss()
                            }) {
                                HStack {
                                    Text(medium)
                                        .font(AppFont.body.font)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if selectedMedium == medium {
                                        Image(systemName: "checkmark")
                                            .font(AppFont.bodyBold.font)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                            }
                            
                            if medium != mediums.last {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Renamed to avoid conflicts with existing views
struct ArtLocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: String
    let locations: [String]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFont.body.font)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Mark Location")
                        .font(AppFont.bodyBold.font)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFont.bodyBold.font)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                
                Divider()
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(locations, id: \.self) { location in
                            Button(action: {
                                selectedLocation = location
                                dismiss()
                            }) {
                                HStack {
                                    Text(location)
                                        .font(AppFont.body.font)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if selectedLocation == location {
                                        Image(systemName: "checkmark")
                                            .font(AppFont.bodyBold.font)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                            }
                            
                            if location != locations.last {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ArtworkUploadView_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkUploadView(model: ProfileModel())
    }
}
