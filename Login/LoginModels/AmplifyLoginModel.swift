import Foundation
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

// MARK: - Amplify Login Model

class AmplifyLoginModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var isAuthenticated = false {
        didSet {
            if isAuthenticated != oldValue {
                NotificationCenter.default.post(
                    name: .authenticationStateChanged,
                    object: nil,
                    userInfo: ["isAuthenticated": isAuthenticated]
                )
            }
        }
    }
    @Published var currentUser: LoginUser?
    @Published var isLoading = false
    @Published var error: String?
    @Published var needsEmailConfirmation = false
    @Published var needsMFAConfirmation = false
    @Published var pendingEmail = ""
    
    // MARK: - Private Properties
    
    private var pendingSignUpResult: AuthSignUpResult?
    private var pendingSignInResult: AuthSignInResult?
    
    // MARK: - Initialization
    
    init() {
        checkAuthenticationState()
        setupAuthListener()
    }
    
    // MARK: - Authentication State Management
    
    /// 检查当前认证状态
    private func checkAuthenticationState() {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                
                await MainActor.run {
                    isAuthenticated = session.isSignedIn
                    isLoading = false
                }
                
                if session.isSignedIn {
                    await loadCurrentUser()
                }
            } catch {
                await MainActor.run {
                    isAuthenticated = false
                    isLoading = false
                    self.error = "Failed to check auth state: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// 设置认证状态监听器
    private func setupAuthListener() {
        Task {
            for await authUpdate in Amplify.Hub.publisher(for: .auth).values {
                switch authUpdate.eventName {
                case HubPayload.EventName.Auth.signedIn:
                    print("User signed in")
                    await MainActor.run {
                        isAuthenticated = true
                    }
                    await loadCurrentUser()
                    
                case HubPayload.EventName.Auth.signedOut:
                    print("User signed out")
                    await MainActor.run {
                        isAuthenticated = false
                        currentUser = nil
                    }
                    
                case HubPayload.EventName.Auth.sessionExpired:
                    print("Session expired")
                    await MainActor.run {
                        isAuthenticated = false
                        currentUser = nil
                        error = "Session expired. Please sign in again."
                    }
                    
                default:
                    break
                }
            }
        }
    }
    
    /// 加载当前用户信息
    private func loadCurrentUser() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            
            // 从属性中提取用户信息
            let email = attributes.first { $0.key == .email }?.value ?? ""
            let name = attributes.first { $0.key == .name }?.value ?? user.username
            let preferredUsername = attributes.first { $0.key == .preferredUsername }?.value ?? user.username
            
            await MainActor.run {
                currentUser = LoginUser(
                    id: user.userId,
                    name: name,
                    username: preferredUsername,
                    email: email,
                    bio: "",
                    phoneNumber: "",
                    connections: 0
                )
            }
        } catch {
            await MainActor.run {
                self.error = "Failed to load user: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Registration Methods
    
    /// 邮箱注册
    func signUpWithEmail(_ email: String, password: String, username: String) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
            pendingEmail = email
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let userAttributes = [
                AuthUserAttribute(.email, value: email),
                AuthUserAttribute(.preferredUsername, value: username)
            ]
            
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            
            let result = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )
            
            pendingSignUpResult = result
            
            await MainActor.run {
                if case .confirmUser = result.nextStep {
                    needsEmailConfirmation = true
                } else {
                    isAuthenticated = true
                }
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
            throw LoginAuthError.unknown
        }
    }
    
    /// 确认邮箱注册
    func confirmSignUp(confirmationCode: String) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let result = try await Amplify.Auth.confirmSignUp(
                for: pendingEmail,
                confirmationCode: confirmationCode
            )
            
            await MainActor.run {
                needsEmailConfirmation = false
                
                if result.isSignUpComplete {
                    // 注册完成，自动登录
                    isAuthenticated = true
                }
            }
            
            if result.isSignUpComplete {
                await loadCurrentUser()
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    /// 重新发送确认邮件
    func resendSignUpCode() async throws {
        do {
            try await Amplify.Auth.resendSignUpCode(for: pendingEmail)
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    // MARK: - Sign In Methods
    
    /// 邮箱登录
    func signInWithEmail(_ email: String, password: String) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
            pendingEmail = email
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let result = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            
            pendingSignInResult = result
            
            await MainActor.run {
                switch result.nextStep {
                case .confirmSignInWithSMSMFACode(_, _):
                    needsMFAConfirmation = true
                case .done:
                    isAuthenticated = true
                default:
                    break
                }
            }
            
            if result.isSignedIn {
                await loadCurrentUser()
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    /// 确认MFA
    func confirmSignIn(challengeResponse: String) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let result = try await Amplify.Auth.confirmSignIn(
                challengeResponse: challengeResponse
            )
            
            await MainActor.run {
                needsMFAConfirmation = false
                
                if result.isSignedIn {
                    isAuthenticated = true
                }
            }
            
            if result.isSignedIn {
                await loadCurrentUser()
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    // MARK: - Social Sign In Methods
    
    /// Google 登录
    func signInWithGoogle(presentationAnchor: UIWindow) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let result = try await Amplify.Auth.signInWithWebUI(
                for: .google,
                presentationAnchor: presentationAnchor
            )
            
            await MainActor.run {
                isAuthenticated = result.isSignedIn
            }
            
            if result.isSignedIn {
                await loadCurrentUser()
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    /// Apple 登录
    func signInWithApple(presentationAnchor: UIWindow) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let result = try await Amplify.Auth.signInWithWebUI(
                for: .apple,
                presentationAnchor: presentationAnchor
            )
            
            await MainActor.run {
                isAuthenticated = result.isSignedIn
            }
            
            if result.isSignedIn {
                await loadCurrentUser()
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    /// Facebook 登录
    func signInWithFacebook(presentationAnchor: UIWindow) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            let result = try await Amplify.Auth.signInWithWebUI(
                for: .facebook,
                presentationAnchor: presentationAnchor
            )
            
            await MainActor.run {
                isAuthenticated = result.isSignedIn
            }
            
            if result.isSignedIn {
                await loadCurrentUser()
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    // MARK: - Password Reset
    
    /// 请求密码重置
    func resetPassword(for email: String) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
            pendingEmail = email
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            try await Amplify.Auth.resetPassword(for: email)
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    /// 确认密码重置
    func confirmResetPassword(newPassword: String, confirmationCode: String) async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: pendingEmail,
                with: newPassword,
                confirmationCode: confirmationCode
            )
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    // MARK: - Sign Out
    
    /// 登出
    func signOut() async throws {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in isLoading = false }
        }
        
        do {
            _ = try await Amplify.Auth.signOut()
            
            await MainActor.run {
                isAuthenticated = false
                currentUser = nil
                needsEmailConfirmation = false
                needsMFAConfirmation = false
                pendingEmail = ""
            }
            
        } catch let error as AuthError {
            await MainActor.run {
                self.error = mapAuthError(error)
            }
            throw LoginAuthError.from(authError: error)
        }
    }
    
    // MARK: - Helper Methods
    
    /// 映射 Amplify 错误到本地错误
    private func mapAuthError(_ error: AuthError) -> String {
        // 使用错误的本地化描述，这在所有版本中都是可用的
        return error.localizedDescription
    }
    
    /// 清理状态
    func clearState() {
        error = nil
        needsEmailConfirmation = false
        needsMFAConfirmation = false
        pendingEmail = ""
        pendingSignUpResult = nil
        pendingSignInResult = nil
    }
}

// MARK: - LoginAuthError Extension

extension LoginAuthError {
    static func from(authError: AuthError) -> LoginAuthError {
        // 使用错误描述来判断错误类型，这样更兼容不同版本的 Amplify SDK
        let errorDescription = authError.localizedDescription
        let lowercaseDescription = errorDescription.lowercased()
        
        if lowercaseDescription.contains("invalid") || lowercaseDescription.contains("parameter") {
            return .invalidEmail
        } else if lowercaseDescription.contains("not authorized") || lowercaseDescription.contains("unauthorized") {
            return .invalidPassword
        } else if lowercaseDescription.contains("not confirmed") || lowercaseDescription.contains("unconfirmed") {
            return .invalidOTP
        } else if lowercaseDescription.contains("not signed in") || lowercaseDescription.contains("not found") {
            return .userNotFound
        } else {
            return .unknown
        }
    }
} 
