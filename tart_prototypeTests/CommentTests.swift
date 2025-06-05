import XCTest
@testable import tart_prototype

final class CommentTests: XCTestCase {
    
    // MARK: - Test Properties
    var sampleComment: Comment!
    let testDate = Date()
    
    override func setUp() {
        super.setUp()
        sampleComment = Comment(
            id: "comment1",
            content: "This is a great artwork!",
            username: "artlover123",
            createdAt: testDate
        )
    }
    
    override func tearDown() {
        sampleComment = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testCommentInitialization() {
        XCTAssertEqual(sampleComment.id, "comment1")
        XCTAssertEqual(sampleComment.content, "This is a great artwork!")
        XCTAssertEqual(sampleComment.username, "artlover123")
        XCTAssertEqual(sampleComment.createdAt, testDate)
    }
    
    func testCommentInitializationWithEmptyContent() {
        let emptyComment = Comment(
            id: "empty1",
            content: "",
            username: "user",
            createdAt: Date()
        )
        
        XCTAssertEqual(emptyComment.content, "")
        XCTAssertFalse(emptyComment.content.isEmpty == false)
    }
    
    // MARK: - Equality Tests
    func testCommentEquality() {
        let comment1 = Comment(
            id: "1",
            content: "Content 1",
            username: "user1",
            createdAt: Date()
        )
        
        let comment2 = Comment(
            id: "1", // Same ID
            content: "Different Content",
            username: "different user",
            createdAt: Date()
        )
        
        let comment3 = Comment(
            id: "2", // Different ID
            content: "Content 1",
            username: "user1",
            createdAt: Date()
        )
        
        XCTAssertEqual(comment1, comment2) // Same ID should be equal
        XCTAssertNotEqual(comment1, comment3) // Different ID should not be equal
    }
    
    // MARK: - Hashable Tests
    func testCommentHashable() {
        let comment1 = Comment(id: "1", content: "test", username: "user", createdAt: Date())
        let comment2 = Comment(id: "1", content: "different", username: "different", createdAt: Date())
        let comment3 = Comment(id: "2", content: "test", username: "user", createdAt: Date())
        
        // Test that comments with same ID can be used in sets (hashable behavior)
        let commentSet1 = Set([comment1, comment2])
        XCTAssertEqual(commentSet1.count, 1) // Should only contain one comment since they have the same ID
        
        let commentSet2 = Set([comment1, comment3])
        XCTAssertEqual(commentSet2.count, 2) // Should contain two comments since they have different IDs
        
        // Test hash consistency
        var hasher1 = Hasher()
        comment1.hash(into: &hasher1)
        let hash1 = hasher1.finalize()
        
        var hasher2 = Hasher()
        comment2.hash(into: &hasher2)
        let hash2 = hasher2.finalize()
        
        var hasher3 = Hasher()
        comment3.hash(into: &hasher3)
        let hash3 = hasher3.finalize()
        
        XCTAssertEqual(hash1, hash2) // Same ID should have same hash
        XCTAssertNotEqual(hash1, hash3) // Different ID should have different hash
    }
    
    // MARK: - Codable Tests
    func testCommentCoding() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(sampleComment)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedComment = try decoder.decode(Comment.self, from: data)
        
        XCTAssertEqual(sampleComment.id, decodedComment.id)
        XCTAssertEqual(sampleComment.content, decodedComment.content)
        XCTAssertEqual(sampleComment.username, decodedComment.username)
        XCTAssertEqual(sampleComment.createdAt.timeIntervalSince1970, decodedComment.createdAt.timeIntervalSince1970, accuracy: 1.0)
    }
    
    // MARK: - Content Validation Tests
    func testCommentContentValidation() {
        // Test with special characters
        let specialComment = Comment(
            id: "special1",
            content: "Amazing! 🎨✨ This artwork is fantastic! @artist #beautiful",
            username: "user123",
            createdAt: Date()
        )
        
        XCTAssertFalse(specialComment.content.isEmpty)
        XCTAssertTrue(specialComment.content.contains("🎨"))
        XCTAssertTrue(specialComment.content.contains("@artist"))
        XCTAssertTrue(specialComment.content.contains("#beautiful"))
    }
    
    func testCommentUsernameValidation() {
        // Test different username formats
        let usernames = ["user123", "artist_name", "user-123", "User.Name"]
        
        for username in usernames {
            let comment = Comment(
                id: "test\(username)",
                content: "Test content",
                username: username,
                createdAt: Date()
            )
            
            XCTAssertEqual(comment.username, username)
            XCTAssertFalse(comment.username.isEmpty)
        }
    }
    
    // MARK: - Date Tests
    func testCommentDateHandling() {
        let pastDate = Date(timeIntervalSinceNow: -86400) // 1 day ago
        let futureDate = Date(timeIntervalSinceNow: 86400) // 1 day from now
        
        let pastComment = Comment(id: "past", content: "Past", username: "user", createdAt: pastDate)
        let futureComment = Comment(id: "future", content: "Future", username: "user", createdAt: futureDate)
        
        XCTAssertTrue(pastComment.createdAt < Date())
        XCTAssertTrue(futureComment.createdAt > Date())
    }
} 