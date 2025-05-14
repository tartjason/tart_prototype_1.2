import Foundation

struct LoginUser: Identifiable, Codable {
    let id: String
    let name: String
    let username: String
    let email: String
    let bio: String
    let phoneNumber: String
    var connections: Int
    
    // 可以添加更多用户相关的属性
    var profileImageURL: String?
    var isVerified: Bool = false
    var joinDate: Date = Date()
    
    // 用于本地存储的键
    static let userDefaultsKey = "currentUser"
    
    // 保存用户到 UserDefaults
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: LoginUser.userDefaultsKey)
        }
    }
    
    // 从 UserDefaults 加载用户
    static func load() -> LoginUser? {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(LoginUser.self, from: data) {
            return user
        }
        return nil
    }
    
    // 清除保存的用户数据
    static func clear() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
} 