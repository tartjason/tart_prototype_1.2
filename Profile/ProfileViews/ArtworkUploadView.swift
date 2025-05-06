import SwiftUI
import PhotosUI

struct ArtworkUploadView: View {
    @Environment(\.dismiss) var dismiss
    @State private var artworkDescription = ""
    @State private var selectedMedium = ""
    @State private var selectedLocation = ""
    @State private var showMediumSheet = false
    @State private var showLocationSheet = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
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
            VStack(spacing: 0) {
                // Navigation bar
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                // Text area
                VStack(spacing: 12) {
                    TextEditor(text: $artworkDescription)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .background(Color.clear)
                        .frame(minHeight: 40, maxHeight: 120)
                        .overlay(
                            Text("Detailed description of your artwork...")
                                .font(.system(size: 16))
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
                                .font(.system(size: 16, weight: .light))
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
                                .font(.system(size: 16, weight: .light))
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
                                    .font(.system(size: 16))
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
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "eye")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                
                                Text("Preview")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        // Post button
                        Button(action: {}) {
                            Text("Post")
                                .font(.system(size: 16, weight: .light))
                                .foregroundColor(Color(hex: "5c5c5c"))
                                .frame(width: 80, height: 36)
                                .background(Color(hex: "E0EFFF"))
                                .cornerRadius(18)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showMediumSheet) {
            ArtMediumPickerView(selectedMedium: $selectedMedium, mediums: artMediums)
        }
        .sheet(isPresented: $showLocationSheet) {
            ArtLocationPickerView(selectedLocation: $selectedLocation, locations: locations)
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
                    .font(.system(size: 17))
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Pick Medium")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .medium))
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
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if selectedMedium == medium {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .medium))
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
                    .font(.system(size: 17))
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Mark Location")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 17, weight: .medium))
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
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    if selectedLocation == location {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 16, weight: .medium))
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

#Preview {
    ArtworkUploadView()
}
