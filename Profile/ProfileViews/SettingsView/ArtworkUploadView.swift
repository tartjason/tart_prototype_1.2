import SwiftUI
import PhotosUI

struct ArtworkUploadView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var model: ProfileModel
    
    @State private var artworkDescription = ""
    @State private var inspirationDescription = ""
    @State private var selectedMedium = ""
    @State private var selectedLocation = ""
    @State private var showMediumPicker = false
    @State private var showLocationPicker = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    // Photo picker states
    @State private var artworkImageItem: PhotosPickerItem?
    @State private var artworkImage: UIImage?
    @State private var inspirationImageItem: PhotosPickerItem?
    @State private var inspirationImage: UIImage?
    
    private let mediumOptions = [
        "Colored Pencil",
        "Oil Painting",
        "Sketch",
        "Sculpture",
        "Installation",
        "Jewelry"
    ]
    
    private let locationOptions = [
        "New York, NY",
        "Los Angeles, CA",
        "San Francisco, CA",
        "Chicago, IL",
        "Miami, FL",
        "Seattle, WA",
        "Boston, MA",
        "Austin, TX",
        "Denver, CO",
        "Portland, OR"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Navigation Bar
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFont.body.font)
                    .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Artwork Info Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Artwork Info")
                        .font(Font.title2.weight(.bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                    
                    // Description text field
                    VStack(alignment: .leading, spacing: 8) {
                        TextEditor(text: $artworkDescription)
                            .font(AppFont.body.font)
                            .foregroundColor(.black)
                            .frame(minHeight: 80)
                            .overlay(
                                Text("Brief description of your artwork...")
                                    .font(AppFont.body.font)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                                    .opacity(artworkDescription.isEmpty ? 1 : 0)
                                , alignment: .topLeading
                            )
                            .padding(.horizontal, 16)
                    }
                    
                    // Picture of artwork
                    VStack(spacing: 12) {
                        PhotosPicker(selection: $artworkImageItem, matching: .images) {
                            VStack(spacing: 12) {
                                if let artworkImage = artworkImage {
                                    Image(uiImage: artworkImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(height: 200)
                                        .overlay(
                                            VStack(spacing: 8) {
                                                Image(systemName: "camera")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(.gray)
                                                
                                                Text("Picture of artwork")
                                                    .font(AppFont.subheadline.font)
                                                    .foregroundColor(.gray)
                                            }
                                        )
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .onChange(of: artworkImageItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        artworkImage = uiImage
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
                
                // Inspiration Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Inspiration")
                        .font(Font.title2.weight(.bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                    
                    // Inspiration description
                    VStack(alignment: .leading, spacing: 8) {
                        TextEditor(text: $inspirationDescription)
                            .font(AppFont.body.font)
                            .foregroundColor(.black)
                            .frame(minHeight: 80)
                            .overlay(
                                Text("Describe how you have been inspired to create this piece of artwork. Feel free to share any back stories about it...")
                                    .font(AppFont.body.font)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                                    .opacity(inspirationDescription.isEmpty ? 1 : 0)
                                , alignment: .topLeading
                            )
                            .padding(.horizontal, 16)
                    }
                    
                    // Sketch/Inspiration photo
                    VStack(spacing: 12) {
                        PhotosPicker(selection: $inspirationImageItem, matching: .images) {
                            VStack(spacing: 12) {
                                if let inspirationImage = inspirationImage {
                                    Image(uiImage: inspirationImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(height: 200)
                                        .overlay(
                                            VStack(spacing: 8) {
                                                Image(systemName: "camera")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(.gray)
                                                
                                                Text("Sketch/Inspiration")
                                                    .font(AppFont.subheadline.font)
                                                    .foregroundColor(.gray)
                                            }
                                        )
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .onChange(of: inspirationImageItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        inspirationImage = uiImage
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 40)
                
                // Options Section
                VStack(spacing: 16) {
                    // Pick medium
                    Button(action: {
                        showMediumPicker = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "paintbrush")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                            
                            Text(selectedMedium.isEmpty ? "Pick medium" : selectedMedium)
                                .font(AppFont.body.font)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // Mark location
                    Button(action: {
                        showLocationPicker = true
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "location")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                            
                            Text(selectedLocation.isEmpty ? "Mark location" : selectedLocation)
                                .font(AppFont.body.font)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // Advanced options
                    Button(action: {}) {
                        HStack(spacing: 12) {
                            Text("Advanced options")
                                .font(AppFont.body.font)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
                .padding(.bottom, 40)
                
                // Bottom buttons
                HStack(spacing: 20) {
                    Button(action: {
                        saveDraft()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                            
                            Text("Save draft")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.gray)
                        }
                    }
                    .disabled(artworkDescription.isEmpty && artworkImage == nil)
                    
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "eye")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                            
                            Text("Preview")
                                .font(AppFont.subheadline.font)
                                .foregroundColor(.gray)
                        }
                    }
                    .disabled(artworkDescription.isEmpty || artworkImage == nil)
                    
                    Spacer()
                    
                    // Post button with loading state
                    Button(action: {
                        submitArtwork()
                    }) {
                        HStack(spacing: 8) {
                            if model.isUploading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "5c5c5c")))
                                    .scaleEffect(0.8)
                            }
                            
                            Text(model.isUploading ? "上传中..." : "Post")
                                .font(AppFont.subheadlineBold.font)
                                .foregroundColor(canSubmit ? Color(hex: "5c5c5c") : .gray)
                        }
                        .frame(width: 80, height: 36)
                        .background(canSubmit ? Color(hex: "E0EFFF") : Color.gray.opacity(0.3))
                        .cornerRadius(18)
                    }
                    .disabled(!canSubmit || model.isUploading)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showMediumPicker) {
            MediumPickerView(selectedMedium: $selectedMedium, options: mediumOptions)
        }
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerView(selectedLocation: $selectedLocation, options: locationOptions)
        }
        .alert("错误", isPresented: $showErrorAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .overlay(
            // 上传进度覆盖层
            Group {
                if model.isUploading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        ProgressView(value: model.uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 200) 
                        
                        Text("上传中... \(Int(model.uploadProgress * 100))%")
                            .font(AppFont.body.font)
                            .foregroundColor(.white)
                    }
                    .padding(20)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(12)
                }
            }
        )
    }
    
    private func submitArtwork() {
        Task {
            do {
                try await model.uploadArtwork(
                    description: artworkDescription,
                    inspirationDescription: inspirationDescription,
                    medium: selectedMedium,
                    location: selectedLocation,
                    artworkImage: artworkImage,
                    inspirationImage: inspirationImage
                )
                
                await MainActor.run {
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
    
    private func saveDraft() {
        do {
            try model.saveDraft(
                description: artworkDescription,
                inspirationDescription: inspirationDescription,
                medium: selectedMedium,
                location: selectedLocation,
                artworkImage: artworkImage,
                inspirationImage: inspirationImage
            )
            dismiss()
        } catch {
            errorMessage = "保存草稿失败: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
    
    private var canSubmit: Bool {
        !artworkDescription.isEmpty && !selectedMedium.isEmpty && artworkImage != nil
    }
}

// Medium Picker View
struct MediumPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMedium: String
    let options: [String]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFont.body.font)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Pick Medium")
                        .font(Font.title2.weight(.bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFont.bodyBold.font)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                Divider()
                
                // Options list
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selectedMedium = option
                                dismiss()
                            }) {
                                HStack {
                                    Text(option)
                                        .font(AppFont.body.font)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if selectedMedium == option {
                                        Image(systemName: "checkmark")
                                            .font(AppFont.body.font)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                            }
                            
                            if option != options.last {
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

// Location Picker View
struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: String
    let options: [String]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppFont.body.font)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Mark Location")
                        .font(Font.title2.weight(.bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppFont.bodyBold.font)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                Divider()
                
                // Options list
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selectedLocation = option
                                dismiss()
                            }) {
                                HStack {
                                    Text(option)
                                        .font(AppFont.body.font)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if selectedLocation == option {
                                        Image(systemName: "checkmark")
                                            .font(AppFont.body.font)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white)
                            }
                            
                            if option != options.last {
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

#Preview {
    ArtworkUploadView(model: ProfileModel())
}
