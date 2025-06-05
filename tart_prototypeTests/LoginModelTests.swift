import XCTest
@testable import tart_prototype
import Combine

final class LoginModelTests: XCTestCase {
    
    // MARK: - Test Properties
    var loginModel: LoginModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        loginModel = LoginModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        loginModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func testLoginModelInitialState() {
        XCTAssertFalse(loginModel.isAuthenticated)
        XCTAssertNil(loginModel.currentUser)
        XCTAssertFalse(loginModel.isLoading)
        XCTAssertNil(loginModel.error)
    }
    
    // MARK: - Email Validation Tests
    func testEmailValidation() async {
        // Test valid emails
        let validEmails = [
            "test@example.com",
            "user.name@domain.co",
            "user+tag@example.org",
            "123@test.com"
        ]
        
        for email in validEmails {
            do {
                try await loginModel.signInWithEmail(email, rememberMe: false)
                XCTAssertTrue(loginModel.isAuthenticated, "Should authenticate with valid email: \(email)")
                XCTAssertNotNil(loginModel.currentUser)
                XCTAssertEqual(loginModel.currentUser?.email, email)
                
                // Reset for next test
                loginModel.signOut()
            } catch {
                XCTFail("Should not throw error for valid email: \(email)")
            }
        }
    }
    
    func testInvalidEmailValidation() async {
        let invalidEmails = [
            "invalid-email",
            "@example.com",
            "test@",
            "test.example.com",
            "",
            "test @example.com"
        ]
        
        for email in invalidEmails {
            do {
                try await loginModel.signInWithEmail(email, rememberMe: false)
                XCTFail("Should throw error for invalid email: \(email)")
            } catch LoginAuthError.invalidEmail {
                XCTAssertFalse(loginModel.isAuthenticated)
                XCTAssertNil(loginModel.currentUser)
                XCTAssertNotNil(loginModel.error)
            } catch {
                XCTFail("Should throw LoginAuthError.invalidEmail for invalid email: \(email)")
            }
        }
    }
    
