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
            imageURL: "https://picsum.photos/300/400?random=11",
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
            imageURL: "https://picsum.photos/300/400?random=12",
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
        ),
        Artwork(
            id: "3",
            imageURL: "https://picsum.photos/300/400?random=13",
            title: "Abstract Dreams",
            artist: "jajasoso",
            medium: "Acrylic",
            description: "An abstract piece representing dreams",
            inspiration: "Night dreams",
            relatedImages: [],
            location: "San Francisco, CA",
            createdAt: Date().addingTimeInterval(-172800),
            likes: 35,
            isLiked: false,
            isSaved: true,
            comments: []
        ),
        Artwork(
            id: "4",
            imageURL: "https://picsum.photos/300/400?random=14",
            title: "City Life",
            artist: "jajasoso",
            medium: "Digital Art",
            description: "Urban life captured in digital form",
            inspiration: "City streets",
            relatedImages: [],
            location: "Chicago, IL",
            createdAt: Date().addingTimeInterval(-259200),
            likes: 18,
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
            imageURLs: ["https://picsum.photos/400/300?random=1"],
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
            imageURLs: ["https://picsum.photos/400/300?random=2"],
            location: "Los Angeles, CA",
            createdAt: Date().addingTimeInterval(-86400),
            likes: 8,
            isLiked: true,
            comments: []
        ),
        LifeUpdate(
            id: "3",
            username: "jajasoso",
            content: "Working on a new sculpture piece. The clay feels amazing today!",
            imageURLs: nil,
            location: nil,
            createdAt: Date().addingTimeInterval(-3600),
            likes: 12,
            isLiked: false,
            comments: []
        ),
        LifeUpdate(
            id: "4",
            username: "jajasoso",
            content: "Beautiful sunset inspiration for my next watercolor series.",
            imageURLs: ["https://picsum.photos/400/300?random=3"],
            location: "San Francisco, CA",
            createdAt: Date().addingTimeInterval(-7200),
            likes: 25,
            isLiked: true,
            comments: []
        )
    ]
    
    static let collectedArtworks: [Artwork] = [
        Artwork(
            id: "c1",
            imageURL: "https://picsum.photos/300/400?random=21",
            title: "Garden Dreams",
            artist: "Vincent Chen",
            medium: "Oil on Canvas",
            description: "A serene garden scene with vibrant flowers and peaceful atmosphere",
            inspiration: "Nature's harmony",
            relatedImages: [],
            location: "Paris, France",
            createdAt: Date().addingTimeInterval(-86400 * 30),
            likes: 156,
            isLiked: true,
            isSaved: true,
            comments: []
        ),
        Artwork(
            id: "c2",
            imageURL: "https://picsum.photos/300/400?random=22",
            title: "Urban Reflections",
            artist: "Maria Rodriguez",
            medium: "Acrylic",
            description: "City life captured through abstract forms and bold colors",
            inspiration: "Metropolitan energy",
            relatedImages: [],
            location: "New York, NY",
            createdAt: Date().addingTimeInterval(-86400 * 45),
            likes: 203,
            isLiked: false,
            isSaved: true,
            comments: []
        ),
        Artwork(
            id: "c3",
            imageURL: "https://picsum.photos/300/400?random=23",
            title: "Ocean Waves",
            artist: "Akira Tanaka",
            medium: "Watercolor",
            description: "The rhythm and movement of ocean waves in soft blue tones",
            inspiration: "Coastal memories",
            relatedImages: [],
            location: "Tokyo, Japan",
            createdAt: Date().addingTimeInterval(-86400 * 60),
            likes: 89,
            isLiked: true,
            isSaved: true,
            comments: []
        ),
        Artwork(
            id: "c4",
            imageURL: "https://picsum.photos/300/400?random=24",
            title: "Mountain Serenity",
            artist: "Elena Petrov",
            medium: "Digital Art",
            description: "Majestic mountain peaks bathed in golden sunrise light",
            inspiration: "Alpine adventures",
            relatedImages: [],
            location: "Switzerland",
            createdAt: Date().addingTimeInterval(-86400 * 75),
            likes: 124,
            isLiked: false,
            isSaved: true,
            comments: []
        ),
        Artwork(
            id: "c5",
            imageURL: "https://picsum.photos/300/400?random=25",
            title: "Abstract Emotions",
            artist: "David Kim",
            medium: "Mixed Media",
            description: "An exploration of human emotions through abstract expressionism",
            inspiration: "Inner feelings",
            relatedImages: [],
            location: "Seoul, South Korea",
            createdAt: Date().addingTimeInterval(-86400 * 90),
            likes: 67,
            isLiked: true,
            isSaved: true,
            comments: []
        )
    ]
} 