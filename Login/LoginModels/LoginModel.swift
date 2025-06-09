import Foundation
import SwiftUI

class LoginModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: LoginUser?
    @Published var isLoading = false
    @Published var error: String?
    
    // MARK: - Development Configuration
    static let isDevelopmentMode = true // 设为false使用真实API
    
    private let authService = AuthService.shared
    
    // MARK: - Authentication Methods
    
    // MARK: - Registration Methods
    
    func registerWithGoogle() async throws {
        isLoading = true
        error = nil
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                self.currentUser = LoginUser(
                    id: UUID().uuidString,
                    name: "Google User",
                    username: "googleuser\(Int.random(in: 1000...9999))",
                    email: "user@gmail.com",
                    bio: "Registered with Google",
                    phoneNumber: "",
                    connections: 0
                )
                self.isAuthenticated = true
            } else {
                // 真实API模式
                try await authService.socialRegister(provider: "google")
                if let user = authService.currentUser {
                    self.currentUser = user.toLoginUser()
                    self.isAuthenticated = authService.isAuthenticated
                }
            }
        } catch let error as LoginAuthError {
            self.error = error.localizedDescription
            throw error
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func registerWithApple() async throws {
        isLoading = true
        error = nil
        
        do {
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                self.currentUser = LoginUser(
                    id: UUID().uuidString,
                    name: "Apple User",
                    username: "appleuser\(Int.random(in: 1000...9999))",
                    email: "user@icloud.com",
                    bio: "Registered with Apple",
                    phoneNumber: "",
                    connections: 0
                )
                self.isAuthenticated = true
            } else {
                // 真实API模式
                try await authService.socialRegister(provider: "apple")
                if let user = authService.currentUser {
                    self.currentUser = user.toLoginUser()
                    self.isAuthenticated = authService.isAuthenticated
                }
            }
        } catch let error as LoginAuthError {
            self.error = error.localizedDescription
            throw error
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func registerWithEmail(_ email: String, username: String) async throws {
        isLoading = true
        error = nil
        
        do {
            // 验证邮箱格式
            if !isValidEmail(email) {
                throw LoginAuthError.invalidEmail
            }
            
            // 验证用户名
            if username.isEmpty || username.count < 3 {
                throw LoginAuthError.invalidUsername
            }
            
            if LoginModel.isDevelopmentMode {
                // 模拟模式
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                self.currentUser = LoginUser(
                    id: UUID().uuidString,
                    name: username,
                    username: username.lowercased(),
                    email: email,
                    bio: "New user",
                    phoneNumber: "",
                    connections: 0
                )
                self.isAuthenticated = true
            } else {
                // 真实API模式
                try await authService.register(email: email, password: "", username: username)
                if let user = authService.currentUser {
                    self.currentUser = user.toLoginUser()
                    self.isAuthenticated = authService.isAuthenticated
                }
            }
        } catch let error as LoginAuthError {
            self.error = error.localizedDescription
            throw error
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    // MARK: - Login Methods
    
    func signInWithEmail(_ email: String, rememberMe: Bool) async throws {
        isLoading = true
        error = nil
        
        do {
            // 验证邮箱格式
            if !isValidEmail(email) {
                throw LoginAuthError.invalidEmail
            }
            
            // TODO: 实现实际的邮箱登录逻辑
            // 这里应该调用你的后端 API
            try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟网络请求
            
            // 模拟成功登录
            self.currentUser = LoginUser(
                id: UUID().uuidString,
                name: "Test User",
                username: "testuser",
                email: email,
                bio: "This is a test user",
                phoneNumber: "+1234567890",
                connections: 0
            )
            self.isAuthenticated = true
            
            if rememberMe {
                // TODO: 保存登录状态
            }
        } catch let error as LoginAuthError {
            self.error = error.localizedDescription
            throw error
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func signInWithGoogle() async throws {
        isLoading = true
        error = nil
        
        do {
            // TODO: 实现 Google 登录逻辑
            try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟网络请求
            
            // 模拟成功登录
            self.currentUser = LoginUser(
                id: UUID().uuidString,
                name: "Google User",
                username: "googleuser",
                email: "google@example.com",
                bio: "This is a Google user",
                phoneNumber: "+1234567890",
                connections: 0
            )
            self.isAuthenticated = true
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func signInWithApple() async throws {
        isLoading = true
        error = nil
        
        do {
            // TODO: 实现 Apple 登录逻辑
            try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟网络请求
            
            // 模拟成功登录
            self.currentUser = LoginUser(
                id: UUID().uuidString,
                name: "Apple User",
                username: "appleuser",
                email: "apple@example.com",
                bio: "This is an Apple user",
                phoneNumber: "+1234567890",
                connections: 0
            )
            self.isAuthenticated = true
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func signInWithFacebook() async throws {
        isLoading = true
        error = nil
        
        do {
            // TODO: 实现 Facebook 登录逻辑
            try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟网络请求
            
            // 模拟成功登录
            self.currentUser = LoginUser(
                id: UUID().uuidString,
                name: "Facebook User",
                username: "facebookuser",
                email: "facebook@example.com",
                bio: "This is a Facebook user",
                phoneNumber: "+1234567890",
                connections: 0
            )
            self.isAuthenticated = true
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func verifyOTP(_ otp: String) async throws {
        isLoading = true
        error = nil
        
        do {
            // 验证 OTP 格式：必须是6位数字
            if otp.count != 6 || !otp.allSatisfy({ $0.isNumber }) {
                throw LoginAuthError.invalidOTP
            }
            
            // TODO: 实现 OTP 验证逻辑
            try await Task.sleep(nanoseconds: 1_000_000_000) // 模拟网络请求
            
            // 模拟成功验证
            self.isAuthenticated = true
        } catch let error as LoginAuthError {
            self.error = error.localizedDescription
            throw error
        } catch {
            self.error = LoginAuthError.unknown.localizedDescription
            throw LoginAuthError.unknown
        }
        
        isLoading = false
    }
    
    func signOut() {
        self.currentUser = nil
        self.isAuthenticated = false
        // TODO: 清除保存的登录状态
    }
    
    // MARK: - Helper Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
} 