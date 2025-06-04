import XCTest
@testable import tart_prototype
import UIKit

final class MessageBaseModelsTests: XCTestCase {
    
    // MARK: - Test Properties
    var sampleUser: User!
    var testDate: Date!
    
    override func setUp() {
        super.setUp()
        sampleUser = User(id: "user1", email: "test@example.com", username: "testuser")
        testDate = Date()
    }
    
    override func tearDown() {
        sampleUser = nil
        testDate = nil
        super.tearDown()
    }
    
    // MARK: - MessageType Tests
    func testMessageTypeEquality() {
        let textMessage1 = MessageType.text("Hello")
        let textMessage2 = MessageType.text("Hello")
        let textMessage3 = MessageType.text("World")
        
        XCTAssertEqual(textMessage1, textMessage2)
        XCTAssertNotEqual(textMessage1, textMessage3)
        
        let location1 = MessageType.location(latitude: 40.7128, longitude: -74.0060)
        let location2 = MessageType.location(latitude: 40.7128, longitude: -74.0060)
        let location3 = MessageType.location(latitude: 34.0522, longitude: -118.2437)
        
        XCTAssertEqual(location1, location2)
        XCTAssertNotEqual(location1, location3)
    }
    
    func testMessageTypeHashable() {
        let textMessage1 = MessageType.text("Hello")
        let textMessage2 = MessageType.text("Hello")
        let textMessage3 = MessageType.text("World")
        
        // Test hashable behavior using Sets
        let messageSet1 = Set([textMessage1, textMessage2])
        XCTAssertEqual(messageSet1.count, 1) // Should only contain one message since they are equal
        
        let messageSet2 = Set([textMessage1, textMessage3])
        XCTAssertEqual(messageSet2.count, 2) // Should contain two messages since they are different
        
        // Test hash consistency
        var hasher1 = Hasher()
        textMessage1.hash(into: &hasher1)
        let hash1 = hasher1.finalize()
        
        var hasher2 = Hasher()
        textMessage2.hash(into: &hasher2)
        let hash2 = hasher2.finalize()
        
        var hasher3 = Hasher()
        textMessage3.hash(into: &hasher3)
        let hash3 = hasher3.finalize()
        
        XCTAssertEqual(hash1, hash2) // Same content should have same hash
        XCTAssertNotEqual(hash1, hash3) // Different content should have different hash
    }
    
    func testMessageTypeVariants() {
        let text = MessageType.text("Hello")
        let images = MessageType.image([UIImage()])
        let voice = MessageType.voice(URL(string: "file://test.mp3")!)
        let location = MessageType.location(latitude: 0.0, longitude: 0.0)
        let file = MessageType.file(URL(string: "file://test.pdf")!)
        
        // Each type should be different from others
        XCTAssertNotEqual(text, images)
        XCTAssertNotEqual(text, voice)
        XCTAssertNotEqual(text, location)
        XCTAssertNotEqual(text, file)
    }
    
    // MARK: - MessageStatus Tests
    func testMessageStatusValues() {
        let statuses: [MessageStatus] = [.sending, .sent, .delivered, .read, .failed]
        
        // All statuses should be hashable and different
        let statusSet = Set(statuses)
        XCTAssertEqual(statusSet.count, 5)
    }
    
    // MARK: - MessagePreview Tests
    func testMessagePreviewInitialization() {
        let preview = MessagePreview(
            id: 1,
            username: "testuser",
            avatar: "avatar.jpg",
            lastMessage: "Hello there!",
            time: "2:30 PM",
            unreadCount: 3,
            isRead: false
        )
        
        XCTAssertEqual(preview.id, 1)
        XCTAssertEqual(preview.username, "testuser")
        XCTAssertEqual(preview.avatar, "avatar.jpg")
        XCTAssertEqual(preview.lastMessage, "Hello there!")
        XCTAssertEqual(preview.time, "2:30 PM")
        XCTAssertEqual(preview.unreadCount, 3)
        XCTAssertFalse(preview.isRead)
    }
    
    func testMessagePreviewEquality() {
        let preview1 = MessagePreview(id: 1, username: "user1", avatar: "avatar1", lastMessage: "msg1", time: "1:00")
        let preview2 = MessagePreview(id: 1, username: "user2", avatar: "avatar2", lastMessage: "msg2", time: "2:00")
        let preview3 = MessagePreview(id: 2, username: "user1", avatar: "avatar1", lastMessage: "msg1", time: "1:00")
        
        XCTAssertEqual(preview1, preview2) // Same ID
        XCTAssertNotEqual(preview1, preview3) // Different ID
    }
    
