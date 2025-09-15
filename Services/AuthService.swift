import Foundation
import Combine

enum AuthError: Error {
    case invalidCredentials
    case networkError(Error)
    case tokenExpired
    case unauthorized
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .tokenExpired:
            return "Session expired. Please login again"
        case .unauthorized:
            return "Unauthorized access"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var error: AuthError?
    
    private let networkConfig: NetworkConfig
    private let storageService: StorageService
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private var accessToken: String? {
        get { UserDefaults.standard.string(forKey: "accessToken") }
        set { UserDefaults.standard.set(newValue, forKey: "accessToken") }
    }
    
    private var refreshToken: String? {
        get { UserDefaults.standard.string(forKey: "refreshToken") }
        set { UserDefaults.standard.set(newValue, forKey: "refreshToken") }
    }
    
    private init(networkConfig: NetworkConfig = .shared,
         storageService: StorageService = .shared,
         session: URLSession = .shared) {
        self.networkConfig = networkConfig
        self.storageService = storageService
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        // 检查是否有保存的token
        if accessToken != nil {
            Task {
                await validateToken()
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    func login(email: String, password: String) async throws {
        let url = networkConfig.baseURL.appendingPathComponent("auth/login")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = networkConfig.headers
        
        let loginData = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: loginData)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.unknown
            }
            
            switch httpResponse.statusCode {
            case 200:
                let authResponse = try decoder.decode(AuthResponse.self, from: data)
                await MainActor.run {
                    self.accessToken = authResponse.accessToken
                    self.refreshToken = authResponse.refreshToken
                    self.currentUser = authResponse.user
                    self.isAuthenticated = true
                }
            case 401:
                throw AuthError.invalidCredentials
            default:
                throw AuthError.unknown
            }
        } catch let error as AuthError {
            await MainActor.run { self.error = error }
            throw error
        } catch {
            let authError = AuthError.networkError(error)
            await MainActor.run { self.error = authError }
            throw authError
        }
    }
    
    func register(email: String, password: String, username: String) async throws {
        let url = networkConfig.baseURL.appendingPathComponent("auth/register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = networkConfig.headers
        
        let registerData = [
            "email": email,
            "password": password,
            "username": username
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: registerData)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.unknown
            }
            
            switch httpResponse.statusCode {
            case 201:
                let authResponse = try decoder.decode(AuthResponse.self, from: data)
                await MainActor.run {
                    self.accessToken = authResponse.accessToken
                    self.refreshToken = authResponse.refreshToken
                    self.currentUser = authResponse.user
                    self.isAuthenticated = true
                }
            case 409:
                throw AuthError.invalidCredentials // Email already exists
            default:
                throw AuthError.unknown
            }
        } catch let error as AuthError {
            await MainActor.run { self.error = error }
            throw error
        } catch {
            let authError = AuthError.networkError(error)
            await MainActor.run { self.error = authError }
            throw authError
        }
    }
    
    func socialRegister(provider: String) async throws {
        let url = networkConfig.baseURL.appendingPathComponent("auth/social/\(provider)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = networkConfig.headers
        
        let socialData = [
            "provider": provider,
            "access_token": "mock_token" // 在实际使用中，这里应该是从社交平台获取的token
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: socialData)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.unknown
            }
            
            switch httpResponse.statusCode {
            case 200, 201:
                let authResponse = try decoder.decode(AuthResponse.self, from: data)
                await MainActor.run {
                    self.accessToken = authResponse.accessToken
                    self.refreshToken = authResponse.refreshToken
                    self.currentUser = authResponse.user
                    self.isAuthenticated = true
                }
            case 409:
                throw AuthError.invalidCredentials // User already exists
            default:
                throw AuthError.unknown
            }
        } catch let error as AuthError {
            await MainActor.run { self.error = error }
            throw error
        } catch {
            let authError = AuthError.networkError(error)
            await MainActor.run { self.error = authError }
            throw authError
        }
    }
    
    func logout() {
        accessToken = nil
        refreshToken = nil
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - Token Management
    
    private func validateToken() async {
        guard let token = accessToken else {
            await MainActor.run { self.isAuthenticated = false }
            return
        }
        
        let url = networkConfig.baseURL.appendingPathComponent("auth/validate")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = networkConfig.headers
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.unknown
            }
            
            switch httpResponse.statusCode {
            case 200:
                let user = try decoder.decode(User.self, from: data)
                await MainActor.run {
                    self.currentUser = user
                    self.isAuthenticated = true
                }
            case 401:
                await refreshAccessToken()
            default:
                throw AuthError.unknown
            }
        } catch {
            await MainActor.run {
                self.isAuthenticated = false
                self.error = .tokenExpired
            }
        }
    }
    
    private func refreshAccessToken() async {
        guard let refreshToken = refreshToken else {
            await MainActor.run { self.isAuthenticated = false }
            return
        }
        
        let url = networkConfig.baseURL.appendingPathComponent("auth/refresh")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = networkConfig.headers
        
        let refreshData = ["refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: refreshData)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.unknown
            }
            
            switch httpResponse.statusCode {
            case 200:
                let authResponse = try decoder.decode(AuthResponse.self, from: data)
                await MainActor.run {
                    self.accessToken = authResponse.accessToken
                    self.refreshToken = authResponse.refreshToken
                    self.currentUser = authResponse.user
                    self.isAuthenticated = true
                }
            default:
                throw AuthError.tokenExpired
            }
        } catch {
            await MainActor.run {
                self.isAuthenticated = false
                self.error = .tokenExpired
            }
        }
    }
    
    // MARK: - Request Authorization
    
    func authorizedRequest(_ request: URLRequest) -> URLRequest {
        var authorizedRequest = request
        if let token = accessToken {
            authorizedRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return authorizedRequest
    }
}

// MARK: - Response Models

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: User
} 