    // MARK: - Authentication Tests
    func testSignInWithEmailSuccess() async {
        let expectation = XCTestExpectation(description: "Email sign in success")
        
        do {
            try await loginModel.signInWithEmail("test@example.com", rememberMe: true)
            
            XCTAssertTrue(loginModel.isAuthenticated)
            XCTAssertNotNil(loginModel.currentUser)
            XCTAssertEqual(loginModel.currentUser?.email, "test@example.com")
            XCTAssertFalse(loginModel.isLoading)
            XCTAssertNil(loginModel.error)
            
            expectation.fulfill()
        } catch {
            XCTFail("Email sign in should succeed")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testSignInWithGoogleSuccess() async {
        let expectation = XCTestExpectation(description: "Google sign in success")
        
        do {
            try await loginModel.signInWithGoogle()
            
            XCTAssertTrue(loginModel.isAuthenticated)
            XCTAssertNotNil(loginModel.currentUser)
            XCTAssertEqual(loginModel.currentUser?.email, "google@example.com")
            XCTAssertEqual(loginModel.currentUser?.username, "googleuser")
            XCTAssertFalse(loginModel.isLoading)
            XCTAssertNil(loginModel.error)
            
            expectation.fulfill()
        } catch {
            XCTFail("Google sign in should succeed")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testSignInWithAppleSuccess() async {
        let expectation = XCTestExpectation(description: "Apple sign in success")
        
        do {
            try await loginModel.signInWithApple()
            
            XCTAssertTrue(loginModel.isAuthenticated)
            XCTAssertNotNil(loginModel.currentUser)
            XCTAssertEqual(loginModel.currentUser?.email, "apple@example.com")
            XCTAssertEqual(loginModel.currentUser?.username, "appleuser")
            XCTAssertFalse(loginModel.isLoading)
            XCTAssertNil(loginModel.error)
            
            expectation.fulfill()
        } catch {
            XCTFail("Apple sign in should succeed")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testSignInWithFacebookSuccess() async {
        let expectation = XCTestExpectation(description: "Facebook sign in success")
        
        do {
            try await loginModel.signInWithFacebook()
            
            XCTAssertTrue(loginModel.isAuthenticated)
            XCTAssertNotNil(loginModel.currentUser)
            XCTAssertEqual(loginModel.currentUser?.email, "facebook@example.com")
            XCTAssertEqual(loginModel.currentUser?.username, "facebookuser")
            XCTAssertFalse(loginModel.isLoading)
            XCTAssertNil(loginModel.error)
            
            expectation.fulfill()
        } catch {
            XCTFail("Facebook sign in should succeed")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    // MARK: - OTP Tests
    func testVerifyOTPSuccess() async {
        let expectation = XCTestExpectation(description: "OTP verification success")
        
        do {
            try await loginModel.verifyOTP("123456")
            
            XCTAssertTrue(loginModel.isAuthenticated)
            XCTAssertFalse(loginModel.isLoading)
            XCTAssertNil(loginModel.error)
            
            expectation.fulfill()
        } catch {
            XCTFail("OTP verification should succeed")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testVerifyOTPValidFormats() async {
        let validOTPs = [
            ("123456", "Regular 6-digit number"),
            ("000000", "All zeros"),
            ("999999", "All nines"),
            ("012345", "Starting with zero"),
            ("100001", "Mixed digits")
        ]
        
        for (otp, description) in validOTPs {
            // Reset state before each test
            loginModel.signOut()
            
            do {
                try await loginModel.verifyOTP(otp)
                XCTAssertTrue(loginModel.isAuthenticated, "Should be authenticated after valid OTP: '\(otp)' (\(description))")
                XCTAssertFalse(loginModel.isLoading, "Should not be loading after valid OTP: '\(otp)' (\(description))")
                XCTAssertNil(loginModel.error, "Should have no error after valid OTP: '\(otp)' (\(description))")
            } catch {
                XCTFail("Valid OTP should succeed: '\(otp)' (\(description)), but got error: \(error)")
            }
        }
    }
    
    func testVerifyOTPInvalidFormat() async {
        let invalidOTPs = [
            ("12345", "Too short - 5 digits"),
            ("1234567", "Too long - 7 digits"), 
            ("abcdef", "Contains letters"),
            ("", "Empty string"),
            ("123", "Too short - 3 digits"),
            ("12345a", "Contains letter at end"),
            ("a12345", "Contains letter at start"),
            ("123 45", "Contains space"),
            ("123-45", "Contains dash"),
            ("123.45", "Contains dot")
        ]
        
        for (otp, description) in invalidOTPs {
            // Reset state before each test
            loginModel.signOut()
            
            do {
                try await loginModel.verifyOTP(otp)
                XCTFail("Should throw error for invalid OTP: '\(otp)' (\(description))")
            } catch LoginAuthError.invalidOTP {
                // Expected behavior
                XCTAssertFalse(loginModel.isAuthenticated, "Should not be authenticated after invalid OTP: '\(otp)' (\(description))")
                XCTAssertNotNil(loginModel.error, "Should have error message for invalid OTP: '\(otp)' (\(description))")
            } catch {
                XCTFail("Should throw LoginAuthError.invalidOTP for invalid OTP: '\(otp)' (\(description)), but got: \(error)")
            }
        }
    }
    
    // MARK: - Sign Out Tests
    func testSignOut() async {
        // First sign in
        try? await loginModel.signInWithEmail("test@example.com", rememberMe: false)
        XCTAssertTrue(loginModel.isAuthenticated)
        XCTAssertNotNil(loginModel.currentUser)
        
        // Then sign out
        loginModel.signOut()
        
        XCTAssertFalse(loginModel.isAuthenticated)
        XCTAssertNil(loginModel.currentUser)
    }
    
    // MARK: - Loading State Tests
    func testLoadingStateDuringSignIn() async {
        let expectation = XCTestExpectation(description: "Loading state test")
        
        // Monitor loading state changes
        var loadingStates: [Bool] = []
        
        loginModel.$isLoading
            .sink { isLoading in
                loadingStates.append(isLoading)
            }
            .store(in: &cancellables)
        
        Task {
            try? await loginModel.signInWithEmail("test@example.com", rememberMe: false)
            
            // Check that loading was true during operation and false after
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertTrue(loadingStates.contains(true), "Loading should be true during operation")
                XCTAssertFalse(self.loginModel.isLoading, "Loading should be false after operation")
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    // MARK: - Error Handling Tests
    func testErrorStateClearing() async {
        // First cause an error
        try? await loginModel.signInWithEmail("invalid-email", rememberMe: false)
        XCTAssertNotNil(loginModel.error)
        
        // Then perform successful operation
        try? await loginModel.signInWithEmail("valid@example.com", rememberMe: false)
        XCTAssertNil(loginModel.error)
    }
    
    // MARK: - Remember Me Tests
    func testRememberMeFunctionality() async {
        // Test with remember me true
        try? await loginModel.signInWithEmail("test@example.com", rememberMe: true)
        XCTAssertTrue(loginModel.isAuthenticated)
        
        // Test with remember me false
        loginModel.signOut()
        try? await loginModel.signInWithEmail("test@example.com", rememberMe: false)
        XCTAssertTrue(loginModel.isAuthenticated)
    }
    
    // MARK: - User Data Tests
    func testUserDataCreation() async {
        try? await loginModel.signInWithEmail("test@example.com", rememberMe: false)
        
        guard let user = loginModel.currentUser else {
            XCTFail("User should not be nil after successful sign in")
            return
        }
        
        XCTAssertFalse(user.id.isEmpty)
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.bio, "This is a test user")
        XCTAssertEqual(user.phoneNumber, "+1234567890")
        XCTAssertEqual(user.connections, 0)
    }
} 