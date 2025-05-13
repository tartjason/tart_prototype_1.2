import Foundation

enum NetworkEnvironment {
    case development
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .development:
            return "http://localhost:8080/api"
        case .staging:
            return "https://staging-api.tart.com/api"
        case .production:
            return "https://api.tart.com/api"
        }
    }
}

struct NetworkConfig {
    static let shared = NetworkConfig()
    
    let environment: NetworkEnvironment
    let apiVersion: String
    let timeoutInterval: TimeInterval
    
    private init() {
        #if DEBUG
        self.environment = .development
        #else
        self.environment = .production
        #endif
        
        self.apiVersion = "v1"
        self.timeoutInterval = 30
    }
    
    var baseURL: URL {
        URL(string: "\(environment.baseURL)/\(apiVersion)")!
    }
    
    var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": Locale.current.languageCode ?? "en"
        ]
    }
} 