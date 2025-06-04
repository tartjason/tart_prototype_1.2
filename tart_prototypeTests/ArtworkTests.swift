import XCTest
@testable import tart_prototype

final class ArtworkTests: XCTestCase {
    
    // MARK: - Test Properties
    var sampleArtwork: Artwork!
    var sampleComments: [Comment]!
    let testDate = Date()
    
    override func setUp() {
        super.setUp()
        
        // 创建测试评论
        sampleComments = [
            Comment(id: "comment1", content: "Beautiful work!", username: "user1", createdAt: testDate),
            Comment(id: "comment2", content: "Love the colors!", username: "user2", createdAt: testDate)
        ]
        
        // 创建测试艺术作品
        sampleArtwork = Artwork(
            id: "artwork1",
            imageURL: "https://example.com/artwork.jpg",
            title: "Test Artwork",
            artist: "Test Artist",
            medium: "Oil on Canvas",
            description: "A beautiful test artwork",
            inspiration: "Inspired by nature",
            relatedImages: ["https://example.com/related1.jpg", "https://example.com/related2.jpg"],
            location: "New York, NY",
            createdAt: testDate,
            likes: 42,
            isLiked: false,
            isSaved: false,
            comments: sampleComments
        )
    }
    
    override func tearDown() {
        sampleArtwork = nil
        sampleComments = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    func testArtworkInitialization() {
        XCTAssertEqual(sampleArtwork.id, "artwork1")
        XCTAssertEqual(sampleArtwork.imageURL, "https://example.com/artwork.jpg")
        XCTAssertEqual(sampleArtwork.title, "Test Artwork")
        XCTAssertEqual(sampleArtwork.artist, "Test Artist")
        XCTAssertEqual(sampleArtwork.medium, "Oil on Canvas")
        XCTAssertEqual(sampleArtwork.description, "A beautiful test artwork")
        XCTAssertEqual(sampleArtwork.inspiration, "Inspired by nature")
        XCTAssertEqual(sampleArtwork.location, "New York, NY")
        XCTAssertEqual(sampleArtwork.likes, 42)
        XCTAssertFalse(sampleArtwork.isLiked)
        XCTAssertFalse(sampleArtwork.isSaved)
        XCTAssertEqual(sampleArtwork.comments.count, 2)
        XCTAssertEqual(sampleArtwork.relatedImages.count, 2)
    }
    
    // MARK: - Equality Tests
    func testArtworkEquality() {
        let artwork1 = Artwork(
            id: "1",
            imageURL: "url1",
            title: "Art 1",
            artist: "Artist 1",
            medium: "Medium 1",
            description: "Description 1",
            inspiration: "Inspiration 1",
            relatedImages: [],
            location: "Location 1",
            createdAt: Date(),
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        )
        
        let artwork2 = Artwork(
            id: "1", // Same ID
            imageURL: "different_url",
            title: "Different Title",
            artist: "Different Artist",
            medium: "Different Medium",
            description: "Different Description",
            inspiration: "Different Inspiration",
            relatedImages: ["different"],
            location: "Different Location",
            createdAt: Date(),
            likes: 100,
            isLiked: true,
            isSaved: true,
            comments: sampleComments
        )
        
        XCTAssertEqual(artwork1, artwork2) // Should be equal because they have the same ID
    }
    
    // MARK: - Hashable Tests
    func testArtworkHashable() {
        let artwork1 = Artwork(id: "1", imageURL: "", title: "", artist: "", medium: "", description: "", inspiration: "", relatedImages: [], location: "", createdAt: Date(), likes: 0, isLiked: false, isSaved: false, comments: [])
        let artwork2 = Artwork(id: "1", imageURL: "different", title: "different", artist: "different", medium: "different", description: "different", inspiration: "different", relatedImages: ["different"], location: "different", createdAt: Date(), likes: 999, isLiked: true, isSaved: true, comments: sampleComments)
        let artwork3 = Artwork(id: "2", imageURL: "", title: "", artist: "", medium: "", description: "", inspiration: "", relatedImages: [], location: "", createdAt: Date(), likes: 0, isLiked: false, isSaved: false, comments: [])
        
        // Test hashable behavior using Sets
        let artworkSet1 = Set([artwork1, artwork2])
        XCTAssertEqual(artworkSet1.count, 1) // Should only contain one artwork since they have the same ID
        
        let artworkSet2 = Set([artwork1, artwork3])
        XCTAssertEqual(artworkSet2.count, 2) // Should contain two artworks since they have different IDs
        
        // Test hash consistency
        var hasher1 = Hasher()
        artwork1.hash(into: &hasher1)
        let hash1 = hasher1.finalize()
        
        var hasher2 = Hasher()
        artwork2.hash(into: &hasher2)
        let hash2 = hasher2.finalize()
        
        var hasher3 = Hasher()
        artwork3.hash(into: &hasher3)
        let hash3 = hasher3.finalize()
        
        XCTAssertEqual(hash1, hash2) // Same ID should have same hash
        XCTAssertNotEqual(hash1, hash3) // Different ID should have different hash
    }
    
    // MARK: - Codable Tests
    func testArtworkCoding() throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(sampleArtwork)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedArtwork = try decoder.decode(Artwork.self, from: data)
        
        XCTAssertEqual(sampleArtwork.id, decodedArtwork.id)
        XCTAssertEqual(sampleArtwork.title, decodedArtwork.title)
        XCTAssertEqual(sampleArtwork.artist, decodedArtwork.artist)
        XCTAssertEqual(sampleArtwork.medium, decodedArtwork.medium)
        XCTAssertEqual(sampleArtwork.description, decodedArtwork.description)
        XCTAssertEqual(sampleArtwork.inspiration, decodedArtwork.inspiration)
        XCTAssertEqual(sampleArtwork.location, decodedArtwork.location)
        XCTAssertEqual(sampleArtwork.likes, decodedArtwork.likes)
        XCTAssertEqual(sampleArtwork.isLiked, decodedArtwork.isLiked)
        XCTAssertEqual(sampleArtwork.isSaved, decodedArtwork.isSaved)
        XCTAssertEqual(sampleArtwork.comments.count, decodedArtwork.comments.count)
        XCTAssertEqual(sampleArtwork.relatedImages.count, decodedArtwork.relatedImages.count)
    }
    
