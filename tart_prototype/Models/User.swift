import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let username: String
    let profileImageURL: String?
    let createdAt: Date
    var lastLoginAt: Date
    
    // 用于本地存储的用户偏好设置
    var preferences: UserPreferences
    
    struct UserPreferences: Codable {
        var rememberMe: Bool
        var notificationEnabled: Bool
        var theme: AppTheme
        
        enum AppTheme: String, Codable {
            case light
            case dark
            case system
        }
    }
}

// 用于登录请求的模型
struct LoginRequest: Codable {
    let email: String
    let password: String
    let rememberMe: Bool
}

// 用于注册请求的模型
struct RegisterRequest: Codable {
    let email: String
    let password: String
    let username: String
}

// 用于 API 响应的模型
struct AuthResponse: Codable {
    let user: User
    let token: String
    let expiresIn: Int
}

// 用于错误处理的枚举
enum AuthError: Error {
    case invalidCredentials
    case emailAlreadyExists
    case weakPassword
    case networkError(Error)
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyExists:
            return "Email already exists"
        case .weakPassword:
            return "Password is too weak"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
} 