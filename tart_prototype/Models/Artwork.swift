import Foundation

// 艺术作品模型
struct Artwork: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let artist: String
    let medium: String
    let description: String
    let inspiration: String
    let imageURL: String
    let relatedImages: [String]
    let location: String
    let createdAt: Date
    var likes: Int
    var comments: [Comment]
    var tags: [String]
    
    // 用于本地存储的额外信息
    var isLiked: Bool
    var isSaved: Bool
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Artwork, rhs: Artwork) -> Bool {
        lhs.id == rhs.id
    }
}

// 评论模型
struct Comment: Identifiable, Codable {
    let id: String
    let userId: String
    let username: String
    let content: String
    let createdAt: Date
    var likes: Int
    var isLiked: Bool
}

// 艺术作品请求模型
struct ArtworkRequest: Codable {
    let page: Int
    let limit: Int
    let sortBy: SortOption
    let filterBy: FilterOption?
    
    enum SortOption: String, Codable {
        case latest
        case popular
        case trending
    }
    
    struct FilterOption: Codable {
        let medium: String?
        let location: String?
        let tags: [String]?
    }
}

// 艺术作品响应模型
struct ArtworkResponse: Codable {
    let artworks: [Artwork]
    let totalCount: Int
    let hasMore: Bool
}

// 艺术作品错误模型
enum ArtworkError: Error {
    case fetchError
    case invalidData
    case networkError(Error)
    case unauthorized
    
    var localizedDescription: String {
        switch self {
        case .fetchError:
            return "Failed to fetch artworks"
        case .invalidData:
            return "Invalid artwork data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
} 