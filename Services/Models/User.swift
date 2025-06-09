import Foundation
// Note: LoginUser需要在同一个module中或者需要import

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
    
    // MARK: - LoginUser Conversion
    func toLoginUser() -> LoginUser {
        return LoginUser(
            id: self.id,
            name: self.username, // 使用username作为显示名称
            username: self.username,
            email: self.email,
            bio: self.bio ?? "",
            phoneNumber: "", // User模型中没有phoneNumber，使用空字符串
            connections: 0, // 默认连接数
            profileImageURL: self.profileImageURL,
            isVerified: true, // 从AuthService来的用户默认已验证
            joinDate: self.createdAt
        )
    }
} 