    // MARK: - Likes Functionality Tests
    func testArtworkLikesFunctionality() {
        var artwork = sampleArtwork!
        
        XCTAssertEqual(artwork.likes, 42)
        XCTAssertFalse(artwork.isLiked)
        
        // Test manual like changes
        artwork.likes += 1
        artwork.isLiked = true
        
        XCTAssertEqual(artwork.likes, 43)
        XCTAssertTrue(artwork.isLiked)
        
        // Test unlike
        artwork.likes -= 1
        artwork.isLiked = false
        
        XCTAssertEqual(artwork.likes, 42)
        XCTAssertFalse(artwork.isLiked)
    }
    
    // MARK: - Save Functionality Tests
    func testArtworkSaveFunctionality() {
        var artwork = sampleArtwork!
        
        XCTAssertFalse(artwork.isSaved)
        
        artwork.isSaved = true
        XCTAssertTrue(artwork.isSaved)
        
        artwork.isSaved = false
        XCTAssertFalse(artwork.isSaved)
    }
    
    // MARK: - Comments Tests
    func testArtworkCommentsManagement() {
        var artwork = sampleArtwork!
        
        XCTAssertEqual(artwork.comments.count, 2)
        
        let newComment = Comment(
            id: "comment3",
            content: "Amazing technique!",
            username: "user3",
            createdAt: Date()
        )
        
        artwork.comments.append(newComment)
        XCTAssertEqual(artwork.comments.count, 3)
        XCTAssertEqual(artwork.comments.last?.id, "comment3")
    }
    
    // MARK: - Related Images Tests
    func testArtworkRelatedImages() {
        XCTAssertEqual(sampleArtwork.relatedImages.count, 2)
        XCTAssertTrue(sampleArtwork.relatedImages.contains("https://example.com/related1.jpg"))
        XCTAssertTrue(sampleArtwork.relatedImages.contains("https://example.com/related2.jpg"))
        
        // Test creating a new artwork with different related images
        let artworkWithMoreImages = Artwork(
            id: "artwork2",
            imageURL: "https://example.com/artwork2.jpg",
            title: "Test Artwork 2",
            artist: "Test Artist 2",
            medium: "Digital Art",
            description: "Another test artwork",
            inspiration: "Inspired by technology",
            relatedImages: [
                "https://example.com/related1.jpg",
                "https://example.com/related2.jpg", 
                "https://example.com/related3.jpg"
            ],
            location: "San Francisco, CA",
            createdAt: Date(),
            likes: 10,
            isLiked: false,
            isSaved: false,
            comments: []
        )
        
        XCTAssertEqual(artworkWithMoreImages.relatedImages.count, 3)
        XCTAssertTrue(artworkWithMoreImages.relatedImages.contains("https://example.com/related3.jpg"))
    }
    
    // MARK: - Validation Tests
    func testArtworkValidation() {
        // Test empty values
        let emptyArtwork = Artwork(
            id: "",
            imageURL: "",
            title: "",
            artist: "",
            medium: "",
            description: "",
            inspiration: "",
            relatedImages: [],
            location: "",
            createdAt: Date(),
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        )
        
        XCTAssertTrue(emptyArtwork.title.isEmpty)
        XCTAssertTrue(emptyArtwork.relatedImages.isEmpty)
        XCTAssertTrue(emptyArtwork.comments.isEmpty)
        XCTAssertEqual(emptyArtwork.likes, 0)
    }
    
    // MARK: - Date Tests
    func testArtworkDateHandling() {
        let pastDate = Date(timeIntervalSinceNow: -86400)
        let artwork = Artwork(
            id: "test",
            imageURL: "",
            title: "Past Artwork",
            artist: "Artist",
            medium: "Medium",
            description: "Description",
            inspiration: "Inspiration",
            relatedImages: [],
            location: "Location",
            createdAt: pastDate,
            likes: 0,
            isLiked: false,
            isSaved: false,
            comments: []
        )
        
        XCTAssertTrue(artwork.createdAt < Date())
    }
} 