import SwiftUI

class AuthManager: ObservableObject {
    @Published var authService: AuthenticationService
    
    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService
    }
}

// 用于在视图中访问 AuthManager 的便捷属性包装器
@propertyWrapper
struct AuthManagerEnvironment: DynamicProperty {
    @EnvironmentObject private var authManager: AuthManager
    
    var wrappedValue: AuthManager {
        authManager
    }
}

// 用于在视图中访问 AuthenticationService 的便捷属性包装器
@propertyWrapper
struct AuthServiceEnvironment: DynamicProperty {
    @EnvironmentObject private var authManager: AuthManager
    
    var wrappedValue: AuthenticationService {
        authManager.authService
    }
} 