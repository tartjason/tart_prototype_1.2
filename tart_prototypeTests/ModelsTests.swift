import XCTest
@testable import tart_prototype

final class ModelsTests: XCTestCase {
    
    // MARK: - User Model Tests
    func testUserInitialization() {
        let now = Date()
        let user = User(
            id: "test-id",
            email: "test@example.com",
            username: "testuser",
            profileImageURL: "https://example.com/image.jpg",
            bio: "Test bio",
            createdAt: now,
            updatedAt: now
        )
        
        XCTAssertEqual(user.id, "test-id")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.profileImageURL, "https://example.com/image.jpg")
        XCTAssertEqual(user.bio, "Test bio")
        XCTAssertEqual(user.createdAt, now)
        XCTAssertEqual(user.updatedAt, now)
    }
    
    func testUserEquality() {
        let user1 = User(id: "1", email: "test1@example.com", username: "user1")
        let user2 = User(id: "1", email: "test2@example.com", username: "user2")
        let user3 = User(id: "2", email: "test1@example.com", username: "user1")
        
        // Test equality based on id
        XCTAssertEqual(user1, user2) // Same id should be equal
        XCTAssertNotEqual(user1, user3) // Different id should not be equal
    }
    
    func testUserCoding() throws {
        let originalUser = User(
            id: "test-id",
            email: "test@example.com",
            username: "testuser"
        )
        
        // Encode to JSON
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalUser)
        
        // Decode from JSON
        let decoder = JSONDecoder()
        let decodedUser = try decoder.decode(User.self, from: data)
        
        // Verify decoded user matches original
        XCTAssertEqual(originalUser, decodedUser)
        XCTAssertEqual(originalUser.email, decodedUser.email)
        XCTAssertEqual(originalUser.username, decodedUser.username)
    }
} 