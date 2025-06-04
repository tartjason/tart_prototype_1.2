//
//  ProfileModel.swift
//  tart_prototype
//
//  Created by ZhengXian Lin on 5/7/25.
//

import Foundation
import SwiftUI
import Combine

class ProfileModel: ObservableObject {
    @Published var user: ProfileUser
    @Published var artworks: [Artwork] = []
    @Published var lifeUpdates: [LifeUpdate] = []
    @Published var collectedArtworks: [Artwork] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: ProfileUser = ProfileUser.default) {
        self.user = user
        setupBindings()
        loadInitialData()
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
    
    func uploadArtwork(description: String, medium: String, location: String, image: UIImage) async throws {
        isLoading = true
        defer { isLoading = false }
        
        // Create new artwork
        let newArtwork = Artwork(
            id: UUID().uuidString,
            imageURL: "", // This would be set after uploading the image
            title: description,
            artist: user.username,
            medium: medium,
            description: description,
            inspiration: "",
            relatedImages: [],
            location: location,
            createdAt: Date(),
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        )
        
        // Here you would typically:
        // 1. Upload the image to a storage service
        // 2. Get the image URL
        // 3. Update the artwork with the image URL
        // 4. Save the artwork to the database
        
        // For now, we'll just add it to the local array
        artworks.append(newArtwork)
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
