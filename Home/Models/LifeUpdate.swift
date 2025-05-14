import Foundation

public struct LifeUpdate: Identifiable, Codable, Hashable {
    public let id: String
    public let username: String
    public let content: String
    public let imageURLs: [String]?
    public let location: String?
    public let createdAt: Date
    public var likes: Int
    public var isLiked: Bool
    public var comments: [Comment]
    
    public init(id: String, username: String, content: String, imageURLs: [String]?, location: String?, createdAt: Date, likes: Int, isLiked: Bool, comments: [Comment]) {
        self.id = id
        self.username = username
        self.content = content
        self.imageURLs = imageURLs
        self.location = location
        self.createdAt = createdAt
        self.likes = likes
        self.isLiked = isLiked
        self.comments = comments
    }
    
    // Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: LifeUpdate, rhs: LifeUpdate) -> Bool {
        lhs.id == rhs.id
    }
} 