import Foundation
import Combine

class AuthenticationService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var error: AuthError?
    
    private let userDefaults = UserDefaults.standard
    private let authTokenKey = "authToken"
    private let currentUserKey = "currentUser"
    
    init() {
        // 尝试从本地存储加载用户信息
        if let userData = userDefaults.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    // 登录方法
    func login(email: String, password: String, rememberMe: Bool) async throws {
        // 这里应该是实际的 API 调用
        // 为了演示，我们使用模拟数据
        let loginRequest = LoginRequest(email: email, password: password, rememberMe: rememberMe)
        
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 模拟成功响应
        let mockUser = User(
            id: UUID().uuidString,
            email: email,
            username: email.components(separatedBy: "@").first ?? "User",
            profileImageURL: nil,
            createdAt: Date(),
            lastLoginAt: Date(),
            preferences: User.UserPreferences(
                rememberMe: rememberMe,
                notificationEnabled: true,
                theme: .system
            )
        )
        
        // 保存用户信息
        if rememberMe {
            saveUser(mockUser)
        }
        
        // 更新状态
        await MainActor.run {
            self.currentUser = mockUser
            self.isAuthenticated = true
            self.error = nil
        }
    }
    
    // 注册方法
    func register(email: String, password: String, username: String) async throws {
        let registerRequest = RegisterRequest(email: email, password: password, username: username)
        
        // 模拟网络延迟
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 模拟成功响应
        let mockUser = User(
            id: UUID().uuidString,
            email: email,
            username: username,
            profileImageURL: nil,
            createdAt: Date(),
            lastLoginAt: Date(),
            preferences: User.UserPreferences(
                rememberMe: false,
                notificationEnabled: true,
                theme: .system
            )
        )
        
        // 更新状态
        await MainActor.run {
            self.currentUser = mockUser
            self.isAuthenticated = true
            self.error = nil
        }
    }
    
    // 登出方法
    func logout() {
        // 清除本地存储
        userDefaults.removeObject(forKey: authTokenKey)
        userDefaults.removeObject(forKey: currentUserKey)
        
        // 更新状态
        currentUser = nil
        isAuthenticated = false
    }
    
    // 保存用户信息到本地存储
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: currentUserKey)
        }
    }
    
    // 验证邮箱格式
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // 验证密码强度
    func isPasswordStrong(_ password: String) -> Bool {
        // 至少8个字符，包含大小写字母和数字
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
} 