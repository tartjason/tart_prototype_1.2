import Foundation

public struct User: Identifiable, Codable, Hashable {
    public let id: String
    public let email: String
    public let username: String
    public let profileImageURL: String?
    public let bio: String?
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String,
        email: String,
        username: String,
        profileImageURL: String? = nil,
        bio: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.username = username
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
} 