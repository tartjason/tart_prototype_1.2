import SwiftUI
import UIKit

// MARK: - Message Types
enum MessageType: Hashable {
    case text(String)
    case image([UIImage])
    case voice(URL)
    case location(latitude: Double, longitude: Double)
    case file(URL)
    
    // 实现 Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .text(let text):
            hasher.combine(0) // 区分不同类型
            hasher.combine(text)
        case .image(let images):
            hasher.combine(1)
            hasher.combine(images.count)
        case .voice(let url):
            hasher.combine(2)
            hasher.combine(url)
        case .location(let lat, let lon):
            hasher.combine(3)
            hasher.combine(lat)
            hasher.combine(lon)
        case .file(let url):
            hasher.combine(4)
            hasher.combine(url)
        }
    }
    
    static func == (lhs: MessageType, rhs: MessageType) -> Bool {
        switch (lhs, rhs) {
        case (.text(let l), .text(let r)):
            return l == r
        case (.image(let l), .image(let r)):
            return l.count == r.count
        case (.voice(let l), .voice(let r)):
            return l == r
        case (.location(let l1, let l2), .location(let r1, let r2)):
            return l1 == r1 && l2 == r2
        case (.file(let l), .file(let r)):
            return l == r
        default:
            return false
        }
    }
}

enum MessageStatus: Hashable {
    case sending
    case sent
    case delivered
    case read
    case failed
}

// MARK: - Base Models
struct MessagePreview: Identifiable, Hashable {
    let id: Int
    let username: String
    let avatar: String
    var lastMessage: String
    var time: String
    var unreadCount: Int = 0
    var isRead: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MessagePreview, rhs: MessagePreview) -> Bool {
        lhs.id == rhs.id
    }
}

struct ChatMessage: Identifiable, Hashable {
    let id: Int
    let isFromMe: Bool
    let text: String
    let timestamp: Date
    var imageAttachments: [UIImage] = []
    var status: MessageStatus = .sent
    var type: MessageType = .text("")
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}

struct MessageMetadata: Hashable {
    let messageId: String
    let status: MessageStatus
    let sentAt: Date
    let deliveredAt: Date?
    let readAt: Date?
    let error: Error?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MessageMetadata, rhs: MessageMetadata) -> Bool {
        lhs.messageId == rhs.messageId
    }
}

struct MessageContent: Hashable {
    let type: MessageType
    let metadata: MessageMetadata
    let replyTo: ChatMessage?
    let forwardFrom: ChatMessage?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(metadata.messageId)
    }
    
    static func == (lhs: MessageContent, rhs: MessageContent) -> Bool {
        lhs.metadata.messageId == rhs.metadata.messageId
    }
}

// MARK: - Notification Models
struct MessageNotification: Identifiable, Hashable {
    let id: String
    let type: NotificationType
    let message: String
    let timestamp: Date
    let isRead: Bool
    
    enum NotificationType: Hashable {
        case newMessage
        case messageRead
        case typing
        case online
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MessageNotification, rhs: MessageNotification) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Group Models
struct MessageGroup: Identifiable, Hashable {
    let id: String
    let name: String
    let participants: [User]
    let avatar: String?
    let lastMessage: ChatMessage?
    let unreadCount: Int
    let isMuted: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MessageGroup, rhs: MessageGroup) -> Bool {
        lhs.id == rhs.id
    }
}

struct GroupSettings: Hashable {
    var name: String
    var avatar: String?
    var isMuted: Bool
    var allowInvites: Bool
    var allowMessageEditing: Bool
    var allowMessageDeletion: Bool
}

// MARK: - Comment Models
struct CommentItem: Identifiable, Hashable {
    let id: Int
    let username: String
    let avatar: String
    let workTitle: String
    let timeText: String
    let commentText: String
    let artworkImage: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CommentItem, rhs: CommentItem) -> Bool {
        lhs.id == rhs.id
    }
} 