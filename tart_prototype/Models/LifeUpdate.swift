import Foundation

// 生活更新模型
struct LifeUpdate: Identifiable, Codable {
    let id: String
    let userId: String
    let username: String
    let content: String
    let createdAt: Date
    var imageURLs: [String]?
    var likes: Int
    var comments: [Comment]
    var location: String?
    var tags: [String]
    
    // 用于本地存储的额外信息
    var isLiked: Bool
    var isSaved: Bool
}

// 生活更新请求模型
struct LifeUpdateRequest: Codable {
    let page: Int
    let limit: Int
    let userId: String?
    let includeImages: Bool
    
    enum SortOption: String, Codable {
        case latest
        case popular
    }
}

// 生活更新响应模型
struct LifeUpdateResponse: Codable {
    let updates: [LifeUpdate]
    let totalCount: Int
    let hasMore: Bool
}

// 生活更新错误模型
enum LifeUpdateError: Error {
    case fetchError
    case invalidData
    case networkError(Error)
    case unauthorized
    
    var localizedDescription: String {
        switch self {
        case .fetchError:
            return "Failed to fetch life updates"
        case .invalidData:
            return "Invalid update data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        }
    }
} 