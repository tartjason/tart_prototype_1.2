import Foundation
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin
import AWSS3StoragePlugin

// MARK: - Amplify Manager

class AmplifyManager {
    static let shared = AmplifyManager()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// 配置并初始化 Amplify
    func configure() {
        do {
            // 添加认证插件
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            
            // 添加 API 插件
            try Amplify.add(plugin: AWSAPIPlugin())
            
            // 添加存储插件
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            // 配置 Amplify
            try Amplify.configure()
            
            print("✅ Amplify configured successfully")
            print("📱 Auth Plugin: ✅")
            print("🔗 API Plugin: ✅")
            print("💾 Storage Plugin: ✅")
            
            // 检查当前认证状态
            checkAuthenticationState()
            
        } catch {
            print("❌ Failed to configure Amplify: \(error)")
            print("🔍 Error details: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Authentication State
    
    /// 检查当前认证状态
    private func checkAuthenticationState() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                print("User is signed in: \(session.isSignedIn)")
                
                if session.isSignedIn {
                    // 获取当前用户信息
                    let user = try await Amplify.Auth.getCurrentUser()
                    print("Current user: \(user.username)")
                }
            } catch {
                print("Failed to fetch auth session: \(error)")
            }
        }
    }
    
    // MARK: - Utility Methods
    
    /// 重置 Amplify 配置（用于测试）
    /// 注意：在新版本的 Amplify SDK 中，reset() 方法可能不可用
    /// 如果需要重置认证状态，请使用 signOut 方法
    func reset() async {
        // await Amplify.reset() // 此方法在当前版本中不可访问
        print("🔄 Reset functionality not available in current Amplify version")
        print("💡 Use signOut() method to clear authentication state instead")
    }
    
    /// 用户登出
    func signOut() async {
        do {
            _ = try await Amplify.Auth.signOut()
            print("🔓 User signed out successfully")
        } catch {
            print("❌ Error signing out: \(error)")
        }
    }
    
    /// 获取当前认证状态
    func isUserSignedIn() async -> Bool {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            return session.isSignedIn
        } catch {
            print("Error checking auth status: \(error)")
            return false
        }
    }
    
    /// 获取当前用户信息
    func getCurrentUser() async -> AuthUser? {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            return user
        } catch {
            print("Error getting current user: \(error)")
            return nil
        }
    }
    
    /// 获取用户属性
    func getUserAttributes() async -> [AuthUserAttribute] {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            return attributes
        } catch {
            print("Error fetching user attributes: \(error)")
            return []
        }
    }
}

// MARK: - Debug Extensions

#if DEBUG
extension AmplifyManager {
    /// 打印 Amplify 配置状态（仅在调试模式下可用）
    func printConfigurationStatus() {
        print("=== Amplify Configuration Status ===")
        
        Task {
            let isSignedIn = await isUserSignedIn()
            print("User Signed In: \(isSignedIn ? "✅" : "❌")")
            
            if isSignedIn, let user = await getCurrentUser() {
                print("Username: \(user.username)")
                print("User ID: \(user.userId)")
                
                let attributes = await getUserAttributes()
                for attribute in attributes {
                    print("Attribute: \(attribute.key.rawValue) = \(attribute.value)")
                }
            }
            
            print("=====================================")
        }
    }
}
#endif 