    func testMessagePreviewDefaultValues() {
        let preview = MessagePreview(
            id: 1,
            username: "testuser",
            avatar: "avatar.jpg",
            lastMessage: "Hello",
            time: "now"
        )
        
        XCTAssertEqual(preview.unreadCount, 0) // Default value
        XCTAssertFalse(preview.isRead) // Default value
    }
    
    // MARK: - ChatMessage Tests
    func testChatMessageInitialization() {
        let message = ChatMessage(
            id: 1,
            isFromMe: true,
            text: "Hello world!",
            timestamp: testDate,
            imageAttachments: [UIImage()],
            status: .sent,
            type: .text("Hello world!")
        )
        
        XCTAssertEqual(message.id, 1)
        XCTAssertTrue(message.isFromMe)
        XCTAssertEqual(message.text, "Hello world!")
        XCTAssertEqual(message.timestamp, testDate)
        XCTAssertEqual(message.imageAttachments.count, 1)
        XCTAssertEqual(message.status, .sent)
    }
    
    func testChatMessageDefaultValues() {
        let message = ChatMessage(
            id: 1,
            isFromMe: false,
            text: "Test",
            timestamp: testDate
        )
        
        XCTAssertTrue(message.imageAttachments.isEmpty) // Default empty array
        XCTAssertEqual(message.status, .sent) // Default status
    }
    
    func testChatMessageEquality() {
        let message1 = ChatMessage(id: 1, isFromMe: true, text: "Hello", timestamp: testDate)
        let message2 = ChatMessage(id: 1, isFromMe: false, text: "Different", timestamp: Date())
        let message3 = ChatMessage(id: 2, isFromMe: true, text: "Hello", timestamp: testDate)
        
        XCTAssertEqual(message1, message2) // Same ID
        XCTAssertNotEqual(message1, message3) // Different ID
    }
    
    // MARK: - MessageMetadata Tests
    func testMessageMetadataInitialization() {
        let metadata = MessageMetadata(
            messageId: "msg123",
            status: .delivered,
            sentAt: testDate,
            deliveredAt: testDate,
            readAt: nil,
            error: nil
        )
        
        XCTAssertEqual(metadata.messageId, "msg123")
        XCTAssertEqual(metadata.status, .delivered)
        XCTAssertEqual(metadata.sentAt, testDate)
        XCTAssertEqual(metadata.deliveredAt, testDate)
        XCTAssertNil(metadata.readAt)
        XCTAssertNil(metadata.error)
    }
    
    func testMessageMetadataEquality() {
        let metadata1 = MessageMetadata(messageId: "1", status: .sent, sentAt: testDate, deliveredAt: nil, readAt: nil, error: nil)
        let metadata2 = MessageMetadata(messageId: "1", status: .read, sentAt: Date(), deliveredAt: testDate, readAt: testDate, error: nil)
        let metadata3 = MessageMetadata(messageId: "2", status: .sent, sentAt: testDate, deliveredAt: nil, readAt: nil, error: nil)
        
        XCTAssertEqual(metadata1, metadata2) // Same messageId
        XCTAssertNotEqual(metadata1, metadata3) // Different messageId
    }
    
    // MARK: - MessageContent Tests
    func testMessageContentInitialization() {
        let metadata = MessageMetadata(messageId: "msg1", status: .sent, sentAt: testDate, deliveredAt: nil, readAt: nil, error: nil)
        let replyMessage = ChatMessage(id: 1, isFromMe: false, text: "Original message", timestamp: testDate)
        
        let content = MessageContent(
            type: .text("Reply message"),
            metadata: metadata,
            replyTo: replyMessage,
            forwardFrom: nil
        )
        
        XCTAssertEqual(content.metadata.messageId, "msg1")
        XCTAssertNotNil(content.replyTo)
        XCTAssertNil(content.forwardFrom)
    }
    
    // MARK: - MessageNotification Tests
    func testMessageNotificationInitialization() {
        let notification = MessageNotification(
            id: "notif1",
            type: .newMessage,
            message: "You have a new message",
            timestamp: testDate,
            isRead: false
        )
        
        XCTAssertEqual(notification.id, "notif1")
        XCTAssertEqual(notification.type, .newMessage)
        XCTAssertEqual(notification.message, "You have a new message")
        XCTAssertEqual(notification.timestamp, testDate)
        XCTAssertFalse(notification.isRead)
    }
    
    func testMessageNotificationTypes() {
        let types: [MessageNotification.NotificationType] = [.newMessage, .messageRead, .typing, .online]
        let typeSet = Set(types)
        XCTAssertEqual(typeSet.count, 4) // All types should be unique
    }
    
