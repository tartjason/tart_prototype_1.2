import Foundation

public struct Comment: Identifiable, Codable, Hashable, Equatable {
    public let id: String
    public let content: String
    public let username: String
    public let createdAt: Date
    
    public init(id: String, content: String, username: String, createdAt: Date) {
        self.id = id
        self.content = content
        self.username = username
        self.createdAt = createdAt
    }
    
    // Hashable conformance
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
} 