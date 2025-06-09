//
//  ProfileModel.swift
//  tart_prototype
//
//  Created by ZhengXian Lin on 5/7/25.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Supporting Models and Enums

enum ArtworkUploadError: LocalizedError {
    case missingArtworkImage
    case missingDescription
    case missingMedium
    case uploadFailed(String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .missingArtworkImage:
            return "请选择一张艺术作品图片"
        case .missingDescription:
            return "请输入作品描述"
        case .missingMedium:
            return "请选择艺术媒介"
        case .uploadFailed(let message):
            return "上传失败: \(message)"
        case .networkError:
            return "网络连接错误，请检查网络设置"
        }
    }
}

enum ImageUploadType {
    case artwork
    case inspiration
}

struct ArtworkDraft: Identifiable, Codable {
    let id: String
    let description: String
    let inspirationDescription: String
    let medium: String
    let location: String
    let artworkImageData: Data?
    let inspirationImageData: Data?
    let createdAt: Date
    let lastModified: Date
    
    var artworkImage: UIImage? {
        guard let data = artworkImageData else { return nil }
        return UIImage(data: data)
    }
    
    var inspirationImage: UIImage? {
        guard let data = inspirationImageData else { return nil }
        return UIImage(data: data)
    }
}

class ProfileModel: ObservableObject {
    @Published var user: ProfileUser
    @Published var artworks: [Artwork] = []
    @Published var lifeUpdates: [LifeUpdate] = []
    @Published var collectedArtworks: [Artwork] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var uploadProgress: Double = 0.0
    @Published var isUploading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var draftArtworks: [ArtworkDraft] = []
    
    init(user: ProfileUser = ProfileUser.default) {
        self.user = user
        setupBindings()
        loadInitialData()
        loadDrafts()
    }
    
    private func setupBindings() {
        // Add any necessary bindings here
    }
    
    private func loadInitialData() {
        Task {
            do {
                try await fetchUserLifeUpdates()
                try await fetchUserArtworks()
                try await fetchCollectedArtworks()
            } catch {
                self.error = error
            }
        }
    }
    
    func updateProfile(name: String, username: String, bio: String, phoneNumber: String, email: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Create a mutable copy of the user
        var updatedUser = user
        updatedUser.updateProfile(name: name, username: username, bio: bio, email: email)
        updatedUser.phoneNumber = phoneNumber
        
        // Update the published property
        user = updatedUser
        
        // Here you would typically make an API call to update the profile
        // For now, we'll just simulate a network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func uploadArtwork(
        description: String,
        inspirationDescription: String = "",
        medium: String,
        location: String,
        artworkImage: UIImage?,
        inspirationImage: UIImage? = nil
    ) async throws {
        guard let artworkImage = artworkImage else {
            throw ArtworkUploadError.missingArtworkImage
        }
        
        guard !description.isEmpty else {
            throw ArtworkUploadError.missingDescription
        }
        
        guard !medium.isEmpty else {
            throw ArtworkUploadError.missingMedium
        }
        
        isUploading = true
        uploadProgress = 0.0
        defer { 
            isUploading = false
            uploadProgress = 0.0
        }
        
        do {
            // 1. Upload artwork image
            uploadProgress = 0.2
            let artworkImageURL = try await uploadImage(artworkImage, type: .artwork)
            
            // 2. Upload inspiration image if provided
            uploadProgress = 0.4
            var inspirationImageURL: String? = nil
            if let inspirationImage = inspirationImage {
                inspirationImageURL = try await uploadImage(inspirationImage, type: .inspiration)
            }
            
            // 3. Create artwork object
            uploadProgress = 0.6
            let relatedImages = inspirationImageURL != nil ? [inspirationImageURL!] : []
            
            let newArtwork = Artwork(
                id: UUID().uuidString,
                imageURL: artworkImageURL,
                title: description,
                artist: user.username,
                medium: medium,
                description: description,
                inspiration: inspirationDescription,
                relatedImages: relatedImages,
                location: location,
                createdAt: Date(),
                likes: 0,
                isLiked: false,
                isSaved: false,
                comments: []
            )
            
            // 4. Save to backend
            uploadProgress = 0.8
            let savedArtwork = try await ProfileService().saveArtwork(newArtwork)
            
            // 5. Update local data
            uploadProgress = 1.0
            await MainActor.run {
                artworks.insert(savedArtwork, at: 0)
            }
            
        } catch {
            await MainActor.run {
                self.error = error
            }
            throw error
        }
    }
    
    func saveDraft(
        description: String,
        inspirationDescription: String = "",
        medium: String,
        location: String,
        artworkImage: UIImage?,
        inspirationImage: UIImage? = nil
    ) throws {
        let draft = ArtworkDraft(
            id: UUID().uuidString,
            description: description,
            inspirationDescription: inspirationDescription,
            medium: medium,
            location: location,
            artworkImageData: artworkImage?.jpegData(compressionQuality: 0.8),
            inspirationImageData: inspirationImage?.jpegData(compressionQuality: 0.8),
            createdAt: Date(),
            lastModified: Date()
        )
        
        draftArtworks.append(draft)
        try saveDraftsToStorage()
    }
    
    func loadDrafts() {
        do {
            draftArtworks = try StorageService.shared.loadArtworkDrafts()
        } catch {
            print("Failed to load drafts: \(error)")
            draftArtworks = []
        }
    }
    
    func getDrafts() -> [ArtworkDraft] {
        return draftArtworks
    }
    
    func deleteDraft(id: String) {
        draftArtworks.removeAll { $0.id == id }
        do {
            try saveDraftsToStorage()
        } catch {
            print("Failed to save drafts after deletion: \(error)")
        }
    }
    
    private func saveDraftsToStorage() throws {
        try StorageService.shared.saveArtworkDrafts(draftArtworks)
    }
    
    private func uploadImage(_ image: UIImage, type: ImageUploadType) async throws -> String {
        let profileService = ProfileService()
        
        switch type {
        case .artwork:
            return try await profileService.uploadArtworkImage(image)
        case .inspiration:
            return try await profileService.uploadInspirationImage(image)
        }
    }
    
    func fetchUserArtworks() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Here you would typically fetch artworks from an API
        // For now, we'll just use mock data
        artworks = ProfileMockData.artworks
    }
    
    func fetchUserLifeUpdates() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Here you would typically fetch life updates from an API
        // For now, we'll just use mock data
        lifeUpdates = ProfileMockData.lifeUpdates
    }
    
    func fetchCollectedArtworks() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Here you would typically fetch collected artworks from an API
        // For now, we'll just use mock data
        collectedArtworks = ProfileMockData.collectedArtworks
    }
}