    func testMessageNotificationEquality() {
        let notif1 = MessageNotification(id: "1", type: .newMessage, message: "msg1", timestamp: testDate, isRead: false)
        let notif2 = MessageNotification(id: "1", type: .typing, message: "msg2", timestamp: Date(), isRead: true)
        let notif3 = MessageNotification(id: "2", type: .newMessage, message: "msg1", timestamp: testDate, isRead: false)
        
        XCTAssertEqual(notif1, notif2) // Same ID
        XCTAssertNotEqual(notif1, notif3) // Different ID
    }
    
    // MARK: - MessageGroup Tests
    func testMessageGroupInitialization() {
        let participants = [sampleUser!]
        let lastMessage = ChatMessage(id: 1, isFromMe: false, text: "Last message", timestamp: testDate)
        
        let group = MessageGroup(
            id: "group1",
            name: "Test Group",
            participants: participants,
            avatar: "group_avatar.jpg",
            lastMessage: lastMessage,
            unreadCount: 5,
            isMuted: false
        )
        
        XCTAssertEqual(group.id, "group1")
        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.participants.count, 1)
        XCTAssertEqual(group.avatar, "group_avatar.jpg")
        XCTAssertNotNil(group.lastMessage)
        XCTAssertEqual(group.unreadCount, 5)
        XCTAssertFalse(group.isMuted)
    }
    
    func testMessageGroupEquality() {
        let group1 = MessageGroup(id: "1", name: "Group 1", participants: [], avatar: nil, lastMessage: nil, unreadCount: 0, isMuted: false)
        let group2 = MessageGroup(id: "1", name: "Different Name", participants: [sampleUser], avatar: "avatar", lastMessage: nil, unreadCount: 10, isMuted: true)
        let group3 = MessageGroup(id: "2", name: "Group 1", participants: [], avatar: nil, lastMessage: nil, unreadCount: 0, isMuted: false)
        
        XCTAssertEqual(group1, group2) // Same ID
        XCTAssertNotEqual(group1, group3) // Different ID
    }
    
    // MARK: - GroupSettings Tests
    func testGroupSettingsInitialization() {
        let settings = GroupSettings(
            name: "My Group",
            avatar: "avatar.jpg",
            isMuted: true,
            allowInvites: false,
            allowMessageEditing: true,
            allowMessageDeletion: false
        )
        
        XCTAssertEqual(settings.name, "My Group")
        XCTAssertEqual(settings.avatar, "avatar.jpg")
        XCTAssertTrue(settings.isMuted)
        XCTAssertFalse(settings.allowInvites)
        XCTAssertTrue(settings.allowMessageEditing)
        XCTAssertFalse(settings.allowMessageDeletion)
    }
    
    // MARK: - CommentItem Tests
    func testCommentItemInitialization() {
        let commentItem = CommentItem(
            id: 1,
            username: "artist123",
            avatar: "user_avatar.jpg",
            workTitle: "Beautiful Sunset",
            timeText: "2 hours ago",
            commentText: "Amazing artwork!",
            artworkImage: "sunset.jpg"
        )
        
        XCTAssertEqual(commentItem.id, 1)
        XCTAssertEqual(commentItem.username, "artist123")
        XCTAssertEqual(commentItem.avatar, "user_avatar.jpg")
        XCTAssertEqual(commentItem.workTitle, "Beautiful Sunset")
        XCTAssertEqual(commentItem.timeText, "2 hours ago")
        XCTAssertEqual(commentItem.commentText, "Amazing artwork!")
        XCTAssertEqual(commentItem.artworkImage, "sunset.jpg")
    }
    
    func testCommentItemEquality() {
        let comment1 = CommentItem(id: 1, username: "user1", avatar: "avatar1", workTitle: "work1", timeText: "1h", commentText: "comment1", artworkImage: "img1")
        let comment2 = CommentItem(id: 1, username: "user2", avatar: "avatar2", workTitle: "work2", timeText: "2h", commentText: "comment2", artworkImage: "img2")
        let comment3 = CommentItem(id: 2, username: "user1", avatar: "avatar1", workTitle: "work1", timeText: "1h", commentText: "comment1", artworkImage: "img1")
        
        XCTAssertEqual(comment1, comment2) // Same ID
        XCTAssertNotEqual(comment1, comment3) // Different ID
    }
    
    func testCommentItemWithNilArtworkImage() {
        let commentItem = CommentItem(
            id: 1,
            username: "user",
            avatar: "avatar.jpg",
            workTitle: "Work",
            timeText: "now",
            commentText: "Comment",
            artworkImage: nil
        )
        
        XCTAssertNil(commentItem.artworkImage)
    }
} 