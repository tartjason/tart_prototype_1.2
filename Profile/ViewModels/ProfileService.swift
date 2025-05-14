import Foundation
import Combine
import UIKit

class ProfileService {
    private let baseURL = "https://api.example.com" // Replace with your actual API base URL
    
    func updateProfile(user: ProfileUser) async throws -> ProfileUser {
        // Here you would typically make an API call to update the user profile
        // For now, we'll just return the updated user
        return user
    }
    
    func uploadArtworkImage(_ image: UIImage) async throws -> String {
        // Here you would typically:
        // 1. Convert the image to data
        // 2. Upload it to your storage service
        // 3. Return the URL of the uploaded image
        
        // For now, we'll just return a mock URL
        return "https://example.com/images/artwork.jpg"
    }
    
    func saveArtwork(_ artwork: Artwork) async throws -> Artwork {
        // Here you would typically make an API call to save the artwork
        // For now, we'll just return the artwork
        return artwork
    }
    
    func fetchUserArtworks(userId: String) async throws -> [Artwork] {
        // Here you would typically make an API call to fetch the user's artworks
        // For now, we'll just return mock data
        return ProfileMockData.artworks
    }
    
    func fetchUserLifeUpdates(userId: String) async throws -> [LifeUpdate] {
        // Here you would typically make an API call to fetch the user's life updates
        // For now, we'll just return mock data
        return ProfileMockData.lifeUpdates
    }
}

// MARK: - Mock Data
struct ProfileMockData {
    static let artworks: [Artwork] = [
        Artwork(
            id: "1",
            imageURL: "https://example.com/artwork1.jpg",
            title: "Sunset at the Beach",
            artist: "jajasoso",
            medium: "Oil on Canvas",
            description: "A beautiful sunset painting",
            inspiration: "Nature's beauty",
            relatedImages: [],
            location: "New York, NY",
            createdAt: Date(),
            likes: 42,
            isLiked: false,
            isSaved: false,
            comments: []
        ),
        Artwork(
            id: "2",
            imageURL: "https://example.com/artwork2.jpg",
            title: "Mountain Landscape",
            artist: "jajasoso",
            medium: "Watercolor",
            description: "A serene mountain scene",
            inspiration: "Mountain hiking",
            relatedImages: [],
            location: "Los Angeles, CA",
            createdAt: Date().addingTimeInterval(-86400),
            likes: 28,
            isLiked: true,
            isSaved: false,
            comments: []
        )
    ]
    
    static let lifeUpdates: [LifeUpdate] = [
        LifeUpdate(
            id: "1",
            username: "jajasoso",
            content: "Just finished my latest painting!",
            imageURLs: ["https://example.com/update1.jpg"],
            location: "New York, NY",
            createdAt: Date(),
            likes: 15,
            isLiked: false,
            comments: []
        ),
        LifeUpdate(
            id: "2",
            username: "jajasoso",
            content: "Visiting the art museum today",
            imageURLs: ["https://example.com/update2.jpg"],
            location: "Los Angeles, CA",
            createdAt: Date().addingTimeInterval(-86400),
            likes: 8,
            isLiked: true,
            comments: []
        )
    ]
} 