import Foundation

enum LoginAuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case networkError
    case invalidOTP
    case otpExpired
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email address"
        case .invalidPassword:
            return "Invalid password"
        case .userNotFound:
            return "User not found"
        case .networkError:
            return "Network error occurred"
        case .invalidOTP:
            return "Invalid OTP code"
        case .otpExpired:
            return "OTP code has expired"
        case .unknown:
            return "An unknown error occurred"
        }
    }
} 