import Foundation

public struct Artwork: Identifiable, Codable, Hashable {
    public let id: String
    public let imageURL: String
    public let title: String
    public let artist: String
    public let medium: String
    public let description: String
    public let inspiration: String
    public let relatedImages: [String]
    public let location: String
    public let createdAt: Date
    public var likes: Int
    public var isLiked: Bool
    public var isSaved: Bool
    public var comments: [Comment]
    
    public init(id: String, imageURL: String, title: String, artist: String, medium: String, description: String, inspiration: String, relatedImages: [String], location: String, createdAt: Date, likes: Int, isLiked: Bool, isSaved: Bool, comments: [Comment]) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.artist = artist
        self.medium = medium
        self.description = description
        self.inspiration = inspiration
        self.relatedImages = relatedImages
        self.location = location
        self.createdAt = createdAt
        self.likes = likes
        self.isLiked = isLiked
        self.isSaved = isSaved
        self.comments = comments
    }
    
    // Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        lhs.id == rhs.id
    }